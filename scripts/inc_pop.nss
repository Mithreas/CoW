/*
  inc_pop

  Concept: Monster populations can be configured to grow and expand into nearby
  areas.  Left unchecked they can even threaten settlements.

  Database table: mipo_populations
  - tag varchar(16)
  - rate tinyint(4)
  - pop  int(8)

  Configuration:
  - Place the Population placeable marker down in an area with a unique tag
    (starting MI_PO_) and set its Rate variable (MI_PO_RATE) to the desired
    repopulation rate (in monsters per month) and its MI_PO_MASTER variable to
    TRUE (1).
  - Place waypoints down with tags <tag>_N where N is an integer. These
    should be placed in adjacent or nearby areas, where N increases the further
    away from the spawn area the location is.

  e.g. a goblin population has a tag of MI_PO_GOBBOS and a rate of 99.  Monthly,
  the database population is increased by 99.  Every time a goblin is killed,
  the population is decreased by 1.  When the population reaches 100+, goblins
  start spawning in all areas that contain a waypoint MI_PO_GOBBOS_1.  When
  the population reaches 200, then areas with waypoints MI_PO_GOBBOS_2 start
  getting flooded, etc.

  It's possible to set e.g. rate=250 and no _1 or _2 waypoints, but to have a _3
  or higher set.  This allows for more dynamic populations (e.g. where you
  expect more than 100 creatures to be killed every game month).

  Technical notes
  - The rate can be adjusted on the placeable.  The database rate will be
    resync'd when the server next restarts.
  - Areas with populations, or with an 'activated' population waypoint, get the
    MI_POPULATION variable set on them with a value of the population tag.
  - When a monster is killed, if the MI_POPULATION tag is set in the area, the
    DB pop is reduced by 1.
  - If the population is dropped below 100 (or 200 etc) then areas are
    reset to their default spawns and the MI_POPULATION variable is cleared
  - This means that the system doesn't handle multiple overflowing populations
    in the same area very well.  Only one group of baddies can attack Cordor at
    once :-)
  - To hardcode existing areas to be associated with the same population (so
    that monster kills there cull the herd) put down copies of the master
    Population marker with GS_PO_MASTER=0.
  - There is a hard limit of 1000 in the code at present.  

*/
#include "inc_encounter"
#include "inc_database"
#include "inc_xfer"

const string VAR_POP       = "MI_POPULATION";
const string VAR_TAG       = "MI_PO_TAG";
const string VAR_RATE      = "MI_PO_RATE";
const string VAR_PO_MASTER = "MI_PO_MASTER";

// Called in gs_m_heartbeat each month.  Increments all populations by their
// rate and checks whether any new areas need to be activated.
void miPORepopulate();

// Adjust population sTag by nAdjustment, then activates or deactivates any
// appropriate areas.
void miPOAdjustPopulation(string sTag, int nAdjustment);

// Activates any areas that need to be set up
void miPOActivateAreas(string sTag);

// Deactivates all areas for the _nN waypoints of sTag.
void miPODeactivateAreas(string sTag, int nN);

// Helper method to query the database for the current population.
int miPOGetPopulation(string sTag);

// Helper method to query the database for the rate of increase of the population.
int miPOGetPopulationRate(string sTag);

// Helper method to get the active population in an area.
string miPOGetActivePopulation(object oArea);

// Adds 10 pop to each area for each object tagged MIPO_NEST in it.
void miPODoNests();

//------------------------------------------------------------------------------
int miPOGetPopulation(string sTag)
{
  SQLExecStatement("SELECT pop FROM mipo_populations WHERE tag=?", sTag);

  if (SQLFetch())
  {
    return StringToInt(SQLGetData(1));
  }

  return 0;
}
//------------------------------------------------------------------------------
int miPOGetPopulationRate(string sTag)
{
  SQLExecStatement("SELECT rate FROM mipo_populations WHERE tag=?", sTag);

  if (SQLFetch())
  {
    return StringToInt(SQLGetData(1));
  }

  return 0;
}
//------------------------------------------------------------------------------
void miPORepopulate()
{
  string sQuery = "UPDATE mipo_populations SET pop=pop+rate";

  // If running multiple servers, edit the following line to ensure you only update once.
  //if (miXFGetCurrentServer() == SERVER_CORDOR || miXFGetCurrentServer() == SERVER_PREHISTORY)
  SQLExecDirect(sQuery);

  // Max 1000. 
  SQLExecDirect("UPDATE mipo_populations SET pop=1000 WHERE pop>1000");
  
  SQLExecDirect("SELECT tag FROM mipo_populations");

  while (SQLFetch())
  {
    miPOActivateAreas(SQLGetData(1));
  }
}
//------------------------------------------------------------------------------
void miPOActivateAreas(string sTag)
{
  int nPop = miPOGetPopulation(sTag);
  object oSourceArea = GetLocalObject(GetModule(), sTag); // cf mi_po_register

  int nCount=1;

  while (nPop > 99)
  {
    int nWPCount = 0;
    object oWP = GetObjectByTag(sTag + "_" + IntToString(nCount), nWPCount);

    while (GetIsObjectValid(oWP))
    {
      gsENCopyArea(oSourceArea, GetArea(oWP));
      SetLocalString(GetArea(oWP), VAR_POP, sTag);

      nWPCount++;
      oWP = GetObjectByTag(sTag + "_" + IntToString(nCount), nWPCount);
    }

    nPop -= 100;
    nCount++;
  }
}
//------------------------------------------------------------------------------
void miPODeactivateAreas(string sTag, int nN)
{
  int nWPCount = 0;
  object oWP = GetObjectByTag(sTag + "_" + IntToString(nN), nWPCount);

  while (GetIsObjectValid(oWP))
  {
    gsENLoadArea(GetArea(oWP));
    DeleteLocalString(GetArea(oWP), VAR_POP);

    nWPCount++;
    oWP = GetObjectByTag(sTag + "_" + IntToString(nN), nWPCount);
  }
}
//------------------------------------------------------------------------------
void miPOAdjustPopulation(string sTag, int nAdjustment)
{
  int nPop = miPOGetPopulation(sTag);

  if (nAdjustment > 0)
  {
    SQLExecStatement("UPDATE mipo_populations SET pop=pop+" +
                     IntToString(nAdjustment) +
                     " WHERE tag=?", sTag);

    if (nPop / 100 != (nPop + nAdjustment)/100) // nwscript always rounds down
    {
      miPOActivateAreas(sTag);
    }
  }
  else if (nAdjustment < 0 && nPop > 0)
  {
    SQLExecStatement("UPDATE mipo_populations SET pop=pop-" +
                     IntToString(abs(nAdjustment)) +
                     " WHERE tag=?", sTag);

    if (nPop / 100 != (nPop + nAdjustment)/100) // nwscript always rounds down
    {
      miPODeactivateAreas(sTag, nPop/100);
    }

  }
}
//------------------------------------------------------------------------------
string miPOGetActivePopulation(object oArea)
{
  return GetLocalString(oArea, VAR_POP);
}
//------------------------------------------------------------------------------
void miPODoNests()
{
  int nNth = 0;
  string sPop;
  object oNest = GetObjectByTag("MIPO_NEST", nNth);
  
  while (GetIsObjectValid(oNest))
  {
    sPop = GetLocalString(GetArea(oNest), VAR_POP);
    miPOAdjustPopulation(sPop, 10);
	
	nNth++;
	oNest = GetObjectByTag("MIPO_NEST", nNth);
  }
}
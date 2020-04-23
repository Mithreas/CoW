/*
  Persistent People Script

  Used for mercenaries and quest NPCs to ensure that they are respawned if the
  server resets.

  Uses a database table - pw_people_data 
  - waypoint - name and tag of waypoint
  - resref - resref of creature to spawn
  - num - number of creatures to spawn. 

  Works by waypoint. Each waypoint tag contains a list of NPC tags of the NPCs
  present at that waypoint.

*/
#include "inc_log"
#include "inc_database"
#include "pg_lists_i"
const string P_PEOPLE  = "PERSISTENT_PEOPLE"; // for logging
const string PEOPLE_DB = "pw_people_data";
const string NPC_TAG_LIST = "npc_tag_list";

// Adds an NPC to the list of NPCs set up on restart.
void AddPersistentPerson(object oWP, string sNPCTag, int bAddIfAlreadyThere=TRUE);

// Removes an NPC from the list of NPCs set up on restart.
void RemovePersistentPerson(object oWP, string sNPCTag);

// Sets up all the persistent people in the database. Call in onmodload.
void SetUpPersistentPeople();

// Utility method to construct the database variable name.
string GetWPIdentifier(object oWP)
{
  return (GetName(oWP) + "__" + GetTag(oWP));
}

void AddPersistentPerson(object oWP, string sNPCTag, int bAddIfAlreadyThere=TRUE)
{
  Trace(P_PEOPLE, "Adding "+sNPCTag+" to "+GetName(oWP));
  int nCount = SQLExecAndFetchSingleInt(SQLPrepareStatement("SELECT num FROM pw_people_data WHERE waypoint=? AND resref=?", GetWPIdentifier(oWP), sNPCTag));

  if (!nCount)
  {
    Trace(P_PEOPLE, "NPC isn't already in list.");
    SQLExecStatement("INSERT INTO pw_people_data (waypoint, resref, num) VALUES(?, ?, 1)", GetWPIdentifier(oWP), sNPCTag);
  }
  else if (bAddIfAlreadyThere)
  {

    Trace(P_PEOPLE, "Adding NPC " + sNPCTag);
	SQLExecStatement("UPDATE pw_people_data SET num=num+1 WHERE waypoint=? AND resref=?", GetWPIdentifier(oWP), sNPCTag);
  }
}

void RemovePersistentPerson(object oWP, string sNPCTag)
{
  Trace(P_PEOPLE, "Removing "+sNPCTag+" from "+GetWPIdentifier(oWP));
  SQLExecStatement("UPDATE pw_people_data SET num=num-1 WHERE waypoint=? AND resref=?", GetWPIdentifier(oWP), sNPCTag);
  SQLExecStatement("DELETE FROM pw_people_data WHERE num=0");
}

void SetUpPersistentPeople()
{
  Trace(P_PEOPLE, "Setting up persistent people.");
  string sWaypointIdentifier;
  string sResref;
  int nCount;

  SQLExecStatement("SELECT waypoint, resref, num FROM pw_people_data");

  while (SQLFetch())
  {
      Trace(P_PEOPLE, "Getting next set of NPCs to spawn.");

      // The waypoint identifier is in the form 'name__tag'. Get it and parse
      // it.
      sWaypointIdentifier = SQLGetData(1);

      int n__index = FindSubString(sWaypointIdentifier, "__");
      string sWaypointName = GetStringLeft(sWaypointIdentifier, n__index);
      int nWIRightLength   = GetStringLength(sWaypointIdentifier) - n__index - 2;
      string sWaypointTag  = GetStringRight(sWaypointIdentifier, nWIRightLength);

      // Find the waypoint whose name matches the one we have. This will have a
      // unique name/tag combo, but may not have a unique name or tag.
      nCount = 0;
      object oWP = GetObjectByTag(sWaypointTag, nCount);

      while (GetIsObjectValid(oWP))
      {
        if (GetName(oWP) == sWaypointName)
        {
          Trace(P_PEOPLE, "Found waypoint!");
          break;
        }

        nCount++;
        oWP = GetObjectByTag(sWaypointTag, nCount);
      }

      sResref = SQLGetData(2);

      nCount = StringToInt(SQLGetData(3));

      while (nCount > 0)
      {
        Trace(P_PEOPLE, "Creating NPC: " + sResref);
        object oNPC = CreateObject(OBJECT_TYPE_CREATURE, sResref, GetLocation(oWP));
		
        SetLocalObject(oNPC, "HOME_WP", oWP);

        nCount--;
      }

  }
}

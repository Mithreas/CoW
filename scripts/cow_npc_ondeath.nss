/* Respawn the NPC in 15 minutes and run the standard death script. */
#include "inc_flag"
#include "inc_log"
#include "inc_reputation"

void CreateObjectReturnsVoid(int nObjectType, string sResRef, location lLocation)
{
  CreateObject(nObjectType, sResRef, lLocation);
}

void main()
{
  // Give -1 point to the NPC's faction, for their death
  GivePointsToFaction(-1, CheckFactionNation(OBJECT_SELF));

  // Check whether we are undestroyable - gs_ai_spawn sets the Mortal flag on things that won't be raisable.
  if (gsFLGetFlag(GS_FL_MORTAL))
  {
    string sResRef = GetResRef(OBJECT_SELF);
    location lLoc = GetLocation(OBJECT_SELF);
    AssignCommand(GetModule(), DelayCommand(900.0,
                  CreateObjectReturnsVoid(OBJECT_TYPE_CREATURE, sResRef, lLoc)));
  }
  
  ExecuteScript("nw_c2_default7", OBJECT_SELF);
}

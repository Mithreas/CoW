/*
  cow_pp_ondeath
  Script for when persistent people die.

*/
#include "inc_flag"
#include "inc_perspeople"
// includes inc_log, inc_database and pg_lists_i
#include "inc_randomquest"
// includes pg_lists_i, inc_reputation, inc_database and inc_log
void main()
{
  // Persistent people will get set as immortal by the default
  // spawn scripts.  Unset that now.
  SetIsDestroyable(TRUE, TRUE, FALSE);

  if (GetHasActivePlayers(OBJECT_SELF))
  {
    // Players are waiting for this NPC. Respawn.
    ExecuteScript("cow_npc_ondeath", OBJECT_SELF);
  }
  else
  {
    // Give -1 point to the NPC's faction, for their death
    GivePointsToFaction(-1, CheckFactionNation(OBJECT_SELF));

    // Remove and tidy up the NPC.
    object oWP = GetLocalObject(OBJECT_SELF, "HOME_WP");

    // Don't respawn this NPC when the server resets... he's dead, Jim!
    RemovePersistentPerson(oWP, GetResRef(OBJECT_SELF));

    ExecuteScript("nw_c2_default7", OBJECT_SELF);
  }
}

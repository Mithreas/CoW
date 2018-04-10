/*
  Name: mi_rstfctnexit
  Author: Mithreas
  Date: 27 Nov 05
  Description:
  Sets a faction to friendly. To use, make a trigger, put the -tag- of a known
  NPC of the correct faction in a string variable called "faction_creature",
  and put this in the OnExit slot.
*/
#include "mi_log"
const string FACTIONS = "FACTIONS"; // For trace
void main()
{
  object oPC = GetExitingObject();
  if (!GetIsPC(oPC)) return;

  string sTag = GetLocalString(OBJECT_SELF, "faction_creature");
  Trace(FACTIONS, "Resetting reputation for "+GetName(oPC)+" with NPC faction "+sTag);
  object oNPC = GetObjectByTag(sTag);
  if (oNPC == OBJECT_INVALID) return;
  Trace(FACTIONS, "Current reputation: " + IntToString(GetFactionAverageReputation(oNPC, oPC)));

  // Reset rep to 50.
  AdjustReputation(oPC, oNPC, 50-GetFactionAverageReputation(oNPC, oPC));
  Trace(FACTIONS, "New reputation: " + IntToString(GetFactionAverageReputation(oNPC, oPC)));
}

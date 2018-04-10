/*
  Name: mi_resetfaction
  Author: Mithreas
  Date: 27 Nov 05
  Description:
  Sets a faction to friendly. To use, make a trigger, put the -tag- of a known
  NPC of the correct faction in a string variable called "faction_creature",
  and put this in the OnEnter slot.
*/

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;

  string sTag = GetLocalString(OBJECT_SELF, "faction_creature");
  object oNPC = GetObjectByTag(sTag);
  if (oNPC == OBJECT_INVALID) return;

  AdjustReputation(oPC, oNPC, 50-GetFactionAverageReputation(oNPC, oPC));
}

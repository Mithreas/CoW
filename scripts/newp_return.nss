// After a PC screwed up their levelup, they get sent to an area which reminds
// them of the levelling rules, and taken to 1xp short of the level they had.
// This script restores their XP and sends them back.
void main()
{
  object oPC = GetLastUsedBy();

  if (!GetIsPC(oPC)) return;
  int nXPToRestore = GetLocalInt (oPC, "XP_LOST");
  location lOldLocation = GetLocalLocation(oPC, "OLD_LOCATION");
  GiveXPToCreature(oPC, nXPToRestore);
  AssignCommand(oPC, JumpToLocation(lOldLocation));
}

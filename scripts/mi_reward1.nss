/*
  Name: mi_reward1
  Author: Mithreas
  Version: 1.0
  Date: 11 Sep 05

  Description: Gives the PC speaker the rewards stored in the NPC as reward1xp,
  reward1gold and reward1item.

  See the Guide Valshera Conversation Scripts doc for more instructions.
*/
int StartingConditional()
{
  object oPC  = GetPCSpeaker();
  int nGold   = GetLocalInt(OBJECT_SELF, "reward1gold");
  int nXP     = GetLocalInt(OBJECT_SELF, "reward1xp");
  string sTag = GetLocalString(OBJECT_SELF, "reward1item");

  if (nGold > 0) GiveGoldToCreature(oPC, nGold);
  if (nXP > 0) GiveXPToCreature(oPC, nXP);
  if (sTag != "") CreateItemOnObject(sTag, oPC);

  return 1;
}

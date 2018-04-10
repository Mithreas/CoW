/*
  Name: mi_intimidated
  Author: Mithreas
  Version: 1.0
  Date: 10 Sep 05

  Description: PC makes an Intimidate check against which the NPC makes a Will
  save. If NPC is intimidated returns true, otherwise returns false.
*/

int CheckConditional()
{
  object oPC = GetPCSpeaker();
  object oNPC = OBJECT_SELF;

  int nIntimidate = GetSkillRank(SKILL_INTIMIDATE, oPC);
  int nWillSaveDC = d20() + nIntimidate;

  int nPassedSave = WillSave(oNPC, nWillSaveDC, SAVING_THROW_TYPE_NONE, oPC);

  return (nPassedSave == 0);
}

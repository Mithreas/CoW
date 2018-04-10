/*
  Name: mi_bluffed
  Author: Mithreas
  Version: 1.0
  Date: 10 Sep 05

  Description: PC makes a Bluff check against which the NPC makes a Bluff +
  Wisdom (NOT charisma) check. If PC gets higher returns true, otherwise
  returns false.
*/
int CheckConditional()
{
  object oPC = GetPCSpeaker();
  object oNPC = OBJECT_SELF;

  int nPCBluff   = GetSkillRank(SKILL_BLUFF, oPC);
  int nNPCBluff  = GetSkillRank(SKILL_BLUFF, oNPC);

  nNPCBluff = nNPCBluff +
              GetAbilityModifier(ABILITY_WISDOM) -
              GetAbilityModifier(ABILITY_CHARISMA);

  return ((d20() + nPCBluff) > (d20() + nNPCBluff));
}

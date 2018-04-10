/*
  Name: mi_persuaded
  Author: Mithreas
  Version: 1.0
  Date: 10 Sep 05

  Description: PC makes a Persuade check against which the NPC makes a Persuade
  + Wisdom (NOT charisma) check. If PC gets higher returns true, otherwise
  returns false.
*/
int CheckConditional()
{
  object oPC = GetPCSpeaker();
  object oNPC = OBJECT_SELF;

  int nPCPersuade   = GetSkillRank(SKILL_PERSUADE, oPC);
  int nNPCPersuade  = GetSkillRank(SKILL_PERSUADE, oNPC);

  nNPCPersuade = nNPCPersuade +
                 GetAbilityModifier(ABILITY_WISDOM) -
                 GetAbilityModifier(ABILITY_CHARISMA);

  return ((d20() + nPCPersuade) > (d20() + nNPCPersuade));
}

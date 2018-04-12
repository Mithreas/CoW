// Create an evil clone of the PC and have them attack.
#include "inc_generic"
#include "inc_combat"
void main()
{
  object oPC = GetLastUsedBy();
  if (!GetIsPC(oPC)) return;

  object oCopy = CopyObject(oPC, GetLocation(oPC));
  ChangeToStandardFaction(oCopy, STANDARD_FACTION_HOSTILE);
  AssignCommand(oCopy, SetIsDestroyable(FALSE, FALSE, FALSE));

  // no lasso allowed
  SetLocalInt(oCopy, "GVD_NO_LASSO", 1);

  // no drops
  SetInventoryDroppable(oCopy, 0);

  FloatingTextStringOnCreature("Your reflection steps out of the mirror and attacks you!", oPC, FALSE);
  AssignCommand(oCopy, gsCBDetermineCombatRound(oPC));

  // Work around the fact that clones can be disarmed by giving them +150 discipline.
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oCopy, 6.0f);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_DISCIPLINE, 150), oCopy);
}

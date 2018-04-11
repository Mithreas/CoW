//::///////////////////////////////////////////////
//:: Holy Sword Dispel
//:: im_w_hs_dispel
//:://////////////////////////////////////////////
/*
  Holy Sword has been customized for Arelith.
  Because the 'Holy Avenger' property is hard-coded,
  this necessitates a custom-written on-hit property.

  The on-hit of dispel of Holy Sword
  - Is now capped at 20 CL
  - And is improved by abjuration foci

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    // the target being hit by the weapon.
    object oSpellTarget = GetSpellTargetObject();

    // the wielder of the weapon
    object oSpellOrigin = OBJECT_SELF;

    // Get CL
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oSpellOrigin) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oSpellOrigin);

    // Cap CL at 20.
    if (nCasterLevel > 20)
        nCasterLevel = 20;
	else if (nCasterLevel < 1)
		nCasterLevel = 1;

    // Improve with Abjuration Foci
    if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oSpellOrigin))
        nCasterLevel += 2;

    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oSpellOrigin))
        nCasterLevel += 2;

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oSpellOrigin))
        nCasterLevel += 2;

    // Modify DC for target's arcane defense feats.
    if (GetHasFeat(FEAT_ARCANE_DEFENSE_ABJURATION, oSpellTarget))
        nCasterLevel -= 2;

    // Build the linked effect.
    effect eEffect = EffectVisualEffect(VFX_IMP_BREACH);
    eEffect = EffectLinkEffects(eEffect, EffectDispelMagicAll(nCasterLevel));

    // Application
    ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eEffect), oSpellTarget);
}

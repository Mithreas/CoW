//::///////////////////////////////////////////////
//:: On Enter: Protection Aura
//:: ent_protectaura
//:://////////////////////////////////////////////
/*
    Applies Aura of Protection effects to
    entering objects:
        * 2 Deflection AC vs. Evil
        * +2 Saving Throws vs. Evil
        * +5 Saving Throws vs. Evil Mind Spells
        * Immunity to Spells Level 3 and Lower
        * Cast by Evil Creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 18, 2016
//:://////////////////////////////////////////////

#include "inc_effect"

void main()
{
    effect eDeflect;
    effect eSaves;
    effect eMind;
    effect eImmunity;
    effect eVFX1;
    effect eLink;
    object oTarget = GetEnteringObject();

    if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget))
    {
        eDeflect = VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL), ALIGNMENT_ALL, ALIGNMENT_EVIL);
        eSaves = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), ALIGNMENT_ALL, ALIGNMENT_EVIL);
        eMind = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_TYPE_MIND_SPELLS, 5), ALIGNMENT_ALL, ALIGNMENT_EVIL);
        eImmunity = VersusAlignmentEffect(EffectSpellLevelAbsorption(3), ALIGNMENT_ALL, ALIGNMENT_EVIL);
        eVFX1 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
        eLink = EffectLinkEffects(eDeflect, eSaves);
        eLink = EffectLinkEffects(eLink, eMind);
        eLink = EffectLinkEffects(eLink, eImmunity);
        eLink = EffectLinkEffects(eLink, eVFX1);

        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, EFFECT_TAG_AURA);
    }
}

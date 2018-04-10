//::///////////////////////////////////////////////
//:: On Enter: Archon Aura
//:: ent_archonaura
//:://////////////////////////////////////////////
/*
    All allies gain the following bonuses:
        * +2 Deflection AC vs. Evil
        * +2 Saving Throws vs. Evil
        * +5 Saving Throws vs. Evil Mind Spells
    Enemies entering must make a will save or
    suffer from the following for 1 round /
    HD of the archon:
        * -2 AB
        * -2 AC
        * -2 Saves
    The default DC is 10 + HD / 2 + CHA, however,
    the DC can be overwritten with a local int,
    ARCHO_AURA_DC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 6, 2016
//:://////////////////////////////////////////////

#include "inc_effect"
#include "nw_i0_spells"

// Applies aura of menace to the target.
void ApplyAuraOfMenace(object oTarget);
// Applies aura of protection to the target.
void ApplyAuraOfProtection(object oTarget);

void main()
{
    object oTarget = GetEnteringObject();

    if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget))
    {
        ApplyAuraOfProtection(oTarget);
    }
    else if(GetIsReactionTypeHostile(oTarget))
    {
        ApplyAuraOfMenace(oTarget);
    }
}

//::///////////////////////////////////////////////
//:: ApplyAuraOfMenace
//:://////////////////////////////////////////////
/*
    Applies aura of menace to the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 6, 2016
//:://////////////////////////////////////////////
void ApplyAuraOfMenace(object oTarget)
{
    effect eAB;
    effect eAC;
    effect eSaves;
    effect eVFX;
    effect eLink;
    object oCreator = GetAreaOfEffectCreator();
    int nDuration = GetHitDice(oCreator);
    int nDC = GetLocalInt(oCreator, "ARCHON_AURA_DC");

    if(!nDC) nDC = 10 + GetHitDice(oCreator) / 2 + GetAbilityModifier(ABILITY_CHARISMA, oCreator);

    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
    {
        eAB = EffectAttackDecrease(2);
        eAC = EffectACDecrease(2);
        eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
        eVFX = EffectVisualEffect(VFX_IMP_DOOM);
        eLink = EffectLinkEffects(eAB, eAC);
        eLink = EffectLinkEffects(eLink, eSaves);

        RemoveTaggedEffects(oTarget, EFFECT_TAG_AURA, oCreator);
        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), EFFECT_TAG_AURA);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
    }
}

//::///////////////////////////////////////////////
//:: ApplyAuraOfProtection
//:://////////////////////////////////////////////
/*
    Applies aura of protection to the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 6, 2016
//:://////////////////////////////////////////////
void ApplyAuraOfProtection(object oTarget)
{
    effect eDeflect = VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL), ALIGNMENT_ALL, ALIGNMENT_EVIL);
    effect eSaves = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), ALIGNMENT_ALL, ALIGNMENT_EVIL);
    effect eMind = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_TYPE_MIND_SPELLS, 5), ALIGNMENT_ALL, ALIGNMENT_EVIL);
    effect eVFX1 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eLink;

    eLink = EffectLinkEffects(eDeflect, eSaves);
    eLink = EffectLinkEffects(eLink, eMind);
    eLink = EffectLinkEffects(eLink, eVFX1);

    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, EFFECT_TAG_AURA);
}

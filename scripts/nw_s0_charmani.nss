#include "inc_spells"
#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDC          = AR_GetSpellSaveDC();
    int nDuration    = 2 + nCasterLevel / 3;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (GetIsReactionTypeFriendly(oTarget))                         return;
    if (! (gsSPGetIsHumanoid(oTarget) || gsSPGetIsAnimal(oTarget))) return;
    //::  Special: Player Non-Humanoids (Imp, Fey, Dragon etc)
    if ( miSPGetIsPlayerNonHumanoid(oTarget) )  return;

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell)) return;

    //saving throw check
    if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS)) return;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),
                EffectCharmed()));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_CHARM),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}

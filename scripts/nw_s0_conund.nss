#include "inc_spells"
#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDC          = AR_GetSpellSaveDC();
    int nDuration    = nCasterLevel;
    int nHD          = nCasterLevel * 2;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    //affection check
    if (! gsSPGetIsUndead(oTarget))         return;
    if (GetIsReactionTypeFriendly(oTarget)) return;
    if (GetHitDice(oTarget) > nHD)          return;

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, 1.0)) return;

    //saving throw check
    if (gsSPSavingThrow(OBJECT_SELF,       oTarget,
                        nSpell,            nDC,
                        SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS,
                        1.0))
    {
        return;
    }

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED),
                EffectDominated()));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_DOMINATE_S),
        oTarget);
    DelayCommand(
        1.0,
        gsSPApplyEffect(
            oTarget,
            eEffect,
            nSpell,
            HoursToSeconds(nDuration)));
}

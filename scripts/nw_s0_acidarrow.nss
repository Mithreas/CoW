#include "inc_customspells"

void gsRun(object oTarget, int nSpell, int nMetaMagic, int nDuration, int bStaticLevel)
{
    if (! nDuration)        return;
    if (GetIsDead(oTarget)) return;

    //apply
    effect eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_S),
            EffectDamage(
                gsSPGetDamage(bStaticLevel ? 2 : 1, 6, nMetaMagic),
                DAMAGE_TYPE_ACID));

    gsSPApplyEffect(oTarget, eEffect, nSpell);

    DelayCommand(6.0, gsRun(oTarget, nSpell, nMetaMagic, nDuration - 1, bStaticLevel));
}
//----------------------------------------------------------------
void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    float fDelay     = GetDistanceToObject(oTarget) / 25.0;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel / 3;
    int bStaticLevel   = GetLocalInt(GetModule(), "STATIC_LEVEL");

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //visual effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(245), oTarget);

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, fDelay)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    if (nDuration < 1)                  nDuration  = 1;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_L),
            EffectDamage(
                gsSPGetDamage(bStaticLevel ? 6 : 3, 6, nMetaMagic),
                DAMAGE_TYPE_ACID));

    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));

    if (! GetHasSpellEffect(nSpell, oTarget))
    {
        eEffect =
            ExtraordinaryEffect(
                EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_TEMPORARY,
                eEffect,
                oTarget,
                RoundsToSeconds(nDuration) + 1.0));
        DelayCommand(
            fDelay + 6.0,
            gsRun(oTarget, nSpell, nMetaMagic, nDuration, bStaticLevel));
    }
}

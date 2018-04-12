#include "inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL_SELECTIVE, oCaster, oTarget)) return;

    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR),
                EffectLinkEffects(
                    VersusAlignmentEffect(
                        EffectACIncrease(2, AC_DEFLECTION_BONUS),
                        ALIGNMENT_ALL, ALIGNMENT_GOOD),
                    EffectLinkEffects(
                        VersusAlignmentEffect(
                            EffectSavingThrowIncrease(SAVING_THROW_WILL, 10, SAVING_THROW_TYPE_MIND_SPELLS),
                            ALIGNMENT_ALL, ALIGNMENT_GOOD),
                        VersusAlignmentEffect(
                            EffectSavingThrowIncrease(SAVING_THROW_ALL, 2),
                            ALIGNMENT_ALL, ALIGNMENT_GOOD)))));

    gsSPApplyEffect(oTarget, eEffect, nSpell, GS_SP_DURATION_PERMANENT);
}

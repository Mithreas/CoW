#include "inc_spell"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual;
    float fDelay       = 0.0;
    int nSpell         = GetSpellId();
    int nMetaMagic     = GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nDuration      = gsSPGetDamage(1, 4, nMetaMagic, 3);
    int nHD            = 0;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    oTarget            = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, TRUE);

    while (GetIsObjectValid(oTarget))
    {
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

        //affection check
        if (oTarget != OBJECT_SELF &&
            gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
        {
            fDelay = GetDistanceToObject(oTarget) / 20.0;

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, fDelay))
            {
                if (! gsSPSavingThrow(OBJECT_SELF,       oTarget,
                                      nSpell,            nDC,
                                      SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS,
                                      fDelay))
                {
                    nHD = GetHitDice(oTarget);

                    //apply
                    if (nHD <= 2)
                    {
                        eVisual    = EffectVisualEffect(VFX_IMP_SLEEP);
                        eEffect    = EffectSleep();
                    }
                    else if (nHD <= 4)
                    {
                        eVisual    = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                        eEffect    = EffectBlindness();
                        nDuration -= 1;
                    }
                    else
                    {
                        eVisual    = EffectVisualEffect(VFX_IMP_STUN);
                        eEffect    = EffectStunned();
                        nDuration -= 2;
                    }

                    eEffect =
                        EffectLinkEffects(
                            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
                                EffectLinkEffects(
                                    EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),
                                    eEffect));

                    DelayCommand(
                        fDelay,
                        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            eVisual,
                            oTarget));
                    DelayCommand(
                        fDelay,
                        gsSPApplyEffect(
                            oTarget,
                            eEffect,
                            nSpell,
                            RoundsToSeconds(nDuration)));
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, TRUE);
    }
}

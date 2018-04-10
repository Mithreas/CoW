#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay       = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 5) nCasterLevel = 5;
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nValue         = 0;

    oTarget            = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

    while (GetIsObjectValid(oTarget))
    {
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

        //affection check
        if (oTarget != OBJECT_SELF &&
            gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget))
        {
            fDelay = GetDistanceToObject(oTarget) / 20.0;

            //resistance check
            if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell, fDelay))
            {
                nValue = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

                //saving throw check
                nValue = AR_GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

                if (nValue > 0)
                {
                    //apply
                    eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_FIRE));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }
}

#include "mi_inc_spells"
#include "inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_FROST_L);
    float fDelay       = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 15) nCasterLevel = 15;
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nValue         = 0;

    if(GetSpellId() == SPELL_SHADES_CONE_OF_COLD)
    {
        nDC = AdjustSpellDCForSpellSchool(nDC, SPELL_SCHOOL_ILLUSION);
    }

    oTarget            = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

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
                nValue = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

                //saving throw check
                nValue = AR_GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_COLD);

                if (nValue > 0)
                {
                    //apply
                    eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_COLD));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                }
                else
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
    }
}

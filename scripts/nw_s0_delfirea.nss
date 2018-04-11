#include "inc_customspells"

void main()
{
    object oCaster     = GetAreaOfEffectCreator();
    object oTarget     = GetEnteringObject();
    location lLocation = GetLocation(OBJECT_SELF);
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nSpell         = gsSPGetSpellID();
    int nCasterLevel   = AR_GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = GetSpellSaveDC();
    int nValue         = 0;

    //affection check
    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
    {
        //visual effect
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_FIREBALL),
            lLocation);

        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);

        while (GetIsObjectValid(oTarget))
        {
            //affection check
            if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget))
            {
                //raise event
                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

                //resistance check
                if (! gsSPResistSpell(oCaster, oTarget, nSpell))
                {
                    nValue = gsSPGetDamage(nCasterLevel, 6, nMetaMagic);

                    //saving throw check
                    nValue = AR_GetReflexAdjustedDamage(nValue, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCaster);

                    if (nValue > 0)
                    {
                        //apply
                        eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_FIRE));

                        gsSPApplyEffect(oTarget, eEffect, nSpell);
                    }
                    else
                    {
                        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                    }
                }
            }

            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_SPELLTARGET);
        }

        DestroyObject(OBJECT_SELF);
    }
}

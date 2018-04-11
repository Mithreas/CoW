#include "inc_spells"
#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget     = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect;
    effect eVisual     = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nValue         = 0;

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_EVIL_10),
        lLocation);

    oTarget            = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLocation);

    while (GetIsObjectValid(oTarget))
    {
        if (gsSPGetIsUndead(oTarget))
        {
            //affection check
            if (gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget))
            {
                nValue = gsSPGetDamage(1, 8, nMetaMagic, nCasterLevel);

                //raise event
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

                //apply
                eEffect =
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_IMP_HEALING_M),
                        EffectHeal(nValue));

                gsSPApplyEffect(oTarget, eEffect, nSpell);
            }
        }
        else
        {
            //affection check
            if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget))
            {
                //resistance check
                if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell))
                {
                    nValue = gsSPGetDamage(1, 8, nMetaMagic, nCasterLevel);

                    //raise event
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

                    //saving throw check
                    if (gsSPSavingThrow(OBJECT_SELF,       oTarget,
                                        nSpell,            nDC,
                                        SAVING_THROW_FORT, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        nValue /= 2;
                    }

                    //apply
                    eEffect = EffectLinkEffects(eVisual, EffectDamage(nValue, DAMAGE_TYPE_NEGATIVE));

                    gsSPApplyEffect(oTarget, eEffect, nSpell);
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLocation);
    }
}

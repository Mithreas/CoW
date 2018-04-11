#include "inc_customspells"
#include "gs_inc_pc"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    object oTarget     = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
    effect eEffect;
    effect eVisual;
    float fDuration    = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = nCasterLevel;
    string sPath       = GetLocalString(gsPCGetCreatureHide(), "MI_PATH");

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    if (sPath == "Path of the Healer")
    {
      fDuration          = TurnsToSeconds(nDuration);
    }
    else
    {
      fDuration          = RoundsToSeconds(nDuration);
    }

    //apply
    eVisual            = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectAttackIncrease(1),
                EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR)));

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
        GetSpellTargetLocation());

    while (GetIsObjectValid(oTarget))
    {
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
			
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL_SELECTIVE, OBJECT_SELF, oTarget))
        {

            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                eVisual,
                oTarget);
            gsSPApplyEffect(
                oTarget,
                eEffect,
                nSpell,
                fDuration);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
    }
}


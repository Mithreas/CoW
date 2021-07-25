#include "inc_spell"
#include "inc_generic"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();
    int nMetaMagic = GetMetaMagicFeat();
    int nDC        = GetSpellSaveDC();

    //affection check
    if (GetIsCorpse(oTarget) || ! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;
    
    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    eEffect = EffectMovementSpeedDecrease(75);
    eEffect = EffectLinkEffects(eEffect, EffectAttackDecrease(2));
    eEffect = EffectLinkEffects(eEffect, EffectDamageDecrease(2));
    gsSPApplyEffect(oTarget, eEffect, nSpell, GS_SP_DURATION_PERMANENT);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);

    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_S),
            EffectDamage(
                gsSPGetDamage(4, 6, nMetaMagic),
                DAMAGE_TYPE_ACID));

    gsSPApplyEffect(oTarget, eEffect, nSpell);
}

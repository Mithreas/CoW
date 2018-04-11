#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration  = 24;
    int nCasterLevel = AR_GetCasterLevel();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (oTarget != GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION))          return;
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //stack check
    if (GetHasSpellEffect(nSpell, oTarget))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectAttackIncrease(2));
    eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_WISDOM, gsSPGetDamage(1, 10, nMetaMagic)));
    eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
    eEffect = EffectLinkEffects(eEffect, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
    //eEffect = EffectLinkEffects(eEffect, EffectACIncrease(nCasterLevel / 3, AC_DEFLECTION_BONUS));
    eEffect = EffectLinkEffects(eEffect, EffectModifyAttacks(1));
    eEffect = SupernaturalEffect(eEffect);

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HOLY_AID),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        HoursToSeconds(nDuration));
}

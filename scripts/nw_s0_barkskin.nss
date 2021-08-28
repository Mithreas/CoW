#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;
    int nValue       = 0;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // Check for Shifter version of the spell.
    if (!GetIsObjectValid(GetSpellCastItem()) && GetSpellId() == 860)
    {
        // Restore feat use.
        IncrementRemainingFeatUses(OBJECT_SELF, 1153);
		gsSTDoCasterDamage(OBJECT_SELF, 8);
        miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
	}	

    //value
    nValue           = 3 + (nCasterLevel - 1) / 6;
    if (nValue > 5)                     nValue     = 5;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_PROT_BARKSKIN),
                EffectACIncrease(nValue, AC_NATURAL_BONUS)));

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HEAD_NATURE),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        HoursToSeconds(nDuration));
}

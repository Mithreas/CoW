#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
	effect eTemp;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpell, FALSE));

    //stack check
    if (GetHasSpellEffect(nSpell, oTarget))
    {
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
        return;
    }

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectAttackIncrease(1),
                    EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR)
			));
	
	eTemp = EffectTemporaryHitpoints(gsSPGetDamage(1, 8, nMetaMagic));
    
	ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HOLY_AID),
        oTarget);
		
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        TurnsToSeconds(nDuration));
		
    gsSPApplyEffect(
        oTarget,
        eTemp,
        nSpell,
        TurnsToSeconds(nDuration));	
}


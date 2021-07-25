#include "inc_customspells"
#include "inc_warlock"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget) && !GetIsReactionTypeFriendly(oTarget))
    {
        if (!miWADoWarlockAttack(OBJECT_SELF, oTarget, GetSpellId())) return;
    }

    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;
    int nDC          = AR_GetSpellSaveDC();

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpell));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;

    //resistance check
    if (gsSPResistSpell(OBJECT_SELF, oTarget, nSpell)) return;

    //saving throw check - removed.
    // if (gsSPSavingThrow(OBJECT_SELF, oTarget, nSpell, nDC, SAVING_THROW_FORT)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),           
            AnemoiEffectBlindness(oTarget));
			
	// Removed deafness as in EE it actually works and the combo is a total disable.

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_BLIND_DEAF_M),
        oTarget);
    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}

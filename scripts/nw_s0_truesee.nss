#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    // effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // The Truesight spell now gives 1 round of True Seeing, and CL rounds of +15 Spot.
    // Divination spell foci increase the True Seeing rounds by +1 each for Spell Focus and Greater Spell Focus, and +2 for Epic Spell Focus.

    effect eTS = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectTrueSeeing());
    effect eSpot = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectSkillIncrease(SKILL_SPOT, 15));
    eSpot = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT), eSpot);

    int nTSDur = 1;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION)) nTSDur += 4;
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION)) nTSDur += 2;
    else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION)) nTSDur += 1;

    gsSPApplyEffect(oTarget, eTS, nSpell, RoundsToSeconds(nTSDur));
    gsSPApplyEffect(oTarget, eSpot, nSpell, RoundsToSeconds(nDuration));
}



/* Old code.  Also, what's with all the wierd spacing?
    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT),
                EffectTrueSeeing()));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration)); //1 round per level instead of 1 turn per level
*/

#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpell, FALSE));

    //affection check
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
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT),
                EffectLinkEffects(
                    EffectSkillIncrease(SKILL_LISTEN, 10),
                    EffectSkillIncrease(SKILL_SPOT, 10))));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}

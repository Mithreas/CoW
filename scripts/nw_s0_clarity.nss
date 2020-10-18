#include "inc_timelock"
#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget = GetSpellTargetObject();
    effect eEffect;
    int nSpell     = GetSpellId();
    int nValue     = 0;
    int nDuration = 5 + AR_GetCasterLevel(OBJECT_SELF);

    if(AR_GetMetaMagicFeat() == METAMAGIC_EXTEND)
      nDuration *= 2;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oTarget, nSpell, FALSE));

    //remove effect
    eEffect = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eEffect))
    {
        switch (GetEffectType(eEffect))
        {
        case EFFECT_TYPE_CHARMED:
        case EFFECT_TYPE_CONFUSED:
        case EFFECT_TYPE_DAZED:
        case EFFECT_TYPE_SLEEP:
        case EFFECT_TYPE_STUNNED:
            RemoveEffect(oTarget, eEffect);
            nValue++;
        }

        eEffect = GetNextEffect(oTarget);
    }

    //apply damage
    if (nValue > 0)
    {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectDamage(nValue, DAMAGE_TYPE_NEGATIVE),
            oTarget);
    }

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE),
                EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS)));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}


#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDamage      = nCasterLevel;
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //remove damage shield
    if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_DEATH_ARMOR);
    }

    if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_ELEMENTAL_SHIELD);
    }

    if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))
    {
        gsSPRemoveEffect(oTarget, SPELL_MESTILS_ACID_SHEATH);
    }

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD),
                    EffectLinkEffects(
                        EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE),
                        EffectLinkEffects(
                            EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50),
                            EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50)))));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        RoundsToSeconds(nDuration));
}

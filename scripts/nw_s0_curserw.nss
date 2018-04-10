#include "mi_inc_spells"
#include "inc_healer"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    if (nCasterLevel > 15) nCasterLevel = 15;
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nValue       = gsSPGetDamage(3, 8, nMetaMagic, nCasterLevel);

    if (nMetaMagic != METAMAGIC_EMPOWER &&
        GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nValue += nValue / 2;
    }

    if (gsSPGetIsUndead(oTarget) || (gsSUGetSubRaceByName(GetSubRace(oTarget)) == GS_SU_SPECIAL_VAMPIRE))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

            //attack check
            if (TouchAttackMelee(oTarget) > 0)
            {
                //resistance check
                if (! gsSPResistSpell(OBJECT_SELF, oTarget, nSpell))
                {
                    //apply
                    eEffect =
                        EffectLinkEffects(
                            EffectVisualEffect(VFX_IMP_SUNSTRIKE),
                            EffectDamage(nValue, DAMAGE_TYPE_DIVINE));

                    gsSPApplyEffect(oTarget, eEffect, nSpell);
                }
            }
        }
    }
    else
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

            ApplyHealToObject(nValue, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L), oTarget);
        }
    }
}

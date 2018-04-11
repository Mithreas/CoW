//::///////////////////////////////////////////////
//:: Heartbeat: Area of Effect - Decay
//:: hrt_aoedecay
//:://////////////////////////////////////////////
/*
    Processes the decay Area of Effect:
      * Hostile targets suffer 10d6 negative damage.
        Reflex save for half.
      * Hostile targets must make a will save
        or be dazed for one round.
      * Hostle targets suffer 20% physical
        vulnerability for one round.
      * The AoE creator heals 5 hit points per
        hostile target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

#include "gs_inc_spell"
#include "inc_generic"
#include "nw_i0_spells"

const int DC_DECAY_AURA_DAMAGE_BASE = 11;
const int DC_DECAY_AURA_NAUSEA_BASE = 11;

// Handles all calculations for the Aura of Decay effect on a single target.
void ApplyAuraOfDecay(object oTarget, object oCaster);

void main()
{
    float fDelay;
    object oCaster = GetAreaOfEffectCreator();
    object oTarget;

    oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {
        if(gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget) && !GetIsDM(oTarget))
        {
            fDelay = GetDistanceBetweenLocations(GetLocation(oCaster), GetLocation(oTarget)) / 20.0;
            DelayCommand(fDelay, ApplyAuraOfDecay(oTarget, oCaster));
        }
        oTarget = GetNextInPersistentObject();
    }
}

//::///////////////////////////////////////////////
//:: ApplyAuraOfDecay
//:://////////////////////////////////////////////
/*
    Handles all calculations for the Aura of Decay
    effect on a single target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////
void ApplyAuraOfDecay(object oTarget, object oCaster)
{
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
    effect eNausea = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), EffectDazed()));
    effect eVis = EffectVisualEffect(VFX_DUR_FLIES);
    effect eVuln = EffectLinkEffects(eVis, EffectDamageImmunityDecrease(DAMAGE_TYPE_BLUDGEONING, 20));

    eVuln = EffectLinkEffects(eVuln, EffectDamageImmunityDecrease(DAMAGE_TYPE_PIERCING, 20));
    eVuln = EffectLinkEffects(eVuln, EffectDamageImmunityDecrease(DAMAGE_TYPE_SLASHING, 20));

    int nDamage;
    object oCaster = GetAreaOfEffectCreator();

    nDamage = d6(10);
    if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, DC_DECAY_AURA_DAMAGE_BASE + (GetHitDice(oCaster) + GetBonusHitDice(oCaster)) / 2, SAVING_THROW_TYPE_DISEASE)) nDamage /= 2;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, oTarget, 6.0);
    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, DC_DECAY_AURA_NAUSEA_BASE + (GetHitDice(oCaster) + GetBonusHitDice(oCaster)) / 2, SAVING_THROW_TYPE_DISEASE))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNausea, oTarget, RoundsToSeconds(1));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(5), oCaster);
}

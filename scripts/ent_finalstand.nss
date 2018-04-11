//::///////////////////////////////////////////////
//:: On Enter: Final Stand Aura (Protector Path)
//:: ent_finalstand
//:://////////////////////////////////////////////
/*
    Applies 20% elemental resist and 5/+10 DR
    to all allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 18, 2016
//:://////////////////////////////////////////////

#include "inc_effect"

void main()
{
    object oTarget = GetEnteringObject();
    effect eLink = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TEN);
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 20));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 20));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 20));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 20));

    if(oTarget != OBJECT_SELF && (!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget)))
    {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, EFFECT_TAG_AURA);
    }
}

//::///////////////////////////////////////////////
//:: On Enter: Regeneration Aura
//:: ent_regenaura
//:://////////////////////////////////////////////
/*
    Applies regeneration effect to all friendly
    entering creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 18, 2016
//:://////////////////////////////////////////////

#include "inc_effect"

void main()
{
    int nRegenAmount = GetLocalInt(GetAreaOfEffectCreator(), "REGEN_AURA_AMOUNT");
    object oTarget = GetEnteringObject();

    if(oTarget != OBJECT_SELF && (!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget)))
    {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, EffectRegenerate(nRegenAmount, 6.0), oTarget, 0.0, EFFECT_TAG_AURA);
    }
}

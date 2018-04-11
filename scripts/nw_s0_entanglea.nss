//::///////////////////////////////////////////////
//:: Entangle: On Enter
//:: nw_s0_entanglea
//:://////////////////////////////////////////////
/*
    Upon entering the AoE the target must make a
    reflex save or be entangled by vegetation.
    Additionally, they are slowed by 50%
    while in the area of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 12, 2016
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

void main()
{
    object oTarget = GetEnteringObject();
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);

    if(GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) || GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL))
        return;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

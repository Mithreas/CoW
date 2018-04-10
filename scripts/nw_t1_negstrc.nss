//::///////////////////////////////////////////////
//:: Strong Negative Energy Trap
//:: NW_T1_NegStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 5d6 negative energy damage and the target
    must make a Fort save or take 2 points of
    strength damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"

#include "mi_inc_traps"
void main()
{
    if (miTRPreHook()) return;
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eNeg = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    effect eDam = EffectDamage(d6(5), DAMAGE_TYPE_NEGATIVE);
    eNeg = SupernaturalEffect(eNeg);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    //Make a saving throw check
    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 18, SAVING_THROW_TYPE_TRAP))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNeg, oTarget);
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

//::///////////////////////////////////////////////
//:: On Hit: Void Slam
//:: hit_voidslam
//:://////////////////////////////////////////////
/*
    Special scripting for voidwraith attack.
    DC 15 or lose 1d2 constitution on hit. The
    voidwraith gains 5 temp hp when this occurs.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 23, 2016
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_NEGATIVE))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION, d2()), oTarget, HoursToSeconds(1));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(5), OBJECT_SELF, HoursToSeconds(1));
    }
}

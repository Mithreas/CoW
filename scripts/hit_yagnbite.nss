//::///////////////////////////////////////////////
//:: On Hit: Yagnoloth Bite
//:: hit_yagnbite
//:://////////////////////////////////////////////
/*
    When disabled, creature's struck by a
    yagnoloth's bite must make a dc 18 fortitude
    save or suffer 1d4 negative levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 1, 2016
//:://////////////////////////////////////////////

#include "inc_generic"
#include "nw_i0_spells"

void main()
{
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsImmobilized(oTarget)) return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 18, SAVING_THROW_TYPE_NEGATIVE))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNegativeLevel(d4()), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
    }
}

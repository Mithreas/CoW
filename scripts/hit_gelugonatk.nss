//::///////////////////////////////////////////////
//:: On Hit: Gelugon Attack
//:: hit_gelugonattack
//:://////////////////////////////////////////////
/*
    Creatures hit by a gelugon must make a DC
    23 fortitude save or be slowed for d6 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 25, 2016
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
    if(d4() != 4) return;

    effect eSlow;
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 23, SAVING_THROW_TYPE_COLD))
    {
        eSlow = EffectLinkEffects(EffectSlow(), EffectVisualEffect(VFX_DUR_ICESKIN));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(d6()));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);
    }
}

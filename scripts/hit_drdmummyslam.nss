//::///////////////////////////////////////////////
//:: On Hit: Dread Mummy Slam
//:: hit_drdmummyslam
//:://////////////////////////////////////////////
/*
    Applies dread mummy DoT to the target:
    -10 concentration, d4 piercing damage per
    round for d6 rounds. Can be removed via
    the cure disease spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////

#include "inc_dot"

void main()
{
    object oTarget = GetSpellTargetObject();

    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DISEASE))
    {
        ApplyDoTToCreature(EffectSkillDecrease(SKILL_CONCENTRATION, 10), VFX_DUR_FLIES, "d4piercing", oTarget, RoundsToSeconds(d6()),
            6.0, OBJECT_SELF, EFFECT_TAG_DISEASE, -1);
    }
}

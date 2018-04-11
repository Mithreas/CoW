//::///////////////////////////////////////////////
//:: Spell: Summon Angel of Decay
//:: spl_sumangelofdecay
//:://////////////////////////////////////////////
/*
    Summons an Angel of Decay, a powerful undead.
    Lasts for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

#include "inc_sumbonuses"

void main()
{
    effect eSummon = EffectSummonCreature("sum_angelofdecay", VFX_FNF_SUMMON_UNDEAD);

    SetEpicSummonScalingOverride(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
}

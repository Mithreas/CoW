//::///////////////////////////////////////////////
//:: x0_s2_blkdead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level 3 - 6:  Summons Ghast
    Level 7 - 10: Doom Knight
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "inc_summons"

const int FEAT_CREATE_UNDEAD = 474;

void main()
{
    if(GetIsTimelocked(OBJECT_SELF, "Create Undead"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Create Undead");
        return;
    }

    if (!X2PreSpellCastCode(FALSE))
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    effect eSummon;
    float fDelay = 3.0;
    int nDuration = nLevel;

    ScheduleSummonCooldown(OBJECT_SELF, 360, "Create Undead", FEAT_CREATE_UNDEAD);
    if (nLevel >= 11)
        eSummon = EffectSummonCreature("sum_doomknight", VFX_FNF_SUMMON_UNDEAD);
    else if(nLevel >= 7)
        eSummon = EffectSummonCreature("sum_voidwraith", VFX_FNF_SUMMON_UNDEAD);
    else
        eSummon = EffectSummonCreature("sum_mohrg", VFX_FNF_SUMMON_UNDEAD);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}

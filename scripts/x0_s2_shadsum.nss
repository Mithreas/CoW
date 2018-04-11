//::///////////////////////////////////////////////
//:: Summon Shadow
//:: X0_S2_ShadSum.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    PRESTIGE CLASS VERSION
    Spell powerful ally from the shadow plane to
    battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////

#include "inc_summons"

void main()
{
    if(GetIsTimelocked(OBJECT_SELF, "Summon Shadow"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Summon Shadow");
        return;
    }

    if (!X2PreSpellCastCode(FALSE))
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int nCasterLevel = GetLevelByClass(27);
    int nDuration = nCasterLevel;
    effect eSummon;

    ScheduleSummonCooldown(OBJECT_SELF, 180, "Summon Shadow", FEAT_SUMMON_SHADOW);
    if(GetGender(OBJECT_SELF) == GENDER_FEMALE)
    {
        eSummon = EffectSummonCreature("sum_sdshadowf", VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        eSummon = EffectSummonCreature("sum_sdshadowm", VFX_FNF_SUMMON_UNDEAD);
    }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}

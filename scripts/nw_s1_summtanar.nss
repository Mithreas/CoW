//::///////////////////////////////////////////////
//:: Summon Tanarri
//:: NW_S0_SummSlaad
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Quasit to aid the threatened Demon
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "inc_sumstream"

void main()
{

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    int nTier;

    if(!nLevel) nLevel = GetHitDice(OBJECT_SELF) - 10;

    if (nLevel < 7)
    {
        nTier = STREAM_PLANAR_TIER_3;
    }
    else if (nLevel < 9 )
    {
        nTier = STREAM_PLANAR_TIER_4;
    }
    else
    {
        nTier = STREAM_PLANAR_TIER_5;
    }

    SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), HoursToSeconds(24), STREAM_TYPE_PLANAR, nTier,
        VFX_FNF_SUMMON_GATE, 3.0);
}

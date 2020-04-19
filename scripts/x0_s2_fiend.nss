//::///////////////////////////////////////////////
//:: x0_s2_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Summons the 'fiendish' servant for the player.
This is a modified version of Planar Binding


At Level 5 the Blackguard gets a Succubus

At Level 9 the Blackguard will get a Vrock

Will remain for one hour per level of blackguard
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: April 2003
//:://////////////////////////////////////////////

#include "inc_summons"
#include "inc_sumstream"
#include "inc_worship"

const int FEAT_FIENDISH_SERVANT = 475;

void main()
{
    if(GetIsTimelocked(OBJECT_SELF, "Summon Fiend"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Summon Fiend");
        return;
    }

    if (!X2PreSpellCastCode(FALSE))
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    int nDuration = GetHitDice(OBJECT_SELF);
    int nTier;
	
    ScheduleSummonCooldown(OBJECT_SELF, 360, "Summon Fiend", FEAT_FIENDISH_SERVANT);
	
    if (GetHasFeat(1003,OBJECT_SELF)) // epic fiend feat
    {
       nTier = STREAM_PLANAR_TIER_5;
    }
    else if (nLevel < 7)
    {
        nTier = STREAM_PLANAR_TIER_2;
    }
    else if (nLevel < 9 )
    {
        nTier = STREAM_PLANAR_TIER_3;
    }
    else
    {
        nTier = STREAM_PLANAR_TIER_4;
    }

    SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), HoursToSeconds(nDuration), STREAM_TYPE_PLANAR, nTier,
        VFX_FNF_SUMMON_GATE, 3.0, FALSE, FALSE, gsWOGetDeityPlanarStream(OBJECT_SELF));
	
	gsSTDoCasterDamage(OBJECT_SELF, 2 * nTier);
}

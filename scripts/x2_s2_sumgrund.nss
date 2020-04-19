//::///////////////////////////////////////////////
//:: Summon Greater Undead
//:: X2_S2_SumGrUnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     2003-10-03 - GZ: Added Epic Progression
     The level of the Pale Master determines the
     type of undead that is summoned.

     Anemoi version: summons Tier 2 & 3 undead, 
	 one copy of each per undead summoner tier.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:://////////////////////////////////////////////

#include "inc_spells"
#include "inc_sumstream"
#include "inc_customspells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = 24;
	int nCount         = GetUndeadSummonerTier();
    string sSummon1 = GetUndeadStreamBlueprint(OBJECT_SELF, STREAM_UNDEAD_TIER_2);
    string sSummon2 = GetUndeadStreamBlueprint(OBJECT_SELF, STREAM_UNDEAD_TIER_3);

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(nCount, sSummon1, sSummon2), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
	
    ScheduleSummonCooldown(OBJECT_SELF, 300, "Summon Greater Undead", FEAT_SUMMON_GREATER_UNDEAD);
	gsSTDoCasterDamage(OBJECT_SELF, 10);
}






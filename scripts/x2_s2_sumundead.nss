//::///////////////////////////////////////////////
//:: Summon Undead
//:: X2_S2_SumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     The level of the Pale Master determines the
     type of undead that is summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated By: Georg Zoeller, Oct 2003
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

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(3, GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier())), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
	
    ScheduleSummonCooldown(OBJECT_SELF, 240, "Summon Undead", FEAT_SUMMON_UNDEAD);
	gsSTDoCasterDamage(OBJECT_SELF, 7);
}



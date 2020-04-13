//::///////////////////////////////////////////////
//:: Mummy Dust
//:: X2_S2_MumDust
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons a strong warrior mummy for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

#include "inc_spells"
#include "inc_sumstream"
#include "inc_customspells"
#include "x2_inc_spellhook"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    if (GetLevelByClass(CLASS_TYPE_DRUID) > 0) {
        SendMessageToPC(OBJECT_SELF, "Epic Spell: Mummy Dust may not be used by Druids.");
        return;
    }

    location lLocation = GetSpellTargetLocation();
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = 24;
    string sSummon1 = GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier());
    string sSummon2 = GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier() + 1);

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(1, sSummon1, sSummon1, sSummon2), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
	
    ScheduleSummonCooldown(OBJECT_SELF, 300, "Mummy Dust", FEAT_EPIC_SPELL_MUMMY_DUST);
	gsSTDoCasterDamage(OBJECT_SELF, 15);
}


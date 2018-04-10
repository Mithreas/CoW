//::///////////////////////////////////////////////
//:: Summon Greater Undead
//:: X2_S2_SumGrUnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     2003-10-03 - GZ: Added Epic Progression
     The level of the Pale Master determines the
     type of undead that is summoned.

     Level 9 <= Mummy Warrior
     Level 10 <= Spectre
     Level 12 <= Vampire Rogue
     Level 14 <= Bodak
     Level 16 <= Ghoul King
     Level 18 <= Vampire Mage
     Level 20 <= Skeleton Blackguard
     Level 22 <= Lich
     Level 24 <= Lich Lord
     Level 26 <= Alhoon
     Level 28 <= Elder Alhoon
     Level 30 <= Lesser Demi Lich

     Lasts 14 + Casterlevel rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:://////////////////////////////////////////////

#include "inc_spells"
#include "inc_sumstream"
#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    location lLocation = GetSpellTargetLocation();
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDuration      = 24;
    string sSummon1 = GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier());
    string sSummon2 = GetUndeadStreamBlueprint(OBJECT_SELF, GetUndeadSummonerTier() + 1);

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(1, sSummon1, sSummon1, sSummon2), HoursToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
}






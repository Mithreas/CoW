//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

effect SetSummonEffect(int nSpellID, int nUnderdarker);

#include "inc_customspells"
#include "inc_warlock"
#include "inc_worship"
#include "inc_subrace"
#include "inc_summons"
#include "inc_timelock"
#include "inc_spellsword"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

	if(miSSGetIsSpellsword(OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF,"You may not summon a creature");
		return;
	}

    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    nDuration = 24;
    if(nDuration == 1)
    {
        nDuration = 2;
    }
    //Make metamagic check for extend
    int nMetaMagic = AR_GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    int nSubRace = gsSUGetSubRaceByName(GetSubRace(OBJECT_SELF));
    int nUnderdarker = (nSubRace == GS_SU_SPECIAL_KOBOLD) ||
                       (nSubRace == GS_SU_SPECIAL_GOBLIN) ||
                       (nSubRace == GS_SU_ELF_DROW) ||
                       (nSubRace == GS_SU_GNOME_DEEP) ||
                       (nSubRace == GS_SU_HALFORC_OROG) ||
                       (nSubRace == GS_SU_FR_OROG) ||
                       (nSubRace == GS_SU_DWARF_GRAY) ||
                       (nSubRace == GS_SU_SPECIAL_OGRE) ||
                       (nSubRace == GS_SU_SPECIAL_IMP) ||
                       (nSubRace == GS_SU_SPECIAL_HOBGOBLIN);

    int bWarlock = GetLastSpellCastClass() == CLASS_TYPE_BARD && (!GetIsObjectValid(GetSpellCastItem()) && miWAGetIsWarlock(OBJECT_SELF));

    // Warlock summon timelock handling.
    if(bWarlock)
    {
        int nSummonLevel;
        string sTimelockID = "Warlock Summon Creature ";
        switch(nSpellID)
        {
            case SPELL_SUMMON_CREATURE_I:
                nSummonLevel = 1;
                sTimelockID += "I";
                break;
            case SPELL_SUMMON_CREATURE_II:
                nSummonLevel = 2;
                sTimelockID += "II";
                break;
            case SPELL_SUMMON_CREATURE_III:
                nSummonLevel = 3;
                sTimelockID += "III";
                break;
            case SPELL_SUMMON_CREATURE_IV:
                nSummonLevel = 4;
                sTimelockID += "IV";
                break;
            case SPELL_SUMMON_CREATURE_V:
                nSummonLevel = 5;
                sTimelockID += "V";
                break;
            case SPELL_SUMMON_CREATURE_VI:
                nSummonLevel = 6;
                sTimelockID += "VI";
                break;
        }
        if(GetIsTimelocked(OBJECT_SELF, sTimelockID))
        {
            TimelockErrorMessage(OBJECT_SELF, sTimelockID);
            return;
        }
        ScheduleSummonCooldown(OBJECT_SELF, 6 * (nSummonLevel + 1), sTimelockID);
        SummonFromStream(OBJECT_SELF, GetSpellTargetLocation(), HoursToSeconds(nDuration), STREAM_TYPE_PLANAR, nSummonLevel, VFX_FNF_SUMMON_GATE, 1.0, FALSE, FALSE);
        return;
    }

    effect eSummon = SetSummonEffect(nSpellID, nUnderdarker);

    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}

effect SetSummonEffect(int nSpellID, int nUnderdarker)
{
    int nFNF_Effect;
    int nTier;
    string sSummon;

    switch(nSpellID)
    {
        case SPELL_SUMMON_CREATURE_I:
            nTier = 1;
            break;
        case SPELL_SUMMON_CREATURE_II:
            nTier = 2;
            break;
        case SPELL_SUMMON_CREATURE_III:
            nTier = 3;
            break;
        case SPELL_SUMMON_CREATURE_IV:
            nTier = 4;
            break;
        case SPELL_SUMMON_CREATURE_V:
            nTier = 5;
            break;
        case SPELL_SUMMON_CREATURE_VI:
            nTier = 6;
            break;
        case SPELL_SUMMON_CREATURE_VII:
            nTier = 7;
            break;
        case SPELL_SUMMON_CREATURE_VIII:
            nTier = 8;
            break;
        case SPELL_SUMMON_CREATURE_IX:
            nTier = 9;
            break;
    }
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER)  || //WITH THE ANIMAL DOMAIN
       GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION)) // Arelith addition
        nTier++;

    switch(nTier)
    {
        case 1:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = nUnderdarker ? "ca_sum_u_1" : "NW_S_badgerdire";
            break;
        case 2:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = nUnderdarker ? "ca_sum_u_2" : "NW_S_BOARDIRE";
            break;
        case 3:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
            sSummon = nUnderdarker ? "ca_sum_u_3" : "ca_sum_u_3";
            break;
        case 4:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = "NW_S_SPIDDIRE";
            break;
        case 5:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = nUnderdarker ? "ca_sum_u_5" : "ca_sum_u_5";
            break;
        case 6:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
            sSummon = nUnderdarker ? "ca_sum_u_6" : "ca_sum_u_6";
            break;
        case 7:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            sSummon = GetPlanarStreamBlueprint(OBJECT_SELF, STREAM_PLANAR_TIER_3, gsWOGetDeityPlanarStream(OBJECT_SELF));
            break;
        case 8:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            sSummon = GetPlanarStreamBlueprint(OBJECT_SELF, STREAM_PLANAR_TIER_4, gsWOGetDeityPlanarStream(OBJECT_SELF));
            break;
        case 9:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            sSummon = GetPlanarStreamBlueprint(OBJECT_SELF, STREAM_PLANAR_TIER_5, gsWOGetDeityPlanarStream(OBJECT_SELF));
            break;
        case 10:
            nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
            sSummon = GetPlanarStreamBlueprint(OBJECT_SELF, STREAM_PLANAR_TIER_6, gsWOGetDeityPlanarStream(OBJECT_SELF));
            break;
    }

    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
}


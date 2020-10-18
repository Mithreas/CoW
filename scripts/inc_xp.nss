/* EXPERIENCE Library by Gigaschatten */

#include "inc_boss"
#include "inc_common"
#include "inc_pc"
#include "inc_subrace"
#include "inc_text"
#include "inc_time"
#include "inc_checker"
#include "__server_config"
#include "inc_spells"
#include "inc_adv_xp"

//void main() {}

const int GS_XP_ALIGNMENT_SHIFT          = FALSE;
const int GS_XP_KILL_PER_LEVEL           = FALSE; //daily kill reward, set to FALSE to disable

// Septire - Reduced to 10% for new death penalty. Old values are 10x.
const int GS_XP_PENALTY_PER_LEVEL_HIGH   =   20; //level 20+, set to FALSE to take a full level
const int GS_XP_PENALTY_PER_LEVEL_MEDIUM =   10; //level 10+, set to FALSE to take a full level
const int GS_XP_PENALTY_PER_LEVEL_LOW    =    5; //level  1+, set to FALSE to take a full level


const int GS_XP_BONUS_HIGH               =  2000;
const int GS_XP_BONUS_MEDIUM             =  1000;
const int GS_XP_BONUS_LOW                =   500;
const int GS_XP_BONUS_MINI               =    50;
const int GS_XP_PUNISHMENT_HIGH          = -2000;
const int GS_XP_PUNISHMENT_MEDIUM        = -1000;
const int GS_XP_PUNISHMENT_LOW           =  -500;

struct Party
{
    int countPC;
    int countAssociates;
    float challengeRating;
};

//distribute experience for slaying oVictim to each enemy within fRange
void gsXPRewardKill(object oVictim = OBJECT_SELF, float fRange = 40.0);
//return death penalty of oPC, set nPenalty to override internal settings, if nLevelSafe is TRUE oPC will not lose levels
int gsXPGetDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE);
//apply death penalty to oPC, set nPenalty to override internal settings, if nLevelSafe is TRUE oPC will not lose levels
void gsXPApplyDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE);
//give nAmount experience to each member of oCreature's faction nearby
void gsXPDistributeExperience(object oCreature, int nAmount);
//give nAmount experience to oCreature, display floating message if nFloat is TRUE
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE);
//apply nBonus/punishment to oCreature or each member of party oCreature is in if nParty is TRUE
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE, int nApplyECL = FALSE);
//set kill limit of oPC to nValue
void gsXPSetKillLimit(object oPC, int nValue);
//return kill limit of oPC
int gsXPGetKillLimit(object oPC);
//set kill timeout of oPC to nValue
void gsXPSetKillTimeout(object oPC, int nValue);
//return kill timeout of oPC
int gsXPGetKillTimeout(object oPC);
//return percentual multi class penalty of oPC having nSubRace
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE);
// Added by Mith - determine whether this class is a PrC or not
int gsXPGetIsPrestigeClass(int nClass);
// Returns xp multiplier for the given party size.
float GetPartyExperienceMultiplier(float fPartySize);
// Distributes XP to all PC party members within the given range.
void _DistributePartyExperience(object oPC, int nAmount, float fRange, object oVictim, string sRandom);
// Returns a "CR" value for the PC, either the PC's level or the CR of their most
// powerful summon, whichever is higher.
float gsXPGetPCChallengeRating(object oPC, float fRange, object oVictim);
// Counts and returns all party members with range of the given PC as a party struct.
struct Party _CountParty(struct Party party, object oPC, float fRange, object oVictim, string sRandom);

//----------------------------------------------------------------
int _AdjustXPForECL(int nAmount, object oCreatureToReward)
{
  float fCurrentECL = GetLocalFloat(gsPCGetCreatureHide(oCreatureToReward),
                                              "ECL");
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oCreatureToReward));
  int nLevel   = GetHitDice(oCreatureToReward);

  if (fCurrentECL == 0.0)
  {
    fCurrentECL = IntToFloat(gsSUGetECL(nSubRace, nLevel));
  }
  else
  {
    // ECL is stored with a base of 10.0 to distinguish old
    // vs new characters.
    fCurrentECL = IntToFloat(nLevel) + fCurrentECL - 10.0f;
  }

  // Septire - Adjust ECL for RPR.
  // 0 RPR -> 0
  // 10 RPR -> 0
  // 20 RPR -> -0.5 ECL
  // 30 RPR -> -1.0 ECL
  // 40 RPR -> -1.5 ECL
  float fRPR = IntToFloat(gsPCGetRolePlay(oCreatureToReward));
  fRPR = fRPR / 10;
  if (fRPR != 0.0)
  {
    fRPR = (fRPR - 1) / 2;
  }

  fCurrentECL = fCurrentECL - fRPR;

  if (fCurrentECL < 1.0) fCurrentECL = 1.0;

  //apply effective character level
  nAmount = FloatToInt(IntToFloat(nAmount) *
               IntToFloat(nLevel) / fCurrentECL);

  return nAmount;
}

void gsXPRewardKill(object oVictim = OBJECT_SELF, float fRange = 40.0)
{
    object oCreature         = OBJECT_INVALID;
    location lLocation       = GetLocation(oVictim);
    float fRatingVictim      = 0.0;
    float fRating            = 0.0;
    float fRatingNPC         = 0.0;
    float fExperience        = 0.0;
    float fXPMultiplier;
    float fXPMultiplierAssociates;
    int nVictimIsPC          = GetIsPC(oVictim);
    int nExperience          = 0;
    struct Party party;

    //compute victim rating
    if (nVictimIsPC)
    {
        fRatingVictim = IntToFloat(GetHitDice(oVictim));
    }
    else if (! GetLevelByClass(CLASS_TYPE_COMMONER, oVictim))
    {
        fRatingVictim = GetChallengeRating(oVictim);
    }
	
	if (fRatingVictim < 1.0f) fRatingVictim = 1.0f;

	// Create a random seed in case multiple NPC deaths are being processed at once (e.g. AoE effects) to avoid the "this PC has
	// been rewarded" flag from firing. 
	string sRandom = IntToString(Random(99999));
	
    //compute rating
    if(oVictim == OBJECT_SELF) party = _CountParty(party, GetLastKiller(), fRange, oVictim, sRandom);
    oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);

    while (GetIsObjectValid(oCreature))
    {
        if (! GetIsDMPossessed(oCreature) &&
            GetIsReactionTypeHostile(oVictim, oCreature) &&
            !GetIsDead(oCreature))
        {
            if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
            {
                party = _CountParty(party, oCreature, fRange, oVictim, sRandom);
            }
            else
            {
                fRating     = GetChallengeRating(oCreature) / 2.0;
                fRating    *= fRating;
                fRatingNPC += fRating;
            }
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);
    }

    if (party.challengeRating == 0.0)   return;

    // Spread XP out for lower level characters. See __server_config.
    float fVariance = GetLocalFloat(GetModule(), GS_XP_VARIANCE_VAR);
    if (FloatToInt(party.challengeRating) <=
          GetLocalInt(GetModule(), GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER_VAR))
         fVariance *= GetLocalFloat(GetModule(), GS_XP_VARIANCE_MULTIPLIER_VAR);
    fRating = ((fRatingVictim/(2*sqrt(party.challengeRating * party.challengeRating + fRatingNPC))) - 0.5)/fVariance + 1.0;

    if (fRating < 0.0)      fRating = 0.0;
    else if (fRating > 2.0) fRating = 2.0;
    fExperience = IntToFloat(GetLocalInt(GetModule(), GS_XP_BASE_XP_VAR)) * fRating;

    fXPMultiplier = GetPartyExperienceMultiplier(IntToFloat(party.countPC));
    fXPMultiplierAssociates = GetPartyExperienceMultiplier(IntToFloat(party.countPC) + IntToFloat(party.countAssociates) / 2.0);

    if(fXPMultiplierAssociates < fXPMultiplier) fXPMultiplier = fXPMultiplierAssociates;
    fExperience *= fXPMultiplier;

    nExperience = FloatToInt(fExperience);
    if (nExperience <= 0)                    nExperience  = 1;
    else if (gsBOGetIsBossCreature(oVictim)) nExperience *= 4;
	
    //distribute experience
    oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);
	
    while (GetIsObjectValid(oCreature))
    {
        if (GetIsPC(oCreature)  &&
            GetIsReactionTypeHostile(oVictim, oCreature))
        {
            _DistributePartyExperience(oCreature, nExperience, fRange, oVictim, sRandom);
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);
    }

    if(oVictim == OBJECT_SELF)
    {
        // Always distribute experience to the killer, even if none of their party
        // members are in LoS.
        oCreature = GetLastKiller();
        if(GetIsObjectValid(GetMaster(oCreature))) oCreature = GetMaster(oCreature);
        _DistributePartyExperience(oCreature, nExperience, fRange, oVictim, sRandom);
    }
}
//----------------------------------------------------------------
int gsXPGetDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE)
{
    int nHitDice = GetHitDice(oPC);
    int nXP      = GetXP(oPC);
    int nLimit   = nXP - 3000; //level 3
    int nStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

    if (nStaticLevel) return 0;

    //determine penalty
    if (! nPenalty)
    {
        if (nHitDice > 20)      nPenalty = GS_XP_PENALTY_PER_LEVEL_HIGH;
        else if (nHitDice > 10) nPenalty = GS_XP_PENALTY_PER_LEVEL_MEDIUM;
        else                    nPenalty = GS_XP_PENALTY_PER_LEVEL_LOW;
        nPenalty *= nHitDice;
    }

    // Take a whole level instead
    if (! nPenalty)
    {
        nPenalty  = nXP - (nHitDice - 1) * (nHitDice - 2) / 2 * 1000 - nHitDice * 100;
    }

    //start safety
    if (nPenalty > nLimit) nPenalty = nLimit;

    //level safety
    if (nLevelSafe)
    {
        nLimit = nXP - nHitDice * (nHitDice - 1) / 2 * 1000;
        if (nPenalty > nLimit) nPenalty = nLimit;
    }

    return nPenalty < 0 ? 0 : nPenalty;
}
//----------------------------------------------------------------
void gsXPApplyDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE)
{
    nPenalty = gsXPGetDeathPenalty(oPC, nPenalty, nLevelSafe);
    if (nPenalty > 0) gsXPGiveExperience(oPC, -nPenalty);
}
//----------------------------------------------------------------
void gsXPDistributeExperience(object oCreature, int nAmount)
{
    object oArea   = GetArea(oCreature);
    object oMember = GetFirstFactionMember(oCreature);

    while (GetIsObjectValid(oMember))
    {
        if (oArea == GetArea(oMember) &&
            GetDistanceBetween(oCreature, oMember) <= 40.0)
        {
            gsXPGiveExperience(oMember, nAmount);
        }

        oMember = GetNextFactionMember(oCreature);
    }
}
//----------------------------------------------------------------
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE)
{
    if (nAmount == 0) return;	
	
	// If the PC is a ghost, skip.
	if (GetLocalInt(gsPCGetCreatureHide(oCreature), "IS_GHOST"))
	{
	  SendMessageToPC(oCreature, "You cannot gain XP while you are a ghost.");
	  return;
	}

    // Edit by Mithreas: If the PC is possessing a familiar, give
    // xp/alignment shifts to the PC. --[
    object oCreatureToReward = oCreature;

    if (GetIsPossessedFamiliar(oCreature))
    {
      oCreatureToReward = GetMaster(oCreature);
    }
    // ]-- See other refs to oCreatureToReward below.

    string sMessage  = "";
    int nXP          = GetXP(oCreatureToReward);

    if (nAmount > 0)
    {
        int nLevel   = GetHitDice(oCreatureToReward);
        int nXPLevel = (nLevel + 1) * nLevel / 2 * 1000;

        if (nKill)
        {
            if (GS_XP_KILL_PER_LEVEL > 0 && nLevel > 4)
            {
                int nTimestamp = gsTIGetActualTimestamp();
                int nTimeout   = gsXPGetKillTimeout(oCreatureToReward);
                int nLimit     = 0;

                if (nTimeout < nTimestamp)
                {
                    nTimeout = nTimestamp + gsTIGetGameTimestamp(60 * 60 * 24); //24 RL hours
                    gsXPSetKillTimeout(oCreatureToReward, nTimeout);
                }
                else
                {
                    nLimit   = gsXPGetKillLimit(oCreature);

                    if (nLimit > nLevel * GS_XP_KILL_PER_LEVEL)
                    {
                        SendMessageToPC(oCreature, GS_T_16777314);
                        return;
                    }
                }

                gsXPSetKillLimit(oCreatureToReward, nLimit + nAmount);
            }

            nAmount = _AdjustXPForECL(nAmount, oCreatureToReward);

            if (nAmount <= 0) nAmount = 1;

            // check for adventure mode
            if (gvd_GetAdventureMode(oCreatureToReward) == 1) {
              // adventure mode is on, give 50% directly, 100% to adv pool
              gvd_AdventuringXP_GiveXP(oCreatureToReward, nAmount, "Adventure Mode");
              nAmount = nAmount / 2;
            }
        }
	
		// Check for PCs over the "soft cap"
		// Max XP from kills is 40 (x4 for bosses), and from traps is 40.  From quests it could be a
		// a couple of hundred.  Divide by 4 and add 1 so that you get up to 10 for ordinary mobs, exceptions 
		// for bosses and quests.  Typical XP will be 6 for things of the same level as you (note level now
		// factors in feat purchases).
		if (nKill != 2 && GetHitDice(oCreatureToReward) >= GetLocalInt(GetModule(), "STATIC_LEVEL"))
		{
		  nAmount /= 4;
		  nAmount += 1;
		}

        if (nXP >= nXPLevel)
        {
            // Edit by Mithreas: don't spam XP-capped level 15s. --[
            if (nLevel == 15) return;
            // ]-- End edit
            SendMessageToPC(oCreature, GS_T_16777341);
            return;
        }

        sMessage     = "<cªÕþ>+";
    }
    else
    {
        sMessage     = "<cþ((>";
    }

    int level = GetHitDice(oCreatureToReward);
    SetXP(oCreatureToReward, nXP + nAmount);

    if (GetIsPC(oCreatureToReward))
    {
        if (level > GetHitDice(oCreatureToReward)) // We deleveled
        {
		  ExecuteScript("m_level_down", oCreatureToReward);
        }
    }

    gsPCMemorizeClassData(oCreatureToReward);

    sMessage        += IntToString(nAmount) + " " + GS_T_16777315;
    if (nFloat)       FloatingTextStringOnCreature(sMessage, oCreature, FALSE);
    else              SendMessageToPC(oCreature, sMessage);
}
//----------------------------------------------------------------
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE, int nApplyECL = FALSE)
{
    if (! nBonus) return;

    string sColor   = "";
    string sType    = "";
    string sSubType = "";
    int nDM         = GetIsDM(OBJECT_SELF);

    if (nBonus < 0)
    {
        sColor = "<cþ((>";
        sType  = GS_T_16777316;

        if (nBonus < GS_XP_PUNISHMENT_MEDIUM)   sSubType = GS_T_16777321;
        else if (nBonus < GS_XP_PUNISHMENT_LOW) sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777319;
    }
    else
    {
        sColor = "<cªÕþ>";
        sType  = GS_T_16777317;

        if (nBonus <= GS_XP_BONUS_MINI)         sSubType = GS_T_16777318;
        else if (nBonus <= GS_XP_BONUS_LOW)     sSubType = GS_T_16777319;
        else if (nBonus <= GS_XP_BONUS_MEDIUM)  sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777321;
    }

    if (nParty)
    {
        object oMember = GetFirstFactionMember(oCreature);

        while (GetIsObjectValid(oMember))
        {
            SendMessageToPC(
                oMember,
                sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
            if (nDM)
                SendMessageToAllDMs(
                    gsCMReplaceString(
                        GS_T_16777323,
                        GetName(oMember),
                        sSubType + " " + sType,
                        GetName(OBJECT_SELF)));

            if (nApplyECL) nBonus = _AdjustXPForECL(nBonus, oMember);
            gsXPGiveExperience(oMember, nBonus);

            oMember = GetNextFactionMember(oCreature);
        }
    }
    else
    {
        SendMessageToPC(
            oCreature,
            sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
        if (nDM)
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777323,
                    GetName(oCreature),
                    sSubType + " " + sType,
                    GetName(OBJECT_SELF)));

        if (nApplyECL) nBonus = _AdjustXPForECL(nBonus, oCreature);
        gsXPGiveExperience(oCreature, nBonus);
    }
}
//----------------------------------------------------------------
void gsXPSetKillLimit(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillLimit(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_LIMIT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
void gsXPSetKillTimeout(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillTimeout(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_TIMEOUT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE)
{
    int nClass2       = GetClassByPosition(2, oPC);
    if (nClass2 == CLASS_TYPE_INVALID) return 100; //no multi class character
    int nLevel2       = GetLevelByClass(nClass2, oPC);
    int nClass1       = GetClassByPosition(1, oPC);
    int nLevel1       = GetLevelByClass(nClass1, oPC);
    int nClass3       = GetClassByPosition(3, oPC);
    int nLevel3       = nClass3 == CLASS_TYPE_INVALID ? 0 : GetLevelByClass(nClass3, oPC);
    int nFavoredClass = CLASS_TYPE_INVALID;
    int nNth          = 0;

    //order classes by level
    if (nLevel3)
    {
        if (nLevel3 > nLevel1)
        {
            nNth    = nClass1;
            nClass1 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel1;
            nLevel1 = nLevel3;
            nLevel3 = nNth;
        }

        if (nLevel3 > nLevel2)
        {
            nNth    = nClass2;
            nClass2 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel2;
            nLevel2 = nLevel3;
            nLevel3 = nNth;
        }
    }

    if (nLevel2 > nLevel1)
    {
        nNth    = nClass1;
        nClass1 = nClass2;
        nClass2 = nNth;
        nNth    = nLevel1;
        nLevel1 = nLevel2;
        nLevel2 = nNth;
    }

    //favored class
    if (nSubRace)
    {
        nFavoredClass = gsSUGetFavoredClass(nSubRace, GetGender(oPC));
    }
    else
    {
        switch (GetRacialType(oPC))
        {
        case RACIAL_TYPE_DWARF:
            nFavoredClass = CLASS_TYPE_FIGHTER;
            break;

        case RACIAL_TYPE_ELF:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_GNOME:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_HALFELF:
            nFavoredClass = nClass1;
            break;

        case RACIAL_TYPE_HALFLING:
            nFavoredClass = CLASS_TYPE_ROGUE;
            break;

        case RACIAL_TYPE_HALFORC:
            nFavoredClass = CLASS_TYPE_BARBARIAN;
            break;

        case RACIAL_TYPE_HUMAN:
            nFavoredClass = nClass1;
            break;
        }
    }

    // Edits by Mithreas to correct a number of XP-related bugs. Compare
    // levels in classes, not class constants (i.e. nLevel* not nClass*).
    // --[
    if ((nClass3 != CLASS_TYPE_INVALID) &&
        (nClass3 != nFavoredClass) &&
        !gsXPGetIsPrestigeClass(nClass3)
       )
    {
        if ((nClass1 == nFavoredClass) || gsXPGetIsPrestigeClass(nClass1))
        {
            if (gsXPGetIsPrestigeClass(nClass2)) return 100;
            if (nLevel2 - nLevel3 > 1) return 80;
            return 100;
        }

        if ((nClass2 == nFavoredClass) || gsXPGetIsPrestigeClass(nClass2))
        {
            if (nLevel1 - nLevel3 > 1) return 80;
            return 100;
        }

        if (nLevel1 - nLevel2 > 1)
        {
            if (nLevel2 - nLevel3 > 1) return 60;
            // if (nLevel1 - nLevel3 > 1) return 60; - this is not needed (1>2).
            return 80;
        }

        if (nLevel2 - nLevel3 > 1) // Added by Mith.
        {
          // 1 and 2 are within 1 level of each other and 1>2. So only 3 is out
          // of step.
          return 80;
        }
    }

    if (nClass1 == nFavoredClass) return 100;
    if (nClass2 == nFavoredClass) return 100;
    if (gsXPGetIsPrestigeClass(nClass1)) return 100;
    if (gsXPGetIsPrestigeClass(nClass2)) return 100;
    if (nLevel1 - nLevel2 > 1)    return  80;
    // ]-- End edits.
    return 100;
}
//----------------------------------------------------------------
// Added by Mith --[
int gsXPGetIsPrestigeClass(int nClass)
{
  switch (nClass)
  {
    case CLASS_TYPE_ARCANE_ARCHER:
    case CLASS_TYPE_ASSASSIN:
    case CLASS_TYPE_BLACKGUARD:
    case CLASS_TYPE_DIVINE_CHAMPION:
    case CLASS_TYPE_DRAGON_DISCIPLE:
    case CLASS_TYPE_DWARVEN_DEFENDER:
    case CLASS_TYPE_EYE_OF_GRUUMSH:
    case CLASS_TYPE_PALE_MASTER:
    case CLASS_TYPE_SHADOWDANCER:
    case CLASS_TYPE_SHIFTER:
    case CLASS_TYPE_SHOU_DISCIPLE:
    case CLASS_TYPE_WEAPON_MASTER:
      return TRUE;
    default:
  }

  return FALSE;
}
// ]-- End addition.
//----------------------------------------------------------------
float GetPartyExperienceMultiplier(float fPartySize)
{
    if(fPartySize >= 10.0) return 0.0;
    if(fPartySize >= 9.5)  return 0.125;
    if(fPartySize >= 9.0)  return 0.25;
    if(fPartySize >= 8.5)  return 0.375;
    if(fPartySize >= 8.0)  return 0.5;
    if(fPartySize >= 7.5)  return 0.625;
    if(fPartySize >= 6.0)  return 0.75;
    if(fPartySize >= 5.5)  return 0.9;
    if(fPartySize >= 5.0)  return 1.05;
    if(fPartySize >= 4.5)  return 1.075;
    if(fPartySize >= 4.0)  return 1.1;
    if(fPartySize >= 3.5)  return 1.075;
    if(fPartySize >= 2.0)  return 1.05;
    if(fPartySize >= 1.5)  return 1.0;
    return 0.95;
}
// Distributes XP to all PC party members within the given range.
void _DistributePartyExperience(object oPC, int nAmount, float fRange, object oVictim, string sRandom)
{
    object oMember = GetFirstFactionMember(oPC);
	int bKill = (GetLocalInt(oVictim, "RAID_BOSS") ? 2 : TRUE);

    while(GetIsObjectValid(oMember))
    {
        if(!GetLocalInt(oMember, "PartyXPDistributed" + sRandom) &&
            ((GetDistanceBetween(oMember, oVictim) <= fRange && GetDistanceBetween(oMember, oVictim) != 0.0 && GetArea(oMember) == GetArea(oVictim)) || oPC == oMember))
        {
            gsXPGiveExperience(oMember, nAmount, TRUE, bKill);
            SetLocalInt(oMember, "PartyXPDistributed" + sRandom, TRUE);
            DelayCommand(0.0, DeleteLocalInt(oMember, "PartyXPDistributed" + sRandom));
        }
        oMember = GetNextFactionMember(oPC);
    }
}

// Returns a "CR" value for the PC, either the PC's level or the CR of their most
// powerful summon, whichever is higher.
float gsXPGetPCChallengeRating(object oPC, float fRange, object oVictim)
{
    if(GetIsObjectValid(GetMaster(oPC))) oPC = GetMaster(oPC);

    int i;
	
	// Count full levels plus 1 for every 5 purchased feats to a max of 50.  (FL_LEVEL includes hit dice so compensate for that).  Add ECL, which is stored as 10+ECL on the hide.
	int nEffectiveLevel = (GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") - GetHitDice(oPC)) / 5;
	if (nEffectiveLevel > 10) nEffectiveLevel = 10;
    float fCR = IntToFloat(GetHitDice(oPC) + nEffectiveLevel) + GetLocalFloat(gsPCGetCreatureHide(oPC), "ECL") - 10.0f;
    object oAssociate;

    do
    {
        i++;
        oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
        if(GetChallengeRating(oAssociate) > fCR && GetDistanceBetween(oAssociate, oVictim) <= fRange && GetDistanceBetween(oAssociate, oVictim) != 0.0)
        {
            fCR = GetChallengeRating(oAssociate);
        }
    } while(GetIsObjectValid(oAssociate));

    return fCR;
}

// Counts and returns all party members with range of the given PC as a party struct.
struct Party _CountParty(struct Party party, object oPC, float fRange, object oVictim, string sRandom)
{
    // If we have already counted this PC we will already have counted their party.
    if (GetLocalInt(oPC, "PartyMemberCounted" + sRandom)) return party; 
	
    float fCR;
    object oMember = GetFirstFactionMember(oPC, FALSE);

    while(GetIsObjectValid(oMember))
    {
        // dunshine: don't count lassoed creatures in the rating calculations
        if (GetEventScript(oMember, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT) != "gvd_roped_hb") {

          if(!GetLocalInt(oMember, "PartyMemberCounted" + sRandom) &&
            ((GetDistanceBetween(oMember, oVictim) <= fRange && GetDistanceBetween(oMember, oVictim) != 0.0 && GetArea(oMember) == GetArea(oVictim)) || oPC == oMember))
          {
            if(GetIsPC(oMember))
            {
                party.countPC++;
                fCR = gsXPGetPCChallengeRating(oMember, fRange, oVictim);
                if(fCR > party.challengeRating) party.challengeRating = fCR;
            }
            // Only counts the first summon.
            else if(!(GetAssociateType(oMember) == ASSOCIATE_TYPE_SUMMONED && GetAssociate(ASSOCIATE_TYPE_SUMMONED, GetMaster(oMember)) != oMember))
            {
                party.countAssociates++;
            }
            SetLocalInt(oMember, "PartyMemberCounted" + sRandom, TRUE);
            DelayCommand(0.0, DeleteLocalInt(oMember, "PartyMemberCounted" + sRandom));
          }
        }
        oMember = GetNextFactionMember(oPC, FALSE);
    }
    return party;
}

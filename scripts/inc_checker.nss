// Character legality checker. Used to spot hacked characters.
//
// Known issues - doesn't check spells known (or spells per day).
// Doesn't check that all the feats a character has are legal for them (just
// that they have the right number of feats). Doesn't account for cross class
// skills (so e.g. a fighter with 4 starting Tumble would pass).
//
#include "inc_log"
#include "inc_pc"
#include "inc_class"
#include "inc_quickbar"
const string CHECKER = "CHECKER"; // for tracing

const int MAX_FEAT  = 426; // Very few after here, so do them by hand for perf
                           // reasons.
const int MAX_SKILL = 26;

const int GS_EXPERIENCE_BASE = 1000; //level 2

// Bans the PC and boots them from the server with a "friendly" message.
void miBootAndBanPC (object oPC);

// Ensures that the provided player has no metamagic on their bars
// which they should not have, e.g. through delevelling.
void VerifyQuickbarMetaMagic(object pc);

// verify if oPC still meets all requirements for their feats (for now it just logs those invalid feats)
void VerifyFeatRequirements(object oPC);

// City of Winds method for enforcing current class restrictions by race.
int CoW_HasAllowedClasses(object oPC);

string GetSummarisedPlayerInfo(object pc)
{
    return GetName(pc) + " (player ID " + GetPCPlayerName(pc) + ", cd key " + GetPCPublicCDKey(pc, TRUE) + ")";
}

void miBootAndBanPC (object oPC)
{
    SendMessageToPC(oPC, "<cþ  >We have detected that you are attempting to play an illegal character. " +
        "This could be caused by client-side modifications. " +
        "Please reinstall your game, removing all client-side modifications, then try again or contact arelith.dm@gmail.com. ");
    SendMessageToAllDMs("<cþ  >" + GetSummarisedPlayerInfo(oPC) + " just created an illegal character and is booted.");
    Error(CHECKER, "<cþ  >" + GetSummarisedPlayerInfo(oPC) + " just created an illegal character and is booted.");
    //gsPCBanPlayer(oPC, FALSE, GetPCPublicCDKey(oPC), GetPCPlayerName(oPC), GetPCIPAddress(oPC));
    DelayCommand(5.0, BootPC(oPC));
}

void VerifyQuickbarMetaMagic(object pc)
{
    int foundInvalidSpell = FALSE;

    int i;
    for (i = 0; i < QUICKBARSLOT_COUNT; ++i)
    {
        struct QuickBarSlot qbs = GetQuickBarSlot(pc, i);

        if (qbs.type == QUICKBAR_TYPE_SPELL)
        {
            if (qbs.meta == QUICKBAR_METAMAGIC_NONE)
            {
                continue;
            }

            string invalidMetaAsStr = "";

            if (qbs.meta == QUICKBAR_METAMAGIC_EMPOWER && !GetHasFeat(FEAT_EMPOWER_SPELL, pc))
            {
                invalidMetaAsStr = "Empower Spell";
            }
            else if (qbs.meta == QUICKBAR_METAMAGIC_EXTEND && !GetHasFeat(FEAT_EXTEND_SPELL, pc))
            {
                invalidMetaAsStr = "Extend Spell";
            }
            else if (qbs.meta == QUICKBAR_METAMAGIC_MAXIMIZE && !GetHasFeat(FEAT_MAXIMIZE_SPELL, pc))
            {
                invalidMetaAsStr = "Maximize Spell";
            }
            else if (qbs.meta == QUICKBAR_METAMAGIC_QUICKEN && !GetHasFeat(FEAT_QUICKEN_SPELL, pc))
            {
                invalidMetaAsStr = "Quicken Spell";
            }
            else if (qbs.meta == QUICKBAR_METAMAGIC_SILENT && !GetHasFeat(FEAT_SILENCE_SPELL, pc))
            {
                invalidMetaAsStr = "Silent Spell";
            }
            else if (qbs.meta == QUICKBAR_METAMAGIC_STILL && !GetHasFeat(FEAT_STILL_SPELL, pc))
            {
                invalidMetaAsStr = "Still Spell";
            }

            if (invalidMetaAsStr != "") // Bad things have been found!
            {
                qbs.type = QUICKBAR_METAMAGIC_NONE;
                SetQuickBarSlot(pc, qbs);

                string output = GetSummarisedPlayerInfo(pc) +
                    " has spell id " +
                    IntToString(qbs.id) +
                    " (" + Get2DAString("spells", "LABEL", qbs.id) +
                    ") " +
                    "on their quickbars using metamagic " +
                    invalidMetaAsStr +
                    ", but does not have the matching feat!";

                Error(CHECKER, output);
                SendMessageToAllDMs("<cþ  >" + output);
                foundInvalidSpell = TRUE;
            }
        }
    }

    if (foundInvalidSpell)
    {
        SendMessageToPC(pc, "You have one or more spells on your quickbars using metamagic " +
            "your character is incapable of casting. This may have been caused " +
            "by losing a level after learning a metamagic feat. " +
            "The slot(s) in question have been cleared.");
    }
}

void VerifyFeatRequirements(object oPC) {
 
  int iFeats = NWNX_Creature_GetFeatCount(oPC);
  int iFeat = 0;
  int iCurrentFeat;
  int bSniper = GetIsSniper(oPC);
  int bShadowMage = GetIsShadowMage(oPC);
  int iSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iShadowMageLevel = (iSorcererLevel > iWizardLevel) ? iSorcererLevel : iWizardLevel;
  int iRangerLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
  string sSubRace;
  string sClass;
  
  // get subrace and class data to add to logs
  int iSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
  if (iSubRace == GS_SU_NONE) {
    sSubRace = gsSUGetRaceName(GetRacialType(oPC));
  } else {
    sSubRace = gsSUGetNameBySubRace(iSubRace);
  }
  string sClassComposition = "Class 1: " + gvd_GetArelithClassNameByPosition(1, oPC) + "(" + IntToString(GetLevelByPosition(1, oPC)) + ")" + "; Class 2: " + gvd_GetArelithClassNameByPosition(2, oPC) + "(" + IntToString(GetLevelByPosition(2, oPC)) + ")" + "; Class 3: " + gvd_GetArelithClassNameByPosition(3, oPC) + "(" + IntToString(GetLevelByPosition(3, oPC)) + ")";

  // loop through the characters feats
  while (iFeat < iFeats) {

    iCurrentFeat = NWNX_Creature_GetFeatByIndex(oPC, iFeat);

    // check requirements
    if (NWNX_Creature_GetMeetsFeatRequirements(oPC, iCurrentFeat) != 1) {
      // check exceptions
      if        (bSniper && (iCurrentFeat == FEAT_MOBILITY) && (iRangerLevel >= 9)) {
      } else if (bSniper && (iCurrentFeat == FEAT_RAPID_SHOT)) {
      } else if (bSniper && (iCurrentFeat == FEAT_POINT_BLANK_SHOT)) {
      } else if (bSniper && (iCurrentFeat == FEAT_CALLED_SHOT) && (iRangerLevel >= 9)) {
      } else if (iCurrentFeat == FEAT_HORSE_MENU) {
      } else if (bShadowMage && (iCurrentFeat == FEAT_HIDE_IN_PLAIN_SIGHT) && (iShadowMageLevel >= 20)) {
      } else {
        // possible issue, log
        WriteTimestampedLogEntry("CHECKER - FEATS - PC: " + GetName(oPC) + " Race: " + sSubRace + " Classes: " + sClassComposition + " does not meet requirements for feat " + IntToString(iCurrentFeat));
      }
    }

    // next feat
    iFeat = iFeat + 1;
  }

}

int GetHasPermission(int nClass, object oPC)
{
  object oPermission = GetItemPossessedBy(oPC, "GS_PERMISSION_CLASS_" + IntToString(nClass));
  return GetIsObjectValid(oPermission);
}

int CoW_HasAllowedClasses(object oPC)
{
  if (GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE)) return FALSE;
  if (GetLevelByClass(CLASS_TYPE_SHIFTER)) return FALSE;

  switch (GetRacialType(oPC))
  {
    case RACIAL_TYPE_HUMAN:
	{
	  if ((GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && !GetHasPermission(CLASS_TYPE_WIZARD, oPC)) ||
	      (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) && !GetHasPermission(CLASS_TYPE_SORCERER, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_BARD, oPC) && !GetHasPermission(CLASS_TYPE_BARD, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_DRUID, oPC) && !GetHasPermission(CLASS_TYPE_DRUID, oPC)))
      {
	    return FALSE;
	  }
	  else
	  {
	    return TRUE;
	  }
	}
	case RACIAL_TYPE_HALFLING:
	{
	  if ((GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && !GetHasPermission(CLASS_TYPE_WIZARD, oPC)) ||
	      (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) && !GetHasPermission(CLASS_TYPE_SORCERER, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && !GetHasPermission(CLASS_TYPE_CLERIC, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) && !GetHasPermission(CLASS_TYPE_PALADIN, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) && !GetHasPermission(CLASS_TYPE_BLACKGUARD, oPC)))
      {
	    return FALSE;
	  }
	  else
	  {
	    return TRUE;
	  }
	}
	case RACIAL_TYPE_ELF:
	{
	  if ((GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && !GetHasPermission(CLASS_TYPE_CLERIC, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) && !GetHasPermission(CLASS_TYPE_PALADIN, oPC)) ||
		  (GetLevelByClass(CLASS_TYPE_DRUID, oPC) && !GetHasPermission(CLASS_TYPE_DRUID, oPC))||
		  (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) && !GetHasPermission(CLASS_TYPE_BLACKGUARD, oPC)))
	  {
	    return FALSE;
	  }
	  else
	  {
	    return TRUE;
	  }
	}
	default:
	  return FALSE;
  }
  
  return FALSE;
}

#include "inc_finance"

// Dunshine: moved all reward functions to this include file so they can be called from other scripts (i.e. MoD deaths in inc_death)

const string AWARD_MAJOR = "Major";     //award 1
const string AWARD_NORMAL = "Normal";   //award 2
const string AWARD_MINOR = "Minor";     //award 3

// function that handles the reward rolls for oPC
void gvd_DoRewards(object oPC);


// Algorithm for adjusting gold piece worth of items
int _goldCalculationAlgorithm(int nRawGoldPieceValue) {
  int nReturn = 0;
  if (nRawGoldPieceValue <= 50000) {
    nReturn = FloatToInt(nRawGoldPieceValue * 0.4);
  }
  else {
    nReturn = FloatToInt(nRawGoldPieceValue * 0.5);
    nReturn = (nReturn > 50000) ? 50000 : nReturn;
  }
  return nReturn;
}

// Return the gold piece value the character has (custom algorithm to approximate worth)
int _calculatePCWorth(object oPC) {

  int nReturn = 0;
  object oFirst = GetFirstItemInInventory(oPC);
  int relativeGoldWorth;
  // aggregate worth of inventory items, exlcude ammo tiems
  while (oFirst != OBJECT_INVALID) {
    if(GetBaseItemType(oFirst) !=  BASE_ITEM_BOLT && GetBaseItemType(oFirst) !=  BASE_ITEM_ARROW && GetBaseItemType(oFirst) !=  BASE_ITEM_BULLET) {
      relativeGoldWorth = _goldCalculationAlgorithm(GetGoldPieceValue(oFirst));
      nReturn += relativeGoldWorth;
    }
    oFirst = GetNextItemInInventory(oPC);
  }
  // aggregate worth of equipped items, excluded ammo slots
  int i;
  for (i = 0; i <= 10; i++) {
    oFirst = GetItemInSlot(i, oPC);
    relativeGoldWorth = _goldCalculationAlgorithm(GetGoldPieceValue(oFirst));
    nReturn += relativeGoldWorth;
  }

  // Add held gold piece value
  nReturn += GetGold(oPC);

  // Add bank account
  int nCurrentBalance = gsFIGetAccountBalance(gsPCGetPlayerID(oPC));
  nReturn += nCurrentBalance;

  return nReturn;
}

// Calculate flat bonus from artefacts.
int _calculateArteBonus(object oPC)
{
    int nReturn = 0;
    int nTotalValue = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID)
    {
        if (GetLocalInt(oItem, "gvd_artifact_legacy") || GetLocalInt(oItem, "gvd_artifact_legacy")) {
            if (GetLocalInt(oItem, "STORED_ARTEFACT_VALUE"))
                nTotalValue += GetLocalInt(oItem, "STORED_ARTEFACT_VALUE");
            else
                nTotalValue += _goldCalculationAlgorithm(GetGoldPieceValue(oItem));
        }
        oItem = GetNextItemInInventory(oPC);
    }

    // check equipped items
    int i;
    for (i = 0; i < 10; i++)
    {
        oItem = GetItemInSlot(i, oPC);
        if (GetIsObjectValid(oItem) && (GetLocalInt(oItem, "gvd_artifact_legacy") || GetLocalInt(oItem, "gvd_artifact_legacy"))) {
            if (GetLocalInt(oItem, "STORED_ARTEFACT_VALUE"))
                nTotalValue += GetLocalInt(oItem, "STORED_ARTEFACT_VALUE");
            else
                nTotalValue += _goldCalculationAlgorithm(GetGoldPieceValue(oItem));
        }
    }

    if (nTotalValue) {
        nReturn = 1 + nTotalValue / 50000;
        if (nReturn > 5)
            nReturn = 5;
    }
    return nReturn;
}

void _Grant5Percent(object oPC, string sAwardLevel)
{
  string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));

  if (sAwardLevel == AWARD_MAJOR) {
    int nAwards = StringToInt(miDAGetKeyedValue("gs_player_data", sID, "award1"));
    miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(nAwards+1));
  }
  else if (sAwardLevel == AWARD_NORMAL) {
    int nAwards = StringToInt(miDAGetKeyedValue("gs_player_data", sID, "award2"));
    miDASetKeyedValue("gs_player_data", sID, "award2", IntToString(nAwards+1));
  }
  else {
    int nAwards = StringToInt(miDAGetKeyedValue("gs_player_data", sID, "award3"));
    miDASetKeyedValue("gs_player_data", sID, "award3", IntToString(nAwards+1));
  }
  WriteTimestampedLogEntry("5% DEATH AWARD -delete_char: Award granted: " + sAwardLevel + " For: " + GetName(oPC) + " " + GetPCPublicCDKey(oPC));
  FloatingTextStringOnCreature("Congratulations!  You earned a " + sAwardLevel + " award!", oPC);
}



void gvd_DoRewards(object oPC) {

      // Perform award roll
      int nRoll = d100();
      int nLevel = GetHitDice(oPC);

      // FL Server
      if (GetLocalInt(GetModule(), "STATIC_LEVEL")) {
        nLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL");
      }

	  // No rolls any more. 
	  // FL 15+ = minor
	  // FL 50+ = medium
	  // FL 100+ = major
	  
	  if (nLevel >= 100) _Grant5Percent(oPC, AWARD_MAJOR);
	  else if (nLevel >= 50) _Grant5Percent(oPC, AWARD_NORMAL);
	  else if (nLevel >= 15) _Grant5Percent(oPC, AWARD_MINOR);
	  
      WriteTimestampedLogEntry("5% DEATH AWARD -delete_char: Level: " + IntToString(nLevel) + " For: " + GetName(oPC) + " " + GetPCPublicCDKey(oPC));

}


/* COMMON Library by Gigaschatten */

//void main() {}

#include "gs_inc_flag"
#include "gs_inc_pc"
#include "gs_inc_text"
#include "inc_spells"
#include "x2_inc_itemprop"
#include "x3_inc_string"
#include "inc_subrace"
#include "fb_inc_names"
#include "inc_stacking"

const string GS_CM_TEMPLATE_RECREATOR         = "gs_placeable034";
const string GS_CM_TEMPLATE_GOLD              = "nw_it_gold001";
const string GS_CM_TEMPLATE_CACHE             = "mi_da_cache";

const int GS_CM_TEMPLATE_TYPE_TREASURE_LOW    =  1;
const int GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM =  2;
const int GS_CM_TEMPLATE_TYPE_TREASURE_HIGH   =  3;
const int GS_CM_TEMPLATE_TYPE_TREASURE_UNIQUE =  4;
const int GS_CM_TEMPLATE_TYPE_WEAPON_LOW      =  5;
const int GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM   =  6;
const int GS_CM_TEMPLATE_TYPE_WEAPON_HIGH     =  7;
const int GS_CM_TEMPLATE_TYPE_WEAPON_UNIQUE   =  8;
const int GS_CM_TEMPLATE_TYPE_ARMOR_LOW       =  9;
const int GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM    = 10;
const int GS_CM_TEMPLATE_TYPE_ARMOR_HIGH      = 11;
const int GS_CM_TEMPLATE_TYPE_ARMOR_UNIQUE    = 12;

//open oStore to oCustomer trading with oMerchant
void gsCMOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF);
//destroy any object within oObject
void gsCMDestroyInventory(object oObject = OBJECT_SELF);
//transfer any item if nDroppable from oSource to oTarget including Gold
void gsCMTransferInventory(object oSource, object oTarget, int nDroppable = TRUE);
//completely destroy oObject
void gsCMDestroyObject(object oObject = OBJECT_SELF);
//resurrect oObject
void gsCMResurrect(object oCreature = OBJECT_SELF);
//teleport oCreature to oTarget using nVisualEffect
void gsCMTeleportToObject(object oCreature, object oTarget, int nVisualEffect = VFX_IMP_AC_BONUS, int bAllowOverride = FALSE);
//teleport oCreature to lTarget using nVisualEffect
void gsCMTeleportToLocation(object oCreature, location lTarget, int nVisualEffect = VFX_IMP_AC_BONUS, int bAllowOverride = FALSE);
//place recreator of oObject to activate after nTimeout
void gsCMCreateRecreator(int nTimeout, object oObject = OBJECT_SELF);
//::  Creates a recreator for Ore Veins as we need 3 more variables to stick between the nTimeout.
//::  Works exactly like 'gsCMCreateRecreator' just with 3 additional parameters to store.
void gsCMCreateRecreatorAsOreVein(int nTimeout, string sOreTemplate, int nOreTimeout, int nDbId, object oObject = OBJECT_SELF);
//place recreator of oObject at lLocation to activate after nTimeout
void gsCMCreateRecreatorAtLocation(location lLocation, int nTimeout, object oObject = OBJECT_SELF);
//place recreator for oObject of random nType to activate after nTimeout
void gsCMCreateRecreatorByType(int nType, int nTimeout, object oObject = OBJECT_SELF);
//return random tamplate of nType
string gsCMGetTemplateByType(int nType);
//create nAmount gold on oTarget
void gsCMCreateGold(int nAmount, object oTarget = OBJECT_SELF);
//return nearest object to oTarget of nType having sTag
object gsCMGetNearestObject(string sTag, int nType = OBJECT_TYPE_PLACEABLE, object oTarget = OBJECT_SELF);
//return object of nType having sTag
object gsCMGetObject(string sTag, int nType = OBJECT_TYPE_WAYPOINT);
//set hitpoints of oCreature to nValue
void gsCMSetHitPoints(int nValue, object oCreature);
//return item level of nValue
int gsCMGetItemLevelByValue(int nValue);
//return a random string of nLength
string gsCMCreateRandomID(int nLength = 16);
//return TRUE if oCreature has nClass
int gsCMGetHasClass(int nClass, object oCreature = OBJECT_SELF);
//return base armor class of oItem
int gsCMGetItemBaseAC(object oItem);
//return base ability modifier of oCreature for nAbility
int gsCMGetBaseAbilityModifier(object oCreature, int nAbility);
//return base nSkill of oCreature taking related nAbility into account
int gsCMGetBaseSkillRank(int nSkill, int nAbility, object oCreature = OBJECT_SELF);
//internally used
int _gsCMGetBaseSkillRank(int nSkill, int nAbility, object oItem);
//send sText to all players
void gsCMSendMessageToAllPCs(string sText);
//return sString exchanging %1 with sReplacement1, %2 with sReplacement2, %3 with sReplacement3 and %4 with sReplacement4
string gsCMReplaceString(string sString, string sReplacement1 = "", string sReplacement2 = "", string sReplacement3 = "", string sReplacement4 = "");
//return nCount concatenations of sRepeat
string gsCMRepeatString(string sRepeat, int nCount);
//remove redundant whitespace from sString
string gsCMCleanWhitespace(string sString);
// Wrapper for CopyItem that preserves description changes.
// oItem - item to copy
// oTargetInventory - create item in this object's inventory. If this parameter
//                    is not valid, the item will be created in oItem's location
// bCopyVars - copy the local variables from the old item to the new one
// bCopyOne - make a single copy of oItem, rather than copying an entire stack
// * returns the new item (or the larger stack, if you've added to a stack)
// * returns OBJECT_INVALID for non-items.
// * can only copy empty item containers. will return OBJECT_INVALID if oItem contains
//   other items.
// * if it is possible to merge this item with any others in the target location,
//   then it will do so and return the merged object.
object gsCMCopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE, int bCopyOne=FALSE);
// Pad sString up to nLength with instances of sCharacter. Fails if sCharacter
// isn't one single character, or if sString is equal to or longer than nLength.
// Pads to the left if bPadRight = TRUE, or to the right if bPadRight = FALSE.
string gsCMPadString(string sString, int nLength, string sCharacter = "0", int bPadRight = FALSE);
// Inverse of gsCMPadString. Strips all instances of sCharacter from the left or
// right of sString.
string gsCMTrimString(string sString, string sCharacter = "0", int bPadRight = FALSE);
// Reduces the stack of oItem by nCount and returns the number left to destroy.
// Will destroy the item if stack size reaches 0.
int gsCMReduceItem(object oItem, int nCount = 1);
// Stops any nearby PCs from following this PC.  Useful before teleporting.
void gsCMStopFollowers(object oPC);
// Formats a float as a nice string to N digits.
string gsCMGetAsString(float fNumber, int nNumDigits = 4);
// Returns a named cache item object, to be used for storing module-wide
// local variables.  Allows us to split these variables up by class.
object gsCMGetCacheItem(string sKey);
// Returns a named cache item, referenced from a specified object, to be used
// for storing object-specific local variables.  Allows us to split these
// variables up by class.
object gsCMGetCacheItemOnObject(string sKey, object oTarget);
// Copies properties between hides.
void gsCMCopyPropertiesAndVariables(object oOldSkin, object oNewSkin);
//struct to hold open store variables
struct openStore md_DoAppraise(object oStore, object oMerchant, object oCustomer);

struct openStore {
    int nMaxBuyPrice;
    int nModifierBonusBuy;
    int nModifierBonusSell;
};

struct openStore md_DoAppraise(object oStore, object oMerchant, object oCustomer)
{
  // Septire - new logic here, the old logic has been removed.
  // The intent of this change is to prevent appraise runs while still making appraise worthwhile.

  int nAppraiseVariance = 0;
  int nMaxBuyPrice = 0;
  string sThisStore = ObjectToString(oStore);
  int nCustomerAppraise;
  int nMerchantAppraise = GetSkillRank(SKILL_APPRAISE, oMerchant, FALSE);
  // Initialization
  if (!GetLocalInt(oStore, "GS_STORE_ENABLED"))
  {
    SetLocalInt(oStore, "GS_STORE_IDENTIFY_COST", GetStoreIdentifyCost(oStore));
    SetLocalInt(oStore, "GS_STORE_MAX_BUY_PRICE", GetStoreMaxBuyPrice(oStore));
    SetLocalInt(oStore, "GS_STORE_ENABLED", TRUE);
  }
  object oWinner;
  int nWinningAppraise;
  int nWinningMaxBuy;
  int x;
  object oSpeaker = oCustomer;               //insure first run always gets an appraise check no matter distance
  while(GetIsObjectValid(oCustomer) && (GetDistanceBetween(oCustomer, oMerchant) <= 5.0 || x==0))
  {

    nCustomerAppraise = GetSkillRank(SKILL_APPRAISE, oCustomer, FALSE);

    // Appraise check
    if (nCustomerAppraise != GetLocalInt(oCustomer, "GS_STORE_APPRAISE_" + sThisStore) ||
      GetLocalInt(oCustomer, "GS_STORE_VALUE_" + sThisStore) == 0)
    {
      SetLocalInt(oCustomer, "GS_STORE_APPRAISE_" + sThisStore, nCustomerAppraise);

      // Variance algorithm
      int nDie1 = d100() / 2;
      int nDie2 = d100() / 2;
      nAppraiseVariance = (nCustomerAppraise*5) - (nMerchantAppraise*5) + nDie1 - nDie2;
      //SendMessageToPC(oCustomer, "DEBUG: CustomerAppraise: " + IntToString(nCustomerAppraise*5));
      //SendMessageToPC(oCustomer, "DEBUG: nMerchantAppraise: " + IntToString(nMerchantAppraise*5));
      //SendMessageToPC(oCustomer, "DEBUG: nDie1: " + IntToString(nDie1));
      //SendMessageToPC(oCustomer, "DEBUG: nDie2: " + IntToString(nDie2));
      //SendMessageToPC(oCustomer, "DEBUG: Rough Variance: " + IntToString(nAppraiseVariance));

      // Check for a racial match
      int nBit = GetLocalInt(oMerchant, "MD_SUBRACE_BIT");
      if(nBit == 0) //no overriding bit, get bit from subrace
      {
        int nRace = GetRacialType(oMerchant);
        nBit = md_ConvertRaceToBit(nRace) | md_ConvertSubraceToBit(GetLocalInt(oMerchant, "MD_SUBRACE")) | md_ConvertSubraceToBit(gsSUGetSubRaceByName(GetSubRace(oMerchant)));


        if(nBit == 0) //hrm maybe it's an NPC race
        {
            if(nRace == RACIAL_TYPE_HUMANOID_GOBLINOID)
                nBit = MD_BIT_HOBGOBLIN | MD_BIT_GOBLIN;
            else if(nRace == RACIAL_TYPE_GIANT)
                nBit = MD_BIT_OGRE;
            else if(nRace == RACIAL_TYPE_FEY)
                nBit = MD_BIT_FEY;
            else if(nRace == RACIAL_TYPE_HUMANOID_REPTILIAN)
                nBit = MD_BIT_KOBOLD;
            else if(nRace == RACIAL_TYPE_HUMANOID_ORC)
                nBit = MD_BIT_OROG | MD_BIT_HORC;
            else if(nRace == RACIAL_TYPE_HUMANOID_MONSTROUS)
                nBit = MD_BIT_GNOLL;
        }
        else
        {
            if(nBit & MD_BIT_SU_ELF) //one surface elf? count for all surfance elves!
                nBit |= MD_BIT_SU_ELF;
            if(nBit & MD_BIT_SU_DWARF) //one surface dwarf? count for all surface dwarves.
                nBit |= MD_BIT_SU_DWARF;
            if(nBit & MD_BIT_SU_HL) //halflings
                nBit |= MD_BIT_SU_HL;
            if(nBit & MD_BIT_SU_GNOMES || nBit & MD_BIT_DEEP_GNOME) //gnomes!
                nBit |= MD_BIT_SU_GNOMES | MD_BIT_DEEP_GNOME;
            if(nBit & MD_BIT_HUMAN) //humans nice to the orcs and half-elvesd
                nBit |= MD_BIT_HORC | MD_BIT_HELF;
            else if(nBit & MD_BIT_HORC) //and half orcs nice to the humans,else if here so humans won't be nice to orogs
                nBit |= MD_BIT_HUMAN | MD_BIT_OROG;
            if(nBit & MD_BIT_OROG)
                nBit |= MD_BIT_HORC;
            if(nBit & MD_BIT_HOBGOBLIN || nBit & MD_BIT_GOBLIN)
                nBit |= MD_BIT_HOBGOBLIN | MD_BIT_GOBLIN;
        }
      }
      int bRacesMatch = md_IsSubRace(nBit, oCustomer);

      // Special - Duergar are always a racial match.
      if (GetSubRace(oCustomer) == GS_T_16777264)
          bRacesMatch = TRUE;

      // Adjust variance according to matching race
      nAppraiseVariance += (bRacesMatch) ? 50 : -50;
      //SendMessageToPC(oCustomer, "DEBUG: Race Match: " + IntToString(bRacesMatch));

      // Check Nations
      string sNation = GetLocalString(oCustomer, "MI_NATION");
      string sThisAreaNation = GetLocalString(GetArea(oCustomer), "MI_NATION");
      int bNationMatch = (sNation == sThisAreaNation);
      nAppraiseVariance += (bNationMatch) ? 50 : -50;
      //SendMessageToPC(oCustomer, "DEBUG: Nation Match: " + IntToString(bNationMatch));
      //SendMessageToPC(oCustomer, "DEBUG: New Variance: " + IntToString(nAppraiseVariance));

      if (nAppraiseVariance > 0) {
        int nRound = nAppraiseVariance / 10;
        nRound *= 10;
        nRound = nAppraiseVariance - nRound;
        nAppraiseVariance = (nAppraiseVariance / 10);
        nRound = (nRound >= 5) ? 1 : 0;
        nAppraiseVariance += nRound;
        //SendMessageToPC(oCustomer, "DEBUG: Smooth Variance: " + IntToString(nAppraiseVariance));
      }
      else {
        // Negative variance, just set it to 0 to avoid being overly punishing.
        nAppraiseVariance = 0;
      }
      // Distinguish between 0 and no value. -99 is an arbitrary token value for this state.
      switch(nAppraiseVariance) {
        case 0: {
          SetLocalInt(oCustomer, "GS_STORE_VALUE_" + sThisStore, -99);
          break;
        }
        default: {
          SetLocalInt(oCustomer, "GS_STORE_VALUE_" + sThisStore, nAppraiseVariance);
          break;
        }
      }
      // Modify Maximum Buy price based on Appraise
      int die100 = d100();
      nMaxBuyPrice  = 250 + nCustomerAppraise * 5 + die100;
      if (nMaxBuyPrice <= (250 + die100))  nMaxBuyPrice = 250 + die100;

      //SendMessageToPC(oCustomer, "DEBUG: Max Buy Price: " + IntToString(nMaxBuyPrice));
      SetLocalInt(oCustomer, "GS_STORE_MAXBUY_" + sThisStore, nMaxBuyPrice);
    }
    else {
      // Convert -99 state token back to 0.
      nAppraiseVariance = GetLocalInt(oCustomer, "GS_STORE_VALUE_" + sThisStore);
      nMaxBuyPrice = GetLocalInt(oCustomer, "GS_STORE_MAXBUY_" + sThisStore);
      if (nAppraiseVariance == -99) nAppraiseVariance = 0;
    }

    if(nWinningAppraise < nAppraiseVariance)
    {
        oWinner = oCustomer;
        nWinningAppraise = nAppraiseVariance;
        nWinningMaxBuy = nMaxBuyPrice;
    }

    oCustomer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCustomer, ++x, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
  }
  string sWinner;
  if(nWinningAppraise > 0)
  {
    nAppraiseVariance = nWinningAppraise;
    nMaxBuyPrice = nWinningMaxBuy;
    oCustomer = oSpeaker;
    if(oCustomer != oWinner)
        sWinner = " " + fbNAGetGlobalDynamicName(oWinner) + " has achieved better prices.";
  }
  //SetStoreMaxBuyPrice(oStore, nMaxBuyPrice);
  string sMerchantUnfavorable = StringToRGBString(GetStringByStrRef(8963), STRING_COLOR_ROSE);
  string sMerchantFavorable = StringToRGBString(GetStringByStrRef(8965) + sWinner, STRING_COLOR_GREEN);
  string sMerchantNeutral = StringToRGBString(GetStringByStrRef(8964), STRING_COLOR_WHITE);

  if (nAppraiseVariance > 0)
  {
    SendMessageToPC(oCustomer, sMerchantFavorable);
    if(GetIsObjectValid(oWinner) && oCustomer != oWinner)
        SendMessageToPC(oWinner, sMerchantFavorable);
  }
  else if (nAppraiseVariance <= 0)  SendMessageToPC(oCustomer, sMerchantUnfavorable);
  // else                             SendMessageToPC(oCustomer, sMerchantNeutral);

  // Buy/Sell bonus values. Stack with the 100/100 buy and sell on all shops in the module
  // (Shop buys at 100% item's value, sells at 100% item's value)
  int nModifierBonusSell = -30;
  int nModifierBonusBuy = -60;

  // Adjust the Buy Mark Down by the Appraise Variance.
  nModifierBonusBuy += nAppraiseVariance;
  //SendMessageToPC(oCustomer, "DEBUG: BonusBuy With Variance: " + IntToString(nModifierBonusBuy));

  // The upper limit of the BonusBuy is the BonusSell. Buy should never equal or exceed Sell, otherwise you can turn a profit.
  // nModifierBonusSell should be about 5% higher than nModifierBonusBuy, just as a rule of thumb.
  if (nModifierBonusBuy >= nModifierBonusSell - 5) nModifierBonusBuy = nModifierBonusSell - 5;

  struct openStore store;

  store.nMaxBuyPrice = nMaxBuyPrice;
  store.nModifierBonusBuy = nModifierBonusBuy;
  store.nModifierBonusSell = nModifierBonusSell;
  return store;
}
void gsCMOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF)
{

  struct openStore Appraise = md_DoAppraise(oStore, oMerchant, oCustomer);
  SetStoreMaxBuyPrice(oStore, Appraise.nMaxBuyPrice);
  // IDing an item is 50 gold no matter what. It's nice for lowbies, mid levels could easily afford IDing anyways.
  if (GetStoreIdentifyCost(oStore) != -1) {
    SetStoreIdentifyCost(oStore, 50);
  }

  OpenStore(oStore, oCustomer, Appraise.nModifierBonusSell, Appraise.nModifierBonusBuy);
}
//----------------------------------------------------------------
void _DestroyObject(object oItem)
{
  // Checks that we're not destroying a subrace hide or property, or an MoD.
  string srr = GetResRef(oItem);

  if (srr == "gs_item317" || srr == "gs_item318" ||
      srr == "mi_mark_destiny" || srr == "mi_mark_despair")
    return;

  DestroyObject(oItem);

}
void gsCMDestroyInventory(object oObject = OBJECT_SELF)
{
    object oItem = OBJECT_INVALID;

    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        //gold
        AssignCommand(oObject, TakeGoldFromCreature(GetGold(oObject), oObject, TRUE));

        //creature slots
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,      oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS,    oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BELT,      oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS,     oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS,   oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,     oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD,      oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_NECK,      oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oObject);
        if (GetIsObjectValid(oItem)) _DestroyObject(oItem);
    }

    //inventory
    oItem        = GetFirstItemInInventory(oObject);

    while (GetIsObjectValid(oItem))
    {
        _DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
}
//----------------------------------------------------------------
void gsCMTransferInventory(object oSource, object oTarget, int nDroppable = TRUE)
{
    object oItem = OBJECT_INVALID;

    if (GetObjectType(oSource) == OBJECT_TYPE_CREATURE)
    {
        //gold
        AssignCommand(oTarget, TakeGoldFromCreature(GetGold(oSource), oSource));

        //creature slots
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS,    oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BELT,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS,   oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_NECK,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
    }

    //inventory
    oItem        = GetFirstItemInInventory(oSource);

    while (GetIsObjectValid(oItem))
    {
        if ((nDroppable || GetDroppableFlag(oItem)) &&
             ConvertedStackTag(oItem) != "FB_TREASURE")
        {
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        }

        oItem = GetNextItemInInventory(oSource);
    }
}
//----------------------------------------------------------------
void gsCMDestroyObject(object oObject = OBJECT_SELF)
{
    switch (GetObjectType(oObject))
    {
    case OBJECT_TYPE_AREA_OF_EFFECT:
        break;

    case OBJECT_TYPE_CREATURE:
        gsCMDestroyInventory(oObject);
        SetIsDestroyable(TRUE, FALSE);  // Mith - looks bugged, should assign to oObject
        break;

    case OBJECT_TYPE_DOOR:
        break;

    case OBJECT_TYPE_ENCOUNTER:
        break;

    case OBJECT_TYPE_ITEM:
        break;

    case OBJECT_TYPE_PLACEABLE:
        gsCMDestroyInventory(oObject);
        break;

    case OBJECT_TYPE_STORE:
        break;

    case OBJECT_TYPE_TRIGGER:
        break;

    case OBJECT_TYPE_WAYPOINT:
        break;
    }

    DestroyObject(oObject);
}
//----------------------------------------------------------------
void gsCMResurrect(object oCreature = OBJECT_SELF)
{
    if (! GetIsDead(oCreature)) return;

    ApplyResurrection(oCreature);
    gsCMSetHitPoints(GetMaxHitPoints(oCreature) + 10, oCreature);

    if (GetIsPC(oCreature))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oCreature);
    }
    else
    {
        AssignCommand(oCreature, JumpToLocation(GetLocalLocation(oCreature, "GS_LOCATION")));
    }
}
//----------------------------------------------------------------
void gsCMTeleportToObject(object oCreature, object oTarget, int nVisualEffect = VFX_IMP_AC_BONUS, int bAllowOverride = FALSE)
{
    if (nVisualEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature));

    if (bAllowOverride && gsFLGetAreaFlag("OVERRIDE_TELEPORT", oTarget))
    {
      FloatingTextStringOnCreature("A mysterious force pushes you back.", oCreature);
      return;
    }

    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, ActionJumpToObject(oTarget));
    AssignCommand(oCreature, ActionDoCommand(SetFacing(GetFacing(oTarget))));
    if (nVisualEffect) AssignCommand(oCreature, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature))));
    AssignCommand(oCreature, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oCreature, SetCommandable(FALSE));
}
//----------------------------------------------------------------
void gsCMTeleportToLocation(object oCreature, location lTarget, int nVisualEffect = VFX_IMP_AC_BONUS, int bAllowOverride = FALSE)
{
    if (nVisualEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature));

    if (bAllowOverride && gsFLGetAreaFlag("OVERRIDE_TELEPORT", GetNearestObjectToLocation(OBJECT_TYPE_ALL, lTarget)))
    {
      FloatingTextStringOnCreature("A mysterious force pushes you back.", oCreature);
      return;
    }

    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, ActionJumpToLocation(lTarget));
    if (nVisualEffect) AssignCommand(oCreature, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature))));
    AssignCommand(oCreature, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oCreature, SetCommandable(FALSE));
}
//----------------------------------------------------------------
void gsCMCreateRecreatorAsOreVein(int nTimeout, string sOreTemplate, int nOreTimeout, int nDbId, object oObject = OBJECT_SELF)
{
    if (GetLocalInt(oObject, "GS_DISABLED"))    return;

    object oRecreator = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     GS_CM_TEMPLATE_RECREATOR,
                                     GetLocation(oObject));

    if (GetIsObjectValid(oRecreator))
    {
        SetLocalString(oRecreator, "GS_TEMPLATE", GetResRef(oObject));
        SetLocalInt(oRecreator, "GS_TYPE", GetObjectType(oObject));
        SetLocalInt(oRecreator, "GS_TIMEOUT", nTimeout);

        SetLocalString(oRecreator, "ORE_TEMPLATE", sOreTemplate);
        SetLocalInt(oRecreator, "ORE_EXPIRE", nOreTimeout);
        SetLocalInt(oRecreator, "GVD_PLACEABLE_ID", nDbId);
    }
}
//----------------------------------------------------------------
void gsCMCreateRecreator(int nTimeout, object oObject = OBJECT_SELF)
{
    gsCMCreateRecreatorAtLocation(GetLocation(oObject), nTimeout, oObject);
}
//----------------------------------------------------------------
void gsCMCreateRecreatorAtLocation(location lLocation, int nTimeout, object oObject = OBJECT_SELF)
{
    if (GetLocalInt(oObject, "GS_DISABLED"))    return;

    object oRecreator = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     GS_CM_TEMPLATE_RECREATOR,
                                     lLocation);

    if (GetIsObjectValid(oRecreator))
    {
        // copy over any variables from the original
        CopyVariables(OBJECT_SELF, oRecreator);
        DeleteLocalInt(oRecreator, "GS_ENABLED");

        SetLocalString(oRecreator, "GS_TEMPLATE", GetResRef(oObject));
        SetLocalInt(oRecreator, "GS_TYPE", GetObjectType(oObject));
        SetLocalInt(oRecreator, "GS_TIMEOUT", nTimeout);
    }
}
//----------------------------------------------------------------
void gsCMCreateRecreatorByType(int nType, int nTimeout, object oObject = OBJECT_SELF)
{
    if (GetLocalInt(oObject, "GS_DISABLED"))    return;

    object oRecreator = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     GS_CM_TEMPLATE_RECREATOR,
                                     GetLocation(oObject));

    if (GetIsObjectValid(oRecreator))
    {
        // copy over any variables from the original
        CopyVariables(OBJECT_SELF, oRecreator);
        DeleteLocalInt(oRecreator, "GS_ENABLED");

        SetLocalString(oRecreator, "GS_TEMPLATE", gsCMGetTemplateByType(nType));
        SetLocalInt(oRecreator, "GS_TYPE", GetObjectType(oObject));
        SetLocalInt(oRecreator, "GS_TIMEOUT", nTimeout);
    }
}
//----------------------------------------------------------------
string gsCMGetTemplateByType(int nType)
{
    switch (nType)
    {
    case GS_CM_TEMPLATE_TYPE_TREASURE_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable033";
        case 1: return "gs_placeable048";
        case 2: return "gs_placeable049";
        case 3: return "gs_placeable050";
        case 4: return "gs_placeable065";
        case 5: return "gs_placeable066";
        case 6: return "gs_placeable067";
        case 7: return "gs_placeable068";
        case 8: return "gs_placeable069";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable035";
        case 1: return "gs_placeable070";
        case 2: return "gs_placeable071";
        case 3: return "gs_placeable072";
        case 4: return "gs_placeable073";
        case 5: return "gs_placeable074";
        case 6: return "gs_placeable075";
        case 7: return "gs_placeable076";
        case 8: return "gs_placeable077";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable036";
        case 1: return "gs_placeable078";
        case 2: return "gs_placeable079";
        case 3: return "gs_placeable080";
        case 4: return "gs_placeable081";
        case 5: return "gs_placeable082";
        case 6: return "gs_placeable083";
        case 7: return "gs_placeable084";
        case 8: return "gs_placeable085";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable093";
        case 1: return "gs_placeable094";
        case 2: return "gs_placeable095";
        case 3: return "gs_placeable096";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable116";
        case 1: return "gs_placeable117";
        case 2: return "gs_placeable118";
        case 3: return "gs_placeable119";
        case 4: return "gs_placeable120";
        case 5: return "gs_placeable121";
        case 6: return "gs_placeable122";
        case 7: return "gs_placeable123";
        case 8: return "gs_placeable124";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable107";
        case 1: return "gs_placeable108";
        case 2: return "gs_placeable109";
        case 3: return "gs_placeable110";
        case 4: return "gs_placeable111";
        case 5: return "gs_placeable112";
        case 6: return "gs_placeable113";
        case 7: return "gs_placeable114";
        case 8: return "gs_placeable115";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable098";
        case 1: return "gs_placeable099";
        case 2: return "gs_placeable100";
        case 3: return "gs_placeable101";
        case 4: return "gs_placeable102";
        case 5: return "gs_placeable103";
        case 6: return "gs_placeable104";
        case 7: return "gs_placeable105";
        case 8: return "gs_placeable106";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable125";
        case 1: return "gs_placeable126";
        case 2: return "gs_placeable127";
        case 3: return "gs_placeable128";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable151";
        case 1: return "gs_placeable152";
        case 2: return "gs_placeable153";
        case 3: return "gs_placeable154";
        case 4: return "gs_placeable155";
        case 5: return "gs_placeable156";
        case 6: return "gs_placeable157";
        case 7: return "gs_placeable158";
        case 8: return "gs_placeable159";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable142";
        case 1: return "gs_placeable143";
        case 2: return "gs_placeable144";
        case 3: return "gs_placeable145";
        case 4: return "gs_placeable146";
        case 5: return "gs_placeable147";
        case 6: return "gs_placeable148";
        case 7: return "gs_placeable149";
        case 8: return "gs_placeable150";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable133";
        case 1: return "gs_placeable134";
        case 2: return "gs_placeable135";
        case 3: return "gs_placeable136";
        case 4: return "gs_placeable137";
        case 5: return "gs_placeable138";
        case 6: return "gs_placeable139";
        case 7: return "gs_placeable140";
        case 8: return "gs_placeable141";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable160";
        case 1: return "gs_placeable161";
        case 2: return "gs_placeable162";
        case 3: return "gs_placeable163";
        }
    }

    return "";
}
//----------------------------------------------------------------
void gsCMCreateGold(int nAmount, object oTarget = OBJECT_SELF)
{
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        GiveGoldToCreature(oTarget, nAmount);
    }
    else
    {
        while (nAmount > 50000)
        {
            CreateItemOnObject(GS_CM_TEMPLATE_GOLD, oTarget, 50000);
            nAmount -= 50000;
        }

        if (nAmount > 0) CreateItemOnObject(GS_CM_TEMPLATE_GOLD, oTarget, nAmount);
    }
}
//----------------------------------------------------------------
object gsCMGetNearestObject(string sTag, int nType = OBJECT_TYPE_PLACEABLE, object oTarget = OBJECT_SELF)
{
    object oObject = GetNearestObjectByTag(sTag, oTarget);
    int nNth       = 1;

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == nType) return oObject;
        oObject = GetNearestObjectByTag(sTag, oTarget, ++nNth);
    }

    return gsCMGetObject(sTag, nType);
}
//----------------------------------------------------------------
object gsCMGetObject(string sTag, int nType = OBJECT_TYPE_WAYPOINT)
{
    object oObject = GetObjectByTag(sTag);
    int nNth       = 0;

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == nType) return oObject;
        oObject = GetObjectByTag(sTag, ++nNth);
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
void gsCMSetHitPoints(int nValue, object oCreature)
{
    int nHitPoints = GetCurrentHitPoints(oCreature);
    effect eEffect;

    if (nValue < nHitPoints)      eEffect = EffectDamage(nHitPoints - nValue);
    else if (nValue > nHitPoints) eEffect = EffectHeal(nValue - nHitPoints);
    else                          return;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oCreature);
}
//----------------------------------------------------------------
int gsCMGetItemLevelByValue(int nValue)
{
    //------------------------------------------------------------
    // NOTE - this method is no longer used for ILRs.  It still
    // determines durability for wear and tear.
    //
    // See SetItemILR in inc_item for new ILR code.
    //------------------------------------------------------------
    object oModule  = GetModule();
    string sString  = "";
    int nValueLevel = 0;
    int nNth        = 0;

    while (nNth < 60)
    {
        sString     = IntToString(nNth);
        nValueLevel = GetLocalInt(oModule, "GS_CM_ITEMVALUE_" + sString);

        if (! nValueLevel)
        {
            nValueLevel = StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", nNth));
            SetLocalInt(oModule, "GS_CM_ITEMVALUE_" + sString, nValueLevel);
        }

        nNth++;

        if (nValue <= nValueLevel) break;
    }

    return nNth;
}
//----------------------------------------------------------------
string gsCMCreateRandomID(int nLength = 16)
{
    string sString = "";
    int nNth       = 0;

    for (; nNth < nLength; nNth++)
    {
        switch (Random(36))
        {
        case  0: sString += "A"; break;
        case  1: sString += "B"; break;
        case  2: sString += "C"; break;
        case  3: sString += "D"; break;
        case  4: sString += "E"; break;
        case  5: sString += "F"; break;
        case  6: sString += "G"; break;
        case  7: sString += "H"; break;
        case  8: sString += "I"; break;
        case  9: sString += "J"; break;
        case 10: sString += "K"; break;
        case 11: sString += "L"; break;
        case 12: sString += "M"; break;
        case 13: sString += "N"; break;
        case 14: sString += "O"; break;
        case 15: sString += "P"; break;
        case 16: sString += "Q"; break;
        case 17: sString += "R"; break;
        case 18: sString += "S"; break;
        case 19: sString += "T"; break;
        case 20: sString += "U"; break;
        case 21: sString += "V"; break;
        case 22: sString += "W"; break;
        case 23: sString += "X"; break;
        case 24: sString += "Y"; break;
        case 25: sString += "Z"; break;
        case 26: sString += "0"; break;
        case 27: sString += "1"; break;
        case 28: sString += "2"; break;
        case 29: sString += "3"; break;
        case 30: sString += "4"; break;
        case 31: sString += "5"; break;
        case 32: sString += "6"; break;
        case 33: sString += "7"; break;
        case 34: sString += "8"; break;
        case 35: sString += "9"; break;
        }
    }

    return sString;
}
//----------------------------------------------------------------
int gsCMGetHasClass(int nClass, object oCreature = OBJECT_SELF)
{
    return GetClassByPosition(1, oCreature) == nClass ||
           GetClassByPosition(2, oCreature) == nClass ||
           GetClassByPosition(3, oCreature) == nClass;
}
//----------------------------------------------------------------
int gsCMGetItemBaseAC(object oItem)
{
    int nAC                 = GetItemACValue(oItem);
    itemproperty ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_AC_BONUS)
            nAC -= GetItemPropertyCostTableValue(ipProperty);

        ipProperty = GetNextItemProperty(oItem);
    }

    return nAC < 0 ? 0 : nAC;
}
//----------------------------------------------------------------
int gsCMGetBaseAbilityModifier(object oCreature, int nAbility)
{
  return (GetAbilityScore(oCreature, nAbility, TRUE) - 10) / 2;
}
//----------------------------------------------------------------
int gsCMGetBaseSkillRank(int nSkill, int nAbility, object oCreature = OBJECT_SELF)
{
    object oItem   = OBJECT_INVALID;
    int nSkillRank = GetSkillRank(nSkill, oCreature);
    if (nSkillRank < 0) nSkillRank = 0;

    int nSkillAdjust = 0;

    oItem          = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BELT, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_NECK, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCreature);
    if (GetIsObjectValid(oItem)) nSkillAdjust += _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);

    nSkillAdjust /= 2;

    return nSkillRank - nSkillAdjust;
}
//----------------------------------------------------------------
int _gsCMGetBaseSkillRank(int nSkill, int nAbility, object oItem)
{
    itemproperty ipProperty = GetFirstItemProperty(oItem);
    int nValue              = 0;

    while (GetIsItemPropertyValid(ipProperty))
    {
        switch (GetItemPropertyType(ipProperty))
        {
        case ITEM_PROPERTY_SKILL_BONUS:
            if (GetItemPropertySubType(ipProperty) == nSkill)
                nValue += GetItemPropertyCostTableValue(ipProperty) * 2;
            break;

        case ITEM_PROPERTY_ABILITY_BONUS:
            if (GetItemPropertySubType(ipProperty) == nAbility)
                nValue += GetItemPropertyCostTableValue(ipProperty);
            break;

        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            if (GetItemPropertySubType(ipProperty) == nAbility)
                nValue -= GetItemPropertyCostTableValue(ipProperty);
            break;
        }

        ipProperty = GetNextItemProperty(oItem);
    }

    return nValue;
}
//----------------------------------------------------------------
void gsCMSendMessageToAllPCs(string sText)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        FloatingTextStringOnCreature(sText, oPC, FALSE);
        oPC = GetNextPC();
    }
}
//----------------------------------------------------------------
string gsCMReplaceString(string sString, string sReplacement1 = "", string sReplacement2 = "", string sReplacement3 = "", string sReplacement4 = "")
{
    string sReplacement = "";
    int nPosition       = 0;
    int nNth            = 1;

    for (; nNth <= 4; nNth++)
    {
        nPosition = FindSubString(sString, "%" + IntToString(nNth));

        if (nPosition != -1)
        {
            switch (nNth)
            {
            case 1: sReplacement = sReplacement1; break;
            case 2: sReplacement = sReplacement2; break;
            case 3: sReplacement = sReplacement3; break;
            case 4: sReplacement = sReplacement4; break;
            }

            sString = GetStringLeft(sString, nPosition) +
                      sReplacement +
                      GetStringRight(sString, GetStringLength(sString) - nPosition - 2);
        }
    }

    return sString;
}
//----------------------------------------------------------------
string gsCMRepeatString(string sRepeat, int nCount)
{
    string sString = "";
    int nNth       = 0;

    for (; nNth < nCount; nNth++) sString += sRepeat;

    return sString;
}
//----------------------------------------------------------------
string gsCMCleanWhitespace(string sString)
{
    string sClean = "";
    string sChar  = "";
    int nCount    = GetStringLength(sString);
    int nNth      = 0;
    int nFlag     = FALSE;

    for (; nNth < nCount; nNth++)
    {
        sChar  = GetSubString(sString, nNth, 1);

        if (sChar == " ")
        {
            nFlag   = TRUE;
        }
        else if (nFlag)
        {
            sClean += " " + sChar;
            nFlag   = FALSE;
        }
        else
        {
            sClean += sChar;
        }
    }

    if (GetSubString(sClean, 0, 1) == " ")
    {
        nCount = GetStringLength(sClean);
        sClean = GetStringRight(sClean, nCount - 1);
    }

    return sClean;
}
//----------------------------------------------------------------
object gsCMCopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE, int bCopyOne=FALSE)
{
  string sDescription = GetDescription(oItem);
  if (!bCopyOne)
  {
    object oReturn = CopyItem(oItem, oTargetInventory, bCopyVars);
    // If an item has a strref as a description, GetDescription returns their default item type desc.
    // This is annoying for books so stop it happening.
    if (GetStringLeft(sDescription, 10) != "Books are ") SetDescription(oReturn, sDescription);
    return oReturn;
  }
  else
  {
    int nCount =  GetItemStackSize(oItem);
    SetItemStackSize(oItem, GetNumStackedItems(oItem) + 1);

    if (GetItemStackSize(oItem) == nCount)
    {
      // Already at max - create a new item.
      object oReturn = CopyItem(oItem, oTargetInventory, bCopyVars);
      SetItemStackSize(oReturn, 1);
      // If an item has a strref as a description, GetDescription returns their default item type desc.
      // This is annoying for books so stop it happening.
      if (GetStringLeft(sDescription, 10) != "Books are ") SetDescription(oReturn, sDescription);
      return oReturn;
    }
    else
    {
      // All done.
      return oItem;
    }
  }
}

//----------------------------------------------------------------
string gsCMPadString(string sString, int nLength, string sCharacter = "0", int bPadRight = FALSE)
{
  if (GetStringLength(sCharacter) != 1) return sString;
  int nStrLen = GetStringLength(sString);
  while (++nStrLen <= nLength)
  {
    sString = (bPadRight) ? sString + sCharacter : sCharacter + sString;
  }
  return sString;
}
//----------------------------------------------------------------
string gsCMTrimString(string sString, string sCharacter = "0", int bPadRight = FALSE)
{
  if (GetStringLength(sCharacter) != 1) return sString;
  int nStrLen = GetStringLength(sString);
  string sChar = (bPadRight) ? GetStringRight(sString, 1) : GetStringLeft(sString, 1);
  while (--nStrLen >= 0 && sChar == sCharacter)
  {
    sString = (bPadRight) ? GetStringLeft(sString, nStrLen) : GetStringRight(sString, nStrLen);
    sChar = (bPadRight) ? GetStringRight(sString, 1) : GetStringLeft(sString, 1);
  }
  return sString;
}
//----------------------------------------------------------------
int gsCMReduceItem(object oItem, int nCount = 1)
{
  int nStack = GetItemStackSize(oItem);
  if (nCount >= nStack)
  {
    AssignCommand(oItem, SetIsDestroyable(TRUE));
    DestroyObject(oItem);
    return nCount - nStack;
  }

  SetItemStackSize(oItem, nStack - nCount);
  return 0;
}
//----------------------------------------------------------------
void gsCMStopFollowers(object oPC)
{
  int nCount = 1;
  object oPC2 = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                   PLAYER_CHAR_IS_PC,
                                   oPC,
                                   nCount);

  float fDistance = GetDistanceBetween(oPC,oPC2);

  while ((fDistance > 0.0) && (fDistance < 5.0))
  {
    if (GetCurrentAction(oPC2) == ACTION_FOLLOW)
    {
      AssignCommand(oPC2, ClearAllActions());
    }

    nCount++;
    oPC2 = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                              PLAYER_CHAR_IS_PC,
                              oPC,
                              nCount);
    fDistance = GetDistanceBetween(oPC,oPC2);
  }
}
//----------------------------------------------------------------
string gsCMGetAsString(float fNumber, int nNumDigits = 4)
{
  string sReturn = gsCMTrimString(FloatToString(fNumber), " ");

  return GetStringLeft(sReturn, nNumDigits);
}
//----------------------------------------------------------------
object gsCMGetCacheItem(string sKey)
{
    // Make this fast-path as short as possible...
    object oItem = GetLocalObject(GetModule(), "GU_CA_" + sKey);
    if (GetIsObjectValid(oItem))
        return oItem;

    return gsCMGetCacheItemOnObject(sKey, GetModule());
}
//----------------------------------------------------------------
object gsCMGetCacheItemOnObject(string sKey, object oTarget)
{
    string sName = "GU_CA_" + sKey;

    object oItem = GetLocalObject(oTarget, sName);
    if (GetIsObjectValid(oItem))
        return oItem;

    object oContainer = GetLocalObject(GetModule(), "GS_SEQUENCER");
    // Use ObjectToString(oTarget) as part of the cache item's tag, so that
    // items with the same key but for different target objects don't end
    // up stacking inside the cache container.
    oItem = CreateItemOnObject(GS_CM_TEMPLATE_CACHE,
                               oContainer, 1,
                               sName + ObjectToString(oTarget));

    SetLocalObject(oTarget, sName, oItem);
    return oItem;
}
//----------------------------------------------------------------
void gsCMCopyPropertiesAndVariables(object oOldSkin, object oNewSkin)
{
    // Properties.
    IPWildShapeCopyItemProperties(oOldSkin, oNewSkin, FALSE, TRUE);

    // Copying variables is unnecessary - gsPCGetCreatureHide should be used
    // where variables are needed.
}




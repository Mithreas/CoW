/* SHOP library by Gigaschatten */

#include "inc_quarter"
#include "inc_common"
#include "inc_container"
#include "inc_listener"
#include "inc_factions"
#include "inc_rename"
#include "inc_subrace"

//void main() {}
const int SHOP_LIMIT = 20; // If you reduce this, some items will be lost!
const string SHOP = "SHOP"; // for tracing

//Local var to save the items custom price
const string CUSTOM_PRICE = "MD_CUSTOM_PRICE";

//struct to hold open store variables
struct openStore {
    int nMaxBuyPrice;
    int nModifierBonusBuy;
    int nModifierBonusSell;
};

//return TRUE if oPC is owner of oShop
int gsSHGetIsOwner(object oShop, object oPC);
//return owner id of oShop
string gsSHGetOwnerID(object oShop);
//make oPC own oShop
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0);
//return owner name of oShop
string gsSHGetOwnerName(object oShop);
//update timestamp of oShop
void gsSHTouch(object oShop);
//update timestamp of oShop and informs oPC
void gsSHTouchWithNotification(object oShop, object oPC);
//return TRUE if oShop is vacant
int gsSHGetIsVacant(object oShop);
//return TRUE if oShop is available
int gsSHGetIsAvailable(object oShop);
//load inventory of oShop
void gsSHLoad(object oShop);
//save inventory of oShop
struct gsCOResults gsSHSave(object oShop);
//abandon oShop
void gsSHAbandon(object oShop);
//import oItem to oShop. Returns the sale value of oItem.
int gsSHImportItem(object oItem, object oShop, object oPC = OBJECT_INVALID);
//export oItem to oTarget
void gsSHExportItem(object oItem, object oTarget);
//set sale price of oShop to nValue
void gsSHSetSalePrice(object oShop, int nValue);
//return sale price of oShop
int gsSHGetSalePrice(object oShop);
//open oStore to oCustomer trading with oMerchant
void gsSHOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF);
//Open a store, applying all modifiers.
struct openStore md_DoAppraise(object oStore, object oMerchant, object oCustomer);
// checks if an item is allowed in stores / merchants, returns 1 is allowed, 0 if not (this is resref based)
int gvd_ItemAllowedInStores(object oCheck);


int gsSHGetIsOwner(object oShop, object oPC)
{
  return gsQUGetIsOwner(oShop, oPC);
}
//----------------------------------------------------------------
string gsSHGetOwnerID(object oShop)
{
  return gsQUGetOwnerID(oShop);
}
//----------------------------------------------------------------
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0)
{
  gsQUSetOwner(oShop, oPC, nTimeout);
  gsQUReset(oShop);
}
//----------------------------------------------------------------
string gsSHGetOwnerName(object oShop)
{
  return gsQUGetOwnerName(oShop);
}
//----------------------------------------------------------------
void gsSHTouch(object oShop)
{
  gsQUTouch(oShop);
}
//----------------------------------------------------------------
void gsSHTouchWithNotification(object oShop, object oPC)
{
  gsSHTouch(oShop);
  FloatingTextStringOnCreature("You have refreshed your shop.", oPC, FALSE);
}
//----------------------------------------------------------------
int gsSHGetIsVacant(object oShop)
{
  return gsQUGetIsVacant(oShop);
}
//----------------------------------------------------------------
int gsSHGetIsAvailable(object oShop)
{
  return gsQUGetIsAvailable(oShop);
}
//----------------------------------------------------------------
void gsSHLoad(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCOLoad(sID + "_" + IntToString(nInstance), oShop, SHOP_LIMIT, TRUE);

    object oItem  = GetFirstItemInInventory(oShop);

    while (GetIsObjectValid(oItem))
    {
        SetLocalObject(oItem, "GS_SH_CONTAINER", oShop);
        oItem = GetNextItemInInventory(oShop);
    }
}
//----------------------------------------------------------------
struct gsCOResults gsSHSave(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCOSave(sID + "_" + IntToString(nInstance), oShop, SHOP_LIMIT, TRUE);
}
//----------------------------------------------------------------
void gsSHAbandon(object oShop)
{
  gsQUAbandon(oShop);
}
//----------------------------------------------------------------
int gsSHImportItem(object oItem, object oShop, object oPC = OBJECT_INVALID)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) != "GS_SH_")
    {
        object oCopy = CopyObject(oItem,
                                  GetLocation(oShop),
                                  oShop,
                                  "GS_SH_" + sTag);

        if (GetIsObjectValid(oCopy))
        {
            SetLocalInt(oCopy, SLOT_VAR, GetLocalInt(oItem, SLOT_VAR));
            int nValue;
            string sFaction =  md_SHLoadFacID(oShop);
            int nOwner = gsSHGetIsOwner(oShop, oPC);
            int nPowCheck = GetIsObjectValid(oPC) && (nOwner || (md_SHLoadFacABL(ABL_B_SCP | ABL_B_SCI, oShop) &&
                            fbFAGetFactionNameDatabaseID(sFaction) != "" && md_GetHasPowerShop(MD_PR2_SCP | MD_PR2_SCI, oPC, sFaction, "2")));
            if(nPowCheck)
               nValue = StringToInt(chatGetLastMessage(oPC));

            if(nValue < 1)
            {
              //If they have the power to set custom prices, but not the power to take items
              //give them a second chance to set the items price.
              if(nPowCheck && !nOwner && (!md_SHLoadFacABL(ABL_B_TKI, oShop) || !md_GetHasPowerShop(MD_PR_RIS, oPC, sFaction)))
              {
                SetLocalObject(oPC, "MD_SAVED_ITEMP", oCopy);
                SetLocalString(oPC, "zzdlgCurrentDialog", "zz_co_shsetprice");
                AssignCommand(oShop, ActionStartConversation(oPC, "zzdlg_conv", TRUE, FALSE));
              }
              int nSalePrice  = gsSHGetSalePrice(oShop);
              nValue          = gsCMGetItemValue(oItem) * nSalePrice / 100;
              if (nValue < 1) nValue = 1;
            }
            else
              SetLocalInt(oCopy, CUSTOM_PRICE, nValue);

            SetLocalObject(oCopy, "GS_SH_CONTAINER", oShop);
            // Added by Mith - workaround to stop stacking.
            SetStolenFlag(oCopy, TRUE);
            DestroyObject(oItem);
            return nValue;
        }
    }

    return 0;
}
//----------------------------------------------------------------
void gsSHExportItem(object oItem, object oTarget)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) == "GS_SH_")
    {
        object oShop = GetLocalObject(oItem, "GS_SH_CONTAINER");
        string sID   = GetLocalString(oShop, "GS_CLASS") + "_" +
                       IntToString(GetLocalInt(oShop, "GS_INSTANCE"));
        spCORemove(sID, oShop, oItem);

        object oCopy = CopyObject(oItem,
                                  GetLocation(oTarget),
                                  oTarget,
                                  GetStringRight(sTag, GetStringLength(sTag) - 6));

        if (GetIsObjectValid(oCopy))
        {
            // Don't give the copy any vars. We want it to stack normally.
            // SetLocalInt(oCopy, SLOT_VAR, GetLocalInt(oItem, SLOT_VAR));
            // Added by Mith - workaround to stop stacking.
            DeleteLocalInt(oCopy, CUSTOM_PRICE);
            SetStolenFlag(oCopy, FALSE);
            DestroyObject(oItem);
        }
    }
}
//----------------------------------------------------------------
void gsSHSetSalePrice(object oShop, int nValue)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    if (nValue < 1)         nValue =  100;
    else if (nValue > 1000) nValue = 1000;

    SetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance), nValue);
}
//----------------------------------------------------------------
int gsSHGetSalePrice(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");
    int nValue    = GetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance));

    return nValue <= 0 ? 100 : nValue;
}
//----------------------------------------------------------------
struct openStore md_DoAppraise(object oStore, object oMerchant, object oCustomer)
{
  // Septire - new logic here, the old logic has been removed.
  // The intent of this change is to prevent appraise runs while still making appraise worthwhile.

  int nAppraiseVariance = 0;
  int nMaxBuyPrice = 0;
  string sThisStore = ObjectToString(oStore);
  int nCustomerAppraise;
  int nMerchantAppraise = GetSkillRank(SKILL_APPRAISE, oMerchant, TRUE);
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
  object oSpeaker = oCustomer;               //ensure first run always gets an appraise check no matter distance
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
      // Modify Maximum Buy price based on Appraise scores and reaction.      
	  // Note that the PC's Appraise here is limited by the NPC's Appraise - low level
	  // merchants won't dare to buy more expensive things. 
      nMaxBuyPrice  = 175;
	  int nReaction = GetSkillRank(SKILL_PERSUADE, oCustomer, FALSE);
	  if (bRacesMatch) nReaction += 25;
	  if (bNationMatch) nReaction += 25;
	  if (nReaction > 50) nReaction = 50;
	  
	  nMaxBuyPrice += nReaction;
	  if (nCustomerAppraise > nMerchantAppraise) nMaxBuyPrice += 5*nMerchantAppraise;
	  else nMaxBuyPrice += 5*nCustomerAppraise;	   

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

    oCustomer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCustomer, ++x);
  }
  string sWinner;
  if(nWinningAppraise > 0)
  {
    nAppraiseVariance = nWinningAppraise;
    nMaxBuyPrice = nWinningMaxBuy;
    oCustomer = oSpeaker;
    if(oCustomer != oWinner)
        sWinner = " " + svGetPCNameOverride(oWinner) + " has achieved better prices.";
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
//----------------------------------------------------------------
void gsSHOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF)
{

  struct openStore Appraise = md_DoAppraise(oStore, oMerchant, oCustomer);
  SetStoreMaxBuyPrice(oStore, Appraise.nMaxBuyPrice);
  // IDing an item is 50 gold no matter what. It's nice for lowbies, mid levels could easily afford IDing anyways.
  if (GetStoreIdentifyCost(oStore) != -1) {
    SetStoreIdentifyCost(oStore, 50);
  }

  // Add the cleanup script to the store.
  SetEventScript(oStore, EVENT_SCRIPT_STORE_ON_CLOSE, "mi_closestore");
  OpenStore(oStore, oCustomer, Appraise.nModifierBonusSell, Appraise.nModifierBonusBuy);
}
//----------------------------------------------------------------
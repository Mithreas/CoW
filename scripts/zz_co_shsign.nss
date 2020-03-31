//::///////////////////////////////////////////////
//:: Name    zz_co_shsign
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The conversation file for shop signs
*/
//:://////////////////////////////////////////////
//:: Created By: Mordeorn
//:: Created On: 1/22/2012
//:://////////////////////////////////////////////
#include "zzdlg_main_inc"
#include "inc_shop"
#include "inc_factions"
#include "inc_listener"
#include "inc_backgrounds"
//Pages
const string PAGE_OWNER = "PAGE_OWNER";
const string PAGE_AVAILABLE = "PAGE_AVAILABLE";
const string PAGE_OWNED = "PAGE_OWNED";
const string PAGE_ABANDON = "PAGE_ABANDON";
const string PAGE_SSP = "PAGE_SSP";
const string PAGE_TSA = "PAGE_TSA";
const string PAGE_FACTION_OPTIONS = "PAGE_FACTION_OPT";
const string PAGE_FACTION_LIST = "PAGE_FACTION_LIST";
const string PAGE_DB_LIST = "PAGE_DB_LIST";
const string PAGE_F_TAX = "PAGE_F_TAX";
const string PAGE_ABL = "PAGE_ABL";
const string PAGE_DISPLAY_PRICES = "PAGE_DIS_PRI";

//Responses used for page_owned
const string RES_REL = "[Release shop]";
const string RES_SSP = "[Set sale prices]";
const string RES_SCP = "[Display/Change Item Prices]";

void _SaveShop()
{
  DeleteLocalInt(OBJECT_SELF, "MD_SAVE_SHOP");
  gsSHSave(GetLocalObject(OBJECT_SELF, "MD_STORED_SHOP"));
}

void _TakeOverShop()
{
  object oPC = dlgGetSpeakingPC();
  object oSelf = OBJECT_SELF;
  int nCost       = GetLocalInt(oSelf, "GS_COST");
  if(GetGold(oPC) < nCost)
  {
    SendMessageToPC(oPC, "You do not have enough gold.");
    dlgEndDialog();
    return;
  }

  int nTimeout    = GetLocalInt(gsQULoad(oSelf), "GS_TIMEOUT");

  if (nCost > 0)
  {
    string sID  = gsSHGetOwnerID(oSelf);
    if (sID == "")
    {
      sID = miCZGetBestNationMatch(QUGetNationNameMatch(oSelf));
      if(sID == "")
        sID = "DUMMY";
      else
        sID = "N"+sID;
    }
    AssignCommand(oPC, gsFITransfer(sID, nCost));
  }

  gsSHSetOwner(oSelf, oPC, nTimeout);
  gsSHSetSalePrice(oSelf, FALSE);
  DeleteLocalInt(oSelf, "GS_SH_AVAILABLE");


  dlgChangePage(PAGE_OWNER);
}

//Displays response in red or green
void _DisplayRespRedGreen(string sText, int nABL)
{
  string sColor = txtRed;
  if(md_SHLoadFacABL(nABL))
    sColor = txtGreen;

  dlgAddResponseAction(PAGE_ABL, sText, sColor);
}

void _ToggleABL(int nABL)
{
  string sSHID = GetLocalString(OBJECT_SELF, "GS_CLASS")+
                 IntToString(GetLocalInt(OBJECT_SELF, "GS_INSTANCE"));
  int nAABL = GetLocalInt(GetArea(OBJECT_SELF), VAR_FAB+sSHID) - 1;

  if(nAABL & nABL) //on so turn off
    nAABL = nAABL & ~nABL;
  else //off so turn on
    nAABL = nAABL | nABL;

  SetLocalInt(GetArea(OBJECT_SELF), VAR_FAB+sSHID, nAABL + 1);

  miDASetKeyedValue("gs_quarter", sSHID, "faction_ability", IntToString(nAABL), "row_key");
}
void CleanUp()
{
  dlgClearResponseList(PAGE_OWNER);
  dlgClearResponseList(PAGE_AVAILABLE);
  dlgClearResponseList(PAGE_OWNED);
  dlgClearResponseList(PAGE_ABANDON);
  dlgClearResponseList(PAGE_SSP);
  dlgClearResponseList(PAGE_TSA);
  dlgClearResponseList(PAGE_FACTION_OPTIONS);
  dlgClearResponseList(PAGE_FACTION_LIST);
  DeleteList(PAGE_DB_LIST);
  dlgClearResponseList(PAGE_F_TAX);
  dlgClearResponseList(PAGE_ABL);
  dlgClearResponseList(PAGE_DISPLAY_PRICES);
}

void OnInit()
{
  if(gsSHGetIsOwner(OBJECT_SELF, dlgGetSpeakingPC()))
    dlgChangePage(PAGE_OWNER);
  else if(! gsSHGetIsVacant(OBJECT_SELF))
    dlgChangePage(PAGE_OWNED);
  else
    dlgChangePage(PAGE_AVAILABLE);

  dlgActivateEndResponse("[Done]", txtRed);
}
void OnPageInit(string sPage)
{
  string sPrompt;
  object oShop = OBJECT_SELF;

  string sPirate;
  int nRank = GetLocalInt(OBJECT_SELF, "REQUIRED_PRANK");
  if(nRank == 0)
    nRank  = GetLocalInt(GetArea(OBJECT_SELF), "REQUIRED_PRANK");
  if(nRank != 0) // it's set
    sPirate = " Only " + md_GetPirateNameFromRank(nRank) + " and above can own this shop.";
  if(sPage == PAGE_OWNER)
  {
    dlgDeactivateResetResponse();
    int nTimeout = GetLocalInt(gsQULoad(oShop), "GS_TIMEOUT");
    string sNation = miCZGetBestNationMatch(QUGetNationNameMatch());

    sPrompt = "This is your shop.\n\nYou can change your offer by adding " +
              "or removing items to/from the shop inventory. A maximum of 20 " +
              "items can be placed permanently in it. If another player buys " +
              "an item from your shop, the payment is credited to your " +
              "bank account. Items are sold at " +
              IntToString(gsSHGetSalePrice(oShop)) +
              "% of the value. " +
              "Remember to check the inventory at least once every " +
              IntToString(nTimeout / (60 * 60 * 24)) + " days, " +
              IntToString((nTimeout % (60 * 60 * 24)) / (60 * 60)) + " hours and " +
              IntToString((nTimeout % (60 * 60)) / 60) + " minutes " +
              "(realtime) or other players may take over your shop." +
              "\n\nThe current monthly tax cost for the shop is " + IntToString(gsQUGetTaxAmount(oShop)) +
              " gold.\n\nThe current tax rate for your settlement is " +
              FloatToString(miCZGetTaxRate(sNation) * 100, 6, 2) + "%" +
              "\n\nThis shop is associated with faction " + fbFAGetFactionNameDatabaseID(md_SHLoadFacID())+
              " and the factions receives " + md_SHLoadFacTax() + "% of sale revenue.";


     if(!GetElementCount(PAGE_OWNER, dlgGetSpeakingPC()))
     {
       dlgAddResponseAction(PAGE_OWNER, "[Abandon shop]");
       dlgAddResponseAction(PAGE_OWNER, "[Set sale prices]");
       dlgAddResponseAction(PAGE_OWNER, "[Toggle shop availability]");
       dlgAddResponseAction(PAGE_OWNER, "[Rename Shop]");
       dlgAddResponseAction(PAGE_OWNER, "[Display/Change Item Prices]");
       dlgAddResponseAction(PAGE_OWNER, "[Faction & Shop Options]");
     }
   }
   else if(sPage == PAGE_OWNED)
   {
     dlgDeactivateResetResponse();
     sPrompt = "''"+gsSHGetOwnerName(oShop)+"'s shop''\n\n"+
               "Open the shop inventory to browse the wares. Items are sold at " +
               IntToString(gsSHGetSalePrice(oShop)) + "% of the value."+
               "\n\nThe current monthly tax cost for the shop is " + IntToString(gsQUGetTaxAmount(oShop)) +
               " gold.";

     object oPC = dlgGetSpeakingPC();
     string sFID =  md_SHLoadFacID();
     //If faction name cannot be retrieved, the faction has been removed or is invalid
     string sFactionName = fbFAGetFactionNameDatabaseID(sFID);
     if(sFactionName != "" && (md_SHLoadFacABL(ABL_B_TOG) ||  md_GetHasPowerShop(MD_PR_SSF, oPC, sFID)))
       sPrompt += "\n\nThis shop is associated with faction " + sFactionName +
              " and the factions recieves " + md_SHLoadFacTax() + "% of sale revenue.";

     sPrompt += "\n" + sPirate;
     if(!GetElementCount(PAGE_OWNED, oPC))
     {

       object oContract = GetItemPossessedBy(oPC, "piratecontract");
       if(gsSHGetIsAvailable(oShop) && (nRank == 0 || (GetIsObjectValid(oContract) && GetLocalInt(oContract, "PIRATE_RANK") >= nRank)))
         dlgAddResponse(PAGE_OWNED, DLG_DEFAULT_TXT_ACTION_COLOR+"[Take over shop]</c> " +
                     txtBlue+"[Cost " + IntToString(GetLocalInt(OBJECT_SELF, "GS_COST")) +
                     " gold]");


       string sNation = miCZGetBestNationMatch(QUGetNationNameMatch());
       string sNationName = miCZGetName(sNation);
       string sFactionID = md_GetDatabaseID(sNationName);

       int nOverride = md_GetHasPowerSettlement(MD_PR2_RVS, oPC, sFactionID, "2");
       if (GetIsDM(oPC) ||
          (sNation != "" && nOverride &&
           miCZGetHasAuthority(gsPCGetPlayerID(oPC),gsQUGetOwnerID(oShop), sNation, nOverride)))
       {
         LeaderLog(GetPCSpeaker(), "Checked shop owned by " + gsQUGetOwnerID(oShop));
         dlgAddResponseAction(PAGE_OWNED, RES_REL);
       }

       if(sFactionName != "")
       {
         if(md_SHLoadFacABL(ABL_B_SPR) && md_GetHasPowerShop(MD_PR2_SPR, oPC, sFID, "2"))
           dlgAddResponseAction(PAGE_OWNED, RES_SSP);
         if(md_SHLoadFacABL(ABL_B_SCP) && md_GetHasPowerShop(MD_PR2_SCP, oPC, sFID, "2"))
           dlgAddResponseAction(PAGE_OWNED, RES_SCP);
       }
     }
   }
   else if(sPage == PAGE_AVAILABLE)
   {
     dlgDeactivateResetResponse();
     sPrompt = "This shop is available."+
               "\n\nThe current monthly tax cost for the shop is " + IntToString(gsQUGetTaxAmount(oShop)) +
               " gold.";


     sPrompt += "\n" + sPirate;
     object oPC = dlgGetSpeakingPC();
     object oContract = GetItemPossessedBy(oPC, "piratecontract");
     if(!GetElementCount(PAGE_AVAILABLE, dlgGetSpeakingPC()) && (nRank == 0 || (GetIsObjectValid(oContract) && GetLocalInt(oContract, "PIRATE_RANK") >= nRank)))
     {
       dlgAddResponse(PAGE_AVAILABLE, DLG_DEFAULT_TXT_ACTION_COLOR+"[Take over shop]</c> " +
                     txtBlue+"[Cost " + IntToString(GetLocalInt(OBJECT_SELF, "GS_COST")) +
                     " gold]");
     }
   }
   else if(sPage == PAGE_ABANDON)
   {
     sPrompt = "Are you sure you want to release this shop?";

     dlgClearResponseList(PAGE_ABANDON);
     dlgAddResponseAction(PAGE_ABANDON, "[OK]");
     dlgActivateResetResponse("[Cancel]", DLG_DEFAULT_TXT_ACTION_COLOR);
   }
   else if(sPage == PAGE_SSP)
   {
     int nSalePrice = gsSHGetSalePrice(oShop);
     sPrompt = "Items are sold at " + IntToString(nSalePrice) +
               "% of the value.";
     SetLocalInt(oShop, "GS_SH_SALE_PRICE", nSalePrice);
     dlgSetMaximumResponses(15);
     if(!GetElementCount(PAGE_SSP, dlgGetSpeakingPC()))
     {
       dlgAddResponse(PAGE_SSP, "+50%");
       dlgAddResponse(PAGE_SSP, "+25%");
       dlgAddResponse(PAGE_SSP, "+10%");
       dlgAddResponse(PAGE_SSP, "+5%");
       dlgAddResponse(PAGE_SSP, "+1%");
       dlgAddResponse(PAGE_SSP, "-1%");
       dlgAddResponse(PAGE_SSP, "-5%");
       dlgAddResponse(PAGE_SSP, "-10%");
       dlgAddResponse(PAGE_SSP, "-25%");
       dlgAddResponse(PAGE_SSP, "-50%");
     }
     dlgActivateResetResponse("[Back]");
   }
   else if(sPage == PAGE_TSA)
   {
     sPrompt = "Click Make Available to make your shop available until " +
               "the next server reset. If anyones buys it in this time the " +
               "value of the shop will be credited to your account.";

     //This can change during the conversation
     dlgClearResponseList(PAGE_TSA);
     if(!gsSHGetIsAvailable(oShop))
       dlgAddResponseAction(PAGE_TSA, "[Make Available]");
     else
       dlgAddResponseAction(PAGE_TSA, "[Make Unavailable]");

     dlgActivateResetResponse("[Back]");
   }
   else if(sPage == PAGE_FACTION_OPTIONS)
   {
     if(!GetElementCount(PAGE_FACTION_OPTIONS, dlgGetSpeakingPC()))
     {
       dlgAddResponseAction(PAGE_FACTION_OPTIONS, "[Set Faction] (Type Name before selecting)");
       dlgAddResponseAction(PAGE_FACTION_OPTIONS, "[Set Faction Permissions & Shop Settings]");
       if(fbFAGetFactionNameDatabaseID(md_SHLoadFacID()) != "")
       {
         dlgAddResponseAction(PAGE_FACTION_OPTIONS, "[Set Tax Rate]");
       }
     }

     sPrompt = "Faction options:";

     dlgActivateResetResponse("[Back]");
   }
   else if(sPage == PAGE_FACTION_LIST)
   {
     sPrompt = "Select a faction.";
     SQLExecStatement("SELECT id,name FROM md_fa_factions WHERE name LIKE ? LIMIT 10",
       "%" + chatGetLastMessage(dlgGetSpeakingPC()) + "%");

     dlgClearResponseList(PAGE_FACTION_LIST);
     DeleteList(PAGE_DB_LIST);
     dlgAddResponseAction(PAGE_FACTION_LIST, "[Remove Faction]");
     string sName;
     while (SQLFetch())
     {
       sName =  SQLGetData(2);

       if(FindSubString(sName, CHILD_PREFIX) == 0 || FindSubString(sName, SETTLEMENT_PREFIX) == 0)
         sName = GetStringRight(sName, GetStringLength(sName) - GetStringLength(CHILD_PREFIX));

       AddStringElement(SQLGetData(1), PAGE_DB_LIST);

       dlgAddResponse(PAGE_FACTION_LIST, sName);

     }
   }
   else if(sPage == PAGE_F_TAX)
   {
     sPrompt = "The current percentage of revenue going to faction " +
                fbFAGetFactionNameDatabaseID(md_SHLoadFacID()) +
                " is " + md_SHLoadFacTax() + "\n\nType in a number before selecting continue.";

     if(!GetElementCount(PAGE_F_TAX, dlgGetSpeakingPC()))
        dlgAddResponseAction(PAGE_F_TAX, "[Continue]");
   }
   else if(sPage == PAGE_ABL)
   {
     sPrompt = "Toggle which shop powers you want " + fbFAGetFactionNameDatabaseID(md_SHLoadFacID()) + " to have.\n\n"+
               "Powers tagged with {Shop} will work for ANYONE who interacts with the shop."+
               "\n\n"+
               "For powers tagged wth {Factions} the character needs the power from the faction AND it "+
               "needs to be turned on through this menu.";


       dlgClearResponseList(PAGE_ABL);
       _DisplayRespRedGreen(ABL_TOG, ABL_B_TOG);
       _DisplayRespRedGreen(ABL_STK, ABL_B_STK);
       _DisplayRespRedGreen(ABL_PLI, ABL_B_PLI);
       _DisplayRespRedGreen(ABL_TKI, ABL_B_TKI);
       _DisplayRespRedGreen(ABL_SPR, ABL_B_SPR);
       _DisplayRespRedGreen(ABL_SCP, ABL_B_SCP);
       _DisplayRespRedGreen(ABL_SCI, ABL_B_SCI);
   }
   else if(sPage == PAGE_DISPLAY_PRICES)
   {
     dlgActivateResetResponse("[Back]");
     sPrompt = "To change an item's price, type the price then select the item. Setting the price to 0 will set the price to the shop's default.";
     dlgClearResponseList(PAGE_DISPLAY_PRICES);
     object oShopFront = GetLocalObject(oShop, "MD_STORED_SHOP");
     if(!GetIsObjectValid(oShopFront))
     {
       //Loop through the placeables
       string sClass = GetLocalString(oShop, "GS_CLASS");
       int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

       oShopFront = GetNearestObject(OBJECT_TYPE_PLACEABLE, oShop);
       int x = 1;
       while(GetIsObjectValid(oShopFront))
       {
         if(sClass == GetLocalString(oShop, "GS_CLASS") && nInstance == GetLocalInt(oShop, "GS_INSTANCE"))
         {
           SetLocalObject(oShop, "MD_STORED_SHOP", oShopFront);
           break;
         }
         oShopFront = GetNearestObject(OBJECT_TYPE_PLACEABLE, oShop, ++x);
       }
     }

     object oItem = GetFirstItemInInventory(oShopFront);
     int y = 0;
     int nValue;
     int nSalePrice  = gsSHGetSalePrice(oShop);
     while(GetIsObjectValid(oItem))
     {
       int nValue = GetLocalInt(oItem, CUSTOM_PRICE);
       if(nValue == 0)
       {
        nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
        if (nValue < 1) nValue = 1;
       }
       dlgAddResponse(PAGE_DISPLAY_PRICES, txtLime + GetName(oItem) + "</c>" +
                      txtGreen + " (Stack Size: " + IntToString(GetItemStackSize(oItem)) + ")</c>: " +
                      IntToString(nValue));

       SetLocalObject(oShop, "MD_SHOP_ITEM"+IntToString(y), oItem);
       y++;
       oItem = GetNextItemInInventory(oShopFront);
     }
   }

   dlgSetPrompt(sPrompt);
   dlgSetActiveResponseList(sPage);
}
void OnSelection(string sPage)
{
  object oSelf = OBJECT_SELF;
	
  if(sPage == PAGE_OWNER)
  {
    int nSelection = dlgGetSelectionIndex();
    switch(nSelection)
    {
    case 0: dlgChangePage(PAGE_ABANDON); break;
    case 1: dlgChangePage(PAGE_SSP); break;
    case 2: dlgChangePage(PAGE_TSA); break;
    case 5: dlgChangePage(PAGE_FACTION_OPTIONS); break;
    case 4: dlgChangePage(PAGE_DISPLAY_PRICES); break;
    case 3: object oPC = dlgGetSpeakingPC();
            string sMsg = gsLIGetLastMessage(oPC);
            gsQUSetName(oSelf, sMsg);
            SendMessageToPC(oPC, "Shop name set to: " + sMsg); break;

    }

  }
  else if(sPage == PAGE_ABANDON)
  {
    object oPC = dlgGetSpeakingPC();
    if(gsPCGetPlayerID(oPC) != gsSHGetOwnerID(oSelf) &&
       md_GetHasWrit(oPC, md_GetDatabaseID(
       miCZGetName(miCZGetBestNationMatch(QUGetNationNameMatch())))
       , MD_PR2_RVS, "2") == 3)
    {
      object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
      if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
    }
    gsSHAbandon(oSelf);
    dlgEndDialog();
  }
  else if(sPage == PAGE_SSP)
  {
    int nSalePrice =  GetLocalInt(oSelf, "GS_SH_SALE_PRICE");
    int nSelection = dlgGetSelectionIndex();
    switch(nSelection)
    {
    case 0:  nSalePrice += 50; break;
    case 1:  nSalePrice += 25; break;
    case 2:  nSalePrice += 10; break;
    case 3:  nSalePrice += 5; break;
    case 4:  nSalePrice += 1; break;
    case 5:  nSalePrice -= 1; break;
    case 6:  nSalePrice -= 5; break;
    case 7:  nSalePrice -= 10; break;
    case 8:  nSalePrice -= 25; break;
    case 9:  nSalePrice -= 50; break;
    }

    gsSHSetSalePrice(oSelf, nSalePrice);
  }
  else if(sPage == PAGE_TSA)
  {
    gsQUSetIsForSale(oSelf, !gsQUGetIsForSale(oSelf));
  }
  else if(sPage == PAGE_OWNED)
  {
    string sSel = dlgGetSelectionName();
    if(sSel == RES_REL)
      dlgChangePage(PAGE_ABANDON);
    else if(sSel == RES_SSP)
      dlgChangePage(PAGE_SSP);
    else if(sSel == RES_SCP)
      dlgChangePage(PAGE_DISPLAY_PRICES);
    else  //take over shop
      _TakeOverShop();
  }
  else if(sPage == PAGE_AVAILABLE)
    _TakeOverShop();
  else if(sPage == PAGE_FACTION_OPTIONS)
  {
    switch(dlgGetSelectionIndex())
    {
    case 0: dlgChangePage(PAGE_FACTION_LIST); break;
    case 1: dlgChangePage(PAGE_ABL); break;
    case 2: dlgChangePage(PAGE_F_TAX); break;
    }
  }
  else if(sPage == PAGE_FACTION_LIST)
  {
    int nSelect = dlgGetSelectionIndex();
    string sSHID = GetLocalString(OBJECT_SELF, "GS_CLASS")+
                   IntToString(GetLocalInt(OBJECT_SELF, "GS_INSTANCE"));

    dlgClearResponseList(PAGE_FACTION_OPTIONS);
    if(nSelect == 0)
    {
      SQLExecDirect("UPDATE gs_quarter SET faction_id=NULL WHERE row_key='"+
                     sSHID+"'");
      SetLocalString(GetModule(), VAR_FID+sSHID, "NONE");
      dlgEndDialog();
    }
    else
    {
      string sID = GetStringElement(nSelect-1, PAGE_DB_LIST);
      miDASetKeyedValue("gs_quarter", sSHID, "faction_id", sID, "row_key");

      SetLocalString(GetModule(), VAR_FID+sSHID, sID);
      dlgChangePage(PAGE_ABL);
    }


  }
  else if(sPage == PAGE_F_TAX)
  {
    string sMsg = chatGetLastMessage(dlgGetSpeakingPC());
    //for proper formatting
    float fTax = StringToFloat(sMsg);
    if(fTax > 100.0)
      fTax = 100.0;
    else if(fTax < 0.0)
      fTax = 0.0;
    sMsg = FloatToString(fTax, GetStringLength(sMsg), 2);
    string sSHID = GetLocalString(OBJECT_SELF, "GS_CLASS")+
                   IntToString(GetLocalInt(OBJECT_SELF, "GS_INSTANCE"));
    miDASetKeyedValue("gs_quarter", sSHID, "faction_tax", sMsg, "row_key");

    SetLocalString(GetArea(OBJECT_SELF), VAR_FTAX+sSHID, sMsg);
  }
  else if(sPage == PAGE_ABL)
  {
    string sSel = dlgGetSelectionName();

    if(sSel == ABL_PLI)
      _ToggleABL(ABL_B_PLI);
    else if(sSel == ABL_SPR)
      _ToggleABL(ABL_B_SPR);
    else if(sSel == ABL_TKI)
      _ToggleABL(ABL_B_TKI);
    else if(sSel == ABL_TOG)
      _ToggleABL(ABL_B_TOG);
    else if(sSel == ABL_STK)
      _ToggleABL(ABL_B_STK);
    else if(sSel == ABL_SCP)
      _ToggleABL(ABL_B_SCP);
    else if(sSel == ABL_SCI)
      _ToggleABL(ABL_B_SCI);
  }
  else if(sPage == PAGE_DISPLAY_PRICES)
  {
    int nCustom = StringToInt(chatGetLastMessage(dlgGetSpeakingPC()));
    object oSelf = OBJECT_SELF;
    object oItem = GetLocalObject(oSelf, "MD_SHOP_ITEM"+IntToString(dlgGetSelectionIndex()));
    if(nCustom >= 1)
      SetLocalInt(oItem, CUSTOM_PRICE, nCustom);
    else
      DeleteLocalInt(oItem, CUSTOM_PRICE);
    string sID   = GetLocalString(oSelf, "GS_CLASS") + "_" +
                   IntToString(GetLocalInt(oSelf, "GS_INSTANCE"));
    spCORemove(sID, GetLocalObject(oSelf, "MD_STORED_SHOP"), oItem);
    //So we don't fire save multiple times
    if(!GetLocalInt(oSelf, "MD_SAVE_SHOP"))
    {
      SetLocalInt(oSelf, "MD_SAVE_SHOP", 1);
      DelayCommand(0.5, _SaveShop());
    }
  }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
  if(sPage == PAGE_TSA ||  sPage == PAGE_FACTION_OPTIONS || ((sPage == PAGE_SSP || sPage == PAGE_ABANDON || sPage == PAGE_DISPLAY_PRICES) && gsSHGetIsOwner(OBJECT_SELF, dlgGetSpeakingPC())))
    dlgChangePage(PAGE_OWNER);
  else if(sPage == PAGE_ABANDON || sPage == PAGE_SSP || sPage == PAGE_DISPLAY_PRICES)
    dlgChangePage(PAGE_OWNED);
  else if(sPage == PAGE_ABL || sPage == PAGE_FACTION_LIST || sPage == PAGE_F_TAX)
    dlgChangePage(PAGE_FACTION_OPTIONS);
}
void OnAbort(string sPage)
{
  CleanUp();
}
void OnEnd(string sPage)
{
  CleanUp();
}
void main()
{
  dlgOnMessage();
}

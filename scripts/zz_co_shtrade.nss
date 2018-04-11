//::///////////////////////////////////////////////
//:: Name    zz_co_shtrade
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The conversation file for shops trade
*/
//:://////////////////////////////////////////////
//:: Created By: Mordeorn
//:: Created On: 2/5/2012
//:://////////////////////////////////////////////
#include "zzdlg_main_inc"
#include "gs_inc_shop"
#include "inc_factions"

const string PAGE_MAIN = "PAGE_MAIN";
const string PAGE_STACK = "PAGE_STACK";

// Edit by Mithreas - work around the fact that we now log when people add stuff
// to their shop.
void SaveShop(object oShop)
{
  gsSHSave(oShop);
}

void _PurchaseFromShop(object oSpeaker, object oItem)
{
  object oSelf    = OBJECT_SELF;
  int nValue = GetLocalInt(oItem, CUSTOM_PRICE);
  if(nValue == 0)
  {
    int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
    nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
  }

  if (nValue < 1) nValue = 1;

  if (GetGold(oSpeaker) < nValue)
  {
      SendMessageToPC(oSpeaker, GS_T_16777238);
  }
  else
  {
      string sID  = gsSHGetOwnerID(oSelf);
      string sNationName = QUGetNationNameMatch(oSelf);
      string sNation;
      float fTax;
      int nTax;
      if (sNationName != "")
      {
        sNation = miCZGetBestNationMatch(sNationName);
        fTax = miCZGetTaxRate(sNation);
        nTax = FloatToInt(fTax * IntToFloat(nValue));
        nValue -= nTax;
        if(sNation != "")
        {
          miCZPayTax("", sNation, nTax, FALSE, oSpeaker);
        } //to keep consistant with quarter taxes, send these to the void, not that it should ever fire
        else
          TakeGoldFromCreature(nTax, oSpeaker, TRUE);
      }

      //Send gold for the faction
      string sFID = md_SHLoadFacID();
      fTax = StringToFloat(md_SHLoadFacTax()) / 100.0;
      //If faction name is removed, faction no longer exists
      string sFacName = fbFAGetFactionNameDatabaseID(sFID);
      if(sFacName != "" && fTax > 0.0)
      {
        nTax = FloatToInt(fTax * IntToFloat(nValue));
        //If it's a nation faction, it goes to the nation account
        sNation = md_GetFacNation(sFID);
        if(sNation != "" && sFacName == miCZGetName(sNation))
          AssignCommand(oSpeaker, gsFITransfer("N" + sNation, nTax));
        else
          AssignCommand(oSpeaker, gsFITransfer("F" + sFID, nTax));

        nValue -= nTax;
      }
      AssignCommand(oSpeaker, gsFITransfer(sID, nValue));
      gsSHExportItem(oItem, oSpeaker);
      ActionDoCommand(DelayCommand(0.5, SaveShop(oSelf)));
  }
}

void CleanUp()
{
  object oSpeaker = dlgGetSpeakingPC();
  object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
  object oSelf    = OBJECT_SELF;
  DeleteLocalObject(oSpeaker, "GS_SH_ITEM");
  DeleteLocalInt(oItem, "GS_SH_FLAG");

  dlgClearResponseList(PAGE_MAIN);
  dlgClearResponseList(PAGE_STACK);
  AssignCommand(oSpeaker, ActionInteractObject(oSelf));
}

void OnInit()
{
  dlgChangePage(PAGE_MAIN);
  dlgActivateEndResponse("[Done]");
}
void OnPageInit(string sPage)
{
  string sPrompt;

  object oSpeaker = dlgGetSpeakingPC();
  object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
  string sName = txtLime + GetName(oItem) + "</c>";
  int nStackSize = GetItemStackSize(oItem);

  if(sPage == PAGE_MAIN)
  {
    dlgDeactivateResetResponse();
    int nValue = GetLocalInt(oItem, CUSTOM_PRICE);
    if(nValue == 0)
    {
      int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
      nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
      if (nValue < 1) nValue = 1;
    }

    sPrompt = "Do you want to buy the article " + sName +
              txtGreen + " (Stack Size: " + IntToString(nStackSize) +
              "</c>) for " + txtLime + IntToString(nValue) + "</c>?";


    if(!GetElementCount(PAGE_MAIN, oSpeaker))
    {
      dlgAddResponseAction(PAGE_MAIN, "[OK]");
      if(md_SHLoadFacABL(ABL_B_STK) && nStackSize > 1)
        dlgAddResponseAction(PAGE_MAIN, "[Buy part of stack]");
      dlgAddResponseAction(PAGE_MAIN, "[Cancel]");
    }
  }
  else if(sPage == PAGE_STACK)
  {
    dlgActivateResetResponse();
    sPrompt = "How much of " + sName + " do you want to purchase?";
    //We use floats to get the most accurate sale price
    //As ints always round down
    float fValue = IntToFloat(GetLocalInt(oItem, CUSTOM_PRICE));
    if(fValue == 0.0)
    {
      float fSalePrice = IntToFloat(gsSHGetSalePrice(OBJECT_SELF));
      fValue     = IntToFloat(gsCMGetItemValue(oItem)) * fSalePrice / 100.0;
    }

    fValue /= IntToFloat(nStackSize);

    if (fValue < 1.0) fValue = 1.0;

    if(!GetElementCount(PAGE_STACK, oSpeaker))
    {
      int x;
      for(x = 1; x <= nStackSize; x++)
      {
        dlgAddResponse(PAGE_STACK, "[Buy: " + IntToString(x) + " at " + txtBlue +
                                   //Don't convert directly to string as some blank space will be
                                   //Outputted. Which just does not look good.
                                   IntToString(FloatToInt(IntToFloat(x) * fValue)) + "</c>]");

      }
    }

  }

  dlgSetPrompt(sPrompt);
  dlgSetActiveResponseList(sPage);
}
void OnSelection(string sPage)
{
  object oSpeaker = dlgGetSpeakingPC();
  int nIndex = dlgGetSelectionIndex();
  object oItem = GetLocalObject(oSpeaker, "GS_SH_ITEM");
  if(sPage == PAGE_MAIN)
  {
    switch(nIndex)
    {
    case 1: if(md_SHLoadFacABL(ABL_B_STK) && GetItemStackSize(oItem) > 1)
              dlgChangePage(PAGE_STACK);
            else //cancel
              dlgEndDialog();
            break;
    case 0: _PurchaseFromShop(oSpeaker, oItem); //No break is intentional
    default: dlgEndDialog();
    }

  }
  else if(sPage == PAGE_STACK)
  {
    int nStack = nIndex + 1;
    if(nStack == GetItemStackSize(oItem))
      _PurchaseFromShop(oSpeaker, oItem);
    else
    {
      //Use this to prevent stacking
      object oHelper = GetObjectByTag("MD_outhelp");
      if(!GetIsObjectValid(oHelper))
      {
        SendMessageToPC(oSpeaker, "Error: Output helper not placed.");
        dlgEndDialog();
        return;
      }

      //Use floats to get most accurate price
      float fOValue = IntToFloat(GetLocalInt(oItem, CUSTOM_PRICE));
      float fCustom = 0.0;
      if(fOValue > 0.0)
      {
        //Get the value for the individual item
        float fValue = fOValue / IntToFloat(GetItemStackSize(oItem));
        //Store the custom price for the bought stack for later
        fCustom = IntToFloat(nStack) * fValue;
        //Store the new value for the unbought stack for later
        fOValue -= fCustom;
      }
      //Check if they're able to buy the item
      int nValue = FloatToInt(fCustom);
      //Placed here so I can get the copy's non-custom value
      object oCopy = CopyItem(oItem, oHelper, TRUE);
      SetItemStackSize(oCopy, nStack);

      if(nValue == 0)
      {
        int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
        nValue = gsCMGetItemValue(oCopy) * nSalePrice / 100;
      }

      if (nValue < 1) nValue = 1;
      //We do not have enough gold for the item, so notify the buyer
      //And destroy the copy.
      if (GetGold(oSpeaker) < nValue)
      {
        SendMessageToPC(oSpeaker, GS_T_16777238);
        DestroyObject(oCopy);
        dlgEndDialog();
        return;
      }
      //Enough gold, set the new values and sell the item
      if(fCustom > 0.0)
      {
        SetLocalInt(oCopy, CUSTOM_PRICE, FloatToInt(fCustom));
        SetLocalInt(oItem, CUSTOM_PRICE, FloatToInt(fOValue));
      }
     // spCORemove(sID, OBJECT_SELF, oItem);
     //Must do this so that the item saves
      DeleteLocalInt(oItem, SLOT_VAR);
      gsCMReduceItem(oItem, nStack);
      _PurchaseFromShop(oSpeaker, oCopy);
    }
    dlgClearResponseList(PAGE_MAIN);
    dlgClearResponseList(PAGE_STACK);
    dlgEndDialog();
  }

}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
  dlgChangePage(PAGE_MAIN);
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

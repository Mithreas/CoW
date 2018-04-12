//::///////////////////////////////////////////////
//:: Name    zz_co_shsetprice
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The conversation file for setting custom shop
    prices second chance
*/
//:://////////////////////////////////////////////
//:: Created By: Mordeorn
//:: Created On: 02-15-2012
//:://////////////////////////////////////////////
#include "zzdlg_main_inc"
#include "inc_listener"
#include "inc_shop"
//Pages
const string PAGE_MAIN = "PAGE_MAIN";
const string PAGE_CONFIRM = "PAGE_CONFIRM";

void _SaveShop()
{
  gsSHSave(OBJECT_SELF);
}


void CleanUp()
{
  dlgClearResponseList(PAGE_MAIN);
  dlgClearResponseList(PAGE_CONFIRM);
  object oPC = dlgGetSpeakingPC();
  DeleteLocalObject(oPC, "MD_SAVED_ITEMP");
  DeleteLocalInt(oPC, "MD_SH_CUR_PRI");
}

void OnInit()
{
  dlgChangePage(PAGE_MAIN);

  dlgActivateEndResponse("[Done]", txtRed);
}
void OnPageInit(string sPage)
{
  string sPrompt;
  object oPC = dlgGetSpeakingPC();
  object oItem = GetLocalObject(oPC, "MD_SAVED_ITEMP");
  string sName = txtLime +
                GetName(oItem) +
                "</c>";
  if(sPage == PAGE_MAIN)
  {

    sPrompt = "Type the price you want " +  sName +
              " to be set at, then select continue.";


    dlgClearResponseList(PAGE_MAIN);
    dlgAddResponseAction(PAGE_MAIN, "[Continue]");
  }
  else if(sPage == PAGE_CONFIRM)
  {
    int nValue = GetLocalInt(oPC, "MD_SH_CUR_PRI");
    if(nValue == 0)
    {
      int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
      nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
      if (nValue < 1) nValue = 1;
    }
    sPrompt = "Are you sure you want " + sName +
              " to be set to " + IntToString(nValue) + "?";

    dlgClearResponseList(PAGE_CONFIRM);
    dlgAddResponseAction(PAGE_CONFIRM, "[Yes]");
    dlgAddResponseAction(PAGE_CONFIRM, "[No. Type the price you want before selecting.]");
  }

  dlgSetPrompt(sPrompt);
  dlgSetActiveResponseList(sPage);
}
void OnSelection(string sPage)
{
  object oPC = dlgGetSpeakingPC();
  if(sPage == PAGE_MAIN)
  {
    SetLocalInt(oPC, "MD_SH_CUR_PRI", StringToInt(chatGetLastMessage(oPC)));
    dlgChangePage(PAGE_CONFIRM);
  }
  else if(sPage == PAGE_CONFIRM)
  {
    object oItem = GetLocalObject(oPC, "MD_SAVED_ITEMP");
    int nPrice = GetLocalInt(oPC, "MD_SH_CUR_PRI");
    switch(dlgGetSelectionIndex())
    {
    case 0: if(nPrice >= 1)
            {
              SetLocalInt(oItem, CUSTOM_PRICE, nPrice);
              //Saved already, so.. lets remove it and save it again
              if(GetLocalInt(oItem, SLOT_VAR))
              {
                spCORemove(GetLocalString(OBJECT_SELF, "GS_CLASS") + "_" +
                  IntToString(GetLocalInt(OBJECT_SELF, "GS_INSTANCE")), OBJECT_SELF, oItem);
                DelayCommand(0.5, _SaveShop());
              }
            }
            dlgEndDialog();
            break;
    case 1: SetLocalInt(oPC, "MD_SH_CUR_PRI", StringToInt(chatGetLastMessage(oPC))); break;
    }
  }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
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

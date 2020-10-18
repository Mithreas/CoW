/*
  Name: zdlg_butcher
  Author: Mithreas
  Date: June 10th 2018
  Description: Butcher convo - buys meat.

*/
#include "inc_divination"
#include "inc_item"
#include "inc_shop"
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "btc_main_options";
const string PAGE_2 = "page_2";
const string END = "end";

void Init()
{
  // Responses to greeting.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Yes, that's why I'm here.", MAIN_MENU);
    AddStringElement("None, sorry.", MAIN_MENU);
    AddStringElement("Do you have anything for sale?", MAIN_MENU);
  }
  
  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Thanks, goodbye.", END);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Been out hunting?  Got any meat to sell?");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {
    object oItem = GetFirstItemInInventory(oPC);
    string sTag;
    int nGold  = 0;
    int nCount = 0;

    while (GetIsObjectValid(oItem))
    {
      sTag = GetTag(oItem);
      if (sTag == "cnrAnimalMeat")
      {
        nGold += gsCMGetItemValue(oItem);
		nCount++;
        DestroyObject (oItem);
      }

      oItem = GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(oPC, nGold);
    if (GetHitDice(oPC) < 6) gsXPGiveExperience(oPC, nGold > 20000 ? 20000 : nGold);

    SetDlgPrompt("Great, that'll feed us for a while.");
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:
        // Sell meat
        {
          SetDlgPageString(PAGE_2);
          break;
        }
      case 1:
        // No meat
        {
          EndDlg();
          break;
        }
      case 3:
        // Shop
        {
          int nTimeout = GetLocalInt(oPC, "WATER_TIMEOUT");
	      if (gsTIGetActualTimestamp() > nTimeout)
	      {
            miDVGivePoints(oPC, ELEMENT_WATER, 8.0);
	        SetLocalInt(oPC, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	      }  
		  
          object oStore = GetNearestObject(OBJECT_TYPE_STORE);
          if (GetIsObjectValid(oStore)) gsSHOpenStore(oStore, OBJECT_SELF, oPC);
          EndDlg();
          break;
        }
    }
  }
  else if (GetDlgResponseList() == END)
  {
    EndDlg();
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void main()
{
  int nEvent = GetDlgEventType();
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}

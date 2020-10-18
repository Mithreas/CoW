/*
  Name: zdlg_bat
  Author: Mithreas
  Date: Apr 30 2006
  Description: Bat bounty conversation script. Uses Z-Dialog.

*/
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "bat_main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string END = "end";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("None, sorry.", MAIN_MENU);
  AddStringElement("Why do you want bat skins?", MAIN_MENU);
  if (GetItemPossessedBy(GetPcDlgSpeaker(), "cnrSkinBat") != OBJECT_INVALID) 
  {
    AddStringElement("Yes, I have some. Here you are!", MAIN_MENU);
  }  

  // Responses to being told why she wants them.
  if (GetElementCount(PAGE_2) == 0)
  {
    AddStringElement("Oh, I see... Goodbye...", PAGE_2);
  }

  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Thanks, ma'am. Goodbye.", END);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Morrian watch over you, stranger. Do you have any bat skins? " +
                 "I'll pay you for them! Five gold each, can't say fairer than " +
                 "that.");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {

    SetDlgPrompt("What a strange question, deary. I collect them, if you must "
               + "know. Their fur is wonderfully soft! You can find bats in the "
               + "Fellstone River, south of the Undercity. Not a good place for "
               + "such as me, but you look like you can take care of yourself.");
    SetDlgResponseList(PAGE_2, OBJECT_SELF);

  }
  else if (sPage == PAGE_3)
  {
    object oItem = GetFirstItemInInventory(oPC);
    string sTag;
    int nGold = 0;
    int nXP   = 0;

    while (GetIsObjectValid(oItem))
    {
      sTag = GetTag(oItem);
      if (sTag == "cnrSkinBat")
      {
        nGold += 5 * GetItemStackSize(oItem);
        nXP += 5 * GetItemStackSize(oItem);
        DestroyObject (oItem);
      }

      oItem = GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(oPC, nGold);
    if (GetHitDice(oPC) < 6) gsXPGiveExperience(oPC, nGold > 20000 ? 20000 : nGold);

    SetDlgPrompt("Thank-you, deary. If you find any more, bring them to me!");
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
        // End conv
        {
          EndDlg();
          break;
        }
      case 1:
        // Ask why
        {
          SetDlgPageString(PAGE_2);
          break;
        }
      case 2:
        // Yes, have some skins to sell.
        {
          SetDlgPageString(PAGE_3);
          break;
        }
    }
  }
  else if (GetDlgResponseList() == PAGE_2)
  {
    EndDlg();
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

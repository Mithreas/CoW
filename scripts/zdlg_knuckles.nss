/*
  Name: zdlg_knuckles
  Author: Mithreas
  Date: Apr 30 2006
  Description: Skeleton knuckles conversation script. Uses Z-Dialog.

*/
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "knk_main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string PAGE_4 = "page_4";
const string END = "end";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("None, sorry.", MAIN_MENU);
  AddStringElement("Why do you want bones?", MAIN_MENU);
  if (GetItemPossessedBy(GetPcDlgSpeaker(), "NW_IT_MSMLMISC13") != OBJECT_INVALID)
  {
    AddStringElement("Yes, I have some. Here you are!", MAIN_MENU);
  }  

  // Responses to being told why he wants them.
  if (GetElementCount(PAGE_2) == 0)
  {
    AddStringElement("Oh, I see... Goodbye...", PAGE_2);
    AddStringElement("It doesn't seem to work very well...", PAGE_2);
  }

  if (GetElementCount(PAGE_4) == 0)
  {
    AddStringElement("Oh, I see... Goodbye...", PAGE_4);
  }

  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Morrian watch over you, old man. Goodbye.", END);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Oh, hello there. Emperor be with you, stranger. I don't " +
                 "suppose you have any old bones on you, do you? Older than " +
                 "mine, I mean.");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {

    SetDlgPrompt("I'm an alchemist, you know. Using those bones, I can make " +
       "myself a potion of eternal youth!");
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
      if (sTag == "NW_IT_MSMLMISC13")
      {
        nGold += 5 * GetItemStackSize(oItem);
        nXP += 5 * GetItemStackSize(oItem);
        DestroyObject (oItem);
      }

      oItem = GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(oPC, nGold);
    if (GetHitDice(oPC) < 6) gsXPGiveExperience(oPC, nXP);
    SetDlgPrompt("Thank-you kindly, stranger. Take this for your efforts.");
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else if (sPage == PAGE_4)
  {

    SetDlgPrompt("I'm an alchemist, you know. Using those bones, I can make " +
       "myself a potion of eternal youth!");
    SetDlgResponseList(PAGE_4, OBJECT_SELF);

  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
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

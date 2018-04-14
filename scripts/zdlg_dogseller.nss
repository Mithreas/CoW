/*
  Name: zdlg_dogseller
  Author: Mithreas
  Date: Apr 30 2006
  Description:Dog seller conversation script. Uses Z-Dialog.

*/
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string END = "end";

void Init()
{
  // Responses to greeting.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Yes, I am.", MAIN_MENU);
    AddStringElement("Not at the moment, thank-you.", MAIN_MENU);
  }

  // Responses to being told a price
  if (GetElementCount(PAGE_2) == 0)
  {
    AddStringElement("On second thoughts, perhaps I'll wait for now.", PAGE_2);
    AddStringElement("It's a deal.", PAGE_2);
  }

  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Goodbye.", END);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("May the Divines guide and keep you, friend. Are you looking "+
                 "for a hunting dog?");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {
    int nRangerLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    if (nRangerLevel > 5)
    {
      int nCost = (nRangerLevel - 5) * 100;
      SetLocalInt(OBJECT_SELF, "COST", nCost);
      SetDlgPrompt("Well, you've come to the right man. I guess you'll be "+
                   "wanting the best animal you can handle, right? I have " +
                   "just the one. He's yours for only " +IntToString(nCost) +
                   " marks.");
      SetDlgResponseList(PAGE_2, OBJECT_SELF);
    }
    else
    {
      SetDlgPrompt("You don't look like the sort who can handle an animal like "
                  + "these, no offense intended. Sorry.");
      SetDlgResponseList(END, OBJECT_SELF);
    }
  }
  else if (sPage == PAGE_3)
  {
    int nCost = GetLocalInt(OBJECT_SELF, "COST");
    if (GetGold(oPC) < nCost)
    {
      SetDlgPrompt("Sorry, you don't have enough gold. ");

    }
    else
    {
      TakeGoldFromCreature(nCost, oPC);
      CreateItemOnObject("dogcollar", oPC);
      if (d2() -1)
      {
        SetDlgPrompt("Congratulations! Look after him...");
      }
      else
      {
        SetDlgPrompt("Congratulations! Look after her...");
      }
    }

    SetDlgResponseList(END, OBJECT_SELF);
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
        // Yes.
        {
          SetDlgPageString(PAGE_2);
          break;
        }
      case 1:
        // End conv
        {
          EndDlg();
          break;
        }
    }
  }
  else if (GetDlgResponseList() == PAGE_2)
  {
    switch (selection)
    {
      case 0:
        // End.
        {
          EndDlg();
          break;
        }
      case 1:
        // Pay for doggy
        {
          SetDlgPageString(PAGE_3);
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
                    "You've found a bug. How embarassing. Please report it.");
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

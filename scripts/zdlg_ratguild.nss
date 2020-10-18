/*
  Name: zdlg_ratguild
  Author: Mithreas
  Date: May 5th 2018
  Description: Rat hunter guild front. Uses Z-Dialog.

*/
#include "inc_backgrounds"
#include "inc_house_check"
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "rg_main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string PAGE_4 = "page_4";
const string END = "end";

void Init()
{
  object oPC = GetPcDlgSpeaker();

  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("None, sorry.", MAIN_MENU);
  AddStringElement("Can you tell me more about the Guild?", MAIN_MENU);
  AddStringElement("Please may I join the Guild?", MAIN_MENU);
  if (GetItemPossessedBy(oPC, "cnrskinrat") != OBJECT_INVALID) 
  {
    AddStringElement("Of course, that's why I'm here.  Here you are.", MAIN_MENU);
  }  

  // Responses to being told more about the guild.
  if (GetElementCount(PAGE_2) == 0)
  {
    AddStringElement("A worthy and honourable cause.  Sign me up!", PAGE_2);
    AddStringElement("You do good work, but I have other duties.", PAGE_2);
  }
  
  // Responses to job offer.
  DeleteList(PAGE_4);
  if (isShadow(oPC)) AddStringElement("Ah, of course.  One too many rats landing on my head, clearly.", PAGE_4);
  else if (isUnaligned(oPC)) 
  { 
    AddStringElement("Yes, my most ardent ambition is to be a first class rodent hunter.", PAGE_4);  
    AddStringElement("The offer is flattering, but I must consider it further.", PAGE_4);
  }	
  else
  {
    AddStringElement("Ah. I'd best get back to work then.", PAGE_4);
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
    SetDlgPrompt("Welcome to the most ancient and honourable order of rat catchers. " +
                 "We pay out a bounty on rat skins for any who bring them, or are you " +
                 "looking for a place among our ranks?  It's vital work.");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {

    SetDlgPrompt("Unless you were born yesterday, you'll have noticed that food is scarce here, "
               + "and we can't afford to lose any to spoilage or vermin.  The Guild was established "
               + "to protect our food stores, mainly from rats, but any other thieves or vermin "
               + "are fair game as well.");
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
      if (sTag == "cnrskinrat")
      {
        nGold += 5 * GetItemStackSize(oItem);
        nXP += 5 * GetItemStackSize(oItem);
        DestroyObject (oItem);
      }

      oItem = GetNextItemInInventory(oPC);
    }

    GiveGoldToCreature(oPC, nGold);
    if (GetHitDice(oPC) < 6) gsXPGiveExperience(oPC, nGold > 20000 ? 20000 : nGold);

    SetDlgPrompt("Good work, Hunter. If you find any more, bring them to me!");
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else if (sPage == PAGE_4)
  {
    if (isShadow(oPC)) 
    {
      SetDlgPrompt("You're already on our rolls!  Feel free to relax in the guildhouse downstairs.");
    }	
    else if (isUnaligned(oPC)) 
    { 
      SetDlgPrompt("We can always use another hunter. Pay is five marks per rat killed, and you get use of our guild rooms downstairs."); 
    }	
    else
    {
      SetDlgPrompt("Eh, folks from the Houses don't have time to be proper rat catchers.  Duties above-ground keep the likes of you busy.");
    }    
	
    SetDlgResponseList(PAGE_4, OBJECT_SELF);
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
        // Ask about the guild
        {
          SetDlgPageString(PAGE_2);
          break;
        }
      case 2:
        // Ask to join
        {
          SetDlgPageString(PAGE_4);
          break;
        }
      case 3:
        // Yes, have some skins to sell.
        {
          SetDlgPageString(PAGE_3);
          break;
        }
    }
  }
  else if (GetDlgResponseList() == PAGE_2)
  {
    switch (selection)
	{
      case 0:
        // Sign up
        {
          SetDlgPageString(PAGE_4);
          break;
        }
	  default:	
        EndDlg();
	}	
  }
  else if (GetDlgResponseList() == PAGE_4)
  {
    if (isShadow(oPC))
	{
      EndDlg();
	}
	else if (isUnaligned(oPC))
	{
	  if (!selection) 
	  {
	    miBAApplyBackground(GetPCSpeaker(), MI_BA_SHADOW, TRUE);
	  }
	  
	  EndDlg();
	}
	else
	{
      EndDlg();
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

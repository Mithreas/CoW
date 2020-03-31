/*
  Name: zdlg_bat
  Author: Mithreas
  Date: Apr 30 2006
  Description: Bat bounty conversation script. Uses Z-Dialog.

*/
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "main_options";
const string ECDYSIS     = "ecdysis";
const string WEB         = "web";
const string THREAD      = "thread";
const string MTHREAD     = "mithril_thread";
const string END = "end";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("It would be good to have some chitin, were any spare.", MAIN_MENU);
  AddStringElement("I find myself in need of some silk, and all know the finest silk is spun by your people.", MAIN_MENU);
  AddStringElement("The mane of the Pan is strong and supple, yet needs a master weaver to spin into thread.  And the finest weavers are the Arachne.", MAIN_MENU);
  AddStringElement("I seek a skilled weaver to coat my thread with mithril.", MAIN_MENU);
  AddStringElement("Fair winds and gentle paths to you, " + (GetGender(OBJECT_SELF) == GENDER_MALE ? "brother" : "sister") + ".", MAIN_MENU);

  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Thank you.  Fair winds and gentle paths.", END);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Did you wish something, " + (GetRacialType(oPC) == RACIAL_TYPE_ELF ? "elfling" : "stranger") + "?");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == ECDYSIS)
  {
    string sComment;
    switch (d6())
	{
	  case 1:
	    sComment = "";
		break;
	  case 2:
	    sComment = "What you use so much for is always a mystery to us.";
		break;
	  case 3:
	    sComment = "Think of me as you wear my skin, yes?";
		break;
	  case 4:
	    sComment = "I come from a proud Lineage.";
		break;
      case 5:
	    sComment = "Pledge to do no ill with what I give you.";
		break;
	  case 6:
	    sComment = "Fair winds and gentle paths.";
		break;
	}
	
	int nEcdysis = GetLocalInt(OBJECT_SELF, "ARACHNE_ECDYSIS_COUNT");
	int nTimeout = GetLocalInt(OBJECT_SELF, "ARACHNE_TIMEOUT");
		  
	if (!nEcdysis && nTimeout < gsTIGetActualTimestamp())
	{
		nEcdysis = d20();		    
	}
		  
	if (!nEcdysis)
	{	    		  
	  SetDlgPrompt("I have no more chitin spare at the moment.");
	}	
	else
	{
	  CreateItemOnObject("arachnechitin", oPC);
	  nEcdysis --;	  
	  SetLocalInt(OBJECT_SELF, "ARACHNE_ECDYSIS_COUNT", nEcdysis);
      SetDlgPrompt("Yes, always. " + sComment);
	  
	  if (!nEcdysis)
	  {
	    SetLocalInt(OBJECT_SELF, "ARACHNE_TIMEOUT", gsTIGetActualTimestamp() + 60 * 5);
	  }
	}
	
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else if (sPage == WEB)
  {
    object oTwig = GetItemPossessedBy(oPC, "cnrtwigent");
	
	if (GetIsObjectValid(oTwig))
	{
	  gsCMReduceItem(oTwig, 1);
	  CreateItemOnObject("cnrspidersilk", oPC);
	  FloatingTextStringOnCreature("Quick as a flash, the arachne winds some silk around a twig and hands it back to you.", oPC);
	  SetDlgPrompt("And so it is.  Here, a gift in the name of friendship.");
	}
	else	
	{
	  SendMessageToPC(oPC, "Bring an arachne a Twig of Ent to get some silk.");
      SetDlgPrompt("Indeed it is.  But you will need a spool for me to spin around.  A simple twig would do.");
	}
	
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else if (sPage == THREAD)
  {
    object oMane = GetItemPossessedBy(oPC, "cnrpanmane");
	
	if (GetIsObjectValid(oMane))
	{
	  CreateItemOnObject("cnrthread", oPC, GetItemStackSize(oMane));
	  DestroyObject(oMane);
	  FloatingTextStringOnCreature("The arachne's limbs weave the mane into thread, moving like a blur.", oPC);
      SetDlgPrompt("That we are.  Faster even than your magics.");
	}
	else
	{
	  SendMessageToPC(oPC, "Bring an arachne some Pan's Mane to make thread.");
      SetDlgPrompt("That is so. And we are always happy to put our craft to work.");
	}	
	
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else if (sPage == MTHREAD)
  {
    object oThread  = GetItemPossessedBy(oPC, "cnrthread");
    object oMithril = GetItemPossessedBy(oPC, "cnringotmit");
	
	int nCount = (GetItemStackSize(oThread) > GetItemStackSize(oMithril) ? GetItemStackSize(oMithril) : GetItemStackSize(oThread));
	
	if (GetIsObjectValid(oThread) && GetIsObjectValid(oMithril))
	{
	  gsCMReduceItem(oThread, nCount);
	  gsCMReduceItem(oMithril, nCount);
	  CreateItemOnObject("cnrthreadmit", oPC, nCount);
	  
	  FloatingTextStringOnCreature("The arachne coats your thread with your mithril.", oPC);
      SetDlgPrompt("Ah, a task worthy of a master of the craft.  It is a pleasure to do such things.");
	}
	else
	{
	  SendMessageToPC(oPC, "Bring an arachne some thread and some pure mithril to make mithril thread.");
      SetDlgPrompt("You have found such a weaver, but you have not found the ingredients.");
	}
	
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
        // Request chitin
        {
          SetDlgPageString(ECDYSIS);
          break;
        }
      case 1:
        // Request silk
        {
          SetDlgPageString(WEB);
          break;
        }
      case 2:
        // Request thread
        {
          SetDlgPageString(THREAD);
          break;
        }
      case 3:
        // Request mithril thread
        {
          SetDlgPageString(MTHREAD);
          break;
        }
      case 4:
        // Goodbye
        {
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

/*
  Name: zdlg_hinwatertst
  Author: Mithreas 
  Date: 29 July 2018
  Description: Conversation script to test whether hin are heavier than ducks. 
*/

#include "inc_awards"
#include "inc_external"
#include "zdlg_include_i"

const string MAIN_MENU   = "hwt_main_options";
const string CONFIRM = "confirm";
const string END = "end";

void _Fail(object oPC)
{
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToObject(GetObjectByTag("WATERY_GRAVE")));

  SendMessageToPC(oPC, "You get a little way out onto open water, then a large wave rises up out of nowhere and swallows your boat.  Death follows shortly thereafter.");
  
  // rewards
  gvd_DoRewards(oPC);

  // Delete character.
  fbEXDeletePC(oPC);
  SetCommandable(FALSE, oPC);
}

void _Success(object oPC)
{
  FloatingTextStringOnCreature("You take the rowboat out onto open water.  Nothing happens, it's quite anticlimactic really.  You row back in and hand the boat back over.",oPC);
  CreateItemOnObject("permission_sea", oPC);
  DelayCommand(6.0f, SpeakString("Congratulations, here's your certificate.  Now get out of my hair."));
}

void Init()
{
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Yes, I want to take the test.", MAIN_MENU);
	AddStringElement("No, not yet.  Just looking.", MAIN_MENU);
  }
  
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("Yes, I'm sure. <cþ  >[Risk Permadeath]</c>", CONFIRM);
	AddStringElement("On second thoughts, maybe I'll just keep my feet on dry land.", CONFIRM); 
  }
  
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Okay, goodbye.", END); 
  }
}

void PageInit()
{
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (GetRacialType(oPC) == RACIAL_TYPE_HUMAN || GetIsObjectValid(GetItemPossessedBy(oPC, "permission_sea")))
  {
    SetDlgPrompt("You don't need a certificate.  Go do something useful.");
	SetDlgResponseList(END);
  }
  else if (sPage == "")
  {
    SetDlgPrompt("So, you're here for a certificate to sail the seas?  I can test you... but only if you're sure you want to risk this."); 
	SetDlgResponseList(MAIN_MENU);
  }
  else if (sPage == CONFIRM)
  {
    SetDlgPrompt("Many don't come back from this.  Even the slightest trace of magic in you, and the sea will take you, just like that.  You're really sure you want to try it?\n\nChoosing this option risks permadeath of your character!");
	SetDlgResponseList(CONFIRM);
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgResponseList();
  
  if (sPage == END) EndDlg();
  else if (sPage == MAIN_MENU)
  {
    if (!selection) SetDlgPageString(CONFIRM);
	else EndDlg();
  }
  else if (sPage == CONFIRM)
  {
    if (!selection)
	{
	  int nFailRate = 100; // Default for all races.
	  
	  if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) nFailRate = 5;  // Halflings start with a low chance.
	  
	  if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)) nFailRate += 20; // Druids have higher risk.
	  
	  if (GetLevelByClass(CLASS_TYPE_BARD, oPC)) nFailRate += 90;  // Bards are very magical and almost certain to fail. 
	  
	  FloatingTextStringOnCreature("You take the rowboat out to sea...", oPC);
	  
	  if (d100() <= nFailRate)
	  {
	    // bad
		DelayCommand(6.0f, _Fail(oPC));
	  }
	  else
	  {
	    // good
		DelayCommand(6.0f, _Success(oPC));
	  }
    }
	
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

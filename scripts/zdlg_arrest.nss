/*
  Name: arrest_zdlg
  Author: Mithreas
  Date: Oct 20 2005
  Description: Guard arrest conversation script. Uses Z-Dialog.

*/
#include "inc_zdlg"
#include "inc_crime"
#include "nw_i0_generic"

const string MAIN_MENU   = "arr_main_options";
const string FALSE_ALARM = "false_alarm";

void Init()
{
  // PC responses to being arrested.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Alright, alright, here's the money.", MAIN_MENU);
    AddStringElement("Um, I don't have the money on me right now....",
                     MAIN_MENU);
    AddStringElement("Make me, wimp.", MAIN_MENU);
  }

  // Multiple guards seeing someone can lead to a false alarm.
  if (GetElementCount(FALSE_ALARM) == 0)
  {
    AddStringElement("Alright, alright, I'm moving!", FALSE_ALARM);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    int nBounty = GetBounty(CheckFactionNation(OBJECT_SELF), oPC);
    // First page. Display the options.
    if (nBounty > 0)
    {
      SetDlgPrompt("Halt! You're under arrest. You may either pay a fine of " +
                   IntToString(nBounty) + " gold, or go to jail.");
      SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
    }
    else
    {
      SetDlgPrompt("Move along, citizen. Quickly.");
      SetDlgResponseList(FALSE_ALARM, OBJECT_SELF);
    }
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }

}

void ExitJail(object oExitWP)
{
  SendMessageToPC(OBJECT_SELF, "Your sentence has been served.  You are free to go.");
  ClearAllActions();
  JumpToLocation(GetLocation(oExitWP));
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
        // Pay.
        {
          int nBounty = GetBounty(CheckFactionNation(OBJECT_SELF), oPC);

          if (nBounty > GetGold(oPC))
          {
            SpeakString("You don't have enough gold. To jail with you.");
            // Fall through to case 1.
          }
          else
          {
            TakeGoldFromCreature(nBounty, oPC);
            RemoveBountyToken(CheckFactionNation(OBJECT_SELF), oPC);
            EndDlg();
            break;
          }

        }
      case 1:
        // Don't pay. Go to jail, go directly to jail, etc etc.
        {
          string sNation = IntToString(CheckFactionNation(OBJECT_SELF));
          object oWP = GetObjectByTag("jail" + sNation);
          object oExitWP = GetObjectByTag("jailexit" + sNation);
          AssignCommand(oPC, ClearAllActions());
          AssignCommand(oPC, JumpToLocation(GetLocation(oWP)));
          RemoveBountyToken(CheckFactionNation(OBJECT_SELF), oPC);
          // Let them out after 15 minutes.
          SendMessageToPC(oPC, "((You have been jailed. You will automatically "
          + "be released after 15 (RL) minutes. Do not log out, or you won't "
          + "be released at all!))");
          DelayCommand(900.0,
                      AssignCommand(oPC, ExitJail(oExitWP)));

          EndDlg();
          break;
        }
      case 2:
        // Resist Arrest!
        EndDlg();
        AdjustReputation(oPC, OBJECT_SELF, -100);
        SetFacingPoint(GetPosition(oPC));
        SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        DetermineCombatRound();
        break;
    }
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

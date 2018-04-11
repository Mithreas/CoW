/*
  zdlg_criers

  Z-Dialog conversation script for town criers, to allow players to specify the
  text they want read out.

  Pages:
    Introduction and prompt
      - leave
      - specify message for this crier
      - specify message for all criers
      - (DMs) remove all messages
    Specify Duration
      - cancel
      - continue
    Not Enough Gold
      - done
    Complete
      - done


*/
#include "gs_inc_listener"
#include "inc_criers"
#include "zdlg_include_i"
#include "inc_log"

const string OPTIONS = "CRI_OPTIONS";
const string CONFIRM = "CRI_CONFIRM";
const string DONE    = "CRI_DONE";

const string PAGE_DURATION = "DURATION";
const string PAGE_DONE     = "DONE";
const string PAGE_FAILED   = "FAILED";

const string VAR_GLOBAL    = "CRI_GLOBAL";
const string VAR_MESSAGE   = "CRI_MESSAGE";

void Init()
{
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", CONFIRM);
    AddStringElement("<cþ  >[Cancel]</c>", CONFIRM);
  }

  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    DeleteList(OPTIONS);
    AddStringElement("<c þ >[Speak a message for all town criers then press here]</c>", OPTIONS);
    AddStringElement("<c þ >[Speak a message for this town crier then press here]</c>", OPTIONS);
    AddStringElement("<cþ  >[Cancel]</c>", OPTIONS);
    if (GetIsDM(oPC)) AddStringElement("<cþ  >[Remove all messages, from all criers]</c>", OPTIONS);

    SetDlgPrompt("Hi. Do you have an announcement for me to shout? The cost is "
    + "one gold coin per hour... or twenty per hour if you want all my fellow "
    + "members of the Guild of Town Criers to shout your message as well.");

    gsLIClearLastMessage(oPC);
    SetDlgResponseList(OPTIONS);
  }
  else if (sPage == PAGE_DURATION)
  {
    SetDlgPrompt("How many hours do you wish your message to be shouted for?");
    gsLIClearLastMessage(oPC);
    SetDlgResponseList(CONFIRM);
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgPrompt("Your message will be shouted to the very heavens themselves!");
    SetDlgResponseList(DONE);
  }
  else if (sPage == PAGE_FAILED)
  {
    SetDlgPrompt("You don't have enough gold.  Come back when you have enough coin.");
    SetDlgResponseList(DONE);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    int nGlobal = FALSE;
    switch (selection)
    {
      case 0:
        nGlobal = TRUE; // now fall through
      case 1:
        SetLocalInt(OBJECT_SELF, VAR_GLOBAL, nGlobal);
        SetLocalString(OBJECT_SELF, VAR_MESSAGE, gsLIGetLastMessage(oPC));
        SetDlgPageString(PAGE_DURATION);
        break;
      case 2:
        EndDlg();
        break;
      case 3:
        miCRPurgeDatabase();
        EndDlg();
        break;
    }
  }
  else if (sPage == PAGE_DURATION)
  {
    switch(selection)
    {
      case 0:
      {
        int nGlobal     = GetLocalInt(OBJECT_SELF, VAR_GLOBAL);
        string sMessage = GetLocalString(OBJECT_SELF, VAR_MESSAGE);
        int nDuration   = StringToInt(gsLIGetLastMessage(oPC));
        int nCost       = nDuration;
        if (!nDuration)
        {
          SendMessageToPC(oPC, "<c þ >Please say a number!");
        }
        else
        {
          if (nGlobal) nCost *= 20;

          if (GetGold(oPC) < nCost)
          {
            SetDlgPageString(PAGE_FAILED);
          }
          else
          {
            TakeGoldFromCreature(nCost, oPC, TRUE);
            miCRAddMessage(sMessage, nDuration, nGlobal, OBJECT_SELF);
            SetDlgPageString(PAGE_DONE);

            Log(CRIERS, "Character " + GetName(oPC) + " just submitted "
                        + sMessage);
          }
        }

        break;
      }
      case 1:
        EndDlg();
        break;
    }
  }
  else
  {
    // The Done response list has only one option, to end the conversation.
    EndDlg();
  }

}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
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

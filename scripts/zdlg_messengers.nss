/*
  zdlg_messengers

  Z-Dialog conversation script for messengers, to allow players to specify the
  message they want delivered.

  Pages:
    Introduction and prompt
      - leave
      - enter player name
    Speak message
      - cancel
      - continue
    Not Enough Gold
      - done
    Complete
      - done


*/
#include "inc_listener"
#include "inc_xfer"
#include "inc_zdlg"
#include "inc_log"

const string OPTIONS = "MES_OPTIONS";
const string CONFIRM = "MES_CONFIRM";
const string DONE    = "MES_DONE";

const string PAGE_MESSAGE = "MESSAGE";
const string PAGE_DONE    = "DONE";
const string PAGE_FAILED  = "FAILED";

const string VAR_PLAYER   = "MES_PLAYER";
const string VAR_SERVER   = "MES_SERVER";
const string VAR_VISIBLE_NAME = "MES_VISIBLE_NAME";

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

  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Speak a name then press here]</c>", OPTIONS);
    AddStringElement("<cþ  >[Cancel]</c>", OPTIONS);
  }

  DeleteLocalString(OBJECT_SELF, VAR_PLAYER);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  // We support Speedy Messengers (halflings) and Goblin Runners (goblins).
  // We really need to change this around.
  int nSpeedy = GetRacialType(OBJECT_SELF);

  if (sPage == "")
  {
    if (nSpeedy == RACIAL_TYPE_HALFLING)
      SetDlgPrompt("Hi! We deliver messages, to anyone, anywhere, any time! Only " +
      "fifty gold... no matter how far we have to go! \n\n<c þ >((Speak the name" +
      " or the first few characters of the name of the recipient, then press Next))");
    else if (nSpeedy == RACIAL_TYPE_ELF)
      SetDlgPrompt("Welcome.  The retainers of Castle Darrowdeep can dispatch a " +
      "messenger, if that is your wish.  There is a nominal fee. \n\n<c þ >((Speak the name" +
      " or the first few characters of the name of the recipient, then press Next))");
    else
      SetDlgPrompt("Youse want send message, yesyes? Gobbo runners take for you! "+
      "Fifty shinies, we go all over, yesyes!\n\n<c þ >((Speak the name" +
      " or the first few characters of the name of the recipient, then press Next))");
    gsLIClearLastMessage(oPC);
    SetDlgResponseList(OPTIONS);
  }
  else if (sPage == PAGE_MESSAGE)
  {
    if (nSpeedy == RACIAL_TYPE_HALFLING)
      SetDlgPrompt(GetLocalString(OBJECT_SELF, VAR_VISIBLE_NAME) +
        "? Sure, we can do that. What message do you want us to deliver?");
    else if (nSpeedy == RACIAL_TYPE_ELF)
      SetDlgPrompt(GetLocalString(OBJECT_SELF, VAR_VISIBLE_NAME) +
        "? It shall be done. What message do you want us to deliver?");
    else
      SetDlgPrompt(GetLocalString(OBJECT_SELF, VAR_VISIBLE_NAME) +
        "? Wez do, easy! What you want say?");
    gsLIClearLastMessage(oPC);
    SetDlgResponseList(CONFIRM);
  }
  else if (sPage == PAGE_DONE)
  {
    if (nSpeedy == RACIAL_TYPE_HALFLING || nSpeedy == RACIAL_TYPE_ELF)
      SetDlgPrompt("I'll send a runner with your message immediately!");
    else
      SetDlgPrompt("Yesyes! We go now!");
    SetDlgResponseList(DONE);
  }
  else if (sPage == PAGE_FAILED)
  {
    if (GetLocalString(OBJECT_SELF, VAR_PLAYER) == "")
    {
      if (nSpeedy == RACIAL_TYPE_HALFLING)
        SetDlgPrompt("*He thumbs through a big book* Hm, no, don't know nobody of " +
          "that name.  You kidding me, kiddo?");
      else if (nSpeedy == RACIAL_TYPE_ELF)
        SetDlgPrompt("*He consults a detailed ledger* Hm, no, we do not have any records " +
          "of that name.");
      else
        SetDlgPrompt("Whut? Gobbos not know that wun.  No send message if not know.");
    }
    else
    {
      if (nSpeedy == RACIAL_TYPE_HALFLING)
        SetDlgPrompt("You don't have enough gold.  Come back when you have enough coin.");
      else if (nSpeedy == RACIAL_TYPE_ELF)
        SetDlgPrompt("I fear you lack the coin for the processing fee.  We will await your return.");
      else
        SetDlgPrompt("No, no! Need more shinies, yesyes!");
    }

    SetDlgResponseList(DONE);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  string sType;

  // We support Speedy Messengers (halflings) and Goblin Runners (goblins).
  if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HALFLING)
    sType = "XFER_MSG_SPEEDY";
  else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELF)
    sType = "XFER_MSG_HERALD";
  else
    sType = "XFER_MSG_GOBLIN";

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:
        // Find a player of this name.
        {
          string sName = gsLIGetLastMessage(oPC);
          object oTarget = OBJECT_INVALID;

          // So first we want to check if a character can be found with an identical name to their visible name (no disguise).
          SQLExecStatement("SELECT pcid,server,visiblename FROM mixf_currentplayers AS a INNER JOIN gs_pc_data AS b " +
                           "ON a.pcid = b.id WHERE b.name LIKE ? AND b.name = visiblename AND reachable IS TRUE", sName + "%");

          int succeeded = FALSE;

          if (SQLFetch())
          {
            succeeded = TRUE;
          }
          else
          {
            // We can't find a PC by their real name, so let's try just their visible name instead.
            SQLExecStatement("SELECT pcid,server,visiblename FROM mixf_currentplayers WHERE visiblename LIKE ? AND reachable IS TRUE", sName + "%");

            if (SQLFetch())
            {
              succeeded = TRUE;
            }
          }

          if (succeeded)
          {
            SetLocalString(OBJECT_SELF, VAR_PLAYER, SQLGetData(1));
            SetLocalString(OBJECT_SELF, VAR_SERVER, SQLGetData(2));
            SetLocalString(OBJECT_SELF, VAR_VISIBLE_NAME, SQLGetData(3));
          }

          SetDlgPageString(succeeded ? PAGE_MESSAGE : PAGE_FAILED);

          break;
        }
      case 1:
        EndDlg();
        break;
    }
  }
  else if (sPage == PAGE_MESSAGE)
  {
    switch(selection)
    {
      case 0:
      {
        string sMessage = gsLIGetLastMessage(oPC);
        int nCost       = 50; // If you change this, also change the intro text!

        if (GetGold(oPC) < nCost)
        {
          SetDlgPageString(PAGE_FAILED);
        }
        else
        {
          TakeGoldFromCreature(nCost, oPC, TRUE);
          string sCurrentServer = GetLocalString(GetModule(), VAR_SERVER_NAME);
          string sTargetServer  = GetLocalString(OBJECT_SELF, VAR_SERVER);
          string sTarget        = GetLocalString(OBJECT_SELF, VAR_PLAYER);

          if (sCurrentServer == sTargetServer)
          {
            miXFDeliverMessage(sTarget, sMessage, sType);

          }
          else
          {
            miXFSendMessage(sTarget, sTargetServer, sMessage, sType);
          }

          SetDlgPageString(PAGE_DONE);
          Log(MESSENGERS, "Character " + GetName(oPC) + " just sent: "
                          + sMessage + "; recipient was " + sTarget);
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

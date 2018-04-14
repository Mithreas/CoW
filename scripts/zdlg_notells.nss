/*
  zdlg_notells

  Z-Dialog conversation script for Tell configuration

  Pages:
    Control prompt
     0 - Block person
     1 - Unblock person
     2 - Block all
     3 - Unblock all
     4 - Toggle blacklist/whitelist
     5 - Done


*/
#include "inc_listener"
#include "inc_tells"
#include "inc_zdlg"

const string OPTIONS = "NOT_OPTIONS";

const string VAR_ACTION = "NOT_ACTION";

void Init()
{
  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Block player]</c>", OPTIONS);
    AddStringElement("<c þ >[Unblock player]</c>", OPTIONS);
    AddStringElement("<c þ >[Block all]</c>", OPTIONS);
    AddStringElement("<c þ >[Unblock all]</c>", OPTIONS);
    AddStringElement("<c þ >[Toggle default]</c>", OPTIONS);
    AddStringElement("<cþ  >[Cancel]</c>", OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  object oPC   = GetPcDlgSpeaker();
  string sBlacklist = GetLocalString(gsPCGetCreatureHide(oPC), BLACKLIST);
  string sWhitelist = GetLocalString(gsPCGetCreatureHide(oPC), WHITELIST);
  string sDefault = GetLocalInt(gsPCGetCreatureHide(oPC), NOTELLS) ? "No tells allowed" : "Tells allowed";

  SetDlgPrompt(
    "Welcome to the Tell Control Panel, the protocol for all your Telling needs." +
    "\n\n(Bonus points if you got both the puns in the line above)." +
    "\n\nAhem.  Right, I was about to explain how the system works. Basically, "+
    "it gives you full control over who can send you Tells. Your options are:" +
    "\n- Speak the name (or the start of the name) of a player you wish not to " +
    "be able to send you Tells, then press Block Player." +
    "\n- Speak the name (or the start of the name) of a player you wish to be " +
    "able to send you tells, then press Unblock Player." +
    "\n- Select Block All to stop everyone on the server from sending you Tells, "+
    "even players you previously whitelisted." +
    "\n- Select Unblock All to allow anyone to send you Tells, even those you " +
    "previously blacklisted." +
    "\n- Select Toggle Default to change whether players you haven't specifically " +
    "configured can send you Tells or not.  Choosing this option won't affect your "+
    "blacklist or whitelist." +
    "\n\nYour current settings are: \n" +
    "Blacklist: " + sBlacklist + "\nWhitelist: " + sWhitelist + "\nDefault: " +
    sDefault);

    gsLIClearLastMessage(oPC);
    SetDlgResponseList(OPTIONS);
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  object oPlayer = miTEGetPlayerFromName(gsLIGetLastMessage(oPC));
  int bBlock = FALSE;
  switch (selection)
  {
    case 0:
      bBlock = TRUE; // fall through.
    case 1:
      if (!GetIsObjectValid(oPlayer))
      {
        SendMessageToPC(oPC, "No player of that name found.");
      }
      else
      {
        if (bBlock) miTEBlockPlayer(oPC, oPlayer);
        else miTEUnblockPlayer(oPC, oPlayer);
      }

      break;
    case 2:
      miTESetNoTellState(TRUE, oPC);
      miTEClearWhitelist(oPC);
      break;
    case 3:
      miTESetNoTellState(FALSE, oPC);
      miTEClearBlacklist(oPC);
      break;
    case 4:
      miTESetNoTellState(!GetLocalInt(oPC, NOTELLS), oPC);
      break;
    case 5:
      EndDlg();
      break;
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

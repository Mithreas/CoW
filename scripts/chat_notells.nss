#include "__server_config"
#include "fb_inc_chatutils"
#include "inc_tells"
#include "inc_examine"

const string HELP = "Use the -notells command to bring up a dialog allowing you to turn tells on or off globally, with the option to whitelist or blacklist certain players.";

void main()
{
  // Command not valid
  if (!ALLOW_NOTELLS) return;

  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-notells", HELP);
  }
  else if (miTEGetTellsDisabled(oSpeaker))
  {
    SendMessageToPC(oSpeaker, "Nice try, but we've already thought of that.");
  }
  else
  {
    SetLocalString(oSpeaker, "dialog", "zdlg_notells");
    AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, "zdlg_converse", TRUE, FALSE));
  }

  chatVerifyCommand(oSpeaker);
}

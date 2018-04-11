#include "fb_inc_chatutils"
#include "inc_xfer"
#include "inc_examine"

const string HELP = "Brings up a list of players, and says which server they're on.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-playerlist", HELP);
  }
  else
  {
    SendMessageToPC(oSpeaker, miXFGetPlayerList());
  }

  chatVerifyCommand(oSpeaker);
}

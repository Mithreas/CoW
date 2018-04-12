#include "inc_chatutils"
#include "inc_database"
#include "inc_xfer"
#include "inc_examine"

const string HELP = "DM command: Displays the time, in real life hours, that the server has been up for.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-uptime", HELP);
  }
  else
  {
    SQLExecStatement("SELECT (UNIX_TIMESTAMP() - startup) FROM nwn.web_server WHERE sid=?", miXFGetCurrentServer());

    if (!SQLFetch())
    {
      SendMessageToPC(oSpeaker, "Warning: Database error. You will need to restart as soon as possible.");
    }
    else
    {
      int nTotSeconds = StringToInt(SQLGetData(1));
      int nHours      = nTotSeconds / 3600;
      int nMinutes    = (nTotSeconds / 60) % 60;

      SendMessageToPC(oSpeaker, "Server has been up for " + IntToString(nHours) +
       " hours, " + IntToString(nMinutes) + " minutes real time.");
    }
  }

  chatVerifyCommand(oSpeaker);
}

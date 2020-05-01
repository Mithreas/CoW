#include "inc_chatutils"
#include "inc_pc"
#include "inc_time"
#include "inc_disguise"
#include "inc_divination"
#include "inc_examine"

const string HELP1 = "<cþôh>-disguise </c><cþ£ >[Text]</c>\nUse -disguise to attempt to disguise yourself. Other people can then see that you are disguised, and can see whether they recognize your character or not using the *looks* command. The higher your Bluff or Perform skills, the more likely you are to remain disguised.\nPlease note: Common sense is to be executed here. If your 'disguise' isn't plausible, don't be surprised if other people recognize you whether you use -disguise or not.";
const string HELP2 = "\n\nThe optional <cþ£ >[Text]</c> can be used to change how your name appears, e.g. <cþôh>-disguise Fred Bloggs</c>.";

void main()
{
  // Command not valid
  if (!ALLOW_DISGUISE) return;

  object oSpeaker = OBJECT_SELF;
  string sParams  = chatGetParams(oSpeaker);

  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-disguise", HELP1 + HELP2);
  }
  else
  {
    if (GetIsPCDisguised(oSpeaker))
    {
      DelayCommand(5.0, AssignCommand(oSpeaker, UnDisguisePC(oSpeaker)));
      SendMessageToPC(oSpeaker, "You take a few moments to undisguise yourself.");
    }
    else
    {
      int nTimeout = GetLocalInt(oSpeaker, "WATER_TIMEOUT");
	  if (gsTIGetActualTimestamp() > nTimeout)
	  {
        miDVGivePoints(oSpeaker, ELEMENT_WATER, 8.0);
	    SetLocalInt(oSpeaker, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	  }  
	  
      DelayCommand(5.0, AssignCommand(oSpeaker, DisguisePC(oSpeaker, sParams)));
      SendMessageToPC(oSpeaker, "You take a few moments to disguise yourself. Remember, the disguise system should only be used for disguises, not for aliases.");
    }
  }

  chatVerifyCommand(oSpeaker);
}

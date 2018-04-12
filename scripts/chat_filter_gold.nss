#include "inc_chatutils"
#include "inc_examine"

const string HELP = "DM command: Set receiving text in the message panel whenever anyone acquires gold on or off. If a player's gold acquisition is being highlighted through the DM wand, you will still receive gold values acquired by them. The settings are 2 (All areas), 1 (Only in your area), or 0 (Turned off). Example: -filter_gold 2";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;  
  string sParams = chatGetParams(oSpeaker);
  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-filter_gold", HELP);
  }
  else
  {
    if (sParams == "2")
    {
      SetLocalInt(oSpeaker, "MI_FILTERING_GOLD", 2);
      SendMessageToPC(oSpeaker, "You will see gold acquisition in all areas.");
    }
    else if (sParams == "1")
    {
      SetLocalInt(oSpeaker, "MI_FILTERING_GOLD", 1);
      SendMessageToPC(oSpeaker, "You will now only see gold acquisition in your area.");
    }
	else if (sParams == "0")
	{
      DeleteLocalInt(oSpeaker, "MI_FILTERING_GOLD");
      SendMessageToPC(oSpeaker, "You will no longer see gold acquisition data.");		
	}
  }

  chatVerifyCommand(oSpeaker);
}

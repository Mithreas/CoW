#include "fb_inc_chatutils"
#include "inc_examine"

const string HELP = "DM command: Set receiving text in the message panel whenever anyone buys or sells an item from an NPC shop. If a player's shopping is being highlighted through the DM wand, you will still receive purchases and sales from them. The settings are 2 (All areas), 1 (Only in your area), or 0 (Turned off). Example: -filter_shop 2";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;
  string sParams = chatGetParams(oSpeaker); 
  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-filter_shop", HELP);
  }
  else
  {
    if (sParams == "2")
    {
      SetLocalInt(oSpeaker, "MI_FILTERING_SHOP", 2);
      SendMessageToPC(oSpeaker, "You will see purchases and sales in all areas.");
    }
    else if (sParams == "1")
    {
      SetLocalInt(oSpeaker, "MI_FILTERING_SHOP", 1);
      SendMessageToPC(oSpeaker, "You will now only see purchases and sales in your area.");
    }
	else if (sParams == "0")
	{
      DeleteLocalInt(oSpeaker, "MI_FILTERING_SHOP");
      SendMessageToPC(oSpeaker, "You will no longer see purchase and sale data.");		
	}
  }

  chatVerifyCommand(oSpeaker);
}

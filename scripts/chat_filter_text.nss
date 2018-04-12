#include "inc_chatutils"
#include "inc_examine"

const string HELP = "DM command: Toggle receiving text in the message panel whenever anyone speaks in character on or off. If a player's chat is being highlighted through the DM wand, you will still receive messages spoken by them.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-filter_text", HELP);
  }
  else
  {
    int nFiltering = GetLocalInt(oSpeaker, "MI_FILTERING_TEXT");

    if (nFiltering)
    {
      DeleteLocalInt(oSpeaker, "MI_FILTERING_TEXT");
      SendMessageToPC(oSpeaker, "You will now hear speech from all areas.");
    }
    else
    {
      SetLocalInt(oSpeaker, "MI_FILTERING_TEXT", 1);
      SendMessageToPC(oSpeaker, "You will now only hear text from your area.");
    }
  }

  chatVerifyCommand(oSpeaker);
}

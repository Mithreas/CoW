#include "inc_chatutils"
#include "inc_examine"

string HELP = "DM command: Toggle receiving text in message panel from NPCs. Usage: <cþôh>-filter_npc</c>";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-filter_npc", HELP);
  }
  else
  {
    int nFiltering = GetLocalInt(oSpeaker, "SEP_FILTERING_NPC");

    if (nFiltering)
    {
      DeleteLocalInt(oSpeaker, "SEP_FILTERING_NPC");
      SendMessageToPC(oSpeaker, "You will now hear NPC and PC messages.");
    }
    else
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_NPC", 1);
      SendMessageToPC(oSpeaker, "You will now hear PC messages only.");
    }
  }

  chatVerifyCommand(oSpeaker);
}
#include "inc_chatutils"
#include "inc_examine"

string HELP = "DM command: Toggle RPR highlighting. Slightly colourizes text so you can see a character's RPR contextually. " + 
              "You use the command like this: -filter_rpr X. X can be 10, 20, 30, 40. If X is not one of those, (left blank or " +
              "type off, doesn't matter) it will turn the filtering off.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-filter_rpr", HELP);
  }
  else
  {

    if (chatGetParams(oSpeaker) == "0")
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE", 1);
      SetLocalString(oSpeaker, "SEP_FILTERING_RPR", "0");
      SendMessageToPC(oSpeaker, "You'll now see 0 RPR messages only.");
    }
    else if (chatGetParams(oSpeaker) == "10")
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE", 1);
      SetLocalString(oSpeaker, "SEP_FILTERING_RPR", "10");
      SendMessageToPC(oSpeaker, "You'll now see 10 RPR messages only.");
    }
    else if (chatGetParams(oSpeaker) == "20")
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE", 1);
      SetLocalString(oSpeaker, "SEP_FILTERING_RPR", "20");
      SendMessageToPC(oSpeaker, "You'll now see 20 RPR messages only.");
    }
    else if (chatGetParams(oSpeaker) == "30")
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE", 1);
      SetLocalString(oSpeaker, "SEP_FILTERING_RPR", "30");
      SendMessageToPC(oSpeaker, "You'll now see 30 RPR messages only.");
    }
    else if (chatGetParams(oSpeaker) == "40")
    {
      SetLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE", 1);
      SetLocalString(oSpeaker, "SEP_FILTERING_RPR", "40");
      SendMessageToPC(oSpeaker, "You'll now see 40 RPR messages only.");
    }
    else
    {
      DeleteLocalInt(oSpeaker, "SEP_FILTERING_RPR_TOGGLE");
      DeleteLocalInt(oSpeaker, "SEP_FILTERING_RPR");
      SendMessageToPC(oSpeaker, "RPR filtering turned off.");
    }
  }

  chatVerifyCommand(oSpeaker);
}

#include "fb_inc_chatutils"
#include "inc_examine"
#include "gvd_inc_subdual"

const string HELP = "Allows you to fight in subdual mode, instead of killing your opponent you knock them unconcious. Note that there is always a small risk of an accidental kill.";

void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParams = chatGetParams(oSpeaker);

    if (chatGetParams(oSpeaker) == "?")
    {
        DisplayTextInExamineWindow("-subdual", HELP);
    }
    else
    {

      // only allow this when the character wields certain weapons
      gvd_ToggleSubdualMode(oSpeaker);

    }

  chatVerifyCommand(oSpeaker);
}
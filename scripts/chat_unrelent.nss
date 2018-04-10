#include "fb_inc_chatutils"
#include "inc_examine"
#include "gvd_inc_subdual"

const string HELP = "This command will dictate how you react when someone tries to tie you up. If activated, you will forcibly resist, there is a significant chance on dying if you do so though. If not activated, you don't resist but will attempt to break free after being tied up instead.";

void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParams = chatGetParams(oSpeaker);

    if (chatGetParams(oSpeaker) == "?")
    {
        DisplayTextInExamineWindow("-unrelent", HELP);
    }
    else
    {

      gvd_ToggleUnrelentMode(oSpeaker);

    }

  chatVerifyCommand(oSpeaker);
}
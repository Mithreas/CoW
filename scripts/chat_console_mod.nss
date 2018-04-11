#include "fb_inc_chat"
#include "gs_inc_pc"
#include "inc_examine"
#include "x3_inc_string"

void main()
{
    object oSpeaker = OBJECT_SELF;
    string params = chatGetParams(oSpeaker);

    if (params == "" || params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-console_mode") + " " + chatCommandParameter("[Value]"),
            "Used to control the output of untranslated text to the combat console.\n\n" +
            chatCommandParameter("0") + "\nDisables outputting untranslated text to the combat console.\n\n" +
            chatCommandParameter("1") + "\nEnables outputting untranslated text to the combat console.\n\n" +
            chatCommandParameter("2") + "\nLike the above, except does not include common.\n\n" +
            chatCommandParameter("3") + "\nOutputs untranslated text to the main chat window, and translated text to the combat console.\n\n" +
            chatCommandParameter("4") + "\nLike the above, except does not include common.");
    }
    else
    {
        if (params == "0" || params == "1" || params == "2" || params == "3" || params == "4")
        {
            SetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "OUTPUT_TO_CONSOLE", StringToInt(params));
            SendMessageToPC(OBJECT_SELF, "Set console_mode mode to '" + params + "'.");
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid console_mode mode: '" + params + "'. Type -console_mode ? to see the valid options.", STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(oSpeaker);
}
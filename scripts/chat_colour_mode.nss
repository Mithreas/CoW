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
            chatCommandTitle("-colour_mode") + " " + chatCommandParameter("[Value]"),
            "Used to control the colour of outputted language text.\n\n" +
            chatCommandParameter("0") + "\nBoth untranslated and translated text are coloured.\n\n" +
            chatCommandParameter("1") + "\nUntranslated text is not coloured and translated text is coloured.\n\n" +
            chatCommandParameter("2") + "\nUntranslated text is coloured and translated text is not coloured.\n\n" +
            chatCommandParameter("3") + "\nNeither untranslated nor translated text are coloured.");
    }
    else
    {
        if (params == "0" || params == "1" || params == "2" || params == "3")
        {
            SetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "OUTPUT_COLOUR", StringToInt(params));
            SendMessageToPC(OBJECT_SELF, "Set colour_mode mode to '" + params + "'.");
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid colour_mode mode: '" + params + "'. Type -colour_mode ? to see the valid options.", STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(oSpeaker);
}
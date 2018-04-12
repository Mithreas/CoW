#include "inc_chat"
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
            chatCommandTitle("-prefix_mode") + " " + chatCommandParameter("[Value]"),
            "Used to control the rendering of the language prefix.\n\n" +
            chatCommandParameter("0") + "\nRender the language prefix.\n\n" +
            chatCommandParameter("1") + "\nLike the above, except does not include common.\n\n" +
            chatCommandParameter("2") + "\nDoes not render the language prefix.");
    }
    else
    {
        if (params == "0" || params == "1" || params == "2")
        {
            SetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "OUTPUT_PREFIX", StringToInt(params));
            SendMessageToPC(OBJECT_SELF, "Set prefix_mode mode to '" + params + "'.");
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid prefix_mode mode: '" + params + "'. Type -prefix_mode ? to see the valid options.", STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(oSpeaker);
}
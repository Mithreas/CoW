#include "fb_inc_chatutils"
#include "inc_emote_style"
#include "inc_examine"
#include "x3_inc_string"

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?" || params == "")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-emote_style") + " " + chatCommandParameter("[Style]"),
            "Toggle between different emote styles using this chat command.\n\n" +

            chatCommandParameter("0") + " (standard)\n" +
            "Text like [text] is untranslated.\n" +
            "Text like *text*, [[text]], and ::text:: is untranslated and surrounded by the appropriate emote marks.\n" +
            "Otherwise, text is translated.\n" +
            "Example: Hello, [Jimmy]. [[He smiles.]]\n\n" +

            chatCommandParameter("1") + " (novel)\n" +
            "Text like [text] is untranslated.\n" +
            "Text like ''text'' is translated.\n" +
            "Otherwise, text is untranslated.\n" +
            "Example: ''Hello, [Jimmy].'' He smiles."
        );
    }
    else
    {
        int style = StringToInt(params);

        if (style >= EMOTE_STYLE_FIRST && style <= EMOTE_STYLE_LAST)
        {
            SetEmoteStyle(OBJECT_SELF, style);
            SendMessageToPC(OBJECT_SELF, "Set emote style to '" + params + "'.");
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid emote style: '" + params + "'. Type -emote_style ? to see the valid options.", STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}

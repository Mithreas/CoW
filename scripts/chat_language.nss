#include "inc_chat"
#include "inc_language"
#include "inc_examine"
#include "x3_inc_string"

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-language") + " " + chatCommandParameter("[Language]") + " " + chatCommandParameter("[Text]"),
            "Allows you to interact with the language system.\n\n" +

            chatCommandTitle("-language") +
            "\nDisplays your progress towards learning languages.\n\n" +

            chatCommandTitle("-language") + " " + chatCommandParameter("[Language]") +
            "\nSwitches to the provided language for all future chat messages.\n\n" +

            chatCommandTitle("-language") + " " + chatCommandParameter("[Language]") + " " + chatCommandParameter("[Text]") +
            "\nSwitches to the provided language for all future chat messages, then sends a message with the provided text.");
    }
    else
    {
        if (params == "")
        {
            string languageText = "";

            int i = GS_LA_LANGUAGE_FIRST;
            while (i <= GS_LA_LANGUAGE_LAST)
            {
                languageText += gsLAGetLanguageProgressionColour(i,
                    "-" + gsLAGetLanguageKey(i) +
                    " ... " + gsLAGetLanguageName(i) +
                    " [" + gsLAGetLanguageProgressString(i) + "]\n");

                ++i;
            }

            DisplayTextInExamineWindow("Available Languages:", languageText);
        }
        else
        {
            string language = StringParse(params);
            params = StringRemoveParsed(params, language);

            int languageId = gsLAGetLanguageByKey(language);

            if (languageId != GS_LA_LANGUAGE_INVALID)
            {
                fbCHSwitchLanguage(languageId, OBJECT_SELF);
            }

            if (params != "")
            {
                chatSpeakString(OBJECT_SELF, chatGetLastChannel(OBJECT_SELF), params);
            }
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
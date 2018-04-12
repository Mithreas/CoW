#include "inc_chatutils"
#include "inc_emotes"
#include "inc_examine"

void main()
{
    if (chatGetParams(OBJECT_SELF) == "?")
    {
        string available = " Available emotes:\n\n";

        int i = EMOTE_FIRST;
        while (i <= EMOTE_LAST)
        {
            string emote = EmoteIdToString(i);
            if (emote != EMOTE_INVALID_STR)
            {
                available += "- " + chatCommandParameter(emote) + "\n";
            }
            ++i;
        }

        DisplayTextInExamineWindow(
            chatCommandTitle("-emote") + " " + chatCommandParameter("[emote]"),
            "Plays the provided visual " + chatCommandParameter("[emote]") + ". " +
            "Some visual emotes may include voiceset usage."
            + available);
    }
    else
    {
        string emote = chatGetParams(OBJECT_SELF);
        int emoteId = EmoteStringToId(emote);

        if (emoteId != EMOTE_INVALID_ID)
        {
            PerformEmote(emoteId, OBJECT_SELF);
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "No such emote '" + emote + "'!");
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
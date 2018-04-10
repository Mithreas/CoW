#include "fb_inc_chat"
#include "inc_examine"
#include "inc_notifychange"
#include "x3_inc_string"

void main()
{
    string params = GetStringLowerCase(chatGetParams(OBJECT_SELF));

    if (params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-relevel"),
            "Can be used to redeem a character relevel if that character qualifies for one. " +
            "Please note that a DM can be contacted for more fine-grained control over the relevel process if needed.");
    }
    else
    {
        int qualifies = NotifyChangesQualifyForRelevel(OBJECT_SELF);

        if (qualifies)
        {
            NotifyChangesRedeemRelevel(OBJECT_SELF);
        }

        SendMessageToPC(OBJECT_SELF, qualifies ?
            StringToRGBString("You have successfully redeemed a character relevel. " +
                "Do NOT log out at level 1, else you may lose everything in your inventory.",
                STRING_COLOR_GREEN) :
            StringToRGBString("You do not qualify for a character relevel at this time.", STRING_COLOR_RED));
    }

    chatVerifyCommand(OBJECT_SELF);
}

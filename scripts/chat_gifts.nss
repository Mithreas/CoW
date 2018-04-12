//::///////////////////////////////////////////////
//:: Chat: Gifts
//:: chat_gifts
//:://////////////////////////////////////////////
/*
    Lists all gift constant values for the caller.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "inc_chatutils"
#include "inc_examine"
#include "inc_backgrounds"

const string HELP = "This command lists all available gift constant values for use with the -addgift and -setgift commands.";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    int i = GIFT_NONE;
    string sGiftName = GetGiftName(i);

    chatVerifyCommand(OBJECT_SELF);

    if(chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-gifts"), HELP);
        return;
    }

    SendMessageToPC(OBJECT_SELF, "Gift Constant Values:");

    while(sGiftName != GIFT_INVALID_NAME)
    {
        SendMessageToPC(OBJECT_SELF, IntToString(i) + ": " + sGiftName);
        i++;
        sGiftName = GetGiftName(i);
    }
}

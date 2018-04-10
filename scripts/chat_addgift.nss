//::///////////////////////////////////////////////
//:: Chat: Add Gift
//:: chat_addgift
//:://////////////////////////////////////////////
/*
    Allows the calling DM to add a gift to the
    PC of the specified value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "fb_inc_chatutils"
#include "inc_dm"
#include "inc_examine"
#include "mi_inc_backgr"
#include "mi_log"

const string HELP = "Adds a gift for the PC last targeted with DM Tool 1. <cÿ× >[Gift Constant]</c> refers to the constant associated with the gift to be added. Type -gifts for a list of all valid gift constants.";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    if(chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-addgift") + " " + chatCommandParameter("[Gift Constant]"), HELP);
        return;
    }

    object oTarget = GetDMActionTarget();

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    int nParams = StringToInt(chatGetParams(OBJECT_SELF));

    SendMessageToPC(OBJECT_SELF, GetGiftName(nParams) + " has been granted to " + GetName(oTarget) + ".");
    DMLog(OBJECT_SELF, oTarget, "Added Gift: " + IntToString(nParams) + "(" + GetGiftName(nParams) + ")");
    AddGift(oTarget, nParams);
}

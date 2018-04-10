//::///////////////////////////////////////////////
//:: Chat: Get Gifts
//:: chat_getgifts
//:://////////////////////////////////////////////
/*
    Lists all gifts on the targeted PC for the
    calling DM.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "fb_inc_chatutils"
#include "inc_dm"
#include "inc_examine"
#include "mi_inc_backgr"

const string HELP = "Lists all gifts for the PC last targeted with DM Tool 1.";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    if(chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-getgifts"), HELP);
        return;
    }

    int i;
    int nTotalGifts;
    object oTarget = GetDMActionTarget();

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    nTotalGifts = GetTotalGifts(oTarget);

    SendMessageToPC(OBJECT_SELF, GetName(oTarget) + "'s Gifts:");

    for(i = 0; i < nTotalGifts; i++)
    {
        SendMessageToPC(OBJECT_SELF, "Gift " + IntToString(i + 1) + ": " + GetGiftName(GetGift(oTarget, i)));
    }
}

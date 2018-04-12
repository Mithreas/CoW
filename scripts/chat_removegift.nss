//::///////////////////////////////////////////////
//:: Chat: Remove Gift
//:: chat_removegift
//:://////////////////////////////////////////////
/*
    Allows the calling DM to remove a PC's
    gift at the specified index.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "inc_chatutils"
#include "inc_dm"
#include "inc_examine"
#include "inc_backgrounds"

const string HELP = "Removes a gift from the PC last targeted with DM Tool 1. <cÿ× >[Nth Gift]</c> refers to the index of the gift (e.g. 1 would set the value of gift 1).";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    if(chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-removegift") + " " + chatCommandParameter("[Nth Gift]"), HELP);
        return;
    }

    object oTarget = GetDMActionTarget();

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    int nParams = StringToInt(chatGetParams(OBJECT_SELF));

    SendMessageToPC(OBJECT_SELF, "Gift " + IntToString(nParams) + "(" + GetGiftName(GetGift(oTarget, nParams - 1)) + ") has been removed from " + GetName(oTarget) + ".");
    DMLog(OBJECT_SELF, oTarget, "Removed Gift " + IntToString(nParams) + ": " + IntToString(GetGift(oTarget, nParams - 1)) + "(" + GetGiftName(GetGift(oTarget, nParams - 1)) + ")");
    RemoveGift(oTarget, nParams - 1);
}

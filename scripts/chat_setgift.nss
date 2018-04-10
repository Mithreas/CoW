//::///////////////////////////////////////////////
//:: Chat: Set Gift
//:: chat_setgift
//:://////////////////////////////////////////////
/*
    Allows the calling DM to set a PC's gift
    at the specified index to a specified value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "fb_inc_chatutils"
#include "inc_dm"
#include "inc_examine"
#include "inc_string"
#include "mi_inc_backgr"
#include "mi_log"

const string HELP = "Sets a gift for the PC last targeted with DM Tool 1. <cÿ× >[Nth Gift]</c> refers to the index of the gift (e.g. 1 would set the value of gift 1). <cÿ× >[Gift Constant]</c> refers to the constant associated with the gift itself. Type -gifts for a list of all valid gift constants.";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    if(chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-getgifts") + " " + chatCommandParameter("[Nth Gift]") + " " + chatCommandParameter("[Gift Constant]"), HELP);
        return;
    }

    object oTarget = GetDMActionTarget();

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    string sParams = chatGetParams(OBJECT_SELF);
    int nElement = StringToInt(GetDelimitedStringElement(sParams, " ", 0));
    int nGift = StringToInt(GetDelimitedStringElement(sParams, " ", 1));

    SendMessageToPC(OBJECT_SELF, "Gift " + IntToString(nElement) + "(" + GetGiftName(GetGift(oTarget, nElement - 1)) + " ) has been replaced with " + GetGiftName(nGift) + ".");
    DMLog(OBJECT_SELF, oTarget, "Altered Gift " + IntToString(nElement) + ": " + IntToString(GetGift(oTarget, nElement - 1)) + "("
        + GetGiftName(GetGift(oTarget, nElement - 1)) + ")" + " -> " + IntToString(nGift) + "(" + GetGiftName(nGift) + ")");
    SetGift(oTarget, nElement - 1, nGift);
}

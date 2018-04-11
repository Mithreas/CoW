//::///////////////////////////////////////////////
//:: Chat: Set Subrace
//:: chat_setsubrace
//:://////////////////////////////////////////////
/*
    Sets the subrace of the DM's target to
    the specified value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////

#include "fb_inc_chatutils"
#include "inc_dm"
#include "inc_examine"
#include "inc_log"

const string HELP = "Sets the subrace of the PC last targeted with DM Tool 1.";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    object oTarget = GetDMActionTarget();
    string sParams = chatGetParams(OBJECT_SELF);

    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-gifts") + " " + chatCommandParameter("[Subrace]"), HELP);
        return;
    }

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    SendMessageToPC(OBJECT_SELF, GetName(oTarget) + "'s subrace has been set to " + sParams);
    DMLog(OBJECT_SELF, oTarget, "Altered Subrace: " + GetSubRace(oTarget) + " -> " + sParams);
    SetSubRace(oTarget, sParams);
}

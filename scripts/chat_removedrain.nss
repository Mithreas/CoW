#include "gs_inc_pc";
#include "inc_chatutils"
#include "inc_dm"
#include "inc_log"
#include "inc_examine"
#include "gs_inc_respawn"

const string HELP = "Removed the current Death Penalty of the PC last targeted with DM Tool 1";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    object oTarget = GetDMActionTarget();
    string sParams = chatGetParams(OBJECT_SELF);

    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-removedeathpenalty"), HELP);
        return;
    }

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    object oHide = gsPCGetCreatureHide(oTarget);

    string nCurrentServer = GetLocalString(GetModule(), "SERVER_NAME"); //Shameless copy of miXFGetCurrentServer() to avoid circular dependency.
    AssignCommand(oTarget, sepREClearAbilityDrains(oTarget));
    switch(StringToInt(nCurrentServer)) {
      case 1: DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_SURFACE"); break;
      case 2: 
      case 3: DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_CANDP"); break;
      default: break;
    } 
    DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_AMT");
    DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_TIMESTAMP");
    DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_SUBDUAL");
    DeleteLocalInt(oHide, "GS_RESPAWN_DRAIN_HOUR_COUNTER");

    SendMessageToPC(OBJECT_SELF, GetName(oTarget) + "'s death penalty was removed.");
    DMLog(OBJECT_SELF, oTarget, "DEATH PENALTY REMOVED.");
    SendMessageToPC(oTarget, "A DM removed your current death penalty.");

}

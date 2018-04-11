#include "gs_inc_pc";
#include "fb_inc_chatutils"
#include "inc_dm"
#include "inc_log"
#include "inc_examine"

const string HELP = "Sets the PVP Death Counter of the PC last targeted with DM Tool 1 to a new value (0 to 4).";

void main()
{
    if(!GetIsDM(OBJECT_SELF)) return;

    chatVerifyCommand(OBJECT_SELF);

    object oTarget = GetDMActionTarget();
    string sParams = chatGetParams(OBJECT_SELF);

    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-setpvpcounter") + " " + chatCommandParameter("[Value]"), HELP);
        return;
    }

    if(!GetIsObjectValid(oTarget) || !GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You must first select a valid PC with DM Tool 1 in order to use this command.");
        return;
    }

    int iNewPVPCounter = StringToInt(sParams);
    
    if ((iNewPVPCounter >= 0) && (iNewPVPCounter <= 4)) {

      object oHide = gsPCGetCreatureHide(oTarget);
      int iPVPCounter = GetLocalInt(oHide, "SEP_RESPAWN_PVP_DEATH");
      SendMessageToPC(OBJECT_SELF, GetName(oTarget) + "'s PVP counter has been set to " + sParams);
      DMLog(OBJECT_SELF, oTarget, "PVP counter update: " + IntToString(iPVPCounter) + " -> " + sParams);
      SetLocalInt(oHide, "SEP_RESPAWN_PVP_DEATH", iNewPVPCounter);
      SendMessageToPC(oTarget, "A DM changed your PVP counter to " + sParams);

      // in case it is set to zero, also remove the PVP drain active flag
      if (iNewPVPCounter == 0) {
        DeleteLocalInt(oHide, "SEP_RESPAWN_PVP_ACTIVE");
      }

    } else {
      SendMessageToPC(OBJECT_SELF, "Only parameter values 0 to 4 are allowed for this command");
    }
}

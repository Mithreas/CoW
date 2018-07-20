//:://////////////////////////////////////////////////
//:: ent_secretdoor, adapted from X0_O2_SEC_DOOR2
//::    This is an OnEntered script for a generic trigger.
//::    When a PC enters the trigger area, it will perform
//::    a check to determine if the secret item is revealed,
//::    then make it appear if so.
//::
//::    Secret item to be revealed: 
//::      defined by RESREF string var on trigger
//::      defaults to Secret Stone Door
//::    Checking for: SKILL_SEARCH
//::
//:://////////////////////////////////////////////////

#include "x0_i0_secret"


void main()
{
    object oEntered = GetEnteringObject();

    if (GetIsSecretItemRevealed()) {return;}
	string sSecret = GetLocalString(OBJECT_SELF, "RESREF");
	if (sSecret == "") sSecret = "x0_sec_door2";

    if ( DetectSecretItem(oEntered)) {
        if (!GetIsPC(oEntered)) {
            // If a henchman, alert the PC if we make the detect check
            object oMaster = GetMaster(oEntered);
            if (GetIsObjectValid(oMaster)
                && oEntered == GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oMaster))
            {
                AssignCommand(oEntered, PlayVoiceChat(VOICE_CHAT_SEARCH));
            }
        } else {
            // It's a PC, reveal the item
            AssignCommand(oEntered, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
            RevealSecretItem(sSecret);
        }
    }
}
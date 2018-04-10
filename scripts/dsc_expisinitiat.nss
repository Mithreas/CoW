//::///////////////////////////////////////////////
//:: Starting Conditional: Expedition Is Initiator
//:: dsc_expisinitiat
//:://////////////////////////////////////////////
/*
    Returns TRUE if this expedition is valid
    and was initiated by the speaker.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 12, 2016
//:://////////////////////////////////////////////

#include "inc_expedition"

int StartingConditional()
{
    return GetExpeditionTarget(GetExpeditionLeader()) != "" && GetExpeditionInitiator() == GetPCSpeaker();
}

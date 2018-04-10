//::///////////////////////////////////////////////
//:: Starting Conditional: Expedition Valid Ticket
//:: dsc_expvalidtick
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker has a valid
    ticket for this expedition.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2016
//:://////////////////////////////////////////////

#include "inc_expedition"

int StartingConditional()
{
    return GetHasValidExpeditionTicket(GetPCSpeaker());
}

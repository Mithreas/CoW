//::///////////////////////////////////////////////
//:: Starting Conditional: Expedition Underway
//:: dsc_expunderway
//:://////////////////////////////////////////////
/*
    Returns TRUE if there is already an
    expedition underway.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 11, 2016
//:://////////////////////11///////////////////////

#include "inc_expedition"

int StartingConditional()
{
    return GetExpeditionTarget(GetExpeditionLeader()) != "";
}

//::///////////////////////////////////////////////
//:: Starting Conditional: Expedition No Leader
//:: dsc_expnoleader
//:://////////////////////////////////////////////
/*
    Returns TRUE if the expedition leader is
    missing (i.e. invalid or dead).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2016
//:://////////////////////////////////////////////

#include "inc_expedition"

int StartingConditional()
{
    object oExpeditionLeader = GetExpeditionLeader();

    return(!GetIsObjectValid(oExpeditionLeader) || GetIsDead(oExpeditionLeader));
}

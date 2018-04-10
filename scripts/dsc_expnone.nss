//::///////////////////////////////////////////////
//:: Starting Conditional: Expedition None
//:: dsc_expnone
//:://////////////////////////////////////////////
/*
    Returns TRUE if no expedition is currently
    set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2016
//:://////////////////////////////////////////////

#include "inc_expedition"

int StartingConditional()
{
    return (GetExpeditionTarget(OBJECT_SELF) == "");
}

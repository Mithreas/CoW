//::///////////////////////////////////////////////
//:: Starting Condition: Set Stream Default Token
//:: dsc_sumdeftoken
//:://////////////////////////////////////////////
/*
    Sets the token value for the "(Default)"
    selections in the summon stream dialogue.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////

#include "inc_sumstream"

int StartingConditional()
{
    SetStreamDefaultToken();

    return TRUE;
}

//::///////////////////////////////////////////////
//:: Starting Conditional: Set Stream Tokens
//:: dsc_streamtokens
//:://////////////////////////////////////////////
/*
    Sets custom token values for the learn stream
    dialogue.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////

#include "inc_item"
#include "inc_sumstream"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oScroll = GetLastItemUsed(oPC);
    int nStreamType = GetStreamScrollType(oScroll);
    int nStreamElement = GetStreamScrollElement(oScroll);

    SetCustomToken(1000, GetStreamTypeName(nStreamType));
    SetCustomToken(1001, GetStreamElementName(nStreamType, nStreamElement));

    return TRUE;
}

//::///////////////////////////////////////////////
//:: Starting Conditional: Stream Unknown
//:: dsc_streamunknwn
//:://////////////////////////////////////////////
/*
    Returns TRUE if the PC does not know the
    stream associated with the scroll used.
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

    return !GetKnowsSummonStream(oPC, GetStreamScrollType(oScroll), GetStreamScrollElement(oScroll));
}

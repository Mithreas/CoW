//::///////////////////////////////////////////////
//:: Actions Taken: Learn Stream
//:: dat_learnstream
//:://////////////////////////////////////////////
/*
    Teaches the PC the stream from the stream
    scroll used. The scroll is consumed.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////

#include "inc_item"
#include "inc_sumstream"

void main()
{
    object oPC = GetPCSpeaker();
    object oScroll = GetLastItemUsed(oPC);
    int nStreamType = GetStreamScrollType(oScroll);
    int nStreamElement = GetStreamScrollElement(oScroll);

    AddKnownSummonStream(oPC, nStreamType, nStreamElement);
    AssignCommand(oPC, PlaySound("gui_learnspell"));
    DestroyObject(oScroll);
}

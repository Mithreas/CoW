//::///////////////////////////////////////////////
//:: dsc_sumknelair
//:: Starting Conditional:
//::    Stream Known - Elemental Air
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker knows the given
    stream.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 25, 2016
//:://////////////////////////////////////////////

#include "inc_sumstream"

int StartingConditional()
{
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_AIR);
}

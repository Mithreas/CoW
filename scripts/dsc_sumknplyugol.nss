//::///////////////////////////////////////////////
//:: dsc_sumknplyugol
//:: Starting Conditional:
//::    Stream Known - Planar Yugoloth
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
    SetStreamAlignmentToken(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_YUGOLOTH);
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_YUGOLOTH);
}

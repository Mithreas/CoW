//::///////////////////////////////////////////////
//:: dsc_sumknpldevil
//:: Starting Conditional:
//::    Stream Known - Planar Devil
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
    SetStreamAlignmentToken(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_DEVIL);
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_DEVIL);
}

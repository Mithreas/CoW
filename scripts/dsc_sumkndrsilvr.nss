//::///////////////////////////////////////////////
//:: dsc_sumkndrsilvr
//:: Starting Conditional:
//::    Stream Known - Dragon Silver
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
    SetStreamAlignmentToken(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SILVER);
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SILVER);
}

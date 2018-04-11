//::///////////////////////////////////////////////
//:: dsc_sumkndrshad
//:: Starting Conditional:
//::    Stream Known - Dragon Shadow
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker knows the given
    stream.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint, modified by SandySunCloud
//:: Created On: March 14, 2017
//:://////////////////////////////////////////////

#include "inc_sumstream"

int StartingConditional()
{
    SetStreamAlignmentToken(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SHADOW);
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SHADOW);
}

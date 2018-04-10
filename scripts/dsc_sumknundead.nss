//::///////////////////////////////////////////////
//:: dsc_sumknundead
//:: Starting Conditional:
//::    Stream Known - Undead
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
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_ANY);
}

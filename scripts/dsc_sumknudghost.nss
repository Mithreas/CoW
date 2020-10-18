//::///////////////////////////////////////////////
//:: dsc_sumknudghost
//:: Starting Conditional:
//::    Stream Known - Undead Ghost
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker knows the given
    stream.
*/

#include "inc_sumstream"

int StartingConditional()
{
    return GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOST);
}

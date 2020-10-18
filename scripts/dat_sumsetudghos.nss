//::///////////////////////////////////////////////
//:: dat_sumsetudghou
//:: Actions Taken: Set Active Summon Stream
//::    - Undead Ghost
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the speaker
    to the given type.
*/

#include "inc_sumstream"

void main()
{
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOST);
}

//::///////////////////////////////////////////////
//:: dat_sumsettrran
//:: Actions Taken: Set Active Summon Stream
//::    - Tribal Warrior Default
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the speaker
    to the given type.
*/

#include "inc_sumstream"

void main()
{
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_TRIBESMAN, STREAM_TRIBESMAN_RANDOM, TRUE);
}

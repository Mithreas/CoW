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
	AddKnownSummonStream(GetPCSpeaker(), STREAM_TYPE_TRIBESMAN, STREAM_TRIBESMAN_MALE, FALSE);
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_TRIBESMAN, STREAM_TRIBESMAN_MALE, TRUE);
}

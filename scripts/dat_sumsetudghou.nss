//::///////////////////////////////////////////////
//:: dat_sumsetudghou
//:: Actions Taken: Set Active Summon Stream
//::    - Undead Ghoul
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the speaker
    to the given type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 25, 2016
//:://////////////////////////////////////////////

#include "inc_sumstream"

void main()
{
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOUL);
}

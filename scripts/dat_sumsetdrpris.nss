//::///////////////////////////////////////////////
//:: dat_sumsetdrpris
//:: Actions Taken: Set Active Summon Stream
//::    - Dragon Prismatic
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the speaker
    to the given type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 26, 2016
//:://////////////////////////////////////////////

#include "inc_sumstream"

void main()
{
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_DRAGON, STREAM_DRAGON_PRISMATIC);
}

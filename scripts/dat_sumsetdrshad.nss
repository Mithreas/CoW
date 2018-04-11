//::///////////////////////////////////////////////
//:: dat_sumsetdrshad
//:: Actions Taken: Set Active Summon Stream
//::    - Dragon Shadow
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the speaker
    to the given type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint, modified by SandySunCloud
//:: Created On: March, 14, 2017
//:://////////////////////////////////////////////

#include "inc_sumstream"

void main()
{
    SetActiveSummonStream(GetPCSpeaker(), STREAM_TYPE_DRAGON, STREAM_DRAGON_SHADOW);
}

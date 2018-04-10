//::///////////////////////////////////////////////
//:: FileName ck_randomtalkend
//:: Created By: Batrachophrenoboocosmomachia
//:: Created On: 5/21/2016
//::///////////////////////////////////////////////

/*
    Put this in the last dialogue option of conversations
    for NPCs that with random one-liner dialogue options
    to keep them from spamming their dialogue out loud.
*/

int StartingConditional()
{
    if (!GetIsObjectValid(GetPCSpeaker())) return FALSE;
    return TRUE;
}

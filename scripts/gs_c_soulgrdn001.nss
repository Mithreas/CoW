#include "inc_xp"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    SetCustomToken(100, IntToString(gsXPGetDeathPenalty(oSpeaker)));
    return GetIsObjectValid(GetLocalObject(oSpeaker, "GS_CORPSE"));
}

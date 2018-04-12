#include "inc_common"
#include "inc_encounter"
#include "inc_text"

const int GS_SLOT = 4;

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nNth     = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET") + GS_SLOT;
    int bNight = GetLocalInt(GetPCSpeaker(), "NIGHT");

    if (nNth <= GetLocalInt(OBJECT_SELF, "GS_EN_COUNT"))
    {
        nNth = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(nNth));

        SetCustomToken(
            99 + GS_SLOT,
            gsCMReplaceString(
                GS_T_16777442,
                gsENGetCreatureName(nNth, oArea, bNight),
                FloatToString(gsENGetCreatureRating(nNth, oArea, bNight), 0, 1),
                IntToString(gsENGetCreatureChance(nNth, oArea, bNight))));
        return TRUE;
    }

    return FALSE;
}

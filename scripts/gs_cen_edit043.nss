#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_text"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nSlot    = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT");
    int bNight = GetLocalInt(GetPCSpeaker(), "NIGHT");

    SetCustomToken(
        100,
        gsCMReplaceString(
            GS_T_16777442,
            gsENGetCreatureName(nSlot, oArea, bNight),
            FloatToString(gsENGetCreatureRating(nSlot, oArea, bNight), 0, 1),
            IntToString(gsENGetCreatureChance(nSlot, oArea, bNight))));

    return TRUE;
}

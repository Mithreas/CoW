#include "inc_boss"
#include "inc_common"
#include "inc_text"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nSlot    = GetLocalInt(OBJECT_SELF, "GS_BO_SLOT");

    SetCustomToken(
        100,
        gsCMReplaceString(
            GS_T_16777443,
            gsBOGetCreatureName(nSlot, oArea),
            FloatToString(gsBOGetCreatureRating(nSlot, oArea), 0, 1)));

    return TRUE;
}

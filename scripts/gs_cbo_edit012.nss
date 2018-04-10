#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_text"

const int GS_SLOT = 4;

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsBOGetCreatureTemplate(GS_SLOT, oArea) != "")
    {
        SetCustomToken(
            99 + GS_SLOT,
            gsCMReplaceString(
                GS_T_16777443,
                gsBOGetCreatureName(GS_SLOT, oArea),
                FloatToString(gsBOGetCreatureRating(GS_SLOT, oArea), 0, 1)));
        return TRUE;
    }

    return FALSE;
}

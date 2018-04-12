#include "inc_placeable"

const int GS_SLOT = 5;

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nNth     = GetLocalInt(OBJECT_SELF, "GS_PL_OFFSET") + GS_SLOT;

    if (nNth <= GetLocalInt(OBJECT_SELF, "GS_PL_COUNT"))
    {
        nNth = GetLocalInt(OBJECT_SELF, "GS_PL_SLOT_" + IntToString(nNth));

        SetCustomToken(99 + GS_SLOT, gsPLGetPlaceableName(nNth, oArea));
        return TRUE;
    }

    return FALSE;
}

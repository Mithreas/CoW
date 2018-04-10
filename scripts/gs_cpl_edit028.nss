#include "gs_inc_placeable"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nSlot    = GetLocalInt(OBJECT_SELF, "GS_PL_SLOT");

    SetCustomToken(100, gsPLGetPlaceableName(nSlot, oArea));
    return TRUE;
}

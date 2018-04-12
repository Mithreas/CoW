#include "inc_placeable"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nOffset  = 0;
    int nSlot    = 0;
    int nNth     = 1;

    for (; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        if (gsPLGetPlaceableTemplate(nNth, oArea) != "")
            SetLocalInt(OBJECT_SELF, "GS_PL_SLOT_" + IntToString(++nSlot), nNth);
    }

    if (GetLocalObject(OBJECT_SELF, "GS_PL_AREA") != oArea)
    {
        SetLocalObject(OBJECT_SELF, "GS_PL_AREA", oArea);
    }
    else if (nSlot)
    {
        nOffset = GetLocalInt(OBJECT_SELF, "GS_PL_OFFSET");
        while (nOffset >= nSlot) nOffset -= 10;
    }

    SetLocalInt(OBJECT_SELF, "GS_PL_OFFSET", nOffset);
    SetLocalInt(OBJECT_SELF, "GS_PL_COUNT", nSlot);
    SetCustomToken(100, IntToString(nOffset / 10 + 1));
    SetCustomToken(101, IntToString(nSlot ? (nSlot - 1) / 10 + 1 : 1));
    return TRUE;
}

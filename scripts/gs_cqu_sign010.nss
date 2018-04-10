#include "gs_inc_quarter"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nCost       = GetLocalInt(OBJECT_SELF, "GS_COST") / 10;
    int nTimeout    = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

    if (nCost > 0) TakeGoldFromCreature(nCost, oSpeaker, TRUE);

    gsQUSetOwner(OBJECT_SELF, oSpeaker, nTimeout);

    return TRUE;
}

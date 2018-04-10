#include "gs_inc_quarter"

int StartingConditional()
{
    if (gsQUGetIsAvailable(OBJECT_SELF))
    {
        SetCustomToken(100, IntToString(GetLocalInt(OBJECT_SELF, "GS_COST")));

        return TRUE;
    }

    return FALSE;
}

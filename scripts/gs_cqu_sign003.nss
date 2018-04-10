#include "gs_inc_quarter"

int StartingConditional()
{
    if (! gsQUGetIsVacant(OBJECT_SELF))
    {
        SetCustomToken(100, gsQUGetOwnerName(OBJECT_SELF));
        return TRUE;
    }

    return FALSE;
}

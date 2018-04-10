#include "gs_inc_token"

int StartingConditional()
{
    //slot 3

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_3") != -1)
    {
        gsTKRecallToken(102);
        return TRUE;
    }

    return FALSE;
}

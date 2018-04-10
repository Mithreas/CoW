#include "gs_inc_token"

int StartingConditional()
{
    //slot 3

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_3_ID") != -1 &&
        GetLocalInt(OBJECT_SELF, "GS_SLOT_3_STRREF") != -1)
    {
        gsTKRecallToken(102);
        return TRUE;
    }

    return FALSE;
}

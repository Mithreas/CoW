#include "gs_inc_token"

int StartingConditional()
{
    //slot 2

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_2_ID") != -1 &&
        GetLocalInt(OBJECT_SELF, "GS_SLOT_2_STRREF") != -1)
    {
        gsTKRecallToken(101);
        return TRUE;
    }

    return FALSE;
}

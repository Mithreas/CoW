#include "gs_inc_token"

int StartingConditional()
{
    //slot 4

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_4_ID") != -1 &&
        GetLocalInt(OBJECT_SELF, "GS_SLOT_4_STRREF") != -1)
    {
        gsTKRecallToken(103);
        return TRUE;
    }

    return FALSE;
}

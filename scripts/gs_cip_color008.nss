#include "gs_inc_token"

int StartingConditional()
{
    //slot 2

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_2") != -1)
    {
        gsTKRecallToken(101);
        return TRUE;
    }

    return FALSE;
}

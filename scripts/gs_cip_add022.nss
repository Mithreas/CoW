#include "inc_token"

int StartingConditional()
{
    //slot 5

    if (GetLocalInt(OBJECT_SELF, "GS_SLOT_5_STRREF") != -1)
    {
        gsTKRecallToken(104);
        return TRUE;
    }

    return FALSE;
}

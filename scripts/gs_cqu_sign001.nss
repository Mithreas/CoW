#include "inc_quarter"
#include "inc_time"

int StartingConditional()
{
    object pc = GetPCSpeaker();
    if (gsQUGetIsOwner(OBJECT_SELF, pc))
    {
        int nTimeout = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

        gsQUTouchWithNotification(OBJECT_SELF, pc);

        SetCustomToken(100, IntToString(nTimeout / 86400));
        SetCustomToken(101, IntToString(gsTIGetHour(nTimeout)));
        SetCustomToken(102, IntToString(gsTIGetMinute(nTimeout)));

        return TRUE;
    }

    return FALSE;
}

#include "gs_inc_time"

void main()
{
    object oSpeaker = GetPCSpeaker();
    string sString  = ObjectToString(OBJECT_SELF);
    int nTimeout    = gsTIGetActualTimestamp() + gsTIGetTimestamp(0, 0, 0, 3);

    SetLocalInt(oSpeaker, "GS_GUARD_TIMEOUT_" + sString, nTimeout);
}

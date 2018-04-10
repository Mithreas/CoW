#include "gs_inc_time"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sString  = ObjectToString(OBJECT_SELF);
    int nTimestamp  = gsTIGetActualTimestamp();
    int nTimeout    = GetLocalInt(oSpeaker, "GS_GUARD_TIMEOUT_" + sString);

    return nTimeout < nTimestamp;
}

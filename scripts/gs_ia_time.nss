#include "inc_common"
#include "inc_text"
#include "inc_time"

void main()
{
    object oUsedBy = GetLastUsedBy();
    int nTimestamp = gsTIGetActualTimestamp();

    SendMessageToPC(
        oUsedBy,
        gsCMReplaceString(
            GS_T_16777426,
            IntToString(gsTIGetHour(nTimestamp)),
            IntToString(gsTIGetDay(nTimestamp)),
            IntToString(gsTIGetMonth(nTimestamp)),
            IntToString(gsTIGetYear(nTimestamp))));
}

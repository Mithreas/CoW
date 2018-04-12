#include "inc_quarter"
#include "inc_time"
#include "inc_finance"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nCost       = GetLocalInt(OBJECT_SELF, "GS_COST");
    int nTimeout    = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

    if (nCost > 0)
    {
      string sID  = gsQUGetOwnerID(OBJECT_SELF);
      AssignCommand(oSpeaker, gsFITransfer(sID, nCost));
    }

    gsQUSetOwner(OBJECT_SELF, oSpeaker, nTimeout);
    DeleteLocalInt(OBJECT_SELF, "GS_SH_AVAILABLE");

    SetCustomToken(834, IntToString(nTimeout / 86400));
    SetCustomToken(835, IntToString(gsTIGetHour(nTimeout)));
    SetCustomToken(836, IntToString(gsTIGetMinute(nTimeout)));

    return TRUE;
}

#include "gs_inc_message"

int StartingConditional()
{
    object oTarget    = GetLocalObject(OBJECT_SELF, "GS_TARGET");
    string sMessageID = GetStringRight(GetTag(oTarget), 16);
    string sMessage   = gsMEGetMessage(sMessageID, GetPCSpeaker());

    if (sMessage != "")
    {
        SetCustomToken(100, sMessage);
        return TRUE;
    }

    return FALSE;
}

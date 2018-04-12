#include "inc_portal"
#include "inc_token"

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "GS_PO_DESTINATION")) return FALSE;

    object oSpeaker = GetPCSpeaker();
    if (! GetIsPC(oSpeaker))                           return FALSE;
    object oPortal  = OBJECT_INVALID;
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");
    nNth            = gsPOGetFirstActivePortal(nNth, oSpeaker);
    int nSlot       = 1;

    SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "GS_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            oPortal = gsPOGetPortal(nNth);
            gsTKSetToken(99 + nSlot, gsPOGetPortalName(oPortal));
        }

        if (++nSlot > 5) break;

        if (nNth != -1) nNth = gsPOGetNextActivePortal(nNth, oSpeaker);
    }

    SetLocalInt(OBJECT_SELF, "GS_PAGE_END", nNth);

    return TRUE;
}

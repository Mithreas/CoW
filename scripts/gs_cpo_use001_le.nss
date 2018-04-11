#include "gs_inc_portal"
#include "inc_adv_xp"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    if (GetLocalInt(OBJECT_SELF, "GS_PO_SOURCE")) return FALSE;

    return GetIsPC(oSpeaker) &&
           oSpeaker != OBJECT_SELF &&
           ! gsPOGetIsPortalActive(OBJECT_SELF, oSpeaker);
}

#include "inc_portal"
#include "inc_adv_xp"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    // handle exploration xp for portals (
    // do it in here, not in inc_portal's ActivatePortal to ensure all pc's also receive xp for the portals they already found before
    // also not in inc_portal's GetIsPortalActive, since then it would trigger for each portal the moment the list with active portals is constructed
    // we only want them to get it when, they are physically reaching the portal location
    if (GetIsPC(oSpeaker) && !GetIsDM(oSpeaker)) {
      gvd_AdventuringXP_ForObject(oSpeaker, "PORTAL", OBJECT_SELF);
    }

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    if (GetLocalInt(OBJECT_SELF, "GS_PO_SOURCE")) return FALSE;

    return GetIsPC(oSpeaker) &&
           oSpeaker != OBJECT_SELF &&
           ! gsPOGetIsPortalActive(OBJECT_SELF, oSpeaker);
}

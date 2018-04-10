#include "gs_inc_common"
#include "gs_inc_portal"
#include "mi_inc_spells"

void main()
{
    //slot 3

    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_SLOT_3");
    object oPortal  = gsPOGetPortal(nNth);

    //gsPODropAllCorpses(oSpeaker);
    gsCMTeleportToObject(oSpeaker, oPortal, VFX_IMP_AC_BONUS, TRUE);

    // Destroy portal lens
    if (GetLocalInt(oSpeaker, "MI_TELEPORTING"))
    {
      miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_TELEPORT);
      DeleteLocalInt(oSpeaker, "MI_TELEPORTING");
    }
    else if (OBJECT_SELF == oSpeaker)
    {
      gsCMReduceItem(GetItemPossessedBy(oSpeaker, "GS_PO_LENS"));
    }
}

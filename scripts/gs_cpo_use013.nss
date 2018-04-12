#include "inc_common"
#include "inc_portal"
#include "inc_customspells"

void main()
{
    //slot 5

    object oSpeaker = GetPCSpeaker();
    int nNth        = GetLocalInt(OBJECT_SELF, "GS_SLOT_5");
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

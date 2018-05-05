/**
 *  Enhancement to the container system to allow for locked chests.
 *  Chests should be given the usual quarter GS_CLASS and GS_INSTANCE variables
 *  and set to locked.  
 * 
 *  When someone with a valid key uses the chest, it will open normally.
 *  When someone else tries to open it, they will have the option to steal
 *  some money from the owner for breaking in to the quarter.  
 */

#include "inc_quarter"
#include "inc_zdlg"
#include "inc_holders"
#include "inc_factions"

void main()
{
    object oPC = GetLastUsedBy();
    object oQuarter = OBJECT_SELF;
    int nOwner = gsQUGetIsOwner(oQuarter, oPC);

    int nOverrideSubrace = GetLocalInt(oQuarter, "GS_OVERRIDE_SUBRACE");  // Faction locks.

    if (gsQUGetIsPublic(oQuarter) ||
        nOwner ||
        (nOverrideSubrace && nOverrideSubrace == gsSUGetSubRaceByName(GetSubRace(oPC))) ||
        (! nOwner && gsQUGetIsAvailable(oQuarter)) ||
        GetIsDM(oPC) ||
        gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) ||
        md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2"))
    {
      if (nOwner)
      {
        gsQUTouchWithNotification(oQuarter, oPC);
      }

      ActionDoCommand(SetLocked(oQuarter, FALSE));
	  FloatingTextStringOnCreature("Unlocked chest", oPC);
    }
    else
    {
      StartDlg(oPC, oQuarter, "zdlg_locked_chst", TRUE, FALSE);
    }
}

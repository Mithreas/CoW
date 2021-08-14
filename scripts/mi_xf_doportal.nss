// Custom portal script for Jhared's & the gnoll camp
// Checks whether PC has a one-use wardstone for using this portal.  If so,
// destroys the wardstone and grants them passage.
//
// Duergar and gnolls travel for free.
#include "inc_subrace"
void main()
{
  object oPC = GetClickingObject();
  if (!GetIsObjectValid(oPC)) oPC = GetLastUsedBy();

    object oWardstone = GetItemPossessedBy(oPC, "mi_xf_wardstone");

    if (GetIsObjectValid(oWardstone))
    {
      gsCMReduceItem(oWardstone);
      ExecuteScript("mi_xf_do", OBJECT_SELF);
    }
    else
    {
      FloatingTextStringOnCreature("The portal refuses you passage.", oPC);
    }
}

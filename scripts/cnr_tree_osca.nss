/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_tree_osca
//
//  Desc:  OnSpellCastAt event handler for minable
//         trees. Minable trees are immune to spell attacks.
//
//  Author: David Bobeck 30Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_language_inc"
void main()
{
  object oPC = GetLastSpellCaster();
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    SetPlotFlag(OBJECT_SELF, TRUE);
    FloatingTextStringOnCreature(CNR_TEXT_MINABLE_TREES_ARE_RESISTANT, oPC, FALSE);

    // clear the plot flag so the next attacker won't get "weapon not effective"
    DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
  }
}

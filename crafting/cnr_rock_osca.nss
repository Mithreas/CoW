/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_rock_osca
//
//  Desc:  OnSpellCastAt event handler for minable
//         rocks. Minable rocks are immune to spell attacks.
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
    FloatingTextStringOnCreature(CNR_TEXT_MINABLE_ROCKS_ARE_RESISTANT, oPC, FALSE);

    // clear the plot flag so the next attacker won't get "weapon not effective"
    DelayCommand(1.0, SetPlotFlag(OBJECT_SELF, FALSE));
  }
}

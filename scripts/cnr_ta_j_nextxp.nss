/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_nextxp
//
//  Desc:  Should the "Next" menu item be shown.
//
//  Author: David Bobeck 24May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if (!GetIsDM(oPC)) return FALSE;
  int nMenuPage = GetLocalInt(oPC, "nCnrXpMenuPage");
  if (nMenuPage >= 2) return FALSE;
  return TRUE;
}

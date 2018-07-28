/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_next
//
//  Desc:  Should the "Next" menu item be shown.
//
//  Author: David Bobeck 19Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  int nLast = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + CNR_SELECTIONS_PER_PAGE;
  if (nLast >= CnrGetTradeskillCount()) return FALSE;
  return TRUE;
}

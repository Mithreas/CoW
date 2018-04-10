/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_r_top
//
//  Desc:  Init's the recipe's top menu page
//
//  Author: David Bobeck 23Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  CnrRecipeShowMenu(sKeyToMenu, nMenuPage);
  string sTokenText = GetLocalString(oPC, "sCnrTokenText22000");
  SetCustomToken(22000, sTokenText);
  DeleteLocalString(oPC, "sCnrTokenText22000");
  return TRUE;
}

/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_b_top
//
//  Desc:  Init's the recipe book's top menu page
//
//  Author: David Bobeck 08Jan03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  CnrRecipeBookShowMenu(sKeyToMenu, nMenuPage);
  string sTokenText = GetLocalString(oPC, "sCnrTokenText22000");
  SetCustomToken(22000, sTokenText);
  DeleteLocalString(oPC, "sCnrTokenText22000");
  return TRUE;
}

/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_r_next
//
//  Desc:  Should the "Next" menu item be shown.
//
//  Author: David Bobeck 08Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oModule = GetModule();
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToCount = sKeyToMenu + "_SubMenuCount";
  int nSubCount = GetLocalInt(oPC, sKeyToCount);
  if (nSubCount == 0)
  {
    // this menu must be showing recipes
    sKeyToCount = sKeyToMenu + "_RecipeCount";
    nSubCount = GetLocalInt(oPC, sKeyToCount);
  }

  int bShowNext = TRUE;
  int nLast = (nMenuPage * CNR_SELECTIONS_PER_PAGE) + CNR_SELECTIONS_PER_PAGE;
  if (nLast >= nSubCount)
  {
    bShowNext = FALSE;
  }
  return bShowNext;
}

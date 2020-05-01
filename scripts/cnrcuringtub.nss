/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrCuringTub
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 05Aug03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrcuringtub init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrCuringTub"
  /////////////////////////////////////////////////////////
  string sMenuHidesSmall = CnrRecipeAddSubMenu("cnrcuringtub", "Small Hides");
  string sMenuHidesMedium = CnrRecipeAddSubMenu("cnrcuringtub", "Medium Hides");
  string sMenuHidesLarge = CnrRecipeAddSubMenu("cnrcuringtub", "Large Hides");

  CnrRecipeSetDevicePreCraftingScript("cnrcuringtub", "cnr_curing_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrCuringTub", "cnr");
  //CnrRecipeSetDeviceEquippedTool("cnrCuringTub", "cnr");
  CnrRecipeSetDeviceTradeskillType("cnrcuringtub", CNR_TRADESKILL_TAILORING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_TAILORING), 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesSmall, "Cured Badger Hide", "cnrhidecurebadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinbadger", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesLarge, "Cured Deer Hide", "cnrhidecuredeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindeer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesMedium, "Cured Wolf Hide", "cnrhidecurewolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinwolf", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesLarge, "Cured Worg Hide", "cnrhidecureworg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinworg", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesLarge, "Cured Grizzly Hide", "cnrhidecuregriz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskingrizbear", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHidesLarge, "Cured Dire Bear Hide", "cnrhidecuredb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnracidtanning", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindb", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

}

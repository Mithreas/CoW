/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTinkerFurnace
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 19May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrtinkerfurnace init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrTinkerFurnace
  /////////////////////////////////////////////////////////
  string sMenuTinkerGlass = CnrRecipeAddSubMenu("cnrtinkerfurnace", "Glass");

  CnrRecipeSetDevicePreCraftingScript("cnrtinkerfurnace", "cnr_forge_anim");
  CnrRecipeSetDeviceTradeskillType("cnrtinkerfurnace", CNR_TRADESKILL_TINKERING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerGlass, "Ingot of Glass", "cnringotglass", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbagofsand", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerGlass, "Five Empty Flasks", "cnremptyflask", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotglass", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 50, 0, 50, 0, 0);

}

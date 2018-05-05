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
  string sMenuTinkerGlass = CnrRecipeAddSubMenu("cnrtinkerfurnace", "Glass and Charcoal");

  CnrRecipeSetDevicePreCraftingScript("cnrtinkerfurnace", "cnr_forge_anim");
  CnrRecipeSetDeviceTradeskillType("cnrtinkerfurnace", CNR_TRADESKILL_EXPLOSIVES);
  CnrRecipeSetRecipeAbilityPercentages("cnrtinkerfurnace", 0, 0, 50, 50, 0, 0); // Con and Int

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerGlass, "Ingot of Glass", "cnringotglass", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbagofsand", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerGlass, "Five Empty Flasks", "cnremptyflask", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotglass", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTinkerGlass, "Charcoal", "charcoal", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
}

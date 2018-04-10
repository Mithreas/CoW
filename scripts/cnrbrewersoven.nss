/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBrewersOven
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15Jun03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrBrewersOven init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrBrewersOven
  /////////////////////////////////////////////////////////
  CnrRecipeSetDeviceTradeskillType("cnrBrewersOven", CNR_TRADESKILL_FOOD_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Barley", "cnrBarleyRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Corn", "cnrCornRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Oats", "cnrOatsRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Rice", "cnrRiceRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Rye", "cnrRyeRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersOven", "Roasted Wheat", "cnrWheatRoasted", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatRaw", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);
}

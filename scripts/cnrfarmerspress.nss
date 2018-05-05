/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrFarmersPress
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

  PrintString("cnrFarmersPress init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrFarmersPress
  /////////////////////////////////////////////////////////
  CnrRecipeSetDeviceTradeskillType("cnrFarmersPress", CNR_TRADESKILL_COOKING);

  string sMenuPressOils = CnrRecipeAddSubMenu("cnrFarmersPress", "Oils");
  string sMenuPressJuices = CnrRecipeAddSubMenu("cnrFarmersPress", "Juices");
  string sMenuPressMiscItems = CnrRecipeAddSubMenu("cnrFarmersPress", "Misc Items");

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Corn Oil", "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornMeal", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Rice Oil", "cnrRiceOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceMeal", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Almond Oil", "cnrAlmondOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAlmondFruit", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Chestnut Oil", "cnrChestnutOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChestnutFruit", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Hazelnut Oil", "cnrHazelnutOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHazelnutFruit", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Pecan Oil", "cnrPecanOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPecanFruit", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressOils, "Walnut Oil", "cnrWalnutOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWalnutFruit", 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Apple Juice", "cnrAppleJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAppleFruit", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Blackberry Juice", "cnrBlkberryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBlkberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Blueberry Juice", "cnrBluberryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBluberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Cherry Juice", "cnrCherryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCherryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Cranberry Juice", "cnrCrnberryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCrnberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Elderberry Juice", "cnrEldberryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEldberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Grape Juice", "cnrGrapeJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrapeFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Juniper Berry Juice", "cnrJuniperJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrJuniperFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Pear Juice", "cnrPearJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPearFruit", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressJuices, "Raspberry Juice", "cnrRspberryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRspberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEmptyJuice", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPressMiscItems, "Raw Parchment", "cnrRawParchment", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagOfSawDust", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);
}

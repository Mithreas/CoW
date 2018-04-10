/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBakersOven
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

  PrintString("cnrBakersOven init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrBakersOven
  /////////////////////////////////////////////////////////
  CnrRecipeSetDeviceTradeskillType("cnrBakersOven", CNR_TRADESKILL_FOOD_CRAFTING);

  string sMenuBakeBreads = CnrRecipeAddSubMenu("cnrBakersOven", "Breads");
  string sMenuBakePies = CnrRecipeAddSubMenu("cnrBakersOven", "Pies");
  string sMenuBakeMiscItems = CnrRecipeAddSubMenu("cnrBakersOven", "Misc Items");

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeBreads, "Rye Bread", "cnrRyeBread", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBakers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeBreads, "Wheat Bread", "cnrWheatBread", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBakers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeBreads, "Rice Bread", "cnrRiceBread", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBakers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeBreads, "Oat Bread", "cnrOatBread", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBakers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeBreads, "Corn Bread", "cnrCornBread", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBakers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMilk", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEggChicken", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakePies, "Apple Pie", "cnrApplePie", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAppleFruit", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakePies, "Cherry Pie", "cnrCherryPie", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCherryFruit", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakePies, "Blackberry Pie", "cnrBlkberryPie", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBlkberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakePies, "Blueberry Pie", "cnrBluberryPie", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBluberryFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakePies, "Pecan Pie", "cnrPecanPie", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornOil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPecanFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBakeMiscItems, "Blank Scroll", "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRawParchment", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);
}

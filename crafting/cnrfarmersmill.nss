/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrFarmersMill
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrFarmersMill init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrFarmersMill
  /////////////////////////////////////////////////////////
  CnrRecipeSetDeviceTradeskillType("cnrFarmersMill", CNR_TRADESKILL_COOKING);

  string sMenuMillMeals = CnrRecipeAddSubMenu("cnrFarmersMill", "Meals");
  string sMenuMillFlours = CnrRecipeAddSubMenu("cnrFarmersMill", "Flours");
  string sMenuMillMalts = CnrRecipeAddSubMenu("cnrFarmersMill", "Malts");

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Barley Meal", "cnrBarleyMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyRaw", 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Corn Meal", "cnrCornMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornRaw", 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Oat Meal", "cnrOatsMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsRaw", 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Rice Meal", "cnrRiceMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceRaw", 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Rye Meal", "cnrRyeMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeRaw", 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMeals, "Wheat Meal", "cnrWheatMeal", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatRaw", 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Barley Flour", "cnrBarleyFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyRaw", 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Corn Flour", "cnrCornFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornRaw", 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Oat Flour", "cnrOatsFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsRaw", 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Rice Flour", "cnrRiceFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceRaw", 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Rye Flour", "cnrRyeFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeRaw", 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillFlours, "Wheat Flour", "cnrWheatFlour", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatRaw", 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Barley", "cnrBarleyMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Corn", "cnrCornMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Oats", "cnrOatsMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Rice", "cnrRiceMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Rye", "cnrRyeMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMillMalts, "Malted Wheat", "cnrWheatMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatRoasted", 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 5, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

}

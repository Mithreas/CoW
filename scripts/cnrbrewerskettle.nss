/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBrewersKettle
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

// Placeholder thoughts
// Beer, spirits - alcohol - reduce rest  (barley)
// Wine - alcohol - reduce rest (grapes)
// Coffee - increase rest (coffee beans)
// Food/drink - temp HP & fort save - only if don't have temp HP
// Food - lesser restoration
// Food - animal charm?
// Salve - very minor healing

void main()
{
  string sKeyToRecipe;

  PrintString("cnrBrewersKettle init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrBrewersKettle
  /////////////////////////////////////////////////////////
  CnrRecipeSetDeviceTradeskillType("cnrBrewersKettle", CNR_TRADESKILL_COOKING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Barley Wort", "cnrBarleyWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Corn Wort", "cnrCornWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Oat Wort", "cnrOatsWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Rice Wort", "cnrRiceWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Rye Wort", "cnrRyeWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKettle", "Wheat Wort", "cnrWheatWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatMalt", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSugar", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 15, 15);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

}

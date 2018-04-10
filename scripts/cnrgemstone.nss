/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrGemStone
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

  PrintString("cnrGemStone init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrGemStone
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrGemStone", "cnr_gemcut_anim");
  CnrRecipeSetDeviceInventoryTool("cnrGemStone", "cnrGemTools", CNR_FLOAT_GEM_CRAFTERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceEquippedTool("cnrGemStone", "cnrGemChisel", CNR_FLOAT_GEM_MINING_CHISEL_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrGemStone", CNR_TRADESKILL_GEM_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Greenstone", "cnrGemCut001", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral001", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust001", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Malachite", "cnrGemCut007", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral007", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust007", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Fire Agate", "cnrGemCut002", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral002", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust002", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Aventurine", "cnrGemCut014", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral014", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust014", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Phenalope", "cnrGemCut004", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral004", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust004", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Amethyst", "cnrGemCut003", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral003", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust003", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Feldspar", "cnrGemCut015", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral015", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust015", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Garnet", "cnrGemCut011", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral011", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust011", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Alexandrite", "cnrGemCut013", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral013", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust013", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Topaz", "cnrGemCut010", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral010", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust010", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Sapphire", "cnrGemCut008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral008", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust008", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Fire Opal", "cnrGemCut009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral009", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust009", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Diamond", "cnrGemCut005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral005", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust005", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Ruby", "cnrGemCut006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral006", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust006", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemStone", "Cut Emerald", "cnrGemCut012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemMineral012", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemDust012", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

}

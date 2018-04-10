/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrGemTable
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

  PrintString("cnrGemTable init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrGemTable
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrGemTable", "cnr_gempol_anim");
  CnrRecipeSetDeviceInventoryTool("cnrGemTable", "cnrGemTools", CNR_FLOAT_GEM_CRAFTERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrGemTable", CNR_TRADESKILL_GEM_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Greenstone", "cnrGemFine001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed001", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Malachite", "cnrGemFine007", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut007", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed007", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Fire Agate", "cnrGemFine002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed002", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Aventurine", "cnrGemFine014", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut014", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed014", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Phenalope", "cnrGemFine004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed004", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Amethyst", "cnrGemFine003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed003", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Feldspar", "cnrGemFine015", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut015", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed015", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Garnet", "cnrGemFine011", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut011", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed011", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Alexandrite", "cnrGemFine013", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut013", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed013", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Topaz", "cnrGemFine010", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut010", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed010", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Sapphire", "cnrGemFine008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed008", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Fire Opal", "cnrGemFine009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed009", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Diamond", "cnrGemFine005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed005", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Ruby", "cnrGemFine006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed006", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrGemTable", "Fine Emerald", "cnrGemFine012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemCut012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilPolishing", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed012", 0, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

}

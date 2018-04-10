/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrForgePublic
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrforgepublic init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrForgePublic
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrforgepublic", "cnr_forge_anim");
  CnrRecipeSetDeviceTradeskillType("cnrforgepublic", CNR_TRADESKILL_SMELTING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Ondaran Ingot(s)", "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Elfur Ingot(s)", "cnringotelf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Lirium Ingot(s)", "cnringotlir", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Demon's Bane Ingot(s)", "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetdem", 2, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Iolum Ingot(s)", "cnringotiol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetiol", 2, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Adanium Ingot(s)", "cnringotada", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetada", 3, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Stallix Ingot(s)", "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetsta", 3, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

}

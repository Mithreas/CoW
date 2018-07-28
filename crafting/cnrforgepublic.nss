/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrForgePublic
//
//  Desc:  Recipe initialization.
//
//  Note: Public forge recipes have no skill requirements.
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
  CnrRecipeSetRecipeAbilityPercentages("cnrforgepublic", 50, 0, 50, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Ondaran Ingot(s)", "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Iron Ingot(s)", "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Silver Ingot(s)", "cnringotsil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Gold Ingot(s)", "cnringotgol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetgol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Demon's Bane Ingot(s)", "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetdem", 2, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Iolum Ingot(s)", "cnringotiol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetiol", 2, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Adanium Ingot(s)", "cnringotada", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetada", 3, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrforgepublic", "Stallix Ingot(s)", "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnuggetsta", 3, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);

}

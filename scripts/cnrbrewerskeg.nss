/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrBrewersKeg
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

  PrintString("cnrBrewersKeg init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrBrewersKeg
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrBrewersKeg", "cnr_brewkeg_anim");
  CnrRecipeSetDeviceTradeskillType("cnrBrewersKeg", CNR_TRADESKILL_COOKING);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Iron Hammer Bock", "cnrbIronHammer", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHazelnutFruit", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Pigs Ear Pilsener", "cnrbPigsEar", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatsWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Will-o-Whiskey", "cnrbWilloWhiskey", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Silver Buckle Gin", "cnrbSilverBuckle", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Dwarf's Head Ale", "cnrbDwarfsHead", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChestnutFruit", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Black Knight Malt", "cnrbBlackKnight", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBlkberryFruit", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Blue Sword Swill", "cnrbBlueSword", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBluberryFruit", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Cherry River Lambic", "cnrbCherryRiver", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCherryJuice", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Jumpin' Juniper Brau", "cnrbJumpinJuniper", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrJuniperFruit", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Broken Knuckle Beer", "cnrbBrokenKnuckle", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // skeleton's knuckle
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 35, 35);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Wizard's Wheat Ale", "cnrbWizardsWheat", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatWort", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHopsFlower", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MPOTION001", 1);  // potion cure light
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 35, 35);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe("cnrBrewersKeg", "Wine", "NW_IT_MPOTION023", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGrapeFruit", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrYeastBrewers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBrewingBottle", 4, 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBucketWater", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrBucketEmpty", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 25, 25);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 40, 0, 60, 0);

}

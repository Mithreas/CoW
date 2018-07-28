/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrScribeInkDesk
//
//  Desc:  Recipe initialization.
//
//  Author: Gary Corcoran 28May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrScribeInkDesk init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribingLab
  /////////////////////////////////////////////////////////
  string sMenuLesserInks = CnrRecipeAddSubMenu("cnrScribeInkDesk", "Lesser Scribing Inks");
  string sMenuAverageInks = CnrRecipeAddSubMenu("cnrScribeInkDesk", "Average Scribing Inks");
  string sMenuGreaterInks = CnrRecipeAddSubMenu("cnrScribeInkDesk", "Greater Scribing Inks");

  CnrRecipeSetDevicePreCraftingScript("cnrScribeInkDesk", "cnr_scribe_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrScribeInkDesk", "");
  CnrRecipeSetDeviceTradeskillType("cnrScribeInkDesk", CNR_TRADESKILL_INVESTING);

  //Lesser Inks (Used for Level 1 through Level 5 Scrolls)

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Abjuration", "cnrInkLAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkullcapLeaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Conjuration", "cnrInkLConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMushroomSpot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Divination", "cnrInkLDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Enchantment", "cnrInkLEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHazelLeaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Evocation", "cnrInkLEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAloeLeaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Illusion", "cnrInkLIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Necromancy", "cnrInkLNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGraveyardDirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLesserInks, "Ink of Lesser Transmutation", "cnrInkLTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGarlicClove", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  //Regular Inks (Used for Level 6 through Level 10 Scrolls)

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Abjuration", "cnrInkAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkullcapLeaf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Conjuration", "cnrInkConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMushroomSpot", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Divination", "cnrInkDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Enchantment", "cnrInkEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHazelLeaf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Evocation", "cnrInkEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAloeLeaf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Illusion", "cnrInkIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Necromancy", "cnrInkNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGraveyardDirt", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAverageInks, "Ink of Transmutation", "cnrInkTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGarlicClove", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  //Greater Inks (Used for Level 11 through Level 15 Scrolls)

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Abjuration", "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkullcapLeaf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Conjuration", "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMushroomSpot", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Divination", "cnrInkGDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHolyWater", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Enchantment", "cnrInkGEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHazelLeaf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Evocation", "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrAloeLeaf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Illusion", "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSpiderSilk", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Necromancy", "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGraveyardDirt", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGreaterInks, "Ink of Greater Transmutation", "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChickenEgg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHoney", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGarlicClove", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

}

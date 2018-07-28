/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrEnchantAltar
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

  PrintString("cnrEnchantAltar init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrEnchantAltar
  /////////////////////////////////////////////////////////
  string sMenuAltarBags = CnrRecipeAddSubMenu("cnrEnchantAltar", "Elemental Bags");
  string sMenuAltarGems = CnrRecipeAddSubMenu("cnrEnchantAltar", "Enchanted Gems");
  string sMenuAltarIngots = CnrRecipeAddSubMenu("cnrEnchantAltar", "Enchanted Ingots");
  //string sMenuAltarRods = CnrRecipeAddSubMenu("cnrEnchantAltar", "Elemental Rods");
  //string sMenuAltarStaves = CnrRecipeAddSubMenu("cnrEnchantAltar", "Elemental Staves");

  CnrRecipeSetDevicePreCraftingScript("cnrEnchantAltar", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrEnchantAltar", "cnrXXX");
  CnrRecipeSetDeviceTradeskillType("cnrEnchantAltar", CNR_TRADESKILL_ENCHANTING);

  //------------------------ elemental bags -------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Sparks", "cnrBagSparks", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust002", 1); // fire agate
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBarleyFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Acid", "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1); // sapphire dust
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRyeFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Fire", "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust009", 1); // fire opal dust
  CnrRecipeAddComponent(sKeyToRecipe, "cnrCornFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Lightning", "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust010", 1); // topaz dust
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRiceFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Frost", "cnrBagFrost", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust010", 1); // diamond dust
  CnrRecipeAddComponent(sKeyToRecipe, "cnrWheatFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Thunder", "cnrBagThunder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1); // ruby dust
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOatFlour", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarBags, "Bag of Poison", "cnrBagPoison", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLeatherPouch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1); // emerald dust
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC23", 1);  //Belladona
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);


  //------------------------ enchanted gems -------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Greenstone", "cnrGemEnchant001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine001", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed001", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Malachite", "cnrGemEnchant007", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine007", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed007", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Fire Agate", "cnrGemEnchant002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine002", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed002", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Aventurine", "cnrGemEnchant014", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine014", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed014", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Phenalope", "cnrGemEnchant004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine004", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed004", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Amethyst", "cnrGemEnchant003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine003", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed003", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Feldspar", "cnrGemEnchant015", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine015", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed015", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Garnet", "cnrGemEnchant011", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine011", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed011", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Alexandrite", "cnrGemEnchant013", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine013", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed013", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Topaz", "cnrGemEnchant010", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine010", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed010", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Sapphire", "cnrGemEnchant008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine008", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed008", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Fire Opal", "cnrGemEnchant009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine009", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed009", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Diamond", "cnrGemEnchant005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine005", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed005", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Ruby", "cnrGemEnchant006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine006", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed006", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarGems, "Enchanted Emerald", "cnrGemEnchant012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemFine012", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGemFlawed012", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  //------------------------ enchanted ingots -------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Copper Ingot", "cnrEnchIngotCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Bronze Ingot", "cnrEnchIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Gold Ingot", "cnrEnchIngotGold", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotGold", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Platinum Ingot", "cnrEnchIngotPlat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Silver Ingot", "cnrEnchIngotSilv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotSilv", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarIngots, "Enchanted Titanium Ingot", "cnrEnchIngotTita", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotTita", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  /*
  //------------------------ elemental rods -------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarRods, "Rod of Lightning", "cnrRodLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRodCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarRods, "Rod of Acid", "cnrRodAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRodCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarRods, "Rod of Fire", "cnrRodFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRodCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarRods, "Rod of Frost", "cnrRodFrost", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRodCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFrost", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarRods, "Rod of Thunder", "cnrRodThunder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrRodCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagThunder", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  //------------------------ elemental staves -------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarStaves, "Staff of Lightning", "cnrStaffLightng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrStaffCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarStaves, "Staff of Acid", "cnrStaffAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrStaffCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarStaves, "Staff of Fire", "cnrStaffFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrStaffCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarStaves, "Staff of Frost", "cnrStaffFrost", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrStaffCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFrost", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAltarStaves, "Staff of Thunder", "cnrStaffThunder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrStaffCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagThunder", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);
  */

}

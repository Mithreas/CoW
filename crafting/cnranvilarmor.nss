/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrAnvilArmor
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

  PrintString("cnrAnvilArmor init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilArmor
  /////////////////////////////////////////////////////////
  string sMenuShields = CnrRecipeAddSubMenu("cnrAnvilArmor", "Shields");
  string sMenuHelms = CnrRecipeAddSubMenu("cnrAnvilArmor", "Helms");
  string sMenuArmor = CnrRecipeAddSubMenu("cnrAnvilArmor", "Armor");

  string sMenuShieldCopp = CnrRecipeAddSubMenu(sMenuShields, "Copper Shields");
  string sMenuShieldBron = CnrRecipeAddSubMenu(sMenuShields, "Bronze Shields");
  string sMenuShieldIron = CnrRecipeAddSubMenu(sMenuShields, "Iron Shields");

  string sMenuHelmsBron = CnrRecipeAddSubMenu(sMenuHelms, "Bronze Helms");
  string sMenuHelmsIron = CnrRecipeAddSubMenu(sMenuHelms, "Iron Helms");
  string sMenuHelmsPlat = CnrRecipeAddSubMenu(sMenuHelms, "Platinum Helms");
  string sMenuHelmsAdam = CnrRecipeAddSubMenu(sMenuHelms, "Adamantium Helms");
  string sMenuHelmsCoba = CnrRecipeAddSubMenu(sMenuHelms, "Cobalt Helms");
  string sMenuHelmsMith = CnrRecipeAddSubMenu(sMenuHelms, "Mithril Helms");

  string sMenuArmorBron = CnrRecipeAddSubMenu(sMenuArmor, "Bronze Armor");
  string sMenuArmorIron = CnrRecipeAddSubMenu(sMenuArmor, "Iron Armor");
  string sMenuArmorPlat = CnrRecipeAddSubMenu(sMenuArmor, "Platinum Armor");
  string sMenuArmorAdam = CnrRecipeAddSubMenu(sMenuArmor, "Adamantium Armor");
  string sMenuArmorCoba = CnrRecipeAddSubMenu(sMenuArmor, "Cobalt Armor");
  string sMenuArmorMith = CnrRecipeAddSubMenu(sMenuArmor, "Mithril Armor");
  string sMenuArmorAdor = CnrRecipeAddSubMenu(sMenuArmor, "Adorned Armor");

  string sMenuBronLight = CnrRecipeAddSubMenu(sMenuArmorBron, "Light Bronze");
  string sMenuBronMedium = CnrRecipeAddSubMenu(sMenuArmorBron, "Medium Bronze");
  string sMenuBronHeavy = CnrRecipeAddSubMenu(sMenuArmorBron, "Heavy Bronze");

  string sMenuIronLight = CnrRecipeAddSubMenu(sMenuArmorIron, "Light Iron");
  string sMenuIronMedium = CnrRecipeAddSubMenu(sMenuArmorIron, "Medium Iron");
  string sMenuIronHeavy = CnrRecipeAddSubMenu(sMenuArmorIron, "Heavy Iron");

  string sMenuPlatLight = CnrRecipeAddSubMenu(sMenuArmorPlat, "Light Platinum");
  string sMenuPlatMedium = CnrRecipeAddSubMenu(sMenuArmorPlat, "Medium Platinum");
  string sMenuPlatHeavy = CnrRecipeAddSubMenu(sMenuArmorPlat, "Heavy Platinum");

  string sMenuAdamLight = CnrRecipeAddSubMenu(sMenuArmorAdam, "Light Adamantium");
  string sMenuAdamMedium = CnrRecipeAddSubMenu(sMenuArmorAdam, "Medium Adamantium");
  string sMenuAdamHeavy = CnrRecipeAddSubMenu(sMenuArmorAdam, "Heavy Adamantium");

  string sMenuCobaLight = CnrRecipeAddSubMenu(sMenuArmorCoba, "Light Cobalt");
  string sMenuCobaMedium = CnrRecipeAddSubMenu(sMenuArmorCoba, "Medium Cobalt");
  string sMenuCobaHeavy = CnrRecipeAddSubMenu(sMenuArmorCoba, "Heavy Cobalt");

  string sMenuMithLight = CnrRecipeAddSubMenu(sMenuArmorMith, "Light Mithril");
  string sMenuMithMedium = CnrRecipeAddSubMenu(sMenuArmorMith, "Medium Mithril");
  string sMenuMithHeavy = CnrRecipeAddSubMenu(sMenuArmorMith, "Heavy Mithril");

  string sMenuAdorLight = CnrRecipeAddSubMenu(sMenuArmorAdor, "Light Adorned");
  string sMenuAdorMedium = CnrRecipeAddSubMenu(sMenuArmorAdor, "Medium Adorned");
  string sMenuAdorHeavy = CnrRecipeAddSubMenu(sMenuArmorAdor, "Heavy Adorned");

  CnrRecipeSetDevicePreCraftingScript("cnrAnvilArmor", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnrAnvilArmor", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrAnvilArmor", CNR_TRADESKILL_ARMOR_CRAFTING);

  //----------------- copper shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Small Copper Shield", "cnrShldSmalCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Copper Buckler", "cnrShldBuckCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Copper Star Shield", "cnrShldStarCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Large Copper Shield", "cnrShldLargCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Copper Heater Shield", "cnrShldHeatCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Copper Kite Shield", "cnrShldKiteCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldCopp, "Copper Tower Shield", "cnrShldTowrCopp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 7);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- bronze shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Small Bronze Shield", "cnrShldSmalBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Bronze Buckler", "cnrShldBuckBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Bronze Star Shield", "cnrShldStarBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Large Bronze Shield", "cnrShldLargBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Bronze Heater Shield", "cnrShldHeatBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Bronze Kite Shield", "cnrShldKiteBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldBron, "Bronze Tower Shield", "cnrShldTowrBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 7);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- iron shields -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Small Iron Shield", "cnrShldSmalIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Iron Buckler", "cnrShldBuckIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Iron Star Shield", "cnrShldStarIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Large Iron Shield", "cnrShldLargIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Iron Heater Shield", "cnrShldHeatIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Iron Kite Shield", "cnrShldKiteIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldIron, "Iron Tower Shield", "cnrShldTowrIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 7);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- bronze helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Pot Helm", "cnrHelmPotBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Bascinet", "cnrHelmBasBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Executioner's Helm", "cnrHelmExeBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Jutter Helm", "cnrHelmJutBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Spike Helm", "cnrHelmSpikeBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsBron, "Bronze Visor Helm", "cnrHelmVisBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- iron helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Pot Helm", "cnrHelmPotIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Bascinet", "cnrHelmBasIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Executioner's Helm", "cnrHelmExeIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Jutter Helm", "cnrHelmJutIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Spike Helm", "cnrHelmSpikeIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsIron, "Iron Visor Helm", "cnrHelmVisIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- platinum helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Pot Helm", "cnrHelmPotPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Bascinet", "cnrHelmBasPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Executioner's Helm", "cnrHelmExePla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Jutter Helm", "cnrHelmJutPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Spike Helm", "cnrHelmSpikePla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsPlat, "Platinum Visor Helm", "cnrHelmVisPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- adamantium helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Pot Helm", "cnrHelmPotAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Bascinet", "cnrHelmBasAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Executioner's Helm", "cnrHelmExeAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Jutter Helm", "cnrHelmJutAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Spike Helm", "cnrHelmSpikeAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsAdam, "Adamantium Visor Helm", "cnrHelmVisAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- cobalt helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Pot Helm", "cnrHelmPotCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Bascinet", "cnrHelmBasCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Executioner's Helm", "cnrHelmExeCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Jutter Helm", "cnrHelmJutCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Spike Helm", "cnrHelmSpikeCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsCoba, "Cobalt Visor Helm", "cnrHelmVisCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- mithril helms -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Pot Helm", "cnrHelmPotMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Bascinet", "cnrHelmBasMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Executioner's Helm", "cnrHelmExeMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Jutter Helm", "cnrHelmJutMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Spike Helm", "cnrHelmSpikeMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuHelmsMith, "Mithril Visor Helm", "cnrHelmVisMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldHelm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 3);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- bronze armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronLight, "Bronze Chain Shirt", "cnrChainShirtBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronMedium, "Bronze Scale Mail", "cnrScaleMailBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronMedium, "Bronze Chain Mail", "cnrChainMailBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronHeavy, "Bronze Banded Mail", "cnrBandedMailBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronHeavy, "Bronze Splint Mail", "cnrSplintMailBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronHeavy, "Bronze Half Plate", "cnrHalfPlateBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronHeavy, "Bronze Full Plate", "cnrFullPlateBro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- iron armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronLight, "Iron Chain Shirt", "cnrChainShirtIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronMedium, "Iron Scale Mail", "cnrScaleMailIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronMedium, "Iron Chain Mail", "cnrChainMailIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronHeavy, "Iron Banded Mail", "cnrBandedMailIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronHeavy, "Iron Splint Mail", "cnrSplintMailIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronHeavy, "Iron Half Plate", "cnrHalfPlateIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronHeavy, "Iron Full Plate", "cnrFullPlateIro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- platinum armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatLight, "Platinum Chain Shirt", "cnrChainShirtPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatMedium, "Platinum Scale Mail", "cnrScaleMailPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatMedium, "Platinum Chain Mail", "cnrChainMailPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatHeavy, "Platinum Banded Mail", "cnrBandedMailPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatHeavy, "Platinum Splint Mail", "cnrSplintMailPla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatHeavy, "Platinum Half Plate", "cnrHalfPlatePla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPlatHeavy, "Platinum Full Plate", "cnrFullPlatePla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotPlat", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledPlat", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- adamantium armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamLight, "Adamantium Chain Shirt", "cnrChainShirtAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamMedium, "Adamantium Scale Mail", "cnrScaleMailAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamMedium, "Adamantium Chain Mail", "cnrChainMailAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamHeavy, "Adamantium Banded Mail", "cnrBandedMailAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamHeavy, "Adamantium Splint Mail", "cnrSplintMailAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamHeavy, "Adamantium Half Plate", "cnrHalfPlateAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdamHeavy, "Adamantium Full Plate", "cnrFullPlateAda", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotAdam", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledAdam", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- cobalt armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaLight, "Cobalt Chain Shirt", "cnrChainShirtCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaMedium, "Cobalt Scale Mail", "cnrScaleMailCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaMedium, "Cobalt Chain Mail", "cnrChainMailCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaHeavy, "Cobalt Banded Mail", "cnrBandedMailCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaHeavy, "Cobalt Splint Mail", "cnrSplintMailCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaHeavy, "Cobalt Half Plate", "cnrHalfPlateCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCobaHeavy, "Cobalt Full Plate", "cnrFullPlateCob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCoba", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCoba", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- mithril armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithLight, "Mithril Chain Shirt", "cnrChainShirtMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainShirt", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithMedium, "Mithril Scale Mail", "cnrScaleMailMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatScaleMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithMedium, "Mithril Chain Mail", "cnrChainMailMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatChainMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithHeavy, "Mithril Banded Mail", "cnrBandedMailMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatBandedMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithHeavy, "Mithril Splint Mail", "cnrSplintMailMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatSplintMail", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithHeavy, "Mithril Half Plate", "cnrHalfPlateMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatHalfPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuMithHeavy, "Mithril Full Plate", "cnrFullPlateMit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotMith", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrPatFullPlate", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------- adorned armors -----------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorLight, "Adorned Chain Shirt", "cnrChainShirtAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 2, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainShirtMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorMedium, "Adorned Scale Mail", "cnrScaleMailAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 2, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScaleMailMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorMedium, "Adorned Chain Mail", "cnrChainMailAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 3, 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrChainMailmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorHeavy, "Adorned Banded Mail", "cnrBandedMailAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 3, 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBandedMailMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorHeavy, "Adorned Splint Mail", "cnrSplintMailAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 4, 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSplintMailMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorHeavy, "Adorned Half Plate", "cnrHalfPlateAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 4, 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHalfPlateMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 4);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAdorHeavy, "Adorned Full Plate", "cnrFullPlateAdo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 5, 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFullPlateMit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledMith", 0, 5);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

}

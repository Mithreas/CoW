/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrEnchantStatue
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

  PrintString("cnrEnchantStatue init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrEnchantStatue
  /////////////////////////////////////////////////////////
  string sMenuShieldLtng = CnrRecipeAddSubMenu("cnrEnchantStatue", "Shields of Lightning");
  string sMenuShieldAcid = CnrRecipeAddSubMenu("cnrEnchantStatue", "Shields of Acid");
  string sMenuShieldFire = CnrRecipeAddSubMenu("cnrEnchantStatue", "Shields of Fire");

  CnrRecipeSetDevicePreCraftingScript("cnrEnchantStatue", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrEnchantStatue", "cnrXXX");
  CnrRecipeSetDeviceTradeskillType("cnrEnchantStatue", CNR_TRADESKILL_ENCHANTING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Small Shield of Lightning", "cnrShldSmalLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Buckler Shield of Lightning", "cnrShldBuckLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Star Shield of Lightning", "cnrShldStarLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Large Shield of Lightning", "cnrShldLargLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Heater Shield of Lightning", "cnrShldHeatLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Kite Shield of Lightning", "cnrShldKiteLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldLtng, "Tower Shield of Lightning", "cnrShldTowrLtng", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagLightning", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrCopp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Small Shield of Acid", "cnrShldSmalAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Buckler Shield of Acid", "cnrShldBuckAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Star Shield of Acid", "cnrShldStarAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Large Shield of Acid", "cnrShldLargAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Heater Shield of Acid", "cnrShldHeatAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Kite Shield of Acid", "cnrShldKiteAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldAcid, "Tower Shield of Acid", "cnrShldTowrAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagAcid", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrBron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Small Shield of Fire", "cnrShldSmalFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldSmalIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Buckler Shield of Fire", "cnrShldBuckFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldBuckIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Star Shield of Fire", "cnrShldStarFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldStarIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Large Shield of Fire", "cnrShldLargFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldLargIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Heater Shield of Fire", "cnrShldHeatFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldHeatIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Kite Shield of Fire", "cnrShldKiteFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldKiteIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuShieldFire, "Tower Shield of Fire", "cnrShldTowrFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilEnchanting", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrBagFire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShldTowrIron", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 60, 40, 0);

}

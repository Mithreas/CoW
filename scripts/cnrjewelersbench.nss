/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrJewelersBench
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

  PrintString("cnrJewelersBench init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrJewelersBench"
  /////////////////////////////////////////////////////////
  string sMenuRings = CnrRecipeAddSubMenu("cnrJewelersBench", "Rings");
  string sMenuScarabs = CnrRecipeAddSubMenu("cnrJewelersBench", "Scarabs");
  string sMenuNecklaces = CnrRecipeAddSubMenu("cnrJewelersBench", "Necklaces");
  string sMenuAmulets = CnrRecipeAddSubMenu("cnrJewelersBench", "Amulets");

  CnrRecipeSetDevicePreCraftingScript("cnrJewelersBench", "cnr_jeweler_anim");
  CnrRecipeSetDeviceInventoryTool("cnrJewelersBench", "cnrGemTools", CNR_FLOAT_GEM_CRAFTERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrJewelersBench", CNR_TRADESKILL_JEWELRY);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Copper Greenstone Ring", "cnrCopGreenRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotCopp", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant001", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Copper Malachite Ring", "cnrCopMalRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotCopp", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant007", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Copper Fire Agate Ring", "cnrCopFireAgRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotCopp", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant002", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Copper Adventurine Ring", "cnrCopAdvRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotCopp", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant014", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Bronze Phenalope Ring", "cnrBroPhenRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant004", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Bronze Amethyst Ring", "cnrBroAmRing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldRing", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant003", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Greenstone Scarab", "cnrBroGreenScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant001", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Malachite Scarab", "cnrBroMalScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant007", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Fire Agate Scarab", "cnrBroFireAgScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant002", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Adventurine Scarab", "cnrBroAdvScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant014", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Gold Phenalope Scarab", "cnrGoldPhenScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant004", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Gold Amethyst Scarab", "cnrGoldAmScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant003", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Bronze Feldspar Necklace", "cnrBroFeldNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant015", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Bronze Garnet Necklace", "cnrBroGarNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant011", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Gold Alexandrite Necklace", "cnrGoldAlexNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant013", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Gold Topaz Necklace", "cnrGoldTopNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant010", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Gold Sapphire Necklace", "cnrGoldSapNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant008", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Gold Fire Opal Necklace", "cnrGoldFireOpNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant009", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Platinum Diamond Necklace", "cnrPlatDiaNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant005", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Platinum Ruby Necklace", "cnrPlatRubyNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant006", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuNecklaces, "Platinum Emerald Necklace", "cnrPlatEmNeck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldNecklace", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant012", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Feldspar Amulet", "cnrGoldFeldAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant015", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Garnet Amulet", "cnrGoldGarAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant011", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Platinum Alexandrite Amulet", "cnrPlatAlexAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant013", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Platinum Topaz Amulet", "cnrPlatTopAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant010", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Platinum Sapphire Amulet", "cnrPlatSapAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant008", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Platinum Fire Opal Amulet", "cnrPlatFireOpAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotPlat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant009", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Diamond Amulet", "cnrSilvDiaAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant005", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Emerald Amulet", "cnrSilvEmAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant012", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Ruby Amulet", "cnrSilvRubyAmulet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldAmulet", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotSilv", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant006", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 80, 0, 0, 0, 20);

}

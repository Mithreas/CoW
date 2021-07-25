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
  string sMenuGems = CnrRecipeAddSubMenu("cnrJewelersBench", "Polished Gems");
  string sMenuRings = CnrRecipeAddSubMenu("cnrJewelersBench", "Rings");
  //string sMenuNecklaces = CnrRecipeAddSubMenu("cnrJewelersBench", "Necklaces");
  string sMenuAmulets = CnrRecipeAddSubMenu("cnrJewelersBench", "Amulets");
  string sMenuStone = CnrRecipeAddSubMenu("cnrJewelersBench", "Stonework");

  CnrRecipeSetDevicePreCraftingScript("cnrJewelersBench", "cnr_jeweler_anim");
  CnrRecipeSetDeviceInventoryTool("cnrJewelersBench", "cnrGemTools", CNR_FLOAT_GEM_CRAFTERS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrJewelersBench", CNR_TRADESKILL_JEWELRY);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_JEWELRY), 0, 50, 0, 0, 0, 50);  // Dex and Cha.

  /////////////////////////////////////////////////////////
  // Gems
  /////////////////////////////////////////////////////////
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Greenstone", "cow_gemgree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM001", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_gree", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Malachite", "cow_gemmala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM007", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_mala", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Fire Agate", "cow_gemfiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM002", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_fiag", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Aventurine", "cow_gemaven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM014", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_aven", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Phenalope", "cow_gemphen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM004", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_phen", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Amethyst", "cow_gemamet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM003", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_amet", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Fluorspar", "cow_gemfluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM015", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_fluo", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Garnet", "cow_gemgarn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM011", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_garn", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Alexandrite", "cow_gemalex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM013", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_alex", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Topaz", "cow_gemtopa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM010", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_topa", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Sapphire", "cow_gemsapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM008", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_sapp", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Fire Opal", "cow_gemfiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM009", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_fiop", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Diamond", "cow_gemdiam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM005", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_diam", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Ruby", "cow_gemruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM006", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_ruby", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuGems, "Polished Emerald", "cow_gememer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_GEM012", 1, 0);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "dust_emer", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  
  /////////////////////////////////////////////////////////
  // Rings
  /////////////////////////////////////////////////////////
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ondaran Ring", "cnrondring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ondaran Greenstone Ring", "cnrondgreering", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgree", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ondaran Malachite Ring", "cnrondmalaring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemmala", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ondaran Fire Agate Ring", "cnrondfiagring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiag", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Iron Ring", "cnriroring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Iron Aventurine Ring", "cnrironavenring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemaven", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Iron Phenalope Ring", "cnrirophenring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemphen", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Iron Amethyst Ring", "cnriroametring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemamet", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Silver Ring", "cnrsilring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Silver Fluorspar Ring", "cnrsilfluoring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfluo", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Silver Garnet Ring", "cnrsilgarnring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Silver Alexandrite Ring", "cnrsilalexring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemalex", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Gold Ring", "cnrgolring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Gold Topaz Ring", "cnrgoltoparing", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemtopa", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Gold Sapphire Ring", "cnrgolsappring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemsapp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Gold Fire Opal Ring", "cnrgolfiopring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiop", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Electrum Ring", "cnrelering", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Electrum Diamond Ring", "cnrelediamring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemdiam", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Electrum Ruby Ring", "cnrelerubyring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemruby", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Electrum Emerald Ring", "cnreleemerring", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gememer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ring of Camouflage", "ring_scout8", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsilgarnring", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "rune_invest1", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 19);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 190, 190);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRings, "Ring of Revealing", "ring_detect8", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsilalexring", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "rune_invest1", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 19);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 190, 190);

  /////////////////////////////////////////////////////////
  // Scarabs
  /////////////////////////////////////////////////////////
/* TODO - brooches that you apply to a cloak/belt to give them the Gem property.
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Greenstone Scarab", "cnrBroGreenScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant001", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Malachite Scarab", "cnrBroMalScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant007", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Fire Agate Scarab", "cnrBroFireAgScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant002", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Bronze Adventurine Scarab", "cnrBroAdvScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotBron", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant014", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Gold Phenalope Scarab", "cnrGoldPhenScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant004", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuScarabs, "Gold Amethyst Scarab", "cnrGoldAmScarab", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldScarab", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrEnchIngotGold", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemEnchant003", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
*/
  /////////////////////////////////////////////////////////
  // Amulets  
  /////////////////////////////////////////////////////////
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Ondaran Amulet", "cnrondamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Ondaran Greenstone Amulet", "cnrondgreeamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgree", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Ondaran Malachite Amulet", "cnrondmalaamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemmala", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Ondaran Fire Agate Amulet", "cnrondfiagamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiag", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Iron Amulet", "cnrironamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Iron Aventurine Amulet", "cnrironavenamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemaven", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Iron Phenalope Amulet", "cnrironphenamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemphen", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Iron Amethyst Amulet", "cnrironametamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemamet", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Amulet", "cnrsilamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Fluorspar Amulet", "cnrsilfluoramu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfluo", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Garnet Amulet", "cnrsilgarnamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Silver Alexandrite Amulet", "cnrsilalexamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemalex", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Amulet", "cnrgoldamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Topaz Amulet", "cnrgoltopaamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemtopa", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Sapphire Amulet", "cnrgolsappamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemsapp", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Gold Fire Opal Amulet", "cnrgolfiopamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiop", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Electrum Amulet", "cnreleamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Electrum Diamond Amulet", "cnrelediamamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemdiam", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Electrum Ruby Amulet", "cnrelerubyamu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemruby", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Electrum Emerald Amulet", "cnreleemeramu", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gememer", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);  

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAmulets, "Greater Luckstone", "cow_luckstone5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_luckstone", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 20);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 200, 200);  

  /////////////////////////////////////////////////////////
  // Stonework
  /////////////////////////////////////////////////////////
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Stone Vase", "gs_item113", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Headstone", "wt_item_hdstn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Stone Sign", "wt_item_sign2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgranite", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Stone Throne", "gs_item377", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Potted Plant", "gs_item111", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Flowers", "gs_item114", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Elaborate Stone Table", "ir_illithtabit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Stone Column", "gs_item376", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Rune Pillar", "wt_item_pllrrune", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Skeletal Throne", "ir_skullseatit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Crystal Ball", "wt_item_ball1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "crystal", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);   
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Guardian Statue", "gs_item112", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Gargoyle", "wt_item_gargoyle", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Knight Statue", "wt_item_stattall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Warrior Statue", "gs_item217", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgranite", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Sphynx Statue", "wt_item_sphynx", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Marble Altar", "gs_item410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Granite Altar", "gs_item411", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgranite", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Spiked Altar", "wt_item_altar1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplainstone", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgranite", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuStone, "Fixture: Enchantment Basin", "gs_item413", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmarble", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotele", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);  
}

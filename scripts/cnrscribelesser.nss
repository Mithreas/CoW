/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrScribeLesser
//
//  Desc:  Recipe initialization.
//
//  Author: Gary Corcoran 19May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrscribelesser init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribeLesser
  /////////////////////////////////////////////////////////
  string sMenuLevel1Scrolls = CnrRecipeAddSubMenu("cnrscribelesser", "Level 1 Scrolls");
  string sMenuLevel2Scrolls = CnrRecipeAddSubMenu("cnrscribelesser", "Level 2 Scrolls");
  string sMenuLevel3Scrolls = CnrRecipeAddSubMenu("cnrscribelesser", "Level 3 Scrolls");
  string sMenuLevel4Scrolls = CnrRecipeAddSubMenu("cnrscribelesser", "Level 4 Scrolls");
  string sMenuLevel5Scrolls = CnrRecipeAddSubMenu("cnrscribelesser", "Level 5 Scrolls");

  CnrRecipeSetDevicePreCraftingScript("cnrscribelesser", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrscribelesser", "");
  CnrRecipeSetDeviceTradeskillType("cnrscribelesser", CNR_TRADESKILL_INVESTING);
  CnrRecipeSetRecipeAbilityPercentages("cnrscribelesser", 0, 0, 0, 50, 50, 0);

//Level 1 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Ray of Frost", "NW_IT_SPARSCR002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RAY_OF_FROST);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Daze", "NW_IT_SPARSCR003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DAZE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Light", "NW_IT_SPARSCR004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LIGHT);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Resistance", "NW_IT_SPARSCR001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RESISTANCE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Cure Minor Wounds", "X2_IT_SPDVSCR001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CURE_MINOR_WOUNDS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Charm Person", "NW_IT_SPARSCR107", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CHARM_PERSON);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Negative Energy Ray", "nw_it_sparscr113", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_NEGATIVE_ENERGY_RAY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Magic Missile", "NW_IT_SPARSCR109", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_MISSILE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Burning Hands", "NW_IT_SPARSCR112", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_BURNING_HANDS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Color Spray", "NW_IT_SPARSCR110", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_COLOR_SPRAY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel1Scrolls, "Sanctuary", "X1_IT_SPDVSCR101", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SANCTUARY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

//Level 2 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Magic Weapon", "X2_IT_SPARSCR105", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_WEAPON);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Endure Elements", "NW_IT_SPARSCR101", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ENDURE_ELEMENTS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Grease", "NW_IT_SPARSCR103", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREASE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Mage Armor", "NW_IT_SPARSCR104", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGE_ARMOR);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Protection from Alignment", "NW_IT_SPARSCR102", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PROTECTION_FROM_EVIL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Ray of Enfeeblement", "NW_IT_SPARSCR111", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RAY_OF_ENFEEBLEMENT);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Scare", "NW_IT_SPARSCR210", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkLNecor", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SCARE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Sleep", "NW_IT_SPARSCR108", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SLEEP);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Summon Creature I", "NW_IT_SPARSCR105", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_I);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Identify", "NW_IT_SPARSCR106", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_IDENTIFY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel2Scrolls, "Cure Light Wounds", "X2_IT_SPDVSCR104", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CURE_LIGHT_WOUNDS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

//Level 3 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Charm Person or Animal", "NW_IT_SPARSCR208", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CHARM_PERSON_OR_ANIMAL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Blindness and Deafness", "NW_IT_SPARSCR211", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_BLINDNESS_AND_DEAFNESS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Bull's Strength", "NW_IT_SPARSCR212", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_BULLS_STRENGTH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Cat's Grace", "NW_IT_SPARSCR213", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CATS_GRACE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Darkness", "NW_IT_SPARSCR206", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DARKNESS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Eagle's Splendor", "nw_it_sparscr219", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_EAGLE_SPLEDOR);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Endurance", "NW_IT_SPARSCR215", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ENDURANCE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Fox's Cunning", "nw_it_sparscr220", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FOXS_CUNNING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel3Scrolls, "Ghostly Visage", "NW_IT_SPARSCR208", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GHOSTLY_VISAGE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

//Level 4 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Ghoul Touch", "NW_IT_SPARSCR209", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GHOUL_TOUCH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Hold Person", "NW_IT_SPARSCR308", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_HOLD_PERSON);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Invisibility", "NW_IT_SPARSCR207", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_INVISIBILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Knock", "NW_IT_SPARSCR216", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_KNOCK);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Lesser Dispel", "NW_IT_SPARSCR218", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_DISPEL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Lesser Restoration", "NW_IT_SPDVSCR201", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_RESTORATION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Melf's Acid Arrow", "NW_IT_SPARSCR202", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MELFS_ACID_ARROW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Owl's Wisdom", "nw_it_sparscr221", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_OWLS_WISDOM);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel4Scrolls, "Resist Elements", "NW_IT_SPARSCR201", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_aven", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RESIST_ELEMENTS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

//Level 5 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "See Invisibility", "NW_IT_SPARSCR205", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SEE_INVISIBILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Silence", "NW_IT_SPDVSCR203", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SILENCE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Sound Burst", "NW_IT_SPDVSCR204", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SOUND_BURST);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Summon Creature II", "NW_IT_SPARSCR203", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_II);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Ultra Vision", "NW_IT_SPARSCR214", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CLARITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Web", "NW_IT_SPARSCR204", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WEB);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Clarity", "NW_IT_SPARSCR217", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CLARITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Protection from Elements", "NW_IT_SPARSCR303", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PROTECTION_FROM_ELEMENTS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel5Scrolls, "Remove Disease", "NW_IT_SPDVSCR302", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_REMOVE_DISEASE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

}

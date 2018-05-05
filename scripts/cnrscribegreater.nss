/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrScribeGreater
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

  PrintString("cnrScribeGreater init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribeGreater
  /////////////////////////////////////////////////////////
  string sMenuLevel11Scrolls = CnrRecipeAddSubMenu("cnrScribeGreater", "Level 11 Scrolls");
  string sMenuLevel12Scrolls = CnrRecipeAddSubMenu("cnrScribeGreater", "Level 12 Scrolls");
  string sMenuLevel13Scrolls = CnrRecipeAddSubMenu("cnrScribeGreater", "Level 13 Scrolls");
  string sMenuLevel14Scrolls = CnrRecipeAddSubMenu("cnrScribeGreater", "Level 14 Scrolls");
  string sMenuLevel15Scrolls = CnrRecipeAddSubMenu("cnrScribeGreater", "Level 15 Scrolls");

  CnrRecipeSetDevicePreCraftingScript("cnrScribeGreater", "cnr_scribe_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrScribeGreater", "");
  CnrRecipeSetDeviceTradeskillType("cnrScribeGreater", CNR_TRADESKILL_INVESTING);

//Level 11 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Raise Dead", "NW_IT_SPDVSCR501", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RAISE_DEAD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Summon Creature V", "NW_IT_SPARSCR510", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_V);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Greater Dispelling", "NW_IT_SPARSCR602", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_DISPELLING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Ethereal Visage", "NW_IT_SPARSCR608", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ETHEREAL_VISAGE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "True Seeing", "NW_IT_SPARSCR606", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TRUE_SEEING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Acid Fog", "NW_IT_SPARSCR603", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ACID_FOG);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Chain Lightning", "NW_IT_SPARSCR607", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CHAIN_LIGHTNING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Circle of Death", "NW_IT_SPARSCR610", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CIRCLE_OF_DEATH);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Globe of Invulnerability", "NW_IT_SPARSCR601", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GLOBE_OF_INVULNERABILITY);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

//Level 12 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Greater Spell Breach", "NW_IT_SPARSCR612", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SPELL_BREACH);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Greater Stoneskin", "NW_IT_SPARSCR613", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_STONESKIN);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Mass Haste", "NW_IT_SPARSCR611", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_HASTE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Planar Binding", "NW_IT_SPARSCR604", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PLANAR_BINDING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Cone of Gold", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_CONE_OF_COLD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Fireball", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_FIREBALL);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Stoneskin", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_STONESKIN);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Summon Shadow", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_SUMMON_SHADOW);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Wall of Fire", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_WALL_OF_FIRE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Summon Creature VI", "NW_IT_SPARSCR605", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VI);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Tenser's Transformation", "nw_it_sparscr614", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TENSERS_TRANSFORMATION);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Control Undead", "NW_IT_SPARSCR707", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CONTROL_UNDEAD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Delayed Blast Fireball", "NW_IT_SPARSCR704", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DELAYED_BLAST_FIREBALL);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

//Level 13 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Finger of Death", "NW_IT_SPARSCR708", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FINGER_OF_DEATH);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Greater Restoration", "NW_IT_SPDVSCR701", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_RESTORATION);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Mordenkainen's Sword", "NW_IT_SPARSCR705", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MORDENKAINENS_SWORD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Power Word Stun", "NW_IT_SPARSCR702", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_POWER_WORD_STUN);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Prismatic Spray", "NW_IT_SPARSCR706", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PRISMATIC_SPRAY);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Protection from Spells", "NW_IT_SPARSCR802", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PROTECTION_FROM_SPELLS);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Resurrection", "NW_IT_SPDVSCR702", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RESURRECTION);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Spell Mantle", "NW_IT_SPARSCR701", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SPELL_MANTLE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Summon Creature VII", "NW_IT_SPARSCR703", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VII);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

//Level 14 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Greater Planar Binding", "NW_IT_SPARSCR803", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_PLANAR_BINDING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Horrid Wilting", "NW_IT_SPARSCR809", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_HORRID_WILTING);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Incendiary Cloud", "NW_IT_SPARSCR804", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_INCENDIARY_CLOUD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mass Blindness and Deafness", "NW_IT_SPARSCR807", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_BLINDNESS_AND_DEAFNESS);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mass Charm", "NW_IT_SPARSCR806", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_CHARM);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mind Blank", "NW_IT_SPARSCR801", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MIND_BLANK);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Premonition", "NW_IT_SPARSCR808", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PREMONITION);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Summon Creature VIII", "NW_IT_SPARSCR805", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VIII);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Dominate Monster", "NW_IT_SPARSCR905", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEnch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DOMINATE_MONSTER);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Energy Drain", "NW_IT_SPARSCR908", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ENERGY_DRAIN);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

//Level 15 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Gate", "NW_IT_SPARSCR902", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GATE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Greater Spell Mantle", "NW_IT_SPARSCR912", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SPELL_MANTLE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Meteor Swarm", "NW_IT_SPARSCR906", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGEvoc", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_METEOR_SWARM);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Mordenkainen's Disjunction", "NW_IT_SPARSCR901", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGAbjur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MORDENKAINENS_DISJUNCTION);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Power Word Kill", "NW_IT_SPARSCR903", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGDiv", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_POWER_WORD_KILL);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Shapechange", "NW_IT_SPARSCR910", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHAPECHANGE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Summon Creature IX", "NW_IT_SPARSCR904", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGConj", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_IX);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Time Stop", "NW_IT_SPARSCR911", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGTrans", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TIME_STOP);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Wail of the Banshee", "NW_IT_SPARSCR909", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGNecro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WAIL_OF_THE_BANSHEE);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Weird", "NW_IT_SPARSCR907", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrScrollBlank", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkGIllus", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrGemDust012", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WEIRD);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrGlassVial", 1, 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 0, 0, 50, 50, 0);

}

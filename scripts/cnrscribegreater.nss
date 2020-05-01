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

  PrintString("cnrscribegreater init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribeGreater
  /////////////////////////////////////////////////////////
  string sMenuLevel11Scrolls = CnrRecipeAddSubMenu("cnrscribegreater", "Level 11 Scrolls");
  string sMenuLevel12Scrolls = CnrRecipeAddSubMenu("cnrscribegreater", "Level 12 Scrolls");
  string sMenuLevel13Scrolls = CnrRecipeAddSubMenu("cnrscribegreater", "Level 13 Scrolls");
  string sMenuLevel14Scrolls = CnrRecipeAddSubMenu("cnrscribegreater", "Level 14 Scrolls");
  string sMenuLevel15Scrolls = CnrRecipeAddSubMenu("cnrscribegreater", "Level 15 Scrolls");

  CnrRecipeSetDevicePreCraftingScript("cnrscribegreater", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrScribeGreater", "");
  CnrRecipeSetDeviceTradeskillType("cnrscribegreater", CNR_TRADESKILL_INVESTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_INVESTING), 0, 0, 0, 50, 50, 0);

//Level 11 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Raise Dead", "NW_IT_SPDVSCR501", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RAISE_DEAD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Summon Creature V", "NW_IT_SPARSCR510", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_V);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Greater Dispelling", "NW_IT_SPARSCR602", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_DISPELLING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Ethereal Visage", "NW_IT_SPARSCR608", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ETHEREAL_VISAGE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "True Seeing", "NW_IT_SPARSCR606", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TRUE_SEEING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Acid Fog", "NW_IT_SPARSCR603", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ACID_FOG);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Chain Lightning", "NW_IT_SPARSCR607", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CHAIN_LIGHTNING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Circle of Death", "NW_IT_SPARSCR610", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CIRCLE_OF_DEATH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel11Scrolls, "Globe of Invulnerability", "NW_IT_SPARSCR601", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GLOBE_OF_INVULNERABILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

//Level 12 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Greater Spell Breach", "NW_IT_SPARSCR612", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SPELL_BREACH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Greater Stoneskin", "NW_IT_SPARSCR613", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_STONESKIN);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Mass Haste", "NW_IT_SPARSCR611", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_HASTE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Planar Binding", "NW_IT_SPARSCR604", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PLANAR_BINDING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Cone of Gold", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_CONE_OF_COLD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Fireball", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_FIREBALL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Stoneskin", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_STONESKIN);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Summon Shadow", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_SUMMON_SHADOW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Shades Wall of Fire", "NW_IT_SPARSCR609", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADES_WALL_OF_FIRE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Summon Creature VI", "NW_IT_SPARSCR605", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VI);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Tenser's Transformation", "nw_it_sparscr614", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TENSERS_TRANSFORMATION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Control Undead", "NW_IT_SPARSCR707", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CONTROL_UNDEAD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel12Scrolls, "Delayed Blast Fireball", "NW_IT_SPARSCR704", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DELAYED_BLAST_FIREBALL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

//Level 13 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Finger of Death", "NW_IT_SPARSCR708", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FINGER_OF_DEATH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Greater Restoration", "NW_IT_SPDVSCR701", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_RESTORATION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Mordenkainen's Sword", "NW_IT_SPARSCR705", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MORDENKAINENS_SWORD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Power Word Stun", "NW_IT_SPARSCR702", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_POWER_WORD_STUN);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Prismatic Spray", "NW_IT_SPARSCR706", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PRISMATIC_SPRAY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Protection from Spells", "NW_IT_SPARSCR802", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PROTECTION_FROM_SPELLS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Resurrection", "NW_IT_SPDVSCR702", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RESURRECTION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Spell Mantle", "NW_IT_SPARSCR701", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SPELL_MANTLE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel13Scrolls, "Summon Creature VII", "NW_IT_SPARSCR703", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VII);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

//Level 14 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Greater Planar Binding", "NW_IT_SPARSCR803", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_PLANAR_BINDING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Horrid Wilting", "NW_IT_SPARSCR809", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_HORRID_WILTING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Incendiary Cloud", "NW_IT_SPARSCR804", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_INCENDIARY_CLOUD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mass Blindness and Deafness", "NW_IT_SPARSCR807", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_BLINDNESS_AND_DEAFNESS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mass Charm", "NW_IT_SPARSCR806", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MASS_CHARM);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Mind Blank", "NW_IT_SPARSCR801", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MIND_BLANK);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Premonition", "NW_IT_SPARSCR808", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PREMONITION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Summon Creature VIII", "NW_IT_SPARSCR805", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_VIII);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Dominate Monster", "NW_IT_SPARSCR905", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DOMINATE_MONSTER);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel14Scrolls, "Energy Drain", "NW_IT_SPARSCR908", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ENERGY_DRAIN);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

//Level 15 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Gate", "NW_IT_SPARSCR902", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GATE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Greater Spell Mantle", "NW_IT_SPARSCR912", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SPELL_MANTLE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Meteor Swarm", "NW_IT_SPARSCR906", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_METEOR_SWARM);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Mordenkainen's Disjunction", "NW_IT_SPARSCR901", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MORDENKAINENS_DISJUNCTION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Power Word Kill", "NW_IT_SPARSCR903", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_POWER_WORD_KILL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Shapechange", "NW_IT_SPARSCR910", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHAPECHANGE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Summon Creature IX", "NW_IT_SPARSCR904", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_IX);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Time Stop", "NW_IT_SPARSCR911", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_TIME_STOP);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Wail of the Banshee", "NW_IT_SPARSCR909", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WAIL_OF_THE_BANSHEE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel15Scrolls, "Weird", "NW_IT_SPARSCR907", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WEIRD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

}

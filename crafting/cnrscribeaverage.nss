/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrScribeAverage
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

  PrintString("cnrscribeaverage init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribeAverage
  /////////////////////////////////////////////////////////
  string sMenuLevel6Scrolls = CnrRecipeAddSubMenu("cnrscribeaverage", "Level 6 Scrolls");
  string sMenuLevel7Scrolls = CnrRecipeAddSubMenu("cnrscribeaverage", "Level 7 Scrolls");
  string sMenuLevel8Scrolls = CnrRecipeAddSubMenu("cnrscribeaverage", "Level 8 Scrolls");
  string sMenuLevel9Scrolls = CnrRecipeAddSubMenu("cnrscribeaverage", "Level 9 Scrolls");
  string sMenuLevel10Scrolls = CnrRecipeAddSubMenu("cnrscribeaverage", "Level 10 Scrolls");

  CnrRecipeSetDevicePreCraftingScript("cnrscribeaverage", "cnr_enchant_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrscribeaverage", "");
  CnrRecipeSetDeviceTradeskillType("cnrscribeaverage", CNR_TRADESKILL_INVESTING);
  CnrRecipeSetRecipeAbilityPercentages("cnrscribeaverage", 0, 0, 0, 50, 50, 0);

//Level 6 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Vampiric Touch", "NW_IT_SPARSCR311", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_VAMPIRIC_TOUCH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Animate Dead", "NW_IT_SPARSCR509", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ANIMATE_DEAD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Bestow Curse", "NW_IT_SPARSCR414", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_BESTOW_CURSE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Clairaudience and Clairvoyance", "NW_IT_SPARSCR307", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Contagion", "NW_IT_SPARSCR411", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CONTAGION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Dispel Magic", "NW_IT_SPARSCR301", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DISPEL_MAGIC);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Fireball", "NW_IT_SPARSCR309", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FIREBALL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Flame Arrow", "NW_IT_SPARSCR304", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FLAME_ARROW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel6Scrolls, "Haste", "NW_IT_SPARSCR312", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_HASTE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

//Level 7 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Invisibility Sphere", "NW_IT_SPARSCR314", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_INVISIBILITY_SPHERE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Lightning Bolt", "NW_IT_SPARSCR310", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LIGHTNING_BOLT);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Magic Circle Against Alignment", "NW_IT_SPARSCR302", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_CIRCLE_AGAINST_CHAOS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Magic Circle Against Alignment", "NW_IT_SPARSCR302", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_CIRCLE_AGAINST_EVIL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Magic Circle Against Alignment", "NW_IT_SPARSCR302", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_CIRCLE_AGAINST_GOOD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Magic Circle Against Alignment", "NW_IT_SPARSCR302", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MAGIC_CIRCLE_AGAINST_LAW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Remove Blindness and Deafness", "NW_IT_SPDVSCR301", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_REMOVE_BLINDNESS_AND_DEAFNESS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Remove Curse", "NW_IT_SPARSCR402", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_REMOVE_CURSE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Slow", "NW_IT_SPARSCR313", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SLOW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Stinking Cloud", "NW_IT_SPARSCR305", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_STINKING_CLOUD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Summon Creature III", "NW_IT_SPARSCR306", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_III);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel7Scrolls, "Negative Energy Burst", "nw_it_sparscr315", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_NEGATIVE_ENERGY_BURST);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

//Level 8 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Charm Monster", "NW_IT_SPARSCR405", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CHARM_MONSTER);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Confusion", "NW_IT_SPARSCR406", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CONFUSION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Fear", "NW_IT_SPARSCR413", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FEAR);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Neutralize Poison", "NW_IT_SPDVSCR402", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_NEUTRALIZE_POISON);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Dismissal", "NW_IT_SPARSCR501", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DISMISSAL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Elemental Shield", "NW_IT_SPARSCR416", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ELEMENTAL_SHIELD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Enervation", "NW_IT_SPARSCR412", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_ENERVATION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Hold Monster", "NW_IT_SPARSCR505", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_HOLD_MONSTER);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel8Scrolls, "Improved Invisibility", "NW_IT_SPARSCR408", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_IMPROVED_INVISIBILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

//Level 9 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Lesser Spell Breach", "NW_IT_SPARSCR417", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_SPELL_BREACH);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Minor Globe of Invulnerability", "NW_IT_SPARSCR401", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MINOR_GLOBE_OF_INVULNERABILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Phantasmal Killer", "NW_IT_SPARSCR409", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_PHANTASMAL_KILLER);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Polymorph Self", "NW_IT_SPARSCR415", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_POLYMORPH_SELF);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Restoration", "NW_IT_SPDVSCR401", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_RESTORATION);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Shadow Conjuration", "NW_IT_SPARSCR410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADOW_CONJURATION_DARKNESS);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Shadow Conjuration", "NW_IT_SPARSCR410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADOW_CONJURATION_INIVSIBILITY);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Shadow Conjuration", "NW_IT_SPARSCR410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADOW_CONJURATION_MAGE_ARMOR);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Shadow Conjuration", "NW_IT_SPARSCR410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADOW_CONJURATION_MAGIC_MISSILE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Shadow Conjuration", "NW_IT_SPARSCR410", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SHADOW_CONJURATION_SUMMON_SHADOW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Stoneskin", "NW_IT_SPARSCR403", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_STONESKIN);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Summon Creature IV", "NW_IT_SPARSCR404", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_SUMMON_CREATURE_IV);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel9Scrolls, "Wall of Fire", "NW_IT_SPARSCR407", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_WALL_OF_FIRE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

//Level 10 Scrolls

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Dominate Person", "NW_IT_SPARSCR503", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_DOMINATE_PERSON);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Cone of Cold", "NW_IT_SPARSCR507", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CONE_OF_COLD);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Cloudkill", "NW_IT_SPARSCR502", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_CLOUDKILL);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Feeblemind", "NW_IT_SPARSCR504", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_FEEBLEMIND);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Greater Shadow Conjuration", "NW_IT_SPARSCR508", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Greater Shadow Conjuration", "NW_IT_SPARSCR508", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Greater Shadow Conjuration", "NW_IT_SPARSCR508", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Greater Shadow Conjuration", "NW_IT_SPARSCR508", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Greater Shadow Conjuration", "NW_IT_SPARSCR508", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_GREATER_SHADOW_CONJURATION_WEB);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Lesser Mind Blank", "NW_IT_SPARSCR511", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_MIND_BLANK);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Lesser Planar Binding", "NW_IT_SPARSCR512", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_PLANAR_BINDING);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Lesser Spell Mantle", "NW_IT_SPARSCR513", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_LESSER_SPELL_MANTLE);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuLevel10Scrolls, "Mind Fog", "NW_IT_SPARSCR506", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "CNR_RECIPE_SPELL", 1, SPELL_MIND_FOG);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

}

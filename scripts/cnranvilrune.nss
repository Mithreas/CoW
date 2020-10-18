#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnranvilrune init");

  /////////////////////////////////////////////////////////
  // Default CNR recipes made in cnrScribeLesser
  /////////////////////////////////////////////////////////
  string sMenuWardingRunes1 = CnrRecipeAddSubMenu("cnranvilrune", "+1 Warding Runes");
  string sMenuWardingRunes2 = CnrRecipeAddSubMenu("cnranvilrune", "+2 Warding Runes");
  string sMenuWardingRunes3 = CnrRecipeAddSubMenu("cnranvilrune", "+3 Warding Runes");

  CnrRecipeSetDevicePreCraftingScript("cnranvilrune", "cnr_enchant_anim");
  CnrRecipeSetDeviceTradeskillType("cnranvilrune", CNR_TRADESKILL_INVESTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_INVESTING), 0, 0, 0, 50, 50, 0);

  // Warding runes lvl 1

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Animals)", "ward_rune_1ani", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Goblins)", "ward_rune_1gob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Lizardfolk)", "ward_rune_1liz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_TORCH001", 1, 0); // Torch
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Fey)", "ward_rune_1fey", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Shapechanger)", "ward_rune_1sha", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes1, "Warding Rune (+1 vs Outsider)", "ward_rune_1out", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkL", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC19", 1, 0); // Fairy dust
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  // Warding runes lvl 2

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Animals)", "ward_rune_2ani", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Goblins)", "ward_rune_2gob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Lizardfolk)", "ward_rune_2liz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_TORCH001", 1, 0); // Torch
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Fey)", "ward_rune_2fey", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Shapechanger)", "ward_rune_2sha", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes2, "Warding Rune (+2 vs Outsider)", "ward_rune_2out", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkM", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC19", 1, 0); // Fairy dust
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  // Warding runes lvl 3

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Animals)", "ward_rune_3ani", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Goblins)", "ward_rune_3gob", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Lizardfolk)", "ward_rune_3liz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_TORCH001", 1, 0); // Torch
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Fey)", "ward_rune_3fey", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Shapechanger)", "ward_rune_3sha", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuWardingRunes3, "Warding Rune (+3 vs Outsider)", "ward_rune_3out", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "x2_it_cfm_bscrl", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC19", 1, 0); // Fairy dust
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);
   
}

/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrbrazierdem
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrbrazierdem init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrbrazierdem
  /////////////////////////////////////////////////////////
  string sMenu4Ammo = CnrRecipeAddSubMenu("cnrbrazierdem", "Ammo and Knives");
  string sMenu4Axes = CnrRecipeAddSubMenu("cnrbrazierdem", "Axes");
  string sMenu4Bladed = CnrRecipeAddSubMenu("cnrbrazierdem", "Bladed");
  string sMenu4Blunts = CnrRecipeAddSubMenu("cnrbrazierdem", "Blunts");
  string sMenu4Double = CnrRecipeAddSubMenu("cnrbrazierdem", "Double-Sided");
  string sMenu4Polearms = CnrRecipeAddSubMenu("cnrbrazierdem", "Polearms");

  CnrRecipeSetDevicePreCraftingScript("cnrbrazierdem", "cnr_caldron_anim");
  //CnrRecipeSetDeviceEquippedTool("cnrbrazierdem", "cnrSmithsHammer");
  CnrRecipeSetDeviceTradeskillType("cnrbrazierdem", CNR_TRADESKILL_WEAPON_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Ammo, "Demon's Bane Bullets", "cnrbullet4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbullet2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Ammo, "Demon's Bane Throwing Knife", "cnrthrow4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthrow2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Ammo, "Demon's Bane Arrows", "cnrarrow4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrarrow2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Ammo, "Demon's Bane Bolts", "cnrbolt4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbolt2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Polearms, "Demon's Bane Spear", "cnrspear4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspear2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Dagger", "cnrdagger4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdagger2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Axes, "Demon's Bane Handaxe", "cnrhandaxe4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhandaxe2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Polearms, "Demon's Bane Scythe", "cnrscythe4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrscythe2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Blunts, "Demon's Bane Mace", "cnrmace4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmace2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Blunts, "Demon's Bane Morningstar", "cnrmstar4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmstar2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangled2", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Short Sword", "cnrshsword4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshsword2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Axes, "Demon's Bane Battleaxe", "cnrbattleaxe4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbattleaxe2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Blunts, "Demon's Bane Warhammer", "cnrwarhammer4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwarhammer2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Rapier", "cnrrapier4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrrapier2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Windblade", "cnrwindblade4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwindblade2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Double, "Demon's Bane Dire Mace", "cnrdiremace4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdiremace2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Longsword", "cnrlgsword4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLgSword2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Axes, "Demon's Bane Greataxe", "cnrgreataxe4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgreataxe2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Double, "Demon's Bane Double Axe", "cnrdoubleaxe4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdoubleaxe2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Double, "Demon's Bane Two-Bladed Sword", "cnrdsword4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdsword2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Bladed, "Demon's Bane Greatsword", "cnrgrsword4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgrsword2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Blunts, "Demon's Bane Club", "cnrclub4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu4Blunts, "Demon's Bane Quarterstaff", "cnrqstaff4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotdem", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrholywater", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

}

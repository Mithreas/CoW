/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrbraziersta
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

  PrintString("cnrbraziersta init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrbraziersta
  /////////////////////////////////////////////////////////
  string sMenu6Ammo = CnrRecipeAddSubMenu("cnrbraziersta", "Ammo and Knives");
  string sMenu6Axes = CnrRecipeAddSubMenu("cnrbraziersta", "Axes");
  string sMenu6Bladed = CnrRecipeAddSubMenu("cnrbraziersta", "Bladed");
  string sMenu6Blunts = CnrRecipeAddSubMenu("cnrbraziersta", "Blunts");
  string sMenu6Double = CnrRecipeAddSubMenu("cnrbraziersta", "Double-Sided");
  string sMenu6Polearms = CnrRecipeAddSubMenu("cnrbraziersta", "Polearms");

  CnrRecipeSetDevicePreCraftingScript("cnrbraziersta", "cnr_caldron_anim");
  //CnrRecipeSetDeviceEquippedTool("cnrbraziersta", "cnrSmithsHammer");
  CnrRecipeSetDeviceTradeskillType("cnrbraziersta", CNR_TRADESKILL_WEAPON_CRAFTING);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Ammo, "Stallix Bullets", "cnrbullet6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbullet5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Ammo, "Stallix Throwing Knife", "cnrthrow6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthrow5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Ammo, "Stallix Arrows", "cnrarrow6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrarrow5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Ammo, "Stallix Bolts", "cnrbolt6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbolt5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Polearms, "Stallix Spear", "cnrspear6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrspear5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Dagger", "cnrdagger6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdagger5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Axes, "Stallix Handaxe", "cnrhandaxe6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhandaxe5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Polearms, "Stallix Scythe", "cnrscythe6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrscythe5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Blunts, "Stallix Mace", "cnrmace6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmace5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Blunts, "Stallix Morningstar", "cnrmstar6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmstar5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangled5", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Short Sword", "cnrshsword6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshsword5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Axes, "Stallix Battleaxe", "cnrbattleaxe6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbattleaxe5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Blunts, "Stallix Warhammer", "cnrwarhammer6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwarhammer5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Rapier", "cnrrapier6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrrapier5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Windblade", "cnrwindblade6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwindblade5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Double, "Stallix Dire Mace", "cnrdiremace6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdiremace5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Longsword", "cnrlgsword6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlgsword5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Axes, "Stallix Greataxe", "cnrgreataxe6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgreataxe5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Double, "Stallix Double Axe", "cnrdoubleaxe6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdoubleaxe5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Double, "Stallix Two-Bladed Sword", "cnrdsword6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrdsword5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Bladed, "Stallix Greatsword", "cnrgrsword6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgrsword5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Blunts, "Stallix Club", "cnrclub6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu6Blunts, "Stallix Quarterstaff", "cnrqstaff6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 50, 30, 0, 0, 10, 10);

}

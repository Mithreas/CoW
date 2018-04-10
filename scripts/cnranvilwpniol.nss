/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpniol
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

  PrintString("cnranvilwpniol init");

  string sMenu5Ammo = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Bullets and Knives");
  string sMenu5Axes = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Axes");
  string sMenu5Bladed = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Bladed");
  string sMenu5Blunts = CnrRecipeAddSubMenu("cnranvirwpnond", "Iolum Blunts");
  string sMenu5Double = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Double-Sided");
  string sMenu5Polearms = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Polearms");
  string sMenu5Subs = CnrRecipeAddSubMenu("cnranvilwpniol", "Iolum Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpniol", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpniol", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpniol", CNR_TRADESKILL_WEAPON_CRAFTING);

  //////////////////Iolum Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Small Iolum Blade", "cnrsmlbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Medium Iolum Blade", "cnrmedbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Large Iolum Blade", "cnrlrgbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Small Iolum Head", "cnrsmlhea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Medium Iolum Head", "cnrmedhea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Large Iolum Head", "cnrlrghea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Subs, "Small Iolum Blade", "cnrshod5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  ///////////////// Iolum Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Ammo, "Iolum Bullets", "cnrbullet5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Ammo, "Iolum Throwing Knives", "cnrthrow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Polearms, "Iolum Spear", "cnrspear5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Dagger", "cnrdagger5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Axes, "Iolum Handaxe", "cnrhandaxe5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Polearms, "Iolum Scythe", "cnrscythe5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Blunts, "Iolum Mace", "cnrmace5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Blunts, "Iolum Morningstar", "cnrmstar5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Short Sword", "cnrshsword5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Axes, "Iolum Battleaxe", "cnrbattleaxe5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Blunts, "Iolum Warhammer", "cnrwarhammer5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Rapier", "cnrrapier5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Windblade", "cnrwindblade5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Double, "Iolum Dire Mace", "cnrdiremace5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea5", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Longsword", "cnrlgsword5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Axes, "Iolum Greataxe", "cnrgreataxe5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Double, "Iolum Double Axe", "cnrdoubleaxe5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Double, "Iolum Two-Bladed Sword", "cnrdsword5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld5", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Bladed, "Iolum Greatsword", "cnrgrsword5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Blunts, "Iolum Shod Club", "cnrclub5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod5", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu5Blunts, "Iolum Shod Quarterstaff", "cnrqstaff5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod5", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

}





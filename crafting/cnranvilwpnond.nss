/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpnond
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

  PrintString("cnranvilwpnond init");

  string sMenu1Ammo = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Bullets and Knives");
  string sMenu1Axes = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Axes");
  string sMenu1Bladed = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Bladed");
  string sMenu1Blunts = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Blunts");
  string sMenu1Double = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Double-Sided");
  string sMenu1Polearms = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Polearms");
  string sMenu1Subs = CnrRecipeAddSubMenu("cnranvilwpnond", "Ondaran Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnond", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnond", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnond", CNR_TRADESKILL_WEAPON_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages("cnranvilwpnond", 50, 50, 0, 0, 0, 0);

  //////////////////Ondaran Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Small Ondaran Blade", "cnrsmlbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Medium Ondaran Blade", "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Large Ondaran Blade", "cnrlrgbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Small Ondaran Head", "cnrsmlhea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Medium Ondaran Head", "cnrmedhea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Large Ondaran Head", "cnrlrghea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Subs, "Ondaran Shoddings", "cnrshod1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);



  ///////////////// Ondaran Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Ammo, "Ondaran Bullets", "cnrbullet1", 99);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Ammo, "Ondaran Throwing Knives", "cnrthrow1", 50);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Polearms, "Ondaran Spear", "cnrspear1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Dagger", "cnrdagger1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Axes, "Ondaran Handaxe", "cnrhandaxe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Polearms, "Ondaran Scythe", "cnrscythe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Blunts, "Ondaran Mace", "cnrmace1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Blunts, "Ondaran Morningstar", "cnrmstar1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Short Sword", "cnrshsword1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Axes, "Ondaran Battleaxe", "cnrbattleaxe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Blunts, "Ondaran Warhammer", "cnrwarhammer1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Rapier", "cnrrapier1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Windblade", "cnrwindblade1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Double, "Ondaran Dire Mace", "cnrdiremace1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Longsword", "cnrlgsword1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Axes, "Ondaran Greataxe", "cnrgreataxe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Double, "Ondaran Double Axe", "cnrdoubleaxe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Double, "Ondaran Two-Bladed Sword", "cnrdsword1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Bladed, "Ondaran Greatsword", "cnrgrsword1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Blunts, "Ondaran Shod Club", "cnrclub1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Blunts, "Ondaran Shod Quarterstaff", "wdbqs002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu1Axes, "Ondaran Waraxe", "cnrwaraxe1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

}



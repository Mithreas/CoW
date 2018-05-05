/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpnlir
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

  PrintString("cnranvilwpnlir init");

  string sMenu3Ammo = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Bullets and Knives");
  string sMenu3Axes = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Axes");
  string sMenu3Bladed = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Bladed");
  string sMenu3Blunts = CnrRecipeAddSubMenu("cnranvirwpnlir", "Lirium Blunts");
  string sMenu3Double = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Double-Sided");
  string sMenu3Polearms = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Polearms");
  string sMenu3Subs = CnrRecipeAddSubMenu("cnranvilwpnlir", "Lirium Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnlir", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnlir", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnlir", CNR_TRADESKILL_WEAPON_CRAFTING);

  //////////////////Lirium Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Lirium Blade", "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Lirium Blade", "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Lirium Blade", "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Lirium Head", "cnrsmlhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Lirium Head", "cnrmedhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Lirium Head", "cnrlrghea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Lirium Blade", "cnrshod3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  ///////////////// Lirium Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Lirium Bullets", "cnrbullet3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Lirium Throwing Knives", "cnrthrow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Lirium Spear", "cnrspear3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Dagger", "cnrdagger3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Lirium Handaxe", "cnrhandaxe3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Lirium Scythe", "cnrscythe3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Lirium Mace", "cnrmace3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Lirium Morningstar", "cnrmstar3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Short Sword", "cnrshsword3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Lirium Battleaxe", "cnrbattleaxe3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Lirium Warhammer", "cnrwarhammer3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Rapier", "cnrrapier3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Windblade", "cnrwindblade3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Lirium Dire Mace", "cnrdiremace3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Longsword", "cnrlgsword3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Lirium Greataxe", "cnrgreataxe3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Lirium Double Axe", "cnrdoubleaxe3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Lirium Two-Bladed Sword", "cnrdsword3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Lirium Greatsword", "cnrgrsword3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Lirium Shod Club", "cnrclub3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Lirium Shod Quarterstaff", "cnrqstaff3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod3", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

}




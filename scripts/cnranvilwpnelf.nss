/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpnelf
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

  PrintString("cnranvilwpnelf init");

  string sMenu2Ammo = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Bullets and Knives");
  string sMenu2Axes = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Axes");
  string sMenu2Bladed = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Bladed");
  string sMenu2Blunts = CnrRecipeAddSubMenu("cnranvirwpnelf", "Elfur Blunts");
  string sMenu2Double = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Double-Sided");
  string sMenu2Polearms = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Polearms");
  string sMenu2Subs = CnrRecipeAddSubMenu("cnranvilwpnelf", "Elfur Components");
  string sMenu2House = CnrRecipeAddSubMenu("cnranvilwpnelf", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnelf", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnelf", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnelf", CNR_TRADESKILL_WEAPON_CRAFTING);

  //////////////////Elfur Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Small Elfur Blade", "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Medium Elfur Blade", "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Large Elfur Blade", "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Small Elfur Head", "cnrsmlhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Medium Elfur Head", "cnrmedhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Large Elfur Head", "cnrlrghea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Small Elfur Blade", "cnrshod2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);



  ///////////////// Elfur Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Elfur Bullets", "cnrbullet2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Elfur Throwing Knives", "cnrthrow2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Polearms, "Elfur Spear", "cnrspear2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Dagger", "cnrdagger2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Elfur Handaxe", "cnrhandaxe2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Polearms, "Elfur Scythe", "cnrscythe2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Elfur Mace", "cnrmace2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Elfur Morningstar", "cnrmstar2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Short Sword", "cnrshsword2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Elfur Battleaxe", "cnrbattleaxe2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Elfur Warhammer", "cnrwarhammer2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Rapier", "cnrrapier2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Windblade", "cnrwindblade2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Elfur Dire Mace", "cnrdiremace2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Longsword", "cnrlgsword2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Elfur Greataxe", "cnrgreataxe2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Elfur Double Axe", "cnrdoubleaxe2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Elfur Two-Bladed Sword", "cnrdsword2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Elfur Greatsword", "cnrgrsword2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Elfur Shod Club", "cnrclub2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Elfur Shod Quarterstaff", "cnrqstaff2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod2", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2House, "Drannis: Golden Blade of Dranns", "dragolbla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotelf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmossyellow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleatbat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescardraglobla", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescardraglobla", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

}



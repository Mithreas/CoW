/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpnsil
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

  PrintString("cnranvilwpnmit init");

  string sMenu3Ammo = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Slingstones and Knives");
  string sMenu3Axes = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Axes");
  string sMenu3Bladed = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Bladed");
  string sMenu3Blunts = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Blunts");
  string sMenu3Double = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Double-Sided");
  string sMenu3Polearms = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Polearms");
  string sMenu3Subs = CnrRecipeAddSubMenu("cnranvilwpnmit", "Mithril Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnmit", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnmit", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnmit", CNR_TRADESKILL_WEAPON_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_WEAPON_CRAFTING), 50, 50, 0, 0, 0, 0);

  //////////////////Mithril Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Mithril Blade", "cnrsmlbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Mithril Blade", "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Mithril Blade", "cnrlrgbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Mithril Head", "cnrsmlhea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Mithril Head", "cnrmedhea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Mithril Head", "cnrlrghea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Mithril Shoddings", "cnrshod6", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  ///////////////// Mithril Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Mithril Slingstones", "ca_gen_bu_mit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Mithril Throwing Knives", "cnrthrow6", 50);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotmit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Mithril Spear", "wplss006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Dagger", "wswdg006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Mithril Handaxe", "waxhn006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Mithril Scythe", "wplsc006", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld6", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Mithril Halberd", "wplhb006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Mithril Mace", "wblml006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Mithril Morningstar", "wblms006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Short Sword", "wswss006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Mithril Battleaxe", "waxbt006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Mithril Warhammer", "wblhw006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Rapier", "wswrp006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Windblade", "wswka006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Mithril Dire Mace", "wdbma006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea6", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Longsword", "wswls006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Mithril Greataxe", "waxgr006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Mithril Double Axe", "wdbax006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Mithril Two-Bladed Sword", "wdbsw006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Mithril Greatsword", "wswgs006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Mithril Shod Club", "wblcl006", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshod6", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Mithril Shod Quarterstaff", "wdbqs006", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshod6", 2);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Mithril Waraxe", "wdwraxe006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

}




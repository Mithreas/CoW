/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpnste
//
//  Desc:  Recipe initialization.
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"


void main()

{
  string sKeyToRecipe;

  PrintString("cnranvilwpnste init");

  string sMenu3Ammo = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Slingstones and Knives");
  string sMenu3Axes = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Axes");
  string sMenu3Bladed = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Bladed");
  string sMenu3Blunts = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Blunts");
  string sMenu3Double = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Double-Sided");
  string sMenu3Polearms = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Polearms");
  string sMenu3Subs = CnrRecipeAddSubMenu("cnranvilwpnste", "Steel Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnste", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnste", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnste", CNR_TRADESKILL_WEAPON_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_WEAPON_CRAFTING), 50, 50, 0, 0, 0, 0);

  //////////////////Steel Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Steel Blade", "cnrsmlbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Steel Blade", "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Steel Blade", "cnrlrgbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Steel Head", "cnrsmlhea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Steel Head", "cnrmedhea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Steel Head", "cnrlrghea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Steel Shoddings", "cnrshod7", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  ///////////////// Steel Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Steel Slingstones", "ca_gen_bu_ste", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Steel Throwing Knives", "cnrthrow4", 50);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotste", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Steel Spear", "wplss004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Dagger", "wswdg004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Steel Handaxe", "waxhn004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Steel Scythe", "wplsc004", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld7", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Steel Halberd", "wplhb004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Steel Mace", "wblml004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Steel Morningstar", "wblms004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Short Sword", "wswss004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Steel Battleaxe", "waxbt004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Steel Warhammer", "wblhw004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Rapier", "wswrp004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Windblade", "wswka004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Steel Dire Mace", "wdbma004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea7", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Longsword", "wswls004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Steel Greataxe", "waxgr004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Steel Double Axe", "wdbax004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Steel Two-Bladed Sword", "wdbsw004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Steel Greatsword", "wswgs004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Steel Shod Club", "wblcl004", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshod7", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Steel Shod Quarterstaff", "wdbqs004", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshod7", 2);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Steel Waraxe", "wdwraxe004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 17);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 170, 170);

}




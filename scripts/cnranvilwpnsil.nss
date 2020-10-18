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

  PrintString("cnranvilwpnsil init");

  string sMenu3Ammo = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Slingstones and Knives");
  string sMenu3Axes = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Axes");
  string sMenu3Bladed = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Bladed");
  string sMenu3Blunts = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Blunts");
  string sMenu3Double = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Double-Sided");
  string sMenu3Polearms = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Polearms");
  string sMenu3Subs = CnrRecipeAddSubMenu("cnranvilwpnsil", "Silver Components");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpnsil", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpnsil", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpnsil", CNR_TRADESKILL_WEAPON_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_WEAPON_CRAFTING), 50, 50, 0, 0, 0, 0);

  //////////////////Silver Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Silver Blade", "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Silver Blade", "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Silver Blade", "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Small Silver Head", "cnrsmlhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Medium Silver Head", "cnrmedhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Large Silver Head", "cnrlrghea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Subs, "Silver Shoddings", "cnrshod3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);



  ///////////////// Silver Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Silver Slingstones", "ca_gen_bu_sil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Ammo, "Silver Throwing Knives", "cnrthrow3", 50);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Silver Spear", "wplss005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Dagger", "wswdg005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Silver Handaxe", "waxhn005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Silver Scythe", "wplsc005", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Polearms, "Silver Halberd", "wplhb005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Silver Mace", "wblml005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Silver Morningstar", "wblms005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Short Sword", "wswss005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Silver Battleaxe", "waxbt005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Silver Warhammer", "wblhw005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Rapier", "wswrp005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Windblade", "wswka005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Silver Dire Mace", "wdbma005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Longsword", "wswls005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Silver Greataxe", "waxgr005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Silver Double Axe", "wdbax005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Double, "Silver Two-Bladed Sword", "wdbsw005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Bladed, "Silver Greatsword", "wswgs005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Silver Shod Club", "wblcl005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Blunts, "Silver Shod Quarterstaff", "wdbqs005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod3", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu3Axes, "Silver Waraxe", "wdwraxe005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

}




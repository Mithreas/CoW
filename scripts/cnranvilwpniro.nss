/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnranvilwpniro
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

  PrintString("cnranvilwpniro init");

  string sMenu2Ammo = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Bullets and Knives");
  string sMenu2Axes = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Axes");
  string sMenu2Bladed = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Bladed");
  string sMenu2Blunts = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Blunts");
  string sMenu2Double = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Double-Sided");
  string sMenu2Polearms = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Polearms");
  string sMenu2Subs = CnrRecipeAddSubMenu("cnranvilwpniro", "Iron Components");
  string sMenu2House = CnrRecipeAddSubMenu("cnranvilwpniro", "House Items");

  CnrRecipeSetDevicePreCraftingScript("cnranvilwpniro", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnranvilwpniro", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnranvilwpniro", CNR_TRADESKILL_WEAPON_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_WEAPON_CRAFTING), 50, 50, 0, 0, 0, 0);

  //////////////////Iron Subs//////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Small Iron Blade", "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Medium Iron Blade", "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Large Iron Blade", "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Small Iron Head", "cnrsmlhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Medium Iron Head", "cnrmedhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Large Iron Head", "cnrlrghea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Subs, "Iron Shoddings", "cnrshod2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);



  ///////////////// Iron Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Iron Bullets", "ca_gen_bu_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Iron Throwing Knives", "ca_gen_tk_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Iron Shurikens", "ca_gen_sh_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Ammo, "Iron Throwing Axes", "ca_gen_axe_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Polearms, "Iron Spear", "wplss003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Dagger", "wswdg003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Iron Pickaxe", "cnrminerspickiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Iron Handaxe", "waxhn003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  //sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Polearms, "Iron Scythe", "wplsc003", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  //CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  //CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  //CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Polearms, "Iron Halberd", "wplhb003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Mace", "wblml003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Morningstar", "wblms003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedhea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Short Sword", "wswss003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Iron Battleaxe", "waxbt003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Warhammer", "wblhw003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrghea2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Rapier", "wswrp003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Windblade", "wswka003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Iron Dire Mace", "wdbma003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Longsword", "wswls003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Iron Greataxe", "waxgr003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Iron Double Axe", "wdbax003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Double, "Iron Two-Bladed Sword", "wdbsw003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Bladed, "Iron Greatsword", "wswgs003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlrgbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbindings", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Shod Club", "wblcl003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Shod Quarterstaff", "wdbqs003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod2", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Blunts, "Iron Shod Quarterstaff (Entwood)", "wdbqs003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrqstaff4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshod2", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2Axes, "Iron Waraxe", "wdwraxe003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmedbld2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);

  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenu2House, "Drannis: Golden Blade of Drannis", "dragolbla", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotada", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsta", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmossyellow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrleatbat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescardraglobla", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescardraglobla", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

}



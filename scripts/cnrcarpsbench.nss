/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrCarpsBench
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//  Modified: Gary Corcoran 19May03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrcarpsbench init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrCarpsBench
  /////////////////////////////////////////////////////////
  string sMenuCarpTimbers = CnrRecipeAddSubMenu("cnrcarpsbench", "Timbers");
  string sMenuCarpMisc = CnrRecipeAddSubMenu("cnrcarpsbench", "Misc");
  string sMenuCarpWeapons = CnrRecipeAddSubMenu("cnrcarpsbench", "Weapons");
  string sMenuCarpArrows = CnrRecipeAddSubMenu("cnrcarpsbench", "Arrows");
  string sMenuCarpBolts = CnrRecipeAddSubMenu("cnrcarpsbench", "Bolts");
  string sMenuCarpBows = CnrRecipeAddSubMenu("cnrcarpsbench", "Bows");
  string sMenuCarpShields = CnrRecipeAddSubMenu("cnrcarpsbench", "Shields");
  string sMenuCarpHouse = CnrRecipeAddSubMenu("cnrcarpsbench", "House Items");

  string sMenuBows2 = CnrRecipeAddSubMenu(sMenuCarpBows, "Yinus");
  string sMenuBows1 = CnrRecipeAddSubMenu(sMenuCarpBows, "Irl");
  string sMenuBows3 = CnrRecipeAddSubMenu(sMenuCarpBows, "Amkare");


  CnrRecipeSetDevicePreCraftingScript("cnrcarpsbench", "cnr_carp_anim");
  CnrRecipeSetDeviceInventoryTool("cnrcarpsbench", "cnrCarpsTools", CNR_FLOAT_CARPS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrcarpsbench", CNR_TRADESKILL_WOOD_CRAFTING);

  ////////////////////////Shields///////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Buckler", "cnrshldbuck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Large Shield", "cnrshldlarg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Tower Shield", "cnrshldtowr", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);


  ////////////////////////////////Timbers////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Irl) Shaft", "cnrshaft", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Yinus) Shaft", "cnrshaft", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Amkare) Shaft", "cnrshaft", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Yinus", "cnrplank2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Irl", "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Amkare", "cnrplank3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Irl", "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Irl", "cnrstavelong1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Amkare", "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Amkare", "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Yinus", "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Yinus", "cnrstavelong2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Torch", "cnrtorch", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrrope", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Wooden Club", "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Wooden Quarterstaff", "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  //----------------------------arrows--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Ondaran Arrows", "cnrarrow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Iron Arrows", "ca_gen_arrow_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Lirium Arrows", "cnrarrow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Iolum Arrows", "cnrarrow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringot5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  //----------------------------bolts--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Ondaran Bolts", "cnrbolt1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Iron Bolts", "ca_gen_bolt_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Lirium Bolts", "cnrbolt3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotlir", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Iolum Bolts", "cnrbolt5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiol", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  // ---------------------------- bows ------------------------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Short Bow", "cnrshortbow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Light Crossbow", "cnrxbow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Long Bow", "cnrlongbow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Heavy Crossbow", "cnrxbow2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Yinus Short Bow", "cnrshortbow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Yinus Light Crossbow", "cnrxbow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Yinus Long Bow", "cnrlongbow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Yinus Heavy Crossbow", "cnrxbow4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Amkare Short Bow", "cnrshortbow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Amkare Light Crossbow", "cnrxbow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Amkare Long Bow", "cnrlongbow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Amkare Heavy Crossbow", "cnrHeavyBowMah", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Compound Irl Short Bow", "cnrshortbow2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshortbow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Compound Irl Long Bow", "cnrlongbow2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlongbow1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Compound Yinus Short Bow", "cnrshorbow4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshortbow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Compound Yinus Long Bow", "cnrlongbow4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlongbow3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Compound Amkare Short Bow", "cnrshortbow6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshortbow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Compound Amkare Long Bow", "cnrlongbow6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrlongbow5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 45, 55, 0, 0, 0, 0);

  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpHouse, "Erenia: Staff of the Gods", "ca_6staere", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmossyellow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarerestagod", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarerestagod", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpHouse, "Drannis: Quickfire Bow", "draquibow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescardraquibow", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescardraquibow", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

}

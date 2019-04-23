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
  string sMenuCarpFurn = CnrRecipeAddSubMenu("cnrcarpsbench", "Furniture");
  string sMenuCarpHouse = CnrRecipeAddSubMenu("cnrcarpsbench", "House Items");

  string sMenuBows1 = CnrRecipeAddSubMenu(sMenuCarpBows, "Irl");
  string sMenuBows2 = CnrRecipeAddSubMenu(sMenuCarpBows, "Ironwood");
  string sMenuBows3 = CnrRecipeAddSubMenu(sMenuCarpBows, "Duskwood");


  CnrRecipeSetDevicePreCraftingScript("cnrcarpsbench", "cnr_carp_anim");
  CnrRecipeSetDeviceInventoryTool("cnrcarpsbench", "cnrCarpsTools", CNR_FLOAT_CARPS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrcarpsbench", CNR_TRADESKILL_WOOD_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages("cnrcarpsbench", 50, 0, 0, 0, 50, 0);

  ////////////////////////Shields///////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Wooden Buckler", "cnrshldbuck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Wooden Large Shield", "cnrshldlarg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Wooden Tower Shield", "cnrshldtowr", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);


  ////////////////////////////////Timbers////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Irl) Shafts", "cnrshaft", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Ironwood) Shafts", "cnrshaft", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Duskwood) Shafts", "cnrshaft", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Irl", "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Ironwood", "cnrplank2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Duskwood", "cnrplank3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Irl", "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Irl", "cnrstavelong1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Ironwood", "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Ironwood", "cnrstavelong2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Duskwood", "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Duskwood", "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  //----------------------------misc--------------------------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Blank Scrolls", "x2_it_cfm_bscrl", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Torch", "NW_IT_TORCH001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrrope", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Bone Wand", "x2_it_cfm_wand", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // Skeleton Knuckle
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Compound Bow Cam", "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  
  //----------------------------weapons--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Wooden Club", "cnrclub", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Ironwood Club", "cnrclub2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Club", "wblcl008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Wooden Quarterstaff", "cnrqstaff", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Ironwood Quarterstaff", "cnrqstaff2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Quarterstaff", "wdbqs004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Mages' Staff", "wmgst008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);  
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  
  //----------------------------arrows--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Ondaran Arrows", "cnrarrow1", 99);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Iron Arrows", "ca_gen_arrow_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpArrows, "Silver Arrows", "ca_gen_arrow_sil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  //----------------------------bolts--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Ondaran Bolts", "cnrbolt1", 99);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Iron Bolts", "ca_gen_bolt_iro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotiro", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpBolts, "Silver Bolts", "ca_gen_bolt_sil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrshaft", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  // ---------------------------- bows ------------------------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Short Bow", "wbwsh002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Light Crossbow", "wbwxl002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Long Bow", "wbwln002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Irl Heavy Crossbow", "wbwxh002", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Ironwood Short Bow", "wbwsh003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Ironwood Light Crossbow", "wbwxl003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Ironwood Long Bow", "wbwln005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Ironwood Heavy Crossbow", "wbwxh003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Duskwood Short Bow", "wbwsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Duskwood Light Crossbow", "wbwxl004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Duskwood Long Bow", "wbwln004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Duskwood Heavy Crossbow", "wbwxh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "North Wind Bow (Longbow)", "wbwmln008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwln005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows2, "Eaglebow (Shortbow)", "wbwmsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Lesser Oathbow (Shortbow)", "wbwmsh009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Lilting Note (Shortbow)", "wbwmsh008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowcam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);
  
  //----------------------------furniture--------------------------------------  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Stool", "wt_item_stool", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Chair", "gs_item033", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Signpost", "gs_item060", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Signboard (small)", "gs_item066", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Sturdy Chair", "wt_item_chair1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Black Chair", "wt_item_chair2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Bench (simple)", "wt_item_bench3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Bench (with brace)", "wt_item_bench2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Cot", "wt_item_cot1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Wooden Throne", "gs_item116", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Signboard (hanging)", "wt_item_sign1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
    
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Bench (large)", "wt_item_bench1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Couch", "gs_item034", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
    
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Lecturn", "wt_item_lecturn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Signboard (medium)", "wt_item_sign3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Simple Table", "wt_item_tbl1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Round Wooden Table", "gs_item036", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Bookcase", "wt_item_bkcase1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Armoire", "fx_armoire", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Chest of Drawers", "fx_drawers", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Wooden Pillar", "wt_item_pllrwood", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Bed", "gs_item067", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Torch Stand", "wt_item_trch1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrLumpOfCoal", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Message Board", "gs_item059", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Dice Table", "wt_item1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Impaled Monster Head", "ir_impmonhead", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Skull Pole", "ir_impmonhead001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Combat Dummy", "wt_item_dummy1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcotton", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Keg", "wt_item_keg1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Archery Target", "wt_item_target1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Gallows", "wt_item_gllw1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50); 

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Cheval de Frise", "fx_cheval", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Painting 1", "wt_item_pntng1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture: Painting 2", "wt_item_pntng2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (green and white)", "wt_item_flag1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (black with red dot)", "wt_item_flag2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (light purple)", "wt_item_flag3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (black and white)", "wt_item_flag4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (purple and white)", "wt_item_flag5", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (purple cross)", "wt_item_flag6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (yellow)", "wt_item_flag7", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpFurn, "Fixture:  Flag (Jolly Roger)", "wt_item_flag8", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloth", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30); 
  
  //////////////////////House Items//////////////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpHouse, "Erenia: Staff of the Gods", "ca_6staere", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrmossyellow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarerestagod", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarerestagod", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpHouse, "Drannis: Quickfire Bow", "draquibow", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "rescardraquibow", 1, 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescardraquibow", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

}

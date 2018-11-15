/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrcarpelf
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

  PrintString("cnrcarpelf init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrcarpelf
  /////////////////////////////////////////////////////////
  string sMenuCarpTimbers = CnrRecipeAddSubMenu("cnrcarpelf", "Timbers");
  string sMenuCarpMisc = CnrRecipeAddSubMenu("cnrcarpelf", "Misc");
  string sMenuCarpWeapons = CnrRecipeAddSubMenu("cnrcarpelf", "Weapons");
  string sMenuCarpAmmo = CnrRecipeAddSubMenu("cnrcarpelf", "Ammo");
  string sMenuCarpBows = CnrRecipeAddSubMenu("cnrcarpelf", "Bows");
  string sMenuCarpShields = CnrRecipeAddSubMenu("cnrcarpelf", "Shields");

  string sMenuBows1 = CnrRecipeAddSubMenu(sMenuCarpBows, "Entwood");
  string sMenuBows3 = CnrRecipeAddSubMenu(sMenuCarpBows, "Duskwood");

  CnrRecipeSetDevicePreCraftingScript("cnrcarpelf", "cnr_carp_anim");
  CnrRecipeSetDeviceInventoryTool("cnrcarpelf", "cnrCarpsTools", CNR_FLOAT_CARPS_TOOLS_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrcarpelf", CNR_TRADESKILL_WOOD_CRAFTING);
  CnrRecipeSetRecipeAbilityPercentages("cnrcarpelf", 50, 0, 0, 0, 50, 0);

  ////////////////////////Shields///////////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Buckler", "cnrshldbuck", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank4", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Large Shield", "cnrshldlarg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank4", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpShields, "Tower Shield", "cnrshldtowr", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank4", 3);	
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);


  ////////////////////////////////Timbers////////////////////////////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Entwood) Shafts", "cnrshaft", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrtwigent", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "(Duskwood) Shafts", "cnrshaft", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Entwood", "cnrplank4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbarkent", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Plank of Duskwood", "cnrplank3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Entwood", "cnrstaveshort4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrtwigent", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Entwood", "cnrstavelong4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrtwigent", 2);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Short Stave of Duskwood", "cnrstaveshort3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpTimbers, "Long Stave of Duskwood", "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbranch3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);

  //----------------------------misc--------------------------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Blank Scrolls", "x2_it_cfm_bscrl", 10);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbarkent", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpMisc, "Bone Wand", "x2_it_cfm_wand", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // Skeleton Knuckle
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort1", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  //----------------------------weapons--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Entwood Club", "cnrclub4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort4", 4);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Club", "wblcl008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Entwood Quarterstaff", "cnrqstaff4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong4", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Quarterstaff", "wdbqs004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Entwood Mages' Staff", "wmgst077", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemphen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_amet", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiag", 1);  
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpWeapons, "Duskwood Mages' Staff", "wmgst008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong3", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fluo", 1);  
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  
  //----------------------------ammo--------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpAmmo, "Entwood Arrows", "ca_gen_arrow_ent", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrtwigent", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuCarpAmmo, "Entwood Bolts", "ca_gen_bolt_ent", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrtwigent", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrfeather", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  // ---------------------------- bows ------------------------------------
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Entwood Short Bow", "wbwsh005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Entwood Light Crossbow", "wbwxl005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Entwood Long Bow", "wbwln006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstavelong4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Entwood Heavy Crossbow", "wbwxh005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrplank4", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbowstring", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

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

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Phantom Bow (Shortbow)", "wbwmsh005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh003", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_phen", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_garn", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_alex", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 80);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows1, "Elven Court Bow (Longbow)", "wbwmln005", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwln006", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_sapp", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 15);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 150, 150);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Lesser Oathbow (Shortbow)", "wbwmsh009", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_ruby", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_fiop", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBows3, "Lilting Note (Shortbow)", "wbwmsh008", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "wbwsh004", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthreadmit", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_topa", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

}

/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrExplodeBench
//
//  Desc:  Recipe initialization.
//
//  Author: Mithreas 5 May 18
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

// Todo:
// Sulphur deposits

void main()
{
  string sKeyToRecipe;

  PrintString("cnrexplodebench init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrExplodeBench
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrexplodebench", "cnr_alchemy_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrexplodebench", "");
  CnrRecipeSetDeviceTradeskillType("cnrexplodebench", CNR_TRADESKILL_CHEMISTRY);
  CnrRecipeSetRecipeAbilityPercentages("cnrexplodebench", 0, 0, 50, 50, 0, 0); // CON and INT
  
  string sMenuExplodeBenchExplosives = CnrRecipeAddSubMenu("cnrexplodebench", "Explosive Mixtures");
  string sMenuExplodeBenchWeapons = CnrRecipeAddSubMenu("cnrexplodebench", "Black Powder Weapons");
  
  // -- Explosive Mixtures -- 
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Black Powder", "blackpowder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "Guano", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "Sulphur", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "Charcoal", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Volatile Oil", "volatileoil", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  //x1_wmgrenade002
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Alchemist's Fire", "x1_wmgrenade002", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "volatileoil", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Fire Bomb", "x2_it_firebomb", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "blackpowder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Gonne Slug", "gonneexplosivesl", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "blackpowder", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotond", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  // -- Black Powder Weapons --

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuExplodeBenchExplosives, "Gonne", "gonne", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "blackpowder", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlhea3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsmlplt3", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrstaveshort2", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);
    
}
  

/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrritualtable
//
//  Desc:  Recipe initialization.
//
//  Author: Mithreas 4 May 19
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

// Todo:
// Sulphur deposits

void main()
{
  string sKeyToRecipe;

  PrintString("cnrritualtable init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrritualtable
  /////////////////////////////////////////////////////////
  CnrRecipeSetDevicePreCraftingScript("cnrritualtable", "cnr_alchemy_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrritualtable", "");
  CnrRecipeSetDeviceTradeskillType("cnrritualtable", CNR_TRADESKILL_INVESTING);
  CnrRecipeSetRecipeAbilityPercentages("cnrritualtable", 0, 0, 0, 50, 50, 0); // WIS and INT
  
  string sMenuRituals = CnrRecipeAddSubMenu("cnrritualtable", "Ritual Circles");;
  
  // -- Rituals - need to be invented first --
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuRituals, "Restoration Ritual", "mi_rit_itm_1", 1);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "rescarritrenew", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "rescarritrenew", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrInkG", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_gree", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_mala", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_emer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "dust_diam", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);
  
    
}
  

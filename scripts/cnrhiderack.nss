/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx & Hrnac
//
//  Name:  cnrHideRack
//
//  Desc:  Recipe initialization.
//
//  Author: Gary Corcoran 05Aug03
//  Updated and substantially revised by Cara 15Apr06
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrhiderack init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Device "cnrHideRack"
  /////////////////////////////////////////////////////////
  string sMenuTailorLeathers = CnrRecipeAddSubMenu("cnrhiderack", "Leathers");

  CnrRecipeSetDevicePreCraftingScript("cnrhiderack", "cnr_hide_anim");
//CnrRecipeSetDeviceInventoryTool("cnrHideRack", "cnrSewingKit", CNR_FLOAT_SEWING_KIT_BREAKAGE_PERCENTAGE);
//CnrRecipeSetDeviceEquippedTool("cnrHideRack", "cnr");
  CnrRecipeSetDeviceTradeskillType("cnrhiderack", CNR_TRADESKILL_TAILORING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_TAILORING), 0, 50, 0, 50, 0, 0);


//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
//New CNR Tailoring items by LasCivious     //
//Modified by Hrnac 07-10-03                //
//////////////////////////////////////////////

// LEATHERS

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Badger Leather", "cnrleathbadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinbadger", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Deer Leather", "cnrleathdeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindeer", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Wolf Leather", "cnrleathwolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinwolf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Grizzly Leather", "cnrleathgriz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskingrizbear", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Worg Leather", "cnrleathworg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinworg", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Dire Bear Leather", "cnrleathdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindb", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

}






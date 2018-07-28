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


//////////////////////////////////////////////////////////////////////////////////////

/*  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Small Piece of Leather", "cnrLeatherSm", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHideCuredSm", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilTanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Medium Piece of Leather", "cnrLeatherMed", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHideCuredMed", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilTanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Large Piece of Leather", "cnrLeatherLg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrHideCuredLg", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrOilTanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0); */

//////////////////////////////////////////////
//New CNR Tailoring items by LasCivious     //
//Modified by Hrnac 07-10-03                //
//////////////////////////////////////////////

// LEATHERS

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Badger Leather", "cnrleathbadg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinbadger", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Bat Leather", "cnrleatbat", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrSkinBat", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Deer Leather", "cnrleathdeer", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindeer", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Wolf Leather", "cnrleathwolf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinwolf", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Worg Leather", "cnrleathworg", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskinworg", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 90, 90);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Grizzly Leather", "cnrleathgriz", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskingriz", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTailorLeathers, "Dire Bear Leather", "cnrleathdb", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskindb", 1, 0);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroiltanning", 1, 0);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 0, 65, 0, 35, 0, 0);

}






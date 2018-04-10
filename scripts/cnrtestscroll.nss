/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrTestScroll
//
//  Desc:  Recipe initialization. This is a crafting
//         book. See definition in cnr_book_init.
//
//  Author: David Bobeck 04Jun03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

  PrintString("cnrTestScroll init");

  /////////////////////////////////////////////////////////
  //  CNR Crafting Book "cnrTestScroll"
  /////////////////////////////////////////////////////////
  sKeyToRecipe = CnrRecipeCreateRecipe("cnrTestScroll", "Potion of Cure Light", "NW_IT_MPOTION001", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // skeleton knuckle
}

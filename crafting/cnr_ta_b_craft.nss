/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_b_craft
//
//  Desc:  This script is run by the cnr_c_recipebook
//         convo when the player chooses to craft
//         a recipe.
//
//  Author: David Bobeck 11Jan03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int bEnableCrafting = GetLocalInt(oPC, "cnrEnableBookCrafting");
  return bEnableCrafting;
}

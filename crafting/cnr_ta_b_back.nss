/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_b_back
//
//  Desc:  Should the "Back" menu item be shown.
//
//  Author: David Bobeck 21Mar03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToKeyToParent = sKeyToMenu + "_KeyToParent";
  string sKeyToParent = GetLocalString(oPC, sKeyToKeyToParent);
  if (sKeyToParent != "")
  {
    return TRUE;
  }
  return FALSE;
}

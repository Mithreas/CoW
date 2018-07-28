/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_r_back
//
//  Desc:  Changes to the parent recipe menu page
//
//  Author: David Bobeck 18Mar03
//
/////////////////////////////////////////////////////////
//#include "cnr_recipe_utils"
void main()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToKeyToParent = sKeyToMenu + "_KeyToParent";
  string sKeyToParent = GetLocalString(oPC, sKeyToKeyToParent);
  SetLocalString(oPC, "sCnrCurrentMenu", sKeyToParent);
  SetLocalInt(oPC, "nCnrMenuPage", 0);
  // the convo script will call "cnr_ta_r_top" next
}

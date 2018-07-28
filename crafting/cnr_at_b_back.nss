/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_b_back
//
//  Desc:  Changes to the parent recipe menu page
//
//  Author: David Bobeck 21Mar03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  string sKeyToKeyToParent = sKeyToMenu + "_KeyToParent";
  string sKeyToParent = GetLocalString(oPC, sKeyToKeyToParent);
  SetLocalString(oPC, "sCnrCurrentMenu", sKeyToParent);
  SetLocalInt(oPC, "nCnrMenuPage", 0);
  // the convo script will call "cnr_ta_b_top" next
}

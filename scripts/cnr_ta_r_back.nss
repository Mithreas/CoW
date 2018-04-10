/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_r_back
//
//  Desc:  Should the "Back" menu item be shown.
//
//  Author: David Bobeck 18Mar03
//
/////////////////////////////////////////////////////////
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

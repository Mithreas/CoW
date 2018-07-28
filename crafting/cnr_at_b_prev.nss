/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_b_prev
//
//  Desc:  Changes to the previous recipe menu page
//
//  Author: David Bobeck 10Jan03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetPCSpeaker();
  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage") - 1;
  SetLocalInt(oPC, "nCnrMenuPage", nMenuPage);
  // the convo script will call "cnr_ta_b_top" next
}

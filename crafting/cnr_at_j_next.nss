/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_j_next
//
//  Desc:  Changes to the next recipe menu page
//
//  Author: David Bobeck 19Apr03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetPCSpeaker();
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage") + 1;
  SetLocalInt(oPC, "nCnrMenuPage", nMenuPage);
  // the convo script will call "cnr_ta_j_main" next
}

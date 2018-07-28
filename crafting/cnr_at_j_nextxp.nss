/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_j_nextxp
//
//  Desc:  Changes to the next recipe menu page
//
//  Author: David Bobeck 24May03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetPCSpeaker();
  int nMenuPage = GetLocalInt(oPC, "nCnrXpMenuPage") + 1;
  SetLocalInt(oPC, "nCnrXpMenuPage", nMenuPage);
  // the convo script will call "cnr_ta_j_topten" next
}

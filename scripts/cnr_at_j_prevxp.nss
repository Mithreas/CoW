/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_j_prevxp
//
//  Desc:  Changes to the previous journal menu page
//
//  Author: David Bobeck 24May03
//
/////////////////////////////////////////////////////////
void main()
{
  object oPC = GetPCSpeaker();
  int nMenuPage = GetLocalInt(oPC, "nCnrXpMenuPage") - 1;
  SetLocalInt(oPC, "nCnrXpMenuPage", nMenuPage);
  // the convo script will call "cnr_ta_j_topten" next
}

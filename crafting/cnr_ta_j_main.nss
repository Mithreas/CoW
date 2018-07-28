/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_main
//
//  Desc:  Init's the journal's top level menu
//
//  Author: David Bobeck 04Mar03
//
/////////////////////////////////////////////////////////
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  SetLocalInt(oPC, "nCnrJournalOffset", 1);

  // init some things for the DM xp altering menus
  SetLocalInt(oPC, "bCnrDMAdjustingXP", FALSE);
  SetLocalInt(oPC, "nCnrXpMenuPage", 0);

  SetLocalInt(oPC, "bCnrTopTenVisible", FALSE);
  return TRUE;
}


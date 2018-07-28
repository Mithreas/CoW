/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_trade
//
//  Desc:  Show this trade be shown in the journal? If
//         so, update the custom token
//
//  Author: David Bobeck 17Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nOffset = GetLocalInt(oPC, "nCnrJournalOffset");
  SetLocalInt(oPC, "nCnrJournalOffset", nOffset+1);
  return CnrJournalIsTradeVisible(nOffset);
}


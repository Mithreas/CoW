/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_j_sel_8
//
//  Desc:  This script is run by the cnr_c_journal convo
//         when the player selects a trade.
//
//  Author: David Bobeck 03May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(oPC, "oCnrJournalTarget");

  int bDMAdjustingXP = GetLocalInt(oPC, "bCnrDMAdjustingXP");
  if (bDMAdjustingXP == TRUE)
  {
    int nMenuPage = GetLocalInt(oPC, "nCnrXpMenuPage");
    int nTradeskillIndex = GetLocalInt(oPC, "nCnrAdjustingTradeIndex");
    int nXP;
    if (nMenuPage == 0)
    {
      // Level 8
      nXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(8));
    }
    else if (nMenuPage == 1)
    {
      // Level 18
      nXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(18));
    }
    else
    {
      // - 100
      nXP = CnrGetTradeskillXPByIndex(oTarget, nTradeskillIndex);
      nXP -= 100;
    }

    CnrSetTradeskillXPByIndex(oTarget, nTradeskillIndex, nXP);
    return;
  }

  int bTopTenVisible = GetLocalInt(oPC, "bCnrTopTenVisible");
  if (bTopTenVisible == FALSE)
  {
    SetLocalInt(oPC, "nCnrJournalSelIndex", 8);
  }
}

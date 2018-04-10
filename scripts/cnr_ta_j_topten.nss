/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_topten
//
//  Desc:  Show the selected trade's top ten list.
//
//  Author: David Bobeck 10May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nSelIndex = GetLocalInt(oPC, "nCnrJournalSelIndex");

  if (GetIsDM(oPC))
  {
    SetLocalInt(oPC, "bCnrDMAdjustingXP", TRUE);
    return CnrJournalBuildXpAdjustMenu(nSelIndex);
  }

  SetLocalInt(oPC, "bCnrDMAdjustingXP", FALSE);
  if (CNR_BOOL_HIDE_TRADE_JOURNALS_TOP_TEN_LISTS == TRUE) return FALSE;
  
  SetLocalInt(oPC, "bCnrTopTenVisible", TRUE);
  return CnrJournalBuildTopTenList(nSelIndex);
}

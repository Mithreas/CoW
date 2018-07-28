/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_b_prev
//
//  Desc:  Should the "Prev" menu item be shown.
//
//  Author: David Bobeck 08Jan03
//
/////////////////////////////////////////////////////////
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if (GetLocalInt(oPC, "nCnrMenuPage") > 0)
  {
    return TRUE;
  }
  return FALSE;
}


/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_r_prev
//
//  Desc:  Should the "Prev" menu item be shown.
//
//  Author: David Bobeck 08Dec02
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

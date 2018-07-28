/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_tok_22000
//
//  Desc:  Updates the custom token 22000.
//
//  Author: David Bobeck 24May03
//
/////////////////////////////////////////////////////////
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sTokenText = GetLocalString(oPC, "sCnrTokenText22000");
  SetCustomToken(22000, sTokenText);
  DeleteLocalString(oPC, "sCnrTokenText22000");
  return TRUE;
}

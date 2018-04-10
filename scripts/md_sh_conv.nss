//Opens zz_co_shsign conversation when starting the shop conversation
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  SetLocalString(oPC, "zzdlgCurrentDialog", "zz_co_shsign");
  ActionStartConversation(oPC, "zzdlg_conv", TRUE, FALSE);
  return FALSE;
}

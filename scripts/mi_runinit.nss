// Used for the lever in the entry area in case the onenter scripts mess up
// for a new character (it happens - lag).
void main()
{
  object oPC = GetLastUsedBy();

  if (GetIsDM(oPC) || GetIsDMPossessed(oPC) || GetHitDice(oPC) > 1) return;
  SendMessageToPC(oPC, "Please wait, initialising...");
  ExecuteScript( "gs_run_pc_init", oPC);
}

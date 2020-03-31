void main()
{
  object oPC = GetEnteringObject();
  
  if (!GetIsPC(oPC)) return;
  
  SetLocalInt(oPC, "AVVT_DAIS", TRUE);
  
  AssignCommand(GetObjectByTag("avvt_scribe"), SpeakString("Step down from the dais, please."));
}
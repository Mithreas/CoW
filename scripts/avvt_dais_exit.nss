void main()
{
  object oPC = GetExitingObject();
  
  if (!GetIsPC(oPC)) return;
  
  DeleteLocalInt(oPC, "AVVT_DAIS");
  
  AssignCommand(GetObjectByTag("avvt_scribe"), SpeakString("Thank you."));
}
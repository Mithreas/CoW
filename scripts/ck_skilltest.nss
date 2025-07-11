/*
  Do a skill test against SKILL with dc DC.
  SKILL and DC to be set as script parameters on the call.
  Returns 1 if the check passes, 0 otherwise.
*/
#include "inc_chat"

int StartingConditional()
{
  int nSkill = StringToInt(GetScriptParam("SKILL"));
  int nDC    = StringToInt(GetScriptParam("DC"));
  
  object oPC = GetPCSpeaker();
  
  int nRoll  = d20();
  string sMessage = IntToString(nRoll) + " + " + IntToString(GetSkillRank(nSkill, oPC)) + " vs DC " + IntToString(nDC) + "</c>";
  
  if (nRoll + GetSkillRank(nSkill, oPC) >= nDC)
  {
    SendMessageToPC(oPC, txtGreen + "Check passed: " + sMessage);
	return TRUE;
  }
  else
  {
    SendMessageToPC(oPC, txtRed + "Check failed: " + sMessage);
    return FALSE;
  }
}
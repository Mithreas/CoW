#include "zdlg_include_i"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oSign = OBJECT_SELF;
  SetLocalString(oSign, VAR_SCRIPT, "zdlg_quarter");
  AssignCommand(oPC, ActionStartConversation(oSign, "zdlg_converse", TRUE, FALSE));
  //StartDlg(oPC, oSign, "zdlg_quarter", TRUE, FALSE);
  return FALSE;
}

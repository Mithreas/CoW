#include "inc_zdlg"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oSign = OBJECT_SELF;


  SetLocalString(oSign, VAR_SCRIPT, "zdlg_temple" );
  AssignCommand(oPC, ActionStartConversation(oSign, "zdlg_converse", TRUE, FALSE));
  //StartDlg(oPC, oSign, "zdlg_quarter", TRUE, FALSE);
  return FALSE;
}

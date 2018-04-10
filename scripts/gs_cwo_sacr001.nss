#include "zzdlg_tools_inc"
int StartingConditional()
{
  object oSpeaker = GetPCSpeaker();
  object oAltar = OBJECT_SELF;
  AssignCommand(oSpeaker, ActionDoCommand(_dlgStart(oSpeaker, oAltar, "zz_co_sacrifice", TRUE, TRUE)));

  return FALSE;
}

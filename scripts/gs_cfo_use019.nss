#include "zzdlg_main_inc"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oBoard = OBJECT_SELF;
  AssignCommand(oPC,
                ActionDoCommand(_dlgStart(oPC, oBoard, "zz_co_forum", TRUE, TRUE)));
  return FALSE;
}


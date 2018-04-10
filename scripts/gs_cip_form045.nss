#include "zzdlg_main_inc"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  _dlgStart(oPC, oPC, "zz_co_form", 1, 1);
  return TRUE;
}

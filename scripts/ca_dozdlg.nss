#include "inc_zdlg"
void main()
{
  object oPC = GetPCSpeaker();
  object oNPC = OBJECT_SELF;
  string sDialog = GetLocalString(oNPC, "dialog");
  StartDlg(oPC, oNPC, sDialog);
}

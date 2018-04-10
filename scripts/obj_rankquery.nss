/*
  obj_rankquery
  Displays the current faction rank of all logged on PCs.
*/
#include "x2_inc_switches"
#include "zdlg_include_i"

void main()
{
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { return; }

  object oPC   = GetItemActivatedTarget();
  object oDM   = GetItemActivator();
  object oItem = GetItemActivated();
  SetLocalObject(oItem, "TARGET", oPC);
  StartDlg( oDM, oItem, "zdlg_dmwand", TRUE, FALSE );
}

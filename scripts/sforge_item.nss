// This is an item script that starts the soulforging conversation with the
// PC.
#include "zdlg_include_i"
#include "x2_inc_switches"
#include "sforge_include"
void main()
{
  // If this item was used...
  if (GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_ACTIVATE)
  {
    object oPC = GetItemActivator();
    object oItem = GetItemActivatedTarget();

    if (GetObjectType(oItem) != OBJECT_TYPE_ITEM)
    {
      SendMessageToPC(oPC, "You must target an item.");
    }
    else
    {
      Trace(SOULFORGING, "Targetted item: " + GetName(oItem));
      SendMessageToPC(oPC, "You begin work.");
      SetLocalObject(oPC, SOULFORGE_ITEM, oItem);
      StartDlg(oPC, GetItemActivated(), "zdlg_soulforge", TRUE);
    }
  }
}

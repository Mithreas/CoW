/*
  Name: obj_praywidg
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the praying widget.
*/
#include "mi_log"
#include "x2_inc_switches"
const string TRAINING = "TRAINING";
void main()
{
  // If this script was called in an acquire routine, run away.
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { Trace(TRAINING, "Praying object not used"); return; }

  Trace(TRAINING, "Praying Widget Used");
  object oPC = GetItemActivator();

  // If already praying, ignore this use.
  location lPrayLoc = GetLocalLocation(oPC, "pray_location");
  if (GetIsObjectValid(GetAreaFromLocation(lPrayLoc)))
  {
    // PC is already praying and gaining XP from the heartbeat script.
    // So return.
    return;
  }

  Trace(TRAINING, "Calling ExecuteScript");
  DelayCommand(6.0, ExecuteScript("mi_prayhb", oPC));

  location lPCLocation = GetLocation(oPC);
  SetLocalLocation(oPC, "pray_location", lPCLocation);
  // Unequip weapons if holding them.
  object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  if (GetIsObjectValid(oItem))
  {
    AssignCommand(oPC, ActionUnequipItem(oItem));
  }

  oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if (GetIsObjectValid(oItem))
  {
    AssignCommand(oPC, ActionUnequipItem(oItem));
  }


  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 60.0));
}


/*
  Name: mi_draincharges
  Author: Mithreas
  Version: 1.0
  Date: 4 Sep 05

  Description: One of a pair of scripts. They work together to allow an item to
               suck charges from other IG items, and give them to other items.
               Note - cannot recharge items past their maximum.

               This is the script to take charges. It takes a target item and
               moves all charges from that item to the charger.
*/
#include "mi_xfercharges"
void main()
{
  //----------------------------------------------------------------------------
  // Set up local variables - references to both items, the PC, and the
  // current number of charges of both items.
  //----------------------------------------------------------------------------
  object oPC                      = GetItemActivator();
  object oRecharger               = GetItemPossessedBy(oPC, "mi_recharge");
  object oTargetItem              = GetItemActivatedTarget();

  if (oRecharger == OBJECT_INVALID)
  {
    //--------------------------------------------------------------------------
    // The PC doesn't have a recharger.
    //--------------------------------------------------------------------------
    SendMessageToPC(oPC, "You do not have a recharger to store charge in!");
  }
  else
  {
    //--------------------------------------------------------------------------
    // Transfer charges and tell the PC.
    //--------------------------------------------------------------------------
    TransferCharges(oTargetItem, oRecharger);
    SendMessageToPC(oPC, "Item drained.");
  }
}

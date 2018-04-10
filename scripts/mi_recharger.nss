//This method should be an include in both the scripts below.
/*
  TransferCharges - moves as many charges from oFrom to oTo as possible (up to
                    as many as oFrom has, or oTo can take, whichever is smaller)
*/
void TransferCharges(object oFrom, object oTo)
{
  int    nTargetCurrentCharges  = GetItemCharges(oTo);
  int    nChargerCurrentCharges = GetItemCharges(oFrom);

  //----------------------------------------------------------------------------
  // Calculate the number of charges we want the item being charged to have, and
  // set its current charges accordingly. However, we might try and set the
  // item to have more charges than its maximum. In this case, we'll only set it
  // to the item's maximum.
  //----------------------------------------------------------------------------
  int nCharges = nTargetCurrentCharges + nChargerCurrentCharges;
  SetItemCharges(oTo, nCharges);

  //----------------------------------------------------------------------------
  // Work out how many charges we've given away. This will equal
  // nRechargerCurrentCharges if we didn't hit the maximum number for the
  // target item.
  //----------------------------------------------------------------------------
  int nChargesTransferred = GetItemCharges(oTo) - nTargetCurrentCharges;

  //----------------------------------------------------------------------------
  // Set the charges of the recharger item to its original number of charges
  // minus the number transferred. This will be zero if we didn't hit the
  // maximum on the item being charged.
  //----------------------------------------------------------------------------
  SetItemCharges(oFrom, (nChargerCurrentCharges - nChargesTransferred));
}

/*
  Name: mi_recharge
  Author: Mithreas
  Version: 1.0
  Date: 4 Sep 05

  Description: One of a pair of scripts. They work together to allow an item to
               suck charges from IG items, and give them to other items.
               Note - cannot recharge items past their maximum.

               This is the script to give charges. It takes a target item and
               moves all charges from itself to that item.
*/

void main()
{
  //----------------------------------------------------------------------------
  // Set up local variables - references to both items, the PC, and the
  // current number of charges of both items.
  //----------------------------------------------------------------------------
  object oPC                      = GetItemActivator();
  object oRecharger               = GetItemActivated();
  object oTargetItem              = GetItemActivatedTarget();

  //----------------------------------------------------------------------------
  // Transfer charges and tell the PC.
  //----------------------------------------------------------------------------
  TransferCharges(oRecharger, oTargetItem);
  SendMessageToPC(oPC, "Item charged.");
}


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
void main2()
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

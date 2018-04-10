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


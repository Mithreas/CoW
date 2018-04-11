// some functions for stores

// checks if an item is allowed in stores / merchants, returns 1 is allowed, 0 if not (this is resref based)
int gvd_ItemAllowedInStores(object oCheck);


// checks if an item is allowed in stores / merchants, returns 1 is allowed, 0 if not (this is resref based)
int gvd_ItemAllowedInStores(object oCheck) {

  // loop through all items in the exclusion chest
  object oExclusion = GetObjectByTag("GVD_MERCHANT_EXCLUDE");

  if (oExclusion != OBJECT_INVALID) {

    string sResRef = GetResRef(oCheck);
    object oItem = GetFirstItemInInventory(oExclusion);

    while (GetIsObjectValid(oItem)) {

      if (GetResRef(oItem) == sResRef) {
        return 0;
      }

      oItem = GetNextItemInInventory(oExclusion);
    }

  }

  return 1;

}


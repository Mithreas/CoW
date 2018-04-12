// include file that has a couple of functions related to seeds

// info taken from gs_m_unaquire:
// the seed items tag = GS_FX_ + the crop placeable resref
// when a PC plants a seed, the fixture will get the following tag: GS_FX_ + seed item resref
// only the seed item resrefs are consistently starting with "seeds", the placeable resrefs, and therefore the item tags are not consistent and can't be used reliably

// checks if an oItem is a seed
int gvd_GetItemIsSeed(object iItem);

// checks if oPlaceable is a fixture grown from a seed (placed by PC)
int gvd_GetPlaceableIsSeed(object oPlaceable);

// get the crop area oPC is in
object gvd_GetCropAreaForPC(object oPC);

// get current qty of PC planted crops in trigger oCropArea
int gvd_GetQtyInCropArea(object oCropArea);

// check if oSeed item (that was dropped) is inside trigger oCropArea
int gvd_GetItemInCropArea(object oCropArea, object oSeed);

// checks if oSeed can be planted at oPC's current location
int gvd_GetSeedAllowed(object oPC, object oSeed);

// loop through all PC planted crops inside all Crop triggers inside oArea and remove the exhausted flags from them (baring in mind the maximum for each trigger)
void gvd_ActivateCropAreas(object oArea);


int gvd_GetItemIsSeed(object oItem) {

  // all seed items have a resref starting with "seeds"
  if (GetStringLeft(GetResRef(oItem),5) == "seeds") {
    return 1;
  } else {
    return 0;
  }

}

int gvd_GetPlaceableIsSeed(object oPlaceable) {

  // player created crops get a new tag in gs_m_unaquire starting with GS_FX_ and then the item resref, which always starts with "seeds"
  // note: crop placeables placed out by devs in the toolset with have the default tag GS_PLACEABLE, so this function only returns true for player created ones (Which is good)
  if (GetStringLeft(GetTag(oPlaceable), 11) == "GS_FX_seeds") {
    return 1;
  } else {
    return 0;
  }
}

object gvd_GetCropAreaForPC(object oPC) {

  return GetLocalObject(oPC, "GVD_CROP_AREA");
}

int gvd_GetQtyInCropArea(object oCropArea) {

  int iQty = 0;
  object oPlaceable = GetFirstInPersistentObject(oCropArea, OBJECT_TYPE_PLACEABLE);
 
  while (oPlaceable != OBJECT_INVALID) {

    // PC created crop fixture?
    if (gvd_GetPlaceableIsSeed(oPlaceable) == 1) {
      iQty = iQty + 1;
    }
 
    oPlaceable = GetNextInPersistentObject(oCropArea, OBJECT_TYPE_PLACEABLE);
  }

  return iQty;

}

int gvd_GetItemInCropArea(object oCropArea, object oSeed) {

  object oItem = GetFirstInPersistentObject(oCropArea, OBJECT_TYPE_ITEM);
 
  while (oItem != OBJECT_INVALID) {

    // oSeed item?
    if (oItem == oSeed) {
      return 1;
    }
 
    oItem = GetNextInPersistentObject(oCropArea, OBJECT_TYPE_ITEM);
  }

  return 0;

}

int gvd_GetSeedAllowed(object oPC, object oSeed) {

  if (gvd_GetItemIsSeed(oSeed) == 0) {
    // no seed, return true
    return 1;
  }

  if (GetIsDM(oPC) == 1) {
    // DMs can plant whereever they want
    return 1;
  }

  // fixed level server doesn't use the fertile areas
  if (GetLocalInt(GetModule(), "STATIC_LEVEL")) {
    return 1;
  }

  object oCropArea = gvd_GetCropAreaForPC(oPC);

  // inside valid crop area?
  if (oCropArea == OBJECT_INVALID) {
    SendMessageToPC(oPC, "<cþ  >This soil is not suitable for planting seeds.");
    return 0;
  }

  // seed item also dropped inside the trigger area (check this to make sure, PCs are not standing inside the trigger and planting just outside it)
  if (gvd_GetItemInCropArea(oCropArea, oSeed) == 0) {
    SendMessageToPC(oPC, "<cþ  >This soil is not suitable for planting seeds.");
    return 0;
  }
 
  // seed excluded from crop area?
  string sResRef = GetResRef(oSeed);
  if (GetLocalInt(oCropArea, "GVD_NO_" + GetStringRight(sResRef, GetStringLength(sResRef) - 5)) == 1) {
    SendMessageToPC(oPC, "<cþ  >This soil is not suitable for planting this type of seed.");
    return 0;
  }
  
  // check if maximum for this trigger is reached
  if (GetLocalInt(oCropArea, "GVD_MAX_CROPS") > gvd_GetQtyInCropArea(oCropArea)) { 
    return 1;  
  } else {
    SendMessageToPC(oPC, "<cþ  >This land if fully planted.");
    return 0;
  }

}


void gvd_ActivateCropAreas(object oArea) {

  // find crop trigger areas
  int iTrigger = 1;
  object oObjectInArea = GetFirstObjectInArea(oArea);
  object oCropTrigger =  GetNearestObjectByTag("gvd_tr_crop", oObjectInArea, iTrigger);
  object oCrop;
  int iMaxCrops; 

  while (oCropTrigger != OBJECT_INVALID) {

    // get max allowed crops for this trigger
    iMaxCrops = GetLocalInt(oCropTrigger, "GVD_MAX_CROPS");
    
    // loop through all placeables inside the trigger, and remove the withered flag from the first iMaxCrops PC seeded plants
    oCrop = GetFirstInPersistentObject(oCropTrigger, OBJECT_TYPE_PLACEABLE);
    while (oCrop != OBJECT_INVALID) {

      // is PC planted crop?
      if (gvd_GetPlaceableIsSeed(oCrop) == 1) {

        if (iMaxCrops > 0) {

          DeleteLocalInt(oCrop, "GVD_WITHERED");
          iMaxCrops = iMaxCrops - 1;
        }
      }

      // next placeable
      oCrop = GetNextInPersistentObject(oCropTrigger, OBJECT_TYPE_PLACEABLE);
    }
    
    // next crop trigger
    iTrigger = iTrigger + 1;
    oCropTrigger = GetNearestObjectByTag("gvd_tr_crop", oObjectInArea, iTrigger);
  }
}


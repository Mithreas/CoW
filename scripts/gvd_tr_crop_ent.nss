void main()
{
  object oPC = GetEnteringObject();

  if (GetIsPC(oPC)) {
    SetLocalObject(oPC, "GVD_CROP_AREA", OBJECT_SELF);

    string sFlavor = GetLocalString(OBJECT_SELF, "GVD_FLAVOR");
    if (sFlavor != "") {
      SendMessageToPC(oPC, sFlavor);
    }
  }
}


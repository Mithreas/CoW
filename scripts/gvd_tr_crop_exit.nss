void main()
{

  object oPC = GetExitingObject();

  if (GetIsPC(oPC)) {
    DeleteLocalObject(oPC, "GVD_CROP_AREA");
  }

}

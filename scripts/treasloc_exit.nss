void main()
{

  // leave treasure area
  object oPC = GetExitingObject();

  // set treasure variable on player
  DeleteLocalInt(oPC,"treasure_area");


}

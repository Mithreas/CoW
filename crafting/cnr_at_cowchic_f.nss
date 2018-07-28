/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_cowchic_f
//
//  Desc:  The player has requested some of the animals
//         food.
//
//  Author: David Bobeck 24Dec02
//
/////////////////////////////////////////////////////////
void main()
{
  string sAnimalTag = GetTag(OBJECT_SELF);
  object oPC = GetPCSpeaker();

  if (sAnimalTag == "cnrChicken")
  {
    // produce an egg
    string sItemTag = "cnrChickenEgg";
    CreateItemOnObject(sItemTag, oPC, 1);
  }

  if (sAnimalTag == "cnrCow")
  {
    // produce milk
    string sItemTag = "cnrCowsMilk";
    CreateItemOnObject(sItemTag, oPC, 1);
  }

  int nFoodPoints = GetLocalInt(OBJECT_SELF, "nCnrFoodPoints");
  SetLocalInt(OBJECT_SELF, "nCnrFoodPoints", nFoodPoints-6);
}

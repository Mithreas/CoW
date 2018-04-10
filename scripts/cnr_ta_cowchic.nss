/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_cowchic
//
//  Desc:  Alters the greeting text to denote whether
//         the animal has consumed enough food to
//         produce its resource.
//
//  Author: David Bobeck 24Dec02
//
/////////////////////////////////////////////////////////
int StartingConditional()
{
  SetCustomToken(500, "\n");

  int nFoodPoints = GetLocalInt(OBJECT_SELF, "nCnrFoodPoints");

  if (GetTag(OBJECT_SELF) == "cnrChicken")
  {
    if (nFoodPoints >= 6)
    {
      SetCustomToken(22020, "This chicken has been fed well. It appears ready to yield an egg!");
    }
    else
    {
      SetCustomToken(22020, "This chicken is hungry and must be fed. It is not capable of yielding eggs at this time.");
    }
  }
  if (GetTag(OBJECT_SELF) == "cnrCow")
  {
    if (nFoodPoints >= 6)
    {
      SetCustomToken(22020, "This cow has been fed well. It appears ready to yield milk!");
    }
    else
    {
      SetCustomToken(22020, "This cow is hungry and must be fed. It is not capable of yielding milk at this time.");
    }
  }

  // Always show something
  return TRUE;
}

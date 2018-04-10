/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_cow_userdef
//
//  Desc:  This is a custom handler for the cnrCow's
//         OnUserDefined event. User event 2701 will be
//         fired by the module whenever cow food is
//         dropped in the vicinity of this cow. The
//         cow will move to the food and eat it. After
//         eating enough food, the cow yield a
//         cnrCowMilk item.
//
//  Author: David Bobeck 23Dec02
//
/////////////////////////////////////////////////////////
void EatCowFeed(object oItem, int nPoints)
{
  // We must check the item because other cows may have
  // reached and eaten the feed first.
  if (GetIsObjectValid(oItem))
  {
    DestroyObject(oItem);
    int nFoodPoints = GetLocalInt(OBJECT_SELF, "nCnrFoodPoints") + nPoints;
    SetLocalInt(OBJECT_SELF, "nCnrFoodPoints", nFoodPoints);

    if (nFoodPoints >= 6)
    {
      ActionDoCommand(PlaySound("as_an_cow1"));
    }
  }
}

void main()
{
  int nEventNumber = GetUserDefinedEventNumber();
  if (nEventNumber == 2701) // food has been dropped
  {
    location locFood;
    int bFoodFound = FALSE;
    int nFoodPoints = 0;

    // locate the nearest cow food item and move to it.
    object oItem = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_ITEM);
    while ((oItem != OBJECT_INVALID) && !bFoodFound)
    {
      if (GetTag(oItem) == "cnrWheatRaw")
      {
        nFoodPoints = 2;
        bFoodFound = TRUE;
      }
      else if (GetTag(oItem) == "cnrBarleyRaw")
      {
        nFoodPoints = 1;
        bFoodFound = TRUE;
      }
      else if (GetTag(oItem) == "cnrOatsRaw")
      {
        nFoodPoints = 1;
        bFoodFound = TRUE;
      }
      else if (GetTag(oItem) == "cnrRyeRaw")
      {
        nFoodPoints = 1;
        bFoodFound = TRUE;
      }
      else if (GetTag(oItem) == "cnrCornRaw")
      {
        nFoodPoints = 1;
        bFoodFound = TRUE;
      }

      if (bFoodFound)
      {
        ActionMoveToLocation(GetLocation(oItem), FALSE);
        ActionDoCommand(EatCowFeed(oItem, nFoodPoints));
      }
      else
      {
        oItem = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_ITEM);
      }
    }

    if (bFoodFound)
    {
      // keep looking for more food
      event eUserDef = EventUserDefined(2701);
      ActionDoCommand(SignalEvent(OBJECT_SELF, eUserDef));
    }
  }
}


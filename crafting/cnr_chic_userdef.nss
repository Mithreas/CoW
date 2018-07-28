/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_chic_userdef
//
//  Desc:  This is a custom handler for the cnrChicken's
//         OnUserDefined event. User event 2701 will be
//         fired by the module whenever chicken food is
//         dropped in the vicinity of this chicken. The
//         chicken will move to the food and eat it. After
//         eating enough food, the chicken will produce
//         a cnrChickenEgg.
//
//  Author: David Bobeck 23Dec02
//
/////////////////////////////////////////////////////////
void EatChickenFeed(object oItem, int nPoints)
{
  // We must check the item because other chickens may have
  // reached and eaten the feed first.
  if (GetIsObjectValid(oItem))
  {
    DestroyObject(oItem);
    int nFoodPoints = GetLocalInt(OBJECT_SELF, "nCnrFoodPoints") + nPoints;
    SetLocalInt(OBJECT_SELF, "nCnrFoodPoints", nFoodPoints);

    if (nFoodPoints >= 6)
    {
      ActionDoCommand(PlaySound("as_an_chickens1"));
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

    // locate the nearest chicken food item and move to it.
    object oItem = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_ITEM);
    while (GetIsObjectValid(oItem) && !bFoodFound)
    {
      if (GetTag(oItem) == "cnrCornRaw")
      {
        ActionMoveToLocation(GetLocation(oItem), TRUE);
        ActionDoCommand(EatChickenFeed(oItem, 1));
        bFoodFound = TRUE;
      }
      else if (GetTag(oItem) == "cnrCornMeal")
      {
        ActionMoveToLocation(GetLocation(oItem), TRUE);
        ActionDoCommand(EatChickenFeed(oItem, 3));
        bFoodFound = TRUE;
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


/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR)
//
//  Name:  cnr_cowchic_oui
//
//  Desc:  This script notifies cows and chickens
//         within a radius of 20 meters of dropped feed.
//         This script should be executed from the
//         module's OnUnAquireItem handler.
//
//  Author: David Bobeck 24Dec02
//
/////////////////////////////////////////////////////////
void main()
{
  object oItem = GetModuleItemLost();

  int bAlertChickens = FALSE;
  int bAlertCows = FALSE;
  if (GetTag(oItem) == "cnrCornMeal")
  {
    bAlertChickens = TRUE;
    bAlertCows = TRUE;
  }
  else if (GetTag(oItem) == "cnrCornRaw")
  {
    bAlertChickens = TRUE;
  }
  else if (GetTag(oItem) == "cnrBarleyRaw")
  {
    bAlertCows = TRUE;
  }
  else if (GetTag(oItem) == "cnrOatsRaw")
  {
    bAlertCows = TRUE;
  }
  else if (GetTag(oItem) == "cnrRyeRaw")
  {
    bAlertCows = TRUE;
  }
  else if (GetTag(oItem) == "cnrWheatRaw")
  {
    bAlertCows = TRUE;
  }

  if (bAlertChickens)
  {
    // find all chickens within 20 meters of the dropped food
    object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oItem), FALSE, OBJECT_TYPE_CREATURE);
    while (oCreature != OBJECT_INVALID)
    {
      if (GetTag(oCreature) == "cnrChicken")
      {
        // alert the chicken that feed has been dropped near bye
        event eUserDef = EventUserDefined(2701);
        SignalEvent(oCreature, eUserDef);
      }
      oCreature = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oItem), FALSE, OBJECT_TYPE_CREATURE);
    }
  }

  if (bAlertCows)
  {
    // find all cows within 20 meters of the dropped food
    object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oItem), FALSE, OBJECT_TYPE_CREATURE);
    while (oCreature != OBJECT_INVALID)
    {
      if (GetTag(oCreature) == "cnrCow")
      {
        // alert the cows that feed has been dropped near bye
        event eUserDef = EventUserDefined(2701);
        SignalEvent(oCreature, eUserDef);
      }
      oCreature = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oItem), FALSE, OBJECT_TYPE_CREATURE);
    }
  }
}

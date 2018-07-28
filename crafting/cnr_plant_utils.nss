/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_plant_utils
//
//  Desc:  This is an include file. These funtions are
//         for CNR plant placeables.
//
//  Author: David Bobeck 12Dec02
//
/////////////////////////////////////////////////////////

int CNR_INT_ALWAYS_RESPAWN_FRUIT = 1;
int CNR_INT_ALWAYS_RESPAWN_PLANT = 2;


/////////////////////////////////////////////////////////
//  sPlantTag = the tag of the plant placeable.
//  sFruitTag = the tag of the item the plant will yield and spawn.
//  nMaxQty = a random number of fruit between 1 and nMaxQty will be spawned.
//  fSpawnSecs = the time a plant waits, after its inventory has been depleted,
//               before spawning more fruit.
//  nSpawnMode = 0: mode will be determined by CNR_BOOL_RESPAWN_PLANTS_NOT_FRUIT
//                  config setting.
//               CNR_INT_ALWAYS_RESPAWN_FRUIT: overrides config setting.
//               CNR_INT_ALWAYS_RESPAWN_PLANT: overrides config setting.
/////////////////////////////////////////////////////////
void CnrPlantInitialize(string sPlantTag, string sFruitTag, int nMaxQty, float fSpawnSecs, int nSpawnMode = 0);
/////////////////////////////////////////////////////////
void CnrPlantInitialize(string sPlantTag, string sFruitTag, int nMaxQty, float fSpawnSecs, int nSpawnMode = 0)
{
  SetLocalString(GetModule(), sPlantTag + "_FruitTag", sFruitTag);
  SetLocalInt(GetModule(), sPlantTag + "_FruitMax", nMaxQty);
  SetLocalFloat(GetModule(), sPlantTag + "_SpawnSecs", fSpawnSecs);
  SetLocalInt(GetModule(), sPlantTag + "_SpawnMode", nSpawnMode);
}

/////////////////////////////////////////////////////////
void CnrPlantCreateFruitItem(object oPlant, string sFruitTag, int nMaxQty)
{
  int nCount = Random(nMaxQty) + 1;
  int n;
  for (n=0; n<nCount; n++)
  {
    CreateItemOnObject(sFruitTag, oPlant);
  }
}

/////////////////////////////////////////////////////////
void CnrPlantOnDisturbed(string sFruitTag, int nMaxQty, float fSpawnSecs)
{
  object oPC = GetLastDisturbed();
  if (GetIsObjectValid(oPC) && GetIsPC(oPC))
  {
    object oItem = GetInventoryDisturbItem();
    if (GetIsObjectValid(oItem))
    {
      int nDisturbType = GetInventoryDisturbType();
      if (nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED)
      {
        // If all the food is gone, spawn more
        oItem = GetFirstItemInInventory();
        if (oItem == OBJECT_INVALID)
        {
          DelayCommand(fSpawnSecs, CnrPlantCreateFruitItem(OBJECT_SELF, sFruitTag, nMaxQty));
        }
      }
      else if (nDisturbType == INVENTORY_DISTURB_TYPE_ADDED)
      {
        // Cannot add to inventory of plant
        AssignCommand(oPC, ActionTakeItem(oItem, OBJECT_SELF));
      }
    }
  }
}


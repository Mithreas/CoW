/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_plant_ondist
//
//  Desc:  This is the OnDisturbed script for CNR plant
//         placeables. Spawns CNR fruit items.
//
//  Author: David Bobeck 12Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_plant_utils"
#include "cnr_config_inc"

void SpawnNewPlant(string sPlantTag, location locPlant)
{
  object oPlant = CreateObject(OBJECT_TYPE_PLACEABLE, sPlantTag, locPlant);
  SetLocalInt(oPlant, "GS_STATIC", TRUE);
  DestroyObject(OBJECT_SELF);
}

void main()
{
  string sPlantTag = GetTag(OBJECT_SELF);
  float fSpawnSecs = GetLocalFloat(GetModule(), sPlantTag + "_SpawnSecs");
  int nSpawnMode = GetLocalInt(GetModule(), sPlantTag + "_SpawnMode");

  int bRespawnThisPlant = FALSE;
  if (nSpawnMode == CNR_INT_ALWAYS_RESPAWN_PLANT)
  {
    bRespawnThisPlant = TRUE;
  }
  else if (nSpawnMode == CNR_INT_ALWAYS_RESPAWN_FRUIT)
  {
    bRespawnThisPlant = FALSE;
  }
  else if ((CNR_BOOL_RESPAWN_PLANTS_NOT_FRUIT == TRUE) && (fSpawnSecs != 0.0))
  {
    bRespawnThisPlant = TRUE;
  }

  if (bRespawnThisPlant)
  {  
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    if (oItem == OBJECT_INVALID)
    {
      // if empty, so destroy and respawn the plant
      location locPlant = GetLocation(OBJECT_SELF);
      object oSpawner = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrobjectspawner", locPlant);
	  SetLocalInt(oSpawner, "GS_STATIC", TRUE);
      AssignCommand(oSpawner, DelayCommand(fSpawnSecs, SpawnNewPlant(sPlantTag, locPlant)));
      DestroyObject(OBJECT_SELF);
      return;
    }
  }
  else
  {
    string sFruitTag = GetLocalString(GetModule(), sPlantTag + "_FruitTag");
    int nMaxQty = GetLocalInt(GetModule(), sPlantTag + "_FruitMax");
    CnrPlantOnDisturbed(sFruitTag, nMaxQty, fSpawnSecs);
  }
}

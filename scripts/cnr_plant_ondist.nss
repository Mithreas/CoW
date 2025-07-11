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
#include "inc_common"
#include "inc_pc"
#include "inc_worship"

void SpawnNewPlant(string sPlantTag, location locPlant, string sTended = "")
{
  object oPlant = CreateObject(OBJECT_TYPE_PLACEABLE, sPlantTag, locPlant);
  SetLocalInt(oPlant, "GS_STATIC", TRUE);
  if (sTended != "") SetLocalInt(oPlant, sTended, TRUE);
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
  
  object oPC = GetLastDisturbed();
  string sTended = "TENDED_" + gsPCGetPlayerID(oPC);
  int bTended = FALSE;
  
    if ((GetLocalInt(OBJECT_SELF, "TENDED_TO") == 0) &&
	    (GetLocalInt(OBJECT_SELF, sTended) == 0) &&
        (GetLocalInt(gsPCGetCreatureHide(oPC), "GIFT_GREENFINGERS") || (
         gsWOGetDeityAspect(oPC) & ASPECT_NATURE &&
         (gsCMGetHasClass(CLASS_TYPE_RANGER, oPC) || gsCMGetHasClass(CLASS_TYPE_DRUID, oPC) ||
          gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC)))))
    {
      // Tend to the plant
      gsWOAdjustPiety(oPC, 1.0f);
      SetLocalInt(OBJECT_SELF, "TENDED_TO", 1);
	  
	  fSpawnSecs = 0.0f;
	  bRespawnThisPlant = TRUE;
	  bTended = TRUE;

      FloatingTextStringOnCreature("You tend to the plant, encouraging it to bloom once more.", oPC);
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
      AssignCommand(oSpawner, DelayCommand(fSpawnSecs, SpawnNewPlant(sPlantTag, locPlant, bTended ? sTended : "")));
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

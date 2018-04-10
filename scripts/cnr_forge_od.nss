/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_forge_od
//
//  Desc:  This OnDisturbed handler is meant to fix a Bioware
//         bug that sometimes prevents placeables from
//         getting OnOpen or OnClose events. This OnDisturbed
//         handler in coordination with the OnUsed
//         ("cnr_device_ou") handler work around the bug.
//
//  Author: David Bobeck 08Aug03
//
/////////////////////////////////////////////////////////
#include "cnr_config_inc"

/////////////////////////////////////////////////////////
float CnrNormalizeFacing(float fFacing)
{
  while (fFacing >= 360.0) fFacing -= 360.0;
  while (fFacing < 0.0) fFacing += 360.0;
  return fFacing;
}

void BurnUpTheCoal(object oFire, object oPlume1, object oPlume2)
{
  int nCoalCount = GetLocalInt(OBJECT_SELF, "CnrCoalCount") - 1;
  SetLocalInt(OBJECT_SELF, "CnrCoalCount", nCoalCount);
  if (nCoalCount > 0)
  {
    DelayCommand(CNR_FLOAT_FORGE_COAL_BURN_TIME, BurnUpTheCoal(oFire, oPlume1, oPlume2));
  }
  else
  {
    // the coal is gone, so put out the fire
    DestroyObject(oFire);
    DestroyObject(oPlume1);
    DestroyObject(oPlume2);

    object oSound = GetNearestObjectByTag("cnrForgeFire");
    if (oSound != OBJECT_INVALID)
    {
      SoundObjectStop(oSound);
    }
        
  }
}

void main()
{
  if (CNR_BOOL_FORGES_REQUIRE_COAL == FALSE)
  {
    SetLocalInt(OBJECT_SELF, "bCnrDisturbed", TRUE);
    return;
  }
  
  // check if any coal has been added
  object oItem = GetFirstItemInInventory();
  while (oItem != OBJECT_INVALID)
  {
    if (GetTag(oItem) == "cnrLumpOfCoal")
    {
      DestroyObject(oItem);
      int nCoalCount = GetLocalInt(OBJECT_SELF, "CnrCoalCount") + 1;
      SetLocalInt(OBJECT_SELF, "CnrCoalCount", nCoalCount);
      if (nCoalCount == 1)
      {
        // Create and position the fire
        location locForge = GetLocation(OBJECT_SELF);
        float fForgeFacing = GetFacingFromLocation(locForge);
        fForgeFacing = CnrNormalizeFacing(fForgeFacing);

        // Note: the Forge's arrow points the opposite direction of fForgeFacing.
        float fFireFacing = fForgeFacing + 180.0;
        fFireFacing = CnrNormalizeFacing(fFireFacing);

        // find a position and facing fDistance meters towards the back of the object.
        float fDistance = 0.4f;
        float fDistanceY = sin(fFireFacing) * fDistance;
        float fDistanceX = cos(fFireFacing) * fDistance;
        vector vFire = GetPosition(OBJECT_SELF);
        vFire.x = vFire.x - fDistanceX;
        vFire.y = vFire.y - fDistanceY;
        vFire.z = vFire.z + 0.2f;

        location locFire = Location(GetArea(OBJECT_SELF), vFire, fFireFacing);
        object oFire = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_flamesmall", locFire, FALSE);
        object oPlume1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_dustplume", locFire, FALSE);

        // Note: the Forge's arrow points the opposite direction of fForgeFacing.
        float fPlumeFacing = fForgeFacing + 135.0;
        fPlumeFacing = CnrNormalizeFacing(fPlumeFacing);

        // find a position and facing fDistance meters towards the back of the object.
        fDistance = 0.75f;
        fDistanceY = sin(fPlumeFacing) * fDistance;
        fDistanceX = cos(fPlumeFacing) * fDistance;
        vector vPlume = GetPosition(OBJECT_SELF);
        vPlume.x = vPlume.x - fDistanceX;
        vPlume.y = vPlume.y - fDistanceY;
        vPlume.z = vPlume.z + 3.2f;

        location locPlume = Location(GetArea(OBJECT_SELF), vPlume, 0.0);
        object oPlume2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_dustplume", locPlume, FALSE);
        
        object oSound = GetNearestObjectByTag("cnrForgeFire");
        if (oSound != OBJECT_INVALID)
        {
          SoundObjectPlay(oSound);
        }
        
        // the PC just put the first coal nugget into the forge
        DelayCommand(CNR_FLOAT_FORGE_COAL_BURN_TIME, BurnUpTheCoal(oFire, oPlume1, oPlume2));
      }
    }
    else
    {
      SetLocalInt(OBJECT_SELF, "bCnrDisturbed", TRUE);
    }
    oItem = GetNextItemInInventory();
  }
}

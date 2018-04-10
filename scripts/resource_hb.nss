#include "mi_resourcecomm"
// includes mi_repcomm, mi_crimcommon, mi_log and aps_include
const string RES_WP_TAG = "resource_area";
const string RES_WP_LIST = "resource_waypoint_list";

const string MAJOR_RESOURCE = "major_resource";
const string MINOR_RESOURCE = "minor_resource";
const string RESOURCE_CHEST = "resource_chest_";

// Clears all faction resource chests.
void ClearAllFactionResourceChests()
{
  int nFaction = 0;

  while (nFaction < 6)
  {
    object oChest = GetObjectByTag(RESOURCE_CHEST + IntToString(nFaction));

    if (GetIsObjectValid(oChest))
    {
      object oItem = GetFirstItemInInventory(oChest);

      while (GetIsObjectValid(oItem))
      {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oChest);
      }
    }

    nFaction++;
  }
}

// Gives resources from the area to the faction's resource chest.
void GiveResourcesToOwningFaction(object oWP)
{
  int nOwner = GetOwningFaction(GetArea(oWP));
  object oChest = GetObjectByTag(RESOURCE_CHEST + IntToString(nOwner));
  if (oChest == OBJECT_INVALID) return;

  string sMajorResource = GetLocalString(oWP, MAJOR_RESOURCE);
  string sMinorResource = GetLocalString(oWP, MINOR_RESOURCE);

  if (sMajorResource != "")
  {
    CreateItemOnObject(sMajorResource, oChest);
    CreateItemOnObject(sMajorResource, oChest);
    CreateItemOnObject(sMajorResource, oChest);
    CreateItemOnObject(sMajorResource, oChest);
    CreateItemOnObject(sMajorResource, oChest);
  }

  if (sMinorResource != "")
  {
    CreateItemOnObject(sMinorResource, oChest);
    CreateItemOnObject(sMinorResource, oChest);
  }
}

void main()
{
   // Clear the faction resource chests.
   ClearAllFactionResourceChests();

   // Determine who owns each area. Give them rep points and resources.
   int iCount = 0;
   object oWP = GetObjectByTag(RES_WP_TAG, iCount);

   while (GetIsObjectValid(oWP))
   {
     int nOwner = GetOwningFaction(GetArea(oWP));
     GivePointsToFaction(1, nOwner);
     GiveResourcesToOwningFaction(oWP);

     iCount++;
     oWP = GetObjectByTag(RES_WP_TAG, iCount);

     // Store the current owner.
     SetPersistentString(OBJECT_INVALID,
                         GetName(GetArea(oWP)),
                         GetFactionName(nOwner),
                         0,
                         "pwresourcedata");
   }

   // Lower each PC's piety score by 1 point.
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC))
   {
     if (!GetIsDM(oPC))
     {
       int nPietyPoints = GetPersistentInt(oPC, "points", "pc_piety_points");
       if (nPietyPoints > 0)
       {
         nPietyPoints--;
         SetPersistentInt(oPC, "points", nPietyPoints, 0, "pc_piety_points");
       }
     }
   }

   // Kick off this script to run again in an hour's time.
   DelayCommand(3600.0, ExecuteScript("resource_hb", OBJECT_SELF));
}

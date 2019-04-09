#include "inc_reputation"
// includes inc_crime, inc_log and inc_database
const string OWNER = "_owner";
const string RESOURCE = "RESOURCE"; // for logging
const string AREA_DB = "pwresourcedata";

const string RES_WP_TAG = "resource_area";
const string RES_WP_LIST = "resource_waypoint_list";

const string MAJOR_RESOURCE = "major_resource";
const string MINOR_RESOURCE = "minor_resource";
const string RESOURCE_CHEST = "resource_chest_";

// Returns true if PC's faction owns oArea.
int GetPCFactionOwnsArea(object oPC, object oArea);
// Returns true if there are no unaligned mercenaries in this area.
int CheckNoUnalignedMercenaries(object oArea);
// Returns true if the area has none of its owners present at the moment.
int CheckNoOwnersPresent(object oArea);
// Changes ownership of a resource to oPC's faction.
void ClaimResource(object oPC, object oArea);
// Gets current owning faction
int GetOwningFaction(object oArea);
// Clears out the resource chests, stopping infinity stockpiling.
void ClearAllFactionResourceChests();
// Sends resources to the owning faction's chest.
void GiveResourcesToOwningFaction(object oWP);
// Cycle through all resource areas, and distribute resources to their owners.
void DistributeResources();

int GetPCFactionOwnsArea(object oPC, object oArea)
{
  Trace(RESOURCE, "Checking if PC " +GetName(oPC)+ "'s faction owns " +GetName(oArea));

  if (GetPersistentInt(OBJECT_INVALID, GetTag(oArea)+OWNER) == miBAGetBackground(oPC))
  {
    Trace(RESOURCE, "PC's faction ("+IntToString(miBAGetBackground(oPC))+") owns area.");
    return 1;
  }
  else
  {
    Trace(RESOURCE, "PC's faction ("+IntToString(miBAGetBackground(oPC))+") doesn't own area.");
    return 0;
  }
}


int CheckNoUnalignedMercenaries(object oArea)
{
  object oObject = GetFirstObjectInArea(oArea);
  while (GetIsObjectValid(oObject))
  {
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
      if (GetIsPC(oObject))
      {
        int nFaction = miBAGetBackground(oObject);
        if (!nFaction)
        {
          Trace(RESOURCE, "Found unaligned PC. Returning false.");
          return FALSE;
        }
      }
      else
      {
        if (GetFaction(oObject) == FACTION_UNALIGNED_MERCS)
        {
          Trace(RESOURCE, "Found unaligned merc NPC. Returning false.");
          return FALSE;
        }
      }
    }

    oObject = GetNextObjectInArea(oArea);
  }

  return TRUE;
}

int CheckNoOwnersPresent(object oArea)
{
  Trace(RESOURCE, "Entered CheckNoOwnersPresent for "+GetName(oArea));
  int nOwner = GetPersistentInt(OBJECT_INVALID, GetTag(oArea)+OWNER);
  if (nOwner == 0)
  {
    if (CheckNoUnalignedMercenaries(oArea))
    {
      Trace(RESOURCE, "Area has no owner, returning true.");
      return TRUE;
    }
    else
    {
      Trace(RESOURCE, "Owned by unaligned faction and mercs are present.");
      return FALSE;
    }
  }

  object oObject = GetFirstObjectInArea(oArea);
  while (GetIsObjectValid(oObject))
  {
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
      if (GetIsPC(oObject))
      {
        int nFaction = miBAGetBackground(oObject);
        if (nFaction == nOwner)
        {
          Trace(RESOURCE,
                "Found PC of owner's faction("+GetName(oObject)+"). Returning false.");
          return FALSE;
        }
      }
      else
      {
        if (CheckFactionNation(oObject, TRUE) == nOwner)
        {
          Trace(RESOURCE,
                "Found NPC of owner's faction("+GetName(oObject)+"). Returning false.");
          return FALSE;
        }
      }
    }

    oObject = GetNextObjectInArea(oArea);
  }

  Trace(RESOURCE, "Found no-one from owner's faction. Returning true.");
  return TRUE;
}

void ClaimResource(object oPC, object oArea)
{
  if (!GetIsPC(oPC)) return;
  Trace(RESOURCE, "Changing owner of "+GetName(oArea)+" to faction of "+GetName(oPC));

  int nFaction = miBAGetBackground(oPC);
  SetPersistentInt(OBJECT_INVALID, GetTag(oArea)+OWNER, nFaction);
}

int GetOwningFaction(object oArea)
{
  Trace(RESOURCE, "Getting owner for "+GetName(oArea));

  int nOwningFaction = GetPersistentInt(OBJECT_INVALID, GetTag(oArea)+OWNER);
  return(nOwningFaction);
}

// Clears all faction resource chests.
void ClearAllFactionResourceChests()
{
  int nFaction = 0;

  while (nFaction < 10)
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

void DistributeResources()
{		
    Trace(RESOURCE, "Assigning resources.");
    // Clear the faction resource chests.
	// The delete command won't be sent until after the
	// script ends, so delay creation to avoid stacks being
	// added to and then deleted.
    ClearAllFactionResourceChests();

    // Determine who owns each area. Give them rep points and resources.
    int iCount = 0;
    object oWP = GetObjectByTag(RES_WP_TAG, iCount);

    while (GetIsObjectValid(oWP))
    {
        int nOwner = GetOwningFaction(GetArea(oWP));
        GivePointsToFaction(1, nOwner);
        DelayCommand(0.1, GiveResourcesToOwningFaction(oWP));

        // Store the current owner.
        SetPersistentString(OBJECT_INVALID,
                            GetName(GetArea(oWP)),
                            GetFactionName(nOwner),
                            0,
                            AREA_DB);

        iCount++;
        oWP = GetObjectByTag(RES_WP_TAG, iCount);
    }	
}
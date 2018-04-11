/*
  areacleanup script
  removes bodybags, dropped items and creatures when there are no PCs left.
*/

#include "inc_log"
const string AREACLEANUP = "AREA_CLEANUP"; // For trace

void TrashObject(object oObject)
{
    if ((GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE) ||
         (GetObjectType(oObject) == OBJECT_TYPE_CREATURE))
    {
      // Recurse into inventory destroying everything inside.
      object oItem = GetFirstItemInInventory(oObject);
      while (GetIsObjectValid(oItem))
      {
        TrashObject(oItem);
        oItem = GetNextItemInInventory(oObject);
      }
    }

    // Then destroy the object.
    AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
    DestroyObject(oObject);

}

void main()
{
    // First check to see if the ExitingObject is a PC or not
    object oPC = GetExitingObject();
    // If not, we'll just exit
    if (!GetIsPC(oPC))
        return;

    Trace(AREACLEANUP, "Clearing faction reps for exiting PC: " + GetName(oPC));
    // Clear the PC's reputation with the Quest faction.
    SetLocalString(OBJECT_SELF, "faction_creature", "factionexample12");
    ExecuteScript("mi_rstfctnexit", OBJECT_SELF);
    // Clear the PC's reputation with the Animal faction.
    SetLocalString(OBJECT_SELF, "faction_creature", "factionexample17");
    ExecuteScript("mi_rstfctnexit", OBJECT_SELF);

    // Start up the loop, setting oPC now to the first PC
    oPC = GetFirstPC();
    // Continue looping until there are no more PCs left
    while (oPC != OBJECT_INVALID)
    {
        // Check the Area against the Area of the current PC
        // If they are the same, exit the function, as we do not need to
        // check anymore PCs
        if (OBJECT_SELF == GetArea(oPC))
            return;
        // If not, continue to the next PC
        else oPC = GetNextPC();
    }
    // If we've made it this far, we know that there aren't any PCs in the area
    // Set oObject to the first object in the Area
    object oObject = GetFirstObjectInArea(OBJECT_SELF);
    // Continue looping until there are no more objects left
    while (oObject != OBJECT_INVALID)
    {
        // see if we should destroy it.
        int iObjectType = GetObjectType(oObject);
        switch (iObjectType) {
        case OBJECT_TYPE_PLACEABLE:
            if (GetName(oObject) != "Remains") {
                break; }
        case OBJECT_TYPE_ITEM:
            TrashObject(oObject);
            break;
        case OBJECT_TYPE_CREATURE:
          if (GetIsEncounterCreature(oObject) && FindSubString(GetTag(oObject), "boss_") == -1)
              TrashObject(oObject);

          break;
        case OBJECT_TYPE_STORE:
        {
          // If this store has more than 100 items, clear it.
          object oItem = GetFirstItemInInventory(oObject);
          int nCount = 0;
          while (GetIsObjectValid(oItem))
          {
            nCount++;
            oItem = GetNextItemInInventory(oObject);
          }

          if (nCount > 100)
          {
            oItem = GetFirstItemInInventory(oObject);
            while (GetIsObjectValid(oItem))
            {
              DestroyObject(oItem);
            }

            string sResRef = GetResRef(oObject);
            location lLocation = GetLocation(oObject);
            DestroyObject(oObject);
            CreateObject(OBJECT_TYPE_STORE, sResRef, lLocation);
          }
        }
      }

      // Move on to the next object
      oObject = GetNextObjectInArea(OBJECT_SELF);
    }
}


//  ScarFace's Persistent Banking system - OnAreaExit -
#include "inc_database"
#include "bank_inc"
void SpawnChest(string sResRef, location lLoc)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc, FALSE);
}
void SaveItemsInChest(object oObject)
{
    string sKey = GetLocalString(oObject, "CD_KEY"),
           sResRef = GetResRef(oObject),
           sCount;
    object oItem = GetFirstItemInInventory(oObject),
           oArea = GetArea(OBJECT_SELF);
    location lLoc = GetLocation(oObject);
    int iCount = 1;

    while (GetIsObjectValid(oItem))
    {
        if(!GetHasInventory(oItem) && iCount <= MAX_ITEMS && GetItemStackSize(oItem) <= 1)
        {
            sCount = IntToString(iCount);
            if (NWNX_APS_ENABLED)
            {
                SetPersistentObject(OBJECT_INVALID, sKey+sCount, oItem, 0, OBJECT_TABLE);
            }
            else
            {
                StoreCampaignObject("STORAGE", sKey+sCount, oItem, OBJECT_INVALID);
            }
            DestroyObject(oItem);
            iCount++;
        }
        oItem = GetNextItemInInventory(oObject);
    }
    DestroyObject(oObject);
    AssignCommand(oArea, DelayCommand(1.0, SpawnChest(sResRef, lLoc)));
}
void main()
{
    object oObject = GetFirstObjectInArea(),
           oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject);

    if (!GetIsObjectValid(oPC))
    {
        while (GetIsObjectValid(oObject))
        {
            if (GetTag(oObject) == "sf_pers_chests")
            {
                if (GetLocalInt(oObject, "IN_USE"))
                {
                    SaveItemsInChest(oObject);
                }
            }
            oObject = GetNextObjectInArea();
        }
    }
}

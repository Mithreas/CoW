//  ScarFace's Persistent Banking system  - OnClosed -
#include "inc_database"
#include "bank_inc"
void main()
{
    object oChest = OBJECT_SELF;
    ActionLockObject(oChest);
    object oPC = GetLastClosedBy(),
           oItem = GetFirstItemInInventory(oChest);
    string sKey = GetLocalString(oChest, "CD_KEY"),
           sCount;
    int iCount = 1, iBag, iStack;

    while (GetIsObjectValid(oItem))
    {
        if (GetHasInventory(oItem))
        {
            iBag++;
        }
        else if (GetItemStackSize(oItem) > 1)
        {
            iStack++;
        }
        else
        {
            if (iCount <= MAX_ITEMS)
            {
                sCount = IntToString(iCount);
                //if (NWNX_APS_ENABLED)
                if (FALSE)
                {
                    SetPersistentObject(oPC, sKey+sCount, oItem, 0, OBJECT_TABLE);
                }
                else
                {
                    StoreCampaignObject("STORAGE", sKey+sCount, oItem, OBJECT_INVALID);

                }
                DestroyObject(oItem);
                iCount++;
            }
        }
        oItem = GetNextItemInInventory(oChest);
    }
    if (iBag > 0)
    {
        FloatingTextStringOnCreature("** WARNING ** Not all items were saved, You can't store containers.", oPC);
        FloatingTextStringOnCreature("Remove any bag/container from the chest", oPC);
    } // End If
    else if (iStack > 0)
    {
        FloatingTextStringOnCreature("** WARNING ** Not all items were saved, You can't store stacked items.", oPC);
        FloatingTextStringOnCreature("Remove any stacked items from the chest", oPC);
    }
    else if (iCount > MAX_ITEMS)
    {
        FloatingTextStringOnCreature("** WARNING ** You can't store more than "+IntToString(MAX_ITEMS)+" items. You have "+IntToString(iCount)+" items in the chest. only "+IntToString(MAX_ITEMS)+" items were saved. Please remove some items", oPC);
        DelayCommand(3.0, ActionUnlockObject(oChest));
    } // End If
    else if (iCount == 0)
    {
        FloatingTextStringOnCreature("Chest empty, No items saved", oPC);
        DelayCommand(3.0, ActionUnlockObject(oChest));
    } // End If
    else
    {
        FloatingTextStringOnCreature("All items successfully saved", oPC);
    } // End Else
    DeleteLocalString(oChest, "CD_KEY");
    DeleteLocalInt(oChest, "IN_USE");
    DelayCommand(3.0, ActionUnlockObject(oChest));
}

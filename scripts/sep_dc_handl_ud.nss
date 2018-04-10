#include "sep_inc_event"
#include "sep_inc_dynchest"

const float fTime = 3600.0;

void restock(object oChest)
{
    if (!GetIsOpen(oChest))
    {
        dcRestockExistingChest(oChest, TRUE);
    }
    else
    {
        // SendMessageToPC(GetFirstPC(), "<c¦oo>CAUTION: Someone is holding the lid open, new loot not generated! Trying Again in " + FloatToString(10.0) + " seconds.");
        DelayCommand(10.0, restock(oChest));
    }
}

void main()
{
    int nDefined = GetUserDefinedEventNumber();

    if (nDefined == SEP_EV_ON_BASHED)
    {
        // SendMessageToPC(GetFirstPC(), "DEBUG: Chest has been Bashed! Respawning a new one in " + FloatToString(fTime) + " seconds.");
        if (GetLocalInt(OBJECT_SELF, "InitRespawn") == 1)
        {
            dcRespawnNewChest(OBJECT_SELF);
            DeleteLocalInt(OBJECT_SELF, "InitRespawn");
        }
        else
        {
           DelayCommand(fTime, dcRespawnNewChest(OBJECT_SELF));
        }

        // DelayCommand(fTime, SendMessageToPC(GetFirstPC(), "DEBUG: Spawned!"));
    }
    else if (nDefined == SEP_EV_ON_OPENED)
    {
        object oChest = GetLocalObject(OBJECT_SELF, "sep_child_chest");
         // SendMessageToPC(GetFirstPC(), "DEBUG: Restocking the chest in " + FloatToString(fTime) + " seconds!");
        DelayCommand(fTime, restock(oChest));
         // DelayCommand(fTime, SendMessageToPC(GetFirstPC(), "DEBUG: Restocked!"));
    }
    else if (nDefined == SEP_EV_ON_CLEANUP)
    {
        object oChest = GetLocalObject(OBJECT_SELF, "sep_child_chest");
         // SendMessageToPC(GetFirstPC(), "DEBUG: Destroying Chest in " + FloatToString(10.0) + " second!");
        DelayCommand(10.0, _dcPurgeInventory(oChest));
        SetLocalInt(OBJECT_SELF, "InitRespawn", 1);
    }
}


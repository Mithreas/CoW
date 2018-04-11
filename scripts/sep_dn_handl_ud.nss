#include "sep_inc_event"
#include "sep_inc_dynnpc"

void restock(object oNPC)
{
        dnRestockExistingNPC(oNPC, TRUE);
}

void main()
{
    int nDefined = GetUserDefinedEventNumber();

    if (nDefined == SEP_EV_ON_KILLED)
    {
        // SendMessageToPC(GetFirstPC(), "DEBUG: NPC has been Killed! Respawning a new one in 6 seconds.");
        DelayCommand(6.0f, dnRespawnNewNPC(OBJECT_SELF));
        // DelayCommand(6.0f, SendMessageToPC(GetFirstPC(), "DEBUG: Spawned!"));
    }
    else if (nDefined == SEP_EV_ON_INVDISTURBED)
    {
        object oNPC = GetLocalObject(OBJECT_SELF, "sep_child_NPC");
        // SendMessageToPC(GetFirstPC(), "DEBUG: Restocking the NPC in 6 seconds!");
        DelayCommand(6.0f, restock(oNPC));
        // DelayCommand(6.0f, SendMessageToPC(GetFirstPC(), "DEBUG: Restocked!"));
    }
    else if (nDefined == SEP_EV_ON_CLEANUP)
    {
        object oNPC = GetLocalObject(OBJECT_SELF, "sep_child_NPC");
        // SendMessageToPC(GetFirstPC(), "DEBUG: Destroying NPC in 10 second!");
        DelayCommand(10.0, dnPurgeInventory(oNPC));
    }
}


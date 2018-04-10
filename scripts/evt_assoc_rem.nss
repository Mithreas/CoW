//::///////////////////////////////////////////////
//:: Event: Remove Associate
//:: evt_assoc_rem
//:://////////////////////////////////////////////
/*
    Remove the associate command feat when
    all associates have left the party.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////

#include "gs_inc_pc"
#include "inc_associates"
#include "inc_behaviors"
#include "inc_quickbar"
#include "inc_summons"
#include "nwnx_events"

void UpdateForceFollowSettings(object oAssociate);
void SaveQuickbar();

//::///////////////////////////////////////////////
//:: main
//:://////////////////////////////////////////////
/*
    The main driver for the associate removal
    event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void main()
{
    if(!GetIsPC(OBJECT_SELF))
        return;
    DecrementAssociateCount(OBJECT_SELF);
    if(!GetAssociateCount(OBJECT_SELF))
    {
        SaveQuickbar();
        RemoveAssociateCommand(OBJECT_SELF);
    }

    object oAssociate;
    int i, j;
    for (i = ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while (GetIsObjectValid(oAssociate = GetAssociate(i, OBJECT_SELF, ++j)))
        {
            DelayCommand(0.1, UpdateForceFollowSettings(oAssociate));
            // Fix for GetAssociate() ignoring nth parameter with dominated associates.
            if(i == ASSOCIATE_TYPE_DOMINATED)
                break;
        }
        j = 0;
    }
    oAssociate = NWNX_Object_StringToObject(NWNX_Events_GetEventData("ASSOCIATE_OBJECT_ID"));
    SetLocalObject(oAssociate, "Master", OBJECT_SELF);
    AssignCommand(oAssociate, RunSpecialBehaviors(EVENT_ASSOCIATE_REMOVED));
    StartSummonCooldownTimer(oAssociate);
}

//::///////////////////////////////////////////////
//:: UpdateForceFollowSettings
//:://////////////////////////////////////////////
/*
    Removes force follow objects if the associate
    no longer has a master. This is a workaround
    to prevent associates from remembering old
    follow targets in the event that the
    associate is passed from one controller
    to another.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
void UpdateForceFollowSettings(object oAssociate)
{
    if(!GetIsObjectValid(GetAssociateController(oAssociate)))
        RemoveInvalidForceFollowObjects(oAssociate);
}

void SaveQuickbar()
{
    SetLocalString(gsPCGetCreatureHide(), LIB_PREFIX_ASSOCIATES + "_QUICKBAR", GetQuickBar(OBJECT_SELF));
}

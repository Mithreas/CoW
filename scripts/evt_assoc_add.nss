//::///////////////////////////////////////////////
//:: Event: Add Associate
//:: evt_assoc_add
//:://////////////////////////////////////////////
/*
    Adds the associate command feat when
    an associate joins the party, as well as
    updates associate presence and buffs.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////

#include "inc_associates"
#include "inc_sumbonuses"
#include "inc_quickbar"
#include "inc_spells"
#include "inc_summons"
#include "gs_inc_pc"
#include "nwnx_events"

void RestoreQuickbar();

void main()
{
    object oAssociate = NWNX_Object_StringToObject(NWNX_Events_GetEventData("ASSOCIATE_OBJECT_ID"));;

    if(!GetIsPC(OBJECT_SELF))
        return;
    IncrementAssociateCount(OBJECT_SELF);
    if (!GetHasFeat(FEAT_ASSOCIATE_COMMAND))
    {
        GrantAssociateCommand(OBJECT_SELF);
        //RestoreQuickbar(); -not working anyways
    }

    // Setting updated need in case this associate already had associate variables set
    // (e.g. was another player's henchman).
    DelayCommand(0.0, UpdateAssociateAISettings(OBJECT_SELF));
    DismissOldSwarmSummons(OBJECT_SELF);
    ApplyAssociateBuffs(oAssociate);
    InitializeSummonCooldown(oAssociate);
}

void RestoreQuickbar()
{
    string savedQuickbar = GetLocalString(gsPCGetCreatureHide(), LIB_PREFIX_ASSOCIATES + "_QUICKBAR");

    if (savedQuickbar != "")
    {
        int i = 0;
        while (i < QUICKBARSLOT_COUNT)
        {
            string parsed = StringParse(savedQuickbar, QUICKBAR_DELIM);
            savedQuickbar = StringRemoveParsed(savedQuickbar, parsed, QUICKBAR_DELIM);

            struct QuickBarSlot savedQbs = StringToQuickBarSlot(parsed);

            if (savedQbs.type == QUICKBAR_TYPE_FEAT && savedQbs.id == FEAT_ASSOCIATE_COMMAND)
            {
                if (GetQuickBarSlot(OBJECT_SELF, i).type == QUICKBAR_TYPE_INVALID) // Empty currently
                {
                    SetQuickBarSlot(OBJECT_SELF, savedQbs);
                }
            }

            ++i;
        }
    }
}

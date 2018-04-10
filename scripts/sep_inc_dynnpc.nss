#include "sep_inc_event"
/*
Dynamic NPC function library.

System works like this:

Players see a NPC which is populated with loot in the toolset.
They can either unlock or bash the NPC.
The NPC will contain none, some, or all of the loot shown in the toolset.
Bashing alerts NPCs. If the PCs see or are attacked by the player, the guard is alerted.

This is a stealth mini-game, more or less.

The NPC must recreate itself or its loot after X hours.
*/

//..............................................................................
const int FULL_TRANSFER = 0;
const int PARTIAL_TRANSFER = 1;
const int FIRST_RUN = 3;

/*
    Function Headers
*/
// Dynamic NPC - Internally used. Create a NPC handler object off-screen.
void _dnCreateNPCHandler(object oNPC, object oExistingHandler, int bFirstRun = 0);
//..............................................................................

// Dynamic NPC - Internally used. Set the plot flag of the container and the handler.
void _dnPlotStatus(object oNPC, object oHandler);
//..............................................................................

// Dynamic NPC - Internally used. Purge inventory (destroy everything inside) oNPC.
void dnPurgeInventory(object oNPC);
//..............................................................................

// Dynamic NPC - Internally used. Copy all inventory items from oProducer into oConsumer.
// If bDestroyTemp is TRUE, then oProducer is destroyed when finished.
void _dnHandleTransfer(object oProducer, object oConsumer, int bDestroyProducer = TRUE, int nFull = FULL_TRANSFER, int nPick = 3);
//..............................................................................

// Dynamic NPC - Internally used. Creates a new inventory in oNPC. If BHardReset
// is TRUE, it will delete everything currently in the NPC. Otherwise, it adds the new inventory
void dnRestockExistingNPC(object oNPC, int bHardReset = FALSE);
//..............................................................................

// Dynamic NPC - Internally used. Create a new NPC based on what the handler has stored.
void dnRespawnNewNPC(object oHandler);
//..............................................................................

// Dynamic NPC - Internally used. Roll the loot based on Opening, or Bashing.
// nCondition is 0 (opened nicely) or 1 (Bashed to oblivion)
void _dnRollLoot(object oNPC, int nCondition = 0);
//..............................................................................

// Dynamic NPC - OnDeath event handler for Dynamic NPCs.
void dnNPCDeathHandler(object oNPC);
//..............................................................................

// Dynamic NPC - OnHeartbeat event handler for Dynamic NPCs.
void dnHeartbeatHandler(object oNPC);
//..............................................................................

// Dynamic NPC - OnOpen event handler for Dynamic NPCs.
void dnNPCDisturbHandler(object oNPC);
//..............................................................................

/*
    Functions

*/

void _dnCreateNPCHandler(object oNPC, object oExistingHandler, int bFirstRun = 0)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnCreateNPCHandler.");
    int nRandomItems = d6();
    object oHandler;
    if (bFirstRun)
    {
        location lPen = GetLocation(GetWaypointByTag("sep_dynnpc_pen"));
        oHandler = CopyObject(oNPC, lPen);
        // SendMessageToPC(GetFirstPC(), "<co o>New Handler created.");
    }
    else
    {
        oHandler = oExistingHandler;
    }

    SetLocalObject(oHandler, "sep_child_NPC", oNPC);
    SetLocalString(oHandler, "sep_child_resref", GetStringLowerCase(GetTag(oNPC)));
    SetLocalLocation(oHandler, "sep_child_location", GetLocation(oNPC));
    SetLocalObject(oNPC, "sep_parent_handler", oHandler);
    SetLocalInt(oHandler, "sep_init", 1);

    // SendMessageToPC(GetFirstPC(), "<co o>Vars set on handler.");

    if (bFirstRun)
    {
        DelayCommand(0.4, _dnHandleTransfer(oNPC, oHandler, FALSE, FULL_TRANSFER));
        SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_CLEANUP));
        // SendMessageToPC(GetFirstPC(), "<co o>Transfer to Handler Complete, Signaling NPC destruction. ");
    }

    _dnPlotStatus(oNPC, oHandler);
    // SendMessageToPC(GetFirstPC(), "<co o>Plot Properties copied.");
    if (!bFirstRun)
    {
        DelayCommand(1.0, _dnHandleTransfer(oHandler, oNPC, FALSE, PARTIAL_TRANSFER, nRandomItems));
        // SendMessageToPC(GetFirstPC(), "<co o>Generated Partial loot from Handler to NPC");
    }
}
//..............................................................................
void _dnRandomizeNPC(object oNewNPC)
{
    // WIP
    SetCreatureBodyPart(CREATURE_PART_HEAD, 1, oNewNPC);

    if (d20() == 20)
    {
        SetPhenoType(PHENOTYPE_BIG, oNewNPC);
    }
    else
    {
        SetPhenoType(PHENOTYPE_NORMAL, oNewNPC);
    }
}
//..............................................................................
void _dnPlotStatus(object oNPC, object oHandler)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnPlotStatus");
    int bPlotFlagFalse = GetLocalInt(oNPC, "sep_dn_plotisfalse");

    if (bPlotFlagFalse)
    {
        SetPlotFlag(oNPC, FALSE);
        SetPlotFlag(oHandler, FALSE);
    }
    else
    {
        SetPlotFlag(oHandler, GetPlotFlag(oNPC));
    }
}
//..............................................................................
void dnPurgeInventory(object oNPC)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnPurgeInventory");
    object oHandler = GetLocalObject(oNPC, "sep_parent_handler");
    object oIterator = GetFirstItemInInventory(oNPC);
    while(GetIsObjectValid(oIterator))
    {
        DestroyObject(oIterator);
        oIterator = GetNextItemInInventory(oNPC);
    }
    SetPlotFlag(oNPC, FALSE);
    DestroyObject(oNPC);
    SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_KILLED));
}
//..............................................................................
void _dnHandleTransfer(object oProducer, object oConsumer, int bDestroyProducer = TRUE, int nFull = FULL_TRANSFER, int nPick = 3)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnHandleTransfer");
    object oIterator = GetFirstItemInInventory(oProducer);
    int nCount1 = 0;
    int nCount2 = 0;
    int nRandom1 = 0;
    int nRandom2 = 0;
    int nRandom3 = 0;
    int nRandom4 = 0;
    int nRandom5 = 0;
    int nRandom6 = 0;
    int nRandom7 = 0;
    int nRandom8 = 0;
    int nRandom9 = 0;
    int nRandom10 = 0;
    int nPickedItems = 0;

    if (nFull == PARTIAL_TRANSFER)
    {
        while (GetIsObjectValid(oIterator))
        {
            nCount1++;
            oIterator = GetNextItemInInventory(oProducer);
        }
        nRandom1 = Random(nCount1) + 1;
        nRandom2 = Random(nCount1) + 1;
        nRandom3 = Random(nCount1) + 1;
        nRandom4 = Random(nCount1) + 1;
        nRandom5 = Random(nCount1) + 1;
        nRandom6 = Random(nCount1) + 1;
        nRandom7 = Random(nCount1) + 1;
        nRandom8 = Random(nCount1) + 1;
        nRandom9 = Random(nCount1) + 1;
        nRandom10 = Random(nCount1) + 1;
    }

    oIterator = GetFirstItemInInventory(oProducer);
    while (GetIsObjectValid(oIterator))
    {
        if (nFull == FULL_TRANSFER)
        {
            SetPickpocketableFlag(oIterator, TRUE);
            // CopyItem(oIterator, oConsumer, TRUE);
        }
        else if (nFull == PARTIAL_TRANSFER)
        {
            // Pick n items from the master pool and move them over to oConsumer.
            // CopyItem(oIterator, oConsumer, TRUE);
            nCount2++;
            if (
                (nCount2 == nRandom1 && nPick >= 1) ||
                (nCount2 == nRandom2 && nPick >= 2) ||
                (nCount2 == nRandom3 && nPick >= 3) ||
                (nCount2 == nRandom4 && nPick >= 4) ||
                (nCount2 == nRandom5 && nPick >= 5) ||
                (nCount2 == nRandom6 && nPick >= 6) ||
                (nCount2 == nRandom7 && nPick >= 7) ||
                (nCount2 == nRandom8 && nPick >= 8) ||
                (nCount2 == nRandom9 && nPick >= 9) ||
                (nCount2 == nRandom10 && nPick >= 10)
                )
                {
                    CopyItem(oIterator, oConsumer, TRUE);
                    nPickedItems += 1;
                }
        }
        if (bDestroyProducer)
        {
            SetPlotFlag(oIterator, FALSE);
            DestroyObject(oIterator);
        }
        oIterator = GetNextItemInInventory(oProducer);
        if (nPickedItems >= nPick) break;
    }
    if (bDestroyProducer)
    {
        dnPurgeInventory(oProducer);
    }
}
//..............................................................................
void dnRestockExistingNPC(object oNPC, int bHardReset = FALSE)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: _dnRestockExistingNPC");
    int nRandomItems = d6();
    if (bHardReset)
    {
        // Destroy all objects in the NPC.
        object oIterator = GetFirstItemInInventory(oNPC);
        while (GetIsObjectValid(oIterator))
        {
            SetPlotFlag(oIterator, FALSE);
            DestroyObject(oIterator);
            oIterator = GetNextItemInInventory(oNPC);
        }
    }
    // Refill the NPC
    object oHandler = GetLocalObject(oNPC, "sep_parent_handler");
    _dnHandleTransfer(oHandler, oNPC, FALSE, PARTIAL_TRANSFER, nRandomItems);
    DelayCommand(1.0, SetLocalInt(oNPC, "sep_is_touched", FALSE));
}

//..............................................................................
void dnRespawnNewNPC(object oHandler)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnRespawnNewNPC");
    int nRandomItems = d6();
    location lLoc = GetLocalLocation(oHandler, "sep_child_location");
    object oNewNPC = CopyObject(oHandler, lLoc, OBJECT_INVALID);

    if (GetPlotFlag(oNewNPC) == FALSE)
    {
        SetPlotFlag(oNewNPC, TRUE);
        SetLocalInt(oNewNPC, "sep_dn_plotisfalse", TRUE);
    }
    _dnCreateNPCHandler(oNewNPC, oHandler);
    SetLocalInt(oNewNPC, "sep_init", 1);

    string sName = GetName(oHandler);
    if (GetSubString(sName, 0, 4) == "dyn_")
    {
        // strip "dyn_"
        SetName(oNewNPC, GetSubString(sName, 4, GetStringLength(sName)));
    }

    // Is this a static or random NPC?
    int bNPCIsRandom = GetLocalInt(oHandler, "sep_dynnpc_random") == TRUE;

    if (bNPCIsRandom)
    {
        _dnRandomizeNPC(oNewNPC);
    }
}

//..............................................................................
void _dnRollLoot(object oNPC, int nCondition = 0)
{
    // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dnRollLoot");
    // Determine the loot in the NPC based on the original template.
    object oIterator = GetFirstItemInInventory(oNPC);
    int nCount = 0;
    int nTotalGPValue = 0;
    int nHighestGPValue = 0;
    object oValuable;
    int nBaseType = 0;

    int nOuterDie = d20();

    while (GetIsObjectValid(oIterator))
    {
        // Decide here if we are going to prune this item
        int nInnerDie = d100();

        if (nOuterDie >= 20)
        {
            // Everything is intact for this NPC.
            // There's no pruning necessary.
        }
        else if ((nInnerDie <= 20)||(nOuterDie <= 1))
        {
            // Pruned, move on.
            DestroyObject(oIterator);
        }
        else
        {
            // Take inventory
            nCount++;
            if (GetGoldPieceValue(oIterator) > nHighestGPValue)
            {
                nHighestGPValue = GetGoldPieceValue(oIterator);
                oValuable = oIterator;
            }
            nTotalGPValue += GetGoldPieceValue(oIterator);
        }

        oIterator = GetNextItemInInventory(oNPC);
    }

    if (nCondition == 1)
    {
        // NPC was bashed. Destroy highest gold piece value item in there
        // Anything worth more than 1/3 the NPC's total worth is destroyed.
        DestroyObject(oValuable);
        oIterator = GetFirstItemInInventory(oNPC);
        while (GetIsObjectValid(oIterator))
        {
            if (GetGoldPieceValue(oIterator) > 3000)
            {
                DestroyObject(oIterator);
            }

            oIterator = GetNextItemInInventory(oNPC);
        }
    }
}
//..............................................................................

void dnNPCDeathHandler(object oNPC)
{
    //_dnRollLoot(oNPC, 1);
    // SendMessageToPC(GetFirstPC(), "Dead");
    object oHandler = GetLocalObject(oNPC, "sep_parent_handler");
    SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_KILLED));
}
//..............................................................................

void dnNPCDisturbHandler(object oNPC)
{
    int bTouched = GetLocalInt(oNPC, "sep_is_touched");
    int bInit = GetLocalInt(oNPC, "sep_init");
    // Only do the loot roll once.
    if (bInit)
    {
        if (!bTouched)
        {
            SetLocalInt(oNPC, "sep_is_touched", 1);
            object oHandler = GetLocalObject(oNPC, "sep_parent_handler");
            SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_INVDISTURBED));
        }
    }
}
//..............................................................................

void dnHeartbeatHandler(object oNPC)
{
    // Do once, when it spawns in.
    int nInit = GetLocalInt(oNPC, "sep_init");

    if (nInit != 1)
    {
        //effect eBlue = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE);
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlue, oNPC, 1.0);
        _dnCreateNPCHandler(oNPC, OBJECT_INVALID, FIRST_RUN);
        SetLocalInt(oNPC, "sep_init", 1);
    }
}
//..............................................................................

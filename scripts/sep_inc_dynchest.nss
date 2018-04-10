#include "sep_inc_event"
/*
Dynamic Chest function library.

System works like this:

Players see a chest which is populated with loot in the toolset.
They can either unlock or bash the chest.
The chest will contain none, some, or all of the loot shown in the toolset.
Bashing alerts NPCs. If the PCs see or are attacked by the player, the guard is alerted.

This is a stealth mini-game, more or less.

The chest must recreate itself or its loot after X hours.
*/

//..............................................................................
const int FULL_TRANSFER = 0;
const int PARTIAL_TRANSFER = 1;
const int FIRST_RUN = 3;

/*
    Function Headers
*/
// Dynamic Chest - Internally used. Create a chest handler object off-screen.
void _dcCreateChestHandler(object oChest, object oExistingHandler, int bFirstRun = 0);
//..............................................................................

// Dynamic Chest - Internally used. Copy trap properties from oOrigin to oDestination.
void _dcCopyTrap(object oOrigin, object oDestination);
//..............................................................................

// Dynamic Chest - Internally used. Copy lock properties from oOrigin to oDestination.
void _dcCopyLock(object oOrigin, object oDestination);
//..............................................................................

// Dynamic Chest - Internally used. Set the plot flag of the container and the handler.
void _dcPlotStatus(object oChest, object oHandler);
//..............................................................................

// Dynamic Chest - Internally used. Purge inventory (destroy everything inside) oChest.
void _dcPurgeInventory(object oChest);
//..............................................................................

// Dynamic Chest - Internally used. Copy all inventory items from oProducer into oConsumer.
// If bDestroyTemp is TRUE, then oProducer is destroyed when finished.
void _dcHandleTransfer(object oProducer, object oConsumer, int bDestroyProducer = TRUE, int nFull = FULL_TRANSFER, int nPick = 3);
//..............................................................................

// Dynamic Chest - Internally used. Creates a new inventory in oChest. If BHardReset
// is TRUE, it will delete everything currently in the chest. Otherwise, it adds the new inventory
void dcRestockExistingChest(object oChest, int bHardReset = FALSE);
//..............................................................................

// Dynamic Chest - Internally used. Create a new chest based on what the handler has stored.
void dcRespawnNewChest(object oHandler);
//..............................................................................

// Dynamic Chest - Internally used. Roll the loot based on Opening, or Bashing.
// nCondition is 0 (opened nicely) or 1 (Bashed to oblivion)
void _dcRollLoot(object oChest, int nCondition = 0);
//..............................................................................

// Dynamic Chest - OnDeath event handler for Dynamic Chests.
void dcChestDeathHandler(object oChest);
//..............................................................................

// Dynamic Chest - OnHeartbeat event handler for Dynamic Chests.
void dcHeartbeatHandler(object oChest);
//..............................................................................

// Dynamic Chest - OnOpen event handler for Dynamic Chests.
void dcChestOpenHandler(object oChest);
//..............................................................................

/*
    Functions

*/

void _dcCreateChestHandler(object oChest, object oExistingHandler, int bFirstRun = 0)
{
    //TSendMessageoPC(GetFirstPC(), "DEBUG: Executing _dcCreateChestHandler.");
    int nRandomItems = d6();
    object oHandler;
    if (bFirstRun)
    {
        oHandler = CreateObject(OBJECT_TYPE_PLACEABLE, "sep_dc_handler", Location(GetArea(oChest), Vector(0.0, 0.0, -10.0), 0.0), FALSE);
        string sName = GetName(oChest);
        DelayCommand(0.4, SetName(oHandler, sName));
        // SendMessageToPC(GetFirstPC(), "<co o>New Handler created.");
    }
    else
    {
        oHandler = oExistingHandler;
    }

    SetLocalObject(oHandler, "sep_child_chest", oChest);
    SetLocalString(oHandler, "sep_child_resref", GetStringLowerCase(GetTag(oChest)));
    SetLocalLocation(oHandler, "sep_child_location", GetLocation(oChest));
    SetLocalObject(oChest, "sep_parent_handler", oHandler);
    SetLocalInt(oHandler, "sep_init", 1);

    // SendMessageToPC(GetFirstPC(), "<co o>Vars set on handler.");

    if (bFirstRun)
    {
        DelayCommand(0.4, _dcHandleTransfer(oChest, oHandler, FALSE, FULL_TRANSFER));
        SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_CLEANUP));
         // SendMessageToPC(GetFirstPC(), "<co o>Transfer to Handler Complete, Signaling Chest destruction. ");
    }
    // Copy any trap settings here.
    if (GetIsTrapped(oChest))
    {
        CreateTrapOnObject(GetTrapBaseType(oChest), oHandler);
        _dcCopyTrap(oChest, oHandler);
         // SendMessageToPC(GetFirstPC(), "<co o>Trap Properties copied.");
    }
    if (GetLocked(oChest))
    {
        _dcCopyLock(oChest, oHandler);
         // SendMessageToPC(GetFirstPC(), "<co o>Lock Properties copied.");
    }
    _dcPlotStatus(oChest, oHandler);
    // SendMessageToPC(GetFirstPC(), "<co o>Plot Properties copied.");
    if (!bFirstRun)
    {
        DelayCommand(1.0, _dcHandleTransfer(oHandler, oChest, FALSE, PARTIAL_TRANSFER, nRandomItems));
         // SendMessageToPC(GetFirstPC(), "<co o>Generated Partial loot from Handler to Chest");
    }
}
//..............................................................................
void _dcCopyTrap(object oOrigin, object oDestination)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcCopyTrap");
    SetTrapActive(oDestination, GetTrapActive(oOrigin));
    SetTrapDetectable(oDestination, GetTrapDetectable(oOrigin));
    SetTrapDetectDC(oDestination, GetTrapDetectDC(oOrigin));
    SetTrapDisarmable(oDestination, GetTrapDisarmable(oOrigin));
    SetTrapDisarmDC(oDestination, GetTrapDisarmDC(oOrigin));
    SetTrapKeyTag(oDestination, GetTrapKeyTag(oOrigin));
    SetTrapOneShot(oDestination, GetTrapOneShot(oOrigin));
    SetTrapRecoverable(oDestination, GetTrapRecoverable(oOrigin));
}
//..............................................................................
void _dcCopyLock(object oOrigin, object oDestination)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcCopyLock");
    SetLocked(oDestination, GetLocked(oOrigin));
    SetLockLockable(oDestination, GetLockLockable(oOrigin));
    SetLockKeyRequired(oDestination, GetLockKeyRequired(oOrigin));
    SetLockKeyTag(oDestination, GetLockKeyTag(oOrigin));
    SetLockLockDC(oDestination, GetLockLockDC(oOrigin));
    SetLockUnlockDC(oDestination, GetLockUnlockDC(oOrigin));
}
//..............................................................................
void _dcPlotStatus(object oChest, object oHandler)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcPlotStatus");
    int bPlotFlagFalse = GetLocalInt(oChest, "sep_dc_plotisfalse");

    if (bPlotFlagFalse)
    {
        SetPlotFlag(oChest, FALSE);
        SetPlotFlag(oHandler, FALSE);
    }
    else
    {
        SetPlotFlag(oHandler, GetPlotFlag(oChest));
    }
}
//..............................................................................
void _dcPurgeInventory(object oChest)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcPurgeInventory");
    object oHandler = GetLocalObject(oChest, "sep_parent_handler");
    object oIterator = GetFirstItemInInventory(oChest);
    while(GetIsObjectValid(oIterator))
    {
        DestroyObject(oIterator);
        oIterator = GetNextItemInInventory(oChest);
    }
    SetPlotFlag(oChest, FALSE);
    DestroyObject(oChest);
    SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_BASHED));
}
//..............................................................................
void _dcHandleTransfer(object oProducer, object oConsumer, int bDestroyProducer = TRUE, int nFull = FULL_TRANSFER, int nPick = 3)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcHandleTransfer");
    object oIterator = GetFirstItemInInventory(oProducer);
	object oItem;
	int bStolen;
	int nStackSize;
	int nCount  = 0;
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
	    // To prevent stacking, mark all items in the source inventory with the Stolen
		// flag, and unset the flag on each cloned item. 
		// Module start may have stacked items already, so unstack anything stacked on
		// a full transfer.
		bStolen = GetStolenFlag(oIterator);
	    SetStolenFlag(oIterator, TRUE);
	
        if (nFull == FULL_TRANSFER)
        {
		    nStackSize = GetItemStackSize(oIterator);
			
			for (nCount = 0; nCount < nStackSize; nCount++)
			{
              oItem = CopyItem(oIterator, oConsumer, TRUE);
			  SetItemStackSize(oItem, 1);
			  SetStolenFlag(oItem, FALSE);
			}
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
                    oItem = CopyItem(oIterator, oConsumer, TRUE);
					SetStolenFlag(oItem, FALSE);
                    nPickedItems += 1;
                }
        }
		
        if (bDestroyProducer)
        {
            SetPlotFlag(oIterator, FALSE);
            DestroyObject(oIterator);
        }
		
		// Just in case this is ever relevant, reset the stolen flag.
		SetStolenFlag(oIterator, bStolen);
		
        oIterator = GetNextItemInInventory(oProducer);
        if (nPickedItems >= nPick) break;
    }
    if (bDestroyProducer)
    {
        _dcPurgeInventory(oProducer);
    }
}
//..............................................................................
void dcRestockExistingChest(object oChest, int bHardReset = FALSE)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: _dcRestockExistingChest");
    int nRandomItems = d6();
    if (bHardReset)
    {
        // Destroy all objects in the chest.
        object oIterator = GetFirstItemInInventory(oChest);
        while (GetIsObjectValid(oIterator))
        {
            SetPlotFlag(oIterator, FALSE);
            DestroyObject(oIterator);
            oIterator = GetNextItemInInventory(oChest);
        }
    }
    // Refill the chest
    object oHandler = GetLocalObject(oChest, "sep_parent_handler");
    _dcHandleTransfer(oHandler, oChest, FALSE, PARTIAL_TRANSFER, nRandomItems);
    DelayCommand(1.0, SetLocalInt(oChest, "sep_is_touched", FALSE));
}

//..............................................................................
void dcRespawnNewChest(object oHandler)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcRespawnNewChest");
    int nRandomItems = d6();
    string sResref = GetLocalString(oHandler, "sep_child_resref");
    location lLoc = GetLocalLocation(oHandler, "sep_child_location");
    object oNewChest = CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lLoc);

    string sName = GetName(oHandler);
    if (GetSubString(sName, 0, 4) == "dyn_")
    {
        // strip "dyn_"
        DelayCommand(0.4, SetName(oNewChest, GetSubString(sName, 4, GetStringLength(sName))));
    }
    else
    {
        DelayCommand(0.4, SetName(oNewChest, sName));
    }
    if (GetPlotFlag(oNewChest) == FALSE)
    {
        SetPlotFlag(oNewChest, TRUE);
        SetLocalInt(oNewChest, "sep_dc_plotisfalse", TRUE);
    }
    _dcCreateChestHandler(oNewChest, oHandler);
    SetLocalInt(oNewChest, "sep_init", 1);
}

//..............................................................................
void _dcRollLoot(object oChest, int nCondition = 0)
{
     // SendMessageToPC(GetFirstPC(), "DEBUG: Executing _dcRollLoot");
    // Determine the loot in the chest based on the original template.
    object oIterator = GetFirstItemInInventory(oChest);
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
            // Everything is intact for this chest.
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

        oIterator = GetNextItemInInventory(oChest);
    }

    if (nCondition == 1)
    {
        // Chest was bashed. Destroy highest gold piece value item in there
        // Anything worth more than 1/3 the chest's total worth is destroyed.
        DestroyObject(oValuable);
        oIterator = GetFirstItemInInventory(oChest);
        while (GetIsObjectValid(oIterator))
        {
            if (GetGoldPieceValue(oIterator) > 3000)
            {
                DestroyObject(oIterator);
            }

            oIterator = GetNextItemInInventory(oChest);
        }
    }
}
//..............................................................................

void dcChestDeathHandler(object oChest)
{
    _dcRollLoot(oChest, 1);
    object oHandler = GetLocalObject(oChest, "sep_parent_handler");
    SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_BASHED));
}
//..............................................................................

void dcChestOpenHandler(object oChest)
{
    int bTouched = GetLocalInt(oChest, "sep_is_touched");
    int bInit = GetLocalInt(oChest, "sep_init");
    // Only do the loot roll once.
    if (bInit)
    {
        if (!bTouched)
        {
            _dcRollLoot(oChest, 0);
            SetLocalInt(oChest, "sep_is_touched", 1);
            object oHandler = GetLocalObject(oChest, "sep_parent_handler");
            SignalEvent(oHandler, EventUserDefined(SEP_EV_ON_OPENED));
        }
    }
}
//..............................................................................

void dcHeartbeatHandler(object oChest)
{
    // Do once, when it spawns in.
    int nInit = GetLocalInt(oChest, "sep_init");

    if (nInit != 1)
    {
        //effect eBlue = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE);
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlue, oChest, 1.0);
        _dcCreateChestHandler(oChest, OBJECT_INVALID, FIRST_RUN);
        SetLocalInt(oChest, "sep_init", 1);
    }
}
//..............................................................................

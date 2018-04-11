#include "fb_inc_names"
#include "sep_inc_event"

const int CRIME_TYPE_UNKNOWN      = 0;
const int CRIME_TYPE_BREAKENTER   = 1;
const int CRIME_TYPE_MURDER       = 2;
const int CRIME_TYPE_SUMMONS      = 3;
const int CRIME_TYPE_OTHER        = 4;
const int CRIME_TYPE_WARLOCK      = 5;
const int CRIME_TYPE_DARKAGENCIES = 6;
const int CRIME_TYPE_ASSAULT      = 7;
const int CRIME_TYPE_THEFT        = 8;
const int CRIME_TYPE_SPELLCASTING  = 9;
const int CRIME_TYPE_TREASON       = 10;
const int CRIME_TYPE_VANDALISM     = 11;
const string CR_DEFAULT_MESSAGE = "You have been caught breaking the law and have been thrown out of the establishment. Your crimes have been reported to the guard.";
// Headers

// Convert Crime Number to String.
string crCrimeNumberToString(int nCrimeNumber);

// Alert the player guards of oViolator.
void crAlertPlayerGuards(object oViolator, object oWitness, int nCrimeType);

// Create new bracers in oChest, with hallmarks sFrom and sTo and miNation.
object crCreateGuardBracers(object oChest, string sFrom, string sTo, string miNation);

// Destroy a bracer belonging to oGuard with hallmark miNation.
void crDestroyGuardBracers(object oGuard, string miNation);

// Merchant sleeping inside.
void crDoorFailToOpenMerchant();

// Unlocked but no chance of opening without alerting.
void crDoorUnlockAutoAlert();

// Set NPC guards on high alert
void crAlertNPCGuardsInArea(object oArea);

// Trigger an alarm and open the door.
void crOpenDoor(object oDoor = OBJECT_SELF);

// Move the player to the eject point stored on the the caller.
void crEjectPlayer(object oPC);

// Print out the contents of the oBracer's sFrom and sTo variables to oPC.
void crPrintBracer(object oBracer, object oPC);
//.............................................................................................
string crCrimeNumberToString(int nCrimeNumber)
{
    string sReturn = "Unknown";
    switch(nCrimeNumber)
    {
        case 0: sReturn = "Unknown";           break;
        case 1: sReturn = "Break and Enter";   break;
        case 2: sReturn = "Murder";            break;
        case 3: sReturn = "Summoning";         break;
        case 4: sReturn = "Other";             break;
        case 5: sReturn = "Warlock";           break;
        case 6: sReturn = "Dark Agent";        break;
        case 7: sReturn = "Assault";           break;
        case 8: sReturn = "Theft";             break;
        case 9: sReturn = "Spellcasting";      break;
        case 10: sReturn = "Treason";          break;
        case 11: sReturn = "Vandalism";        break;
        default: sReturn = "Unknown";          break;
    }

return sReturn;
}
//.............................................................................................
void crAlertPlayerGuards(object oViolator, object oWitness, int nCrimeType)
{
    object oGuardPC = GetFirstPC();
    // string sViolatorName = fbNAGetGlobalDynamicName(oViolator);
    // string sWitnessName  = fbNAGetGlobalDynamicName(oWitness);
    string sViolatorName = GetName(oViolator);
    string sWitnessName  = GetName(oWitness);
    string sAreaName = GetName(GetArea(oViolator));
    string miNation = GetLocalString(GetArea(oViolator), "MI_NATION");

    while(GetIsObjectValid(oGuardPC))
    {
            // Player guard is in the correct nation to receive the alert!
            object oGuardBracer = GetItemInSlot(INVENTORY_SLOT_ARMS, oGuardPC);
            if (GetTag(oGuardBracer) == "sep_cr_guard" &&
                GetLocalString(oGuardBracer, "MI_NATION") == miNation)
            {
                // Guard is wearing a bracer corresponding to the correct MI_NATION.
                // Septire - VFX disabled because we want undercover guards.
                //effect eWarn = EffectVisualEffect(VFX_IMP_CONFUSION_S);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eWarn, oGuardPC);
                SendMessageToPC(oGuardPC, "Your bracers light up with some new information!");
                SendMessageToPC(oGuardPC, "Suspect: " + sViolatorName);
                if (GetObjectType(oWitness) == OBJECT_TYPE_CREATURE)
                {
                    SendMessageToPC(oGuardPC, "Witness: " + sWitnessName);
                }
                else if (GetObjectType(oWitness) == OBJECT_TYPE_DOOR ||
                         GetObjectType(oWitness) == OBJECT_TYPE_PLACEABLE)
                {
                    SendMessageToPC(oGuardPC, "Alarm Triggered: " + sWitnessName);
                }
                SendMessageToPC(oGuardPC, "Region: " + sAreaName);
                SendMessageToPC(oGuardPC, "Crime: " + crCrimeNumberToString(nCrimeType));
            }

    oGuardPC = GetNextPC();
    }
}
//.............................................................................................
object crCreateGuardBracers(object oChest, string sFrom, string sTo, string miNation)
{
    object oBracers = CreateItemOnObject("sep_cr_guard", oChest, 1, "sep_cr_guard");
    SetLocalString(oBracers, "MI_NATION", miNation);


    SetLocalString(oBracers, "sFrom", sFrom);
    SetLocalString(oBracers, "sTo", sTo);
    return oBracers;
    // SendMessageToAllDMs("Guard bracers created on: "+ GetName(oNewGuard));
}
//.............................................................................................
void crDestroyGuardBracers(object oGuard, string miNation)
{
    object oInvIterator = GetFirstItemInInventory(oGuard);
    while (GetIsObjectValid(oInvIterator))
    {
        if (GetTag(oInvIterator) == "sep_cr_guard" &&
            GetLocalString(oInvIterator, "MI_NATION") == miNation)
            {
                DestroyObject(oInvIterator);
            }
    oInvIterator = GetNextItemInInventory(oGuard);
    }

    int nSlot = INVENTORY_SLOT_ARMS;
    oInvIterator = GetItemInSlot(nSlot, oGuard);
    if (GetTag(oInvIterator) == "sep_cr_guard" &&
        GetLocalString(oInvIterator, "MI_NATION") == miNation)
        {
            DestroyObject(oInvIterator);
        }
    // SendMessageToAllDMs("Guard bracers destroyed on: "+ GetName(oNewGuard));
}
//.............................................................................................
void crDoorFailToOpenMerchant()
{
    object oPC = GetClickingObject();
    int bDay = GetIsDay();

    if (bDay)
    {
        // Hard to say if someone would be sleeping during these hours. The assumption is that players cannot break in during operating hours.

    }
    else
    {
        SendMessageToPC(oPC, "Peering through the keyhole, you see someone sleeping on the other side. "+
        "The door itself seems to be of dwarven design: heavy oak with a large steel bolt barring the door from the other side. "+
        "There doesn't appear to be much hope of picking this lock, and trying to break it down is going to wake someone up from the noise.");
    }
}
//.............................................................................................
void crDoorUnlockAutoAlert()
{
    SendMessageToPC(GetLastUnlocked(), "There is a click as the last pin is picked, "+
    "but you notice that there seems to be an alarm mechanism on the door. There doesn't seem to be a good way to get at it to disable it either.");
}
//.............................................................................................
void crAlertNPCGuardsInArea(object oArea)
{
    object oNPC = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oNPC))
    {
        if (GetObjectType(oNPC) == OBJECT_TYPE_CREATURE &&
            TestStringAgainstPattern("**Guard**", GetName(oNPC)) == TRUE)
            {
                SignalEvent(oNPC, EventUserDefined(SEP_EV_ON_SECURITY_ALERT));
            }

    oNPC = GetNextObjectInArea(oArea);
    }

}
//.............................................................................................
void crOpenDoor(object oDoor = OBJECT_SELF)
{
    object oPC = GetLastOpenedBy();
    int bAllowBurglaryDay   = GetLocalInt(oDoor, "AllowBurglaryDay");
    int bAllowBurglaryNight = GetLocalInt(oDoor, "AllowBurglaryNight");

    if (!bAllowBurglaryDay && GetIsDay() ||
        !bAllowBurglaryNight && GetIsNight())
    {
        // Not suppose to be doing this during these hours.

        // Caught opening the door. Throw everything into high alert.
        crAlertNPCGuardsInArea(GetArea(oPC));
        crAlertPlayerGuards(oPC, oDoor, 1);
        AssignCommand(oDoor, ActionCloseDoor(oDoor));
        SetLocked(oDoor, TRUE);
        crEjectPlayer(oPC);
    }

    /* Needs to go in heartbeat
        // Autolock code
    int bAutolock = GetLocalInt(oDoor, "DOOR_AUTOLOCK");
    int nTimerHours = GetLocalInt(oDoor, "AUTOLOCK_TIMER");

    int nTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    int nTimestampDoor = GetLocalInt(oTrigger, "GS_TIMESTAMP");
    */
}
//.............................................................................................
void crEjectPlayer(object oPC)
{
    object oSelf = OBJECT_SELF;
    string sTag = GetLocalString(oSelf, "EjectWaypointTag");
    string sMessage = GetLocalString(oSelf, "EjectMessage");

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetWaypointByTag(sTag))));
    if (sMessage == "")
    {
        sMessage = CR_DEFAULT_MESSAGE;
    }
    SendMessageToPC(oPC, sMessage);
}
//.............................................................................................
void crPrintBracer(object oBracer, object oPC)
{

    string sFrom = GetLocalString(oBracer, "sFrom");
    string sTo = GetLocalString(oBracer, "sTo");

    SendMessageToPC(oPC, "The bracer you are wearing has the following engraving: ");
    SendMessageToPC(oPC, "Bracer issued by: " + sFrom);
    SendMessageToPC(oPC, "Bracer issued to: " + sTo);
}

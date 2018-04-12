#include "x0_i0_partywide"
#include "inc_quarter"
#include "inc_math"
#include "inc_log"

//void main() {}

/*
 *      AR_SYS_SHIP
 *
 *      Ship system created by  ActionReplay
 *      As expected this script handles the design of the Ship System.
 *      It works together with the zdlg dialog scripts:
 *                                                      - zdlg_navigator
 *                                                      - zdlg_boatswain
 *
 *      The entry point for the ships' update are set in the current
 *      module's OnHeartbeat event in the scope for each minute update.
 *      Meaning  the  'ar_UpdateShips'  function is called from  'gs_m_heartbeat'.
 *
 *      Read below for more information.
 */

const string AR_NAME           = "AR_SHP_NAME";          //::  Ship's name.
const string AR_STATUS         = "AR_SHP_STATUS";        //::  Current ship status
const string AR_DESTINATION    = "AR_SHP_DESTINATION";   //::  Name to our destination
const string AR_TRUE_DEST      = "AR_SHP_DEST_TAG";      //::  Tag to our destination
const string AR_ID             = "AR_SHP_ID";            //::  A unique ID for a player ship
const string AR_DURATION       = "AR_SHP_DURATION";      //::  Duration to reach a destination in RL minutes
const string AR_AT_SEA         = "AR_SHP_AT_SEA";        //::  Is the ship at sea or in harbor/dock/port
const string AR_ATTACK         = "AR_SHP_ATTACK";        //::  If we are under attack/attacking
const string AR_PIRATING       = "AR_SHP_PIRATING";      //::  Checks if a ship is pirating or not
const string AR_TARGET         = "AR_SHP_TARGET_TAG";    //::  The ship's target tag to another player ship
const string AR_SEARCH_TARGET  = "AR_SHP_TARGET_SEARCH"; //::  For Flagships so we can keep track of which ship we are searching for
const string AR_HIDE           = "AR_SHP_HIDE";          //::  Ship's hide ratio, value from 0-20
const string AR_IS_GRAPPLED    = "AR_SHP_IS_GRAPPLED";   //::  Checks if a ship is grappled or not
const string AR_ENEMY_AREA     = "AR_SHP_ENEMY_AREA";    //::  This variable holds which enemy area we are to encounter
const string AR_ENEMY_WP       = "AR_SHP_ENEMY_WP";      //::  This variable holds WHERE in which enemy area we are to do the encounter
const string AR_CAN_PIRATE     = "AR_SHP_CAN_PIRATE";    //::  True if the ship can do pirating
const string AR_CAN_SEARCH     = "AR_SHP_CAN_SEARCH";    //::  True if the ship can search for other PC ships
const string AR_CAN_RAYNE      = "AR_SHP_CAN_RAYNE";     //::  True if the ship can travel to Rayne's Landing
const string AR_CAN_FISH       = "AR_SHP_CAN_FISH";      //::  True if the ship can do fishing
const string AR_UD_VESSEL      = "AR_SHP_UD_VESSEL";     //::  True if the vessel is from the Underdark
const string AR_RENTABLE       = "AR_SHP_RENTABLE";      //::  True if the ship is rentable with limited timeout
const string AR_RENT_TIMEOUT   = "AR_SHP_RENT_TIMEOUT";  //::  Duration a Rentable ship is available for before losing ownership.
const string AR_RENT_TIMER     = "AR_SHP_RENT_TIMER";    //::  Current Timer in hours for the Rent Timeout
const string AR_RENT_HOUR      = "AR_SHP_RENT_HOUR";     //::  Timer to count up to one IG hour (6 ticks) since we changed Updates every minute
const string AR_STORED_PORT    = "AR_SHP_STORED_PORT";   //::  Stored Real Name Port for rentable ships
const string AR_STORED_DEST    = "AR_SHP_STORED_DEST";   //::  Stored Tag destination port for rentable ships
const string AR_EVENT_CHANCE   = "AR_EVENT_CHANCE";      //::  Internal counter for a Ship to increase chances to find something if we have been unlucky for a while.
const string AR_WAR_MERCHANT   = "AR_SHP_WAR_MERCHANT";  //::  To store if PC vessel attacked this type of NPC ship
const string AR_WAR_PIRATE     = "AR_SHP_WAR_PIRATE";    //::  To store if PC vessel attacked this type of NPC ship
const string AR_WAR_CORDOR     = "AR_SHP_WAR_CORDOR";    //::  To store if PC vessel attacked this type of NPC ship
const string AR_WAR_AMN        = "AR_SHP_WAR_AMN";       //::  To store if PC vessel attacked this type of NPC ship

const int    AR_NPC_VESSELS    = 4;                      //::  Number of NPC ships that can be found
const int    AR_SEA_TARGETS    = 7;                      //::  Number of Sea Targets that can be found
const int    AR_SHIPS          = 8;                      //::  The total amount of ships (player ships) in the module to update

const string LOG_SHIP          = "SHIP_SYSTEM";         //::  For Tracing

//::----------------------------------------------------------------------------
//:: DECLARATION
//::----------------------------------------------------------------------------

//::  Returns oShip's name.
string GetShipName(object oShip);
//::  Returns oShip's status.
string GetShipStatus(object oShip);
//::  Returns oShip's destination (pure name string, ie Cordor. Not tags!)
string GetShipDestination(object oShip);
//::  Returns TRUE if oShip is under attack.
int GetShipUnderAttack(object oShip);
//::  Returns the name of oShip's target (only works on PC vessels atm)
string GetTargetShipName(object oShip);
//::  Returns oShip's current target ship (player vessel).
object GetTargetShip(object oShip);
//::  Returns the name of the ship oShip is searching for.
string GetSearchName(object oShip);
//::  Returns TRUE if oShip is out at sea.
int IsShipAtSea(object oShip);
//::  Returns TRUE if oShip is pirating.
int IsShipPirating(object oShip);
//::  Returns TRUE if oShip has a target.
int GetHasShipTarget(object oShip);
//::  Returns TRUE if oShip is grappled.
int GetIsGrappled(object oShip);
//::  Returns TRUE if oShip can do pirating.
int GetCanShipPirate(object oShip);
//::  Returns TRUE if oShip can search for other PC ships individually (Cordorian Flagship only!).
int GetCanShipSearch(object oShip);
//::  Returns TRUE if oShip can travel to Rayne's Landing.
int GetCanShipRayne(object oShip);
//::  Returns TRUE if oShip can do fishing.
int GetCanShipFish(object oShip);
//::  Returns TRUE if Rayne's Landing is open (The beacon has been lit)
int GetIsRayneOpen();
//::  Returns TRUE if oShip is a UD vessel
int GetIsUDVessel(object oShip);
//::  Returns the amount of coal on the UD vessel the Dreadnought.
int GetDreadCoalStorage();
//::  Returns TRUE of oShip is rentable.
int GetIsShipRentable(object oShip);
//::  Returns the current rent Timer for oShip.
int GetShipCurrentRentTimer(object oShip) { return GetLocalInt(oShip, AR_RENT_TIMER); }
//::  Returns the max total rent hours available for oShip.
int GetShipRentTimeout(object oShip) { return GetLocalInt(oShip, AR_RENT_TIMEOUT); }

//::  Sets oShip's status to sStatus
void SetShipStatus(object oShip, string sStatus);
//::  Sets oShip's destination to sDestination (pure name string, ie Cordor. Not tags!)
void SetShipDestination(object oShip, string sDestination);

//::  Displays a sMessage from the navigator at oShip
void DoNavigatorMessage(object oShip, string sMessage);
//::  Wrapper function that updates oShip's status when we have a destination,
void SetShipDestinationStatus(object oShip);
//::  Helper function, probably exists in the NWNLexicon somewhere.
//:: - sTag      The tag of the object you want to find
//:: - oArea     The area to seach in
object GetObjectByTagInArea(string sTag, object oArea);
//::  Sends sMessage to all PCs on oShip
void AlertPlayersOnShip(object oShip, string sMessage);
//::  Returns TRUE if there are any players on deck, otherwise  false.
int ArePlayersOnDeck(object oShip);
//::  Returns the average player level on oShip's deck to calculate proper spawns.
int GetAveragePlayerLevel(object oShip);
//::  Returns the number of players on oShip's deck area.
int GetNumberOfPlayersOnDeck(object oShip);
//::  Returns a random value range from min to max.
//::  fPercentage is the weight of max, e.g fPercentage of 0.5 on
//::  a max value of 6 would be 3, thus function returns at highest a 3 + min.
int GetSpawnAmount(int min, int max, float fPercentage);
//::  Adds nAmount of coal to the dreadnought coal storage
void AddDreadCoalStorage(int nAmount);
//::  Subtracts nAmount of coal to the dreadnought coal storage
void SubDreadCoalStorage(int nAmount);



//::----------------------------------------------------------------------------
//::  ar_  prefix functions are specific for the ship guild system.  Everything
//::  above, especially the Getter and Setter functions are only help functions.
//::  But they help make better read of the code.
//::----------------------------------------------------------------------------

//::  This function starts a voyage for oShip, heading towards sTagDestination as the final goal.
//::  sDestination is just a pure name for the destination, ie "Cordor" or "Wharftown".
//:: - oShip            The object ship (an area) that should do the voyage.
//:: - sDestination     The name of our destination, a pure name such as "Cordor".  Its just for display.
//:: - sTagDestination  The true destination tag to a waypoint the ship is "heading" towards.  When oShip has
//::                    reached its destination this is where PCs will dock from the ship when entering land again.
//:: - bInstant         Set to TRUE to travel to sTagDestination instantly next tick
void ar_DoVoyage(object oShip, string sDestination = "Cordor", string sTagDestination = "AR_DOCK_CORDOR", int bInstant = FALSE);

//::  Starts the pirating feature when called for oShip.
void ar_DoPirating(object oShip);

//::  Called on Module Startup to Initialize the ships.
//::  EDIT: Currently Unused!
void ar_InitShips();

//::  When called this function updates all the player ships in the module.
//::  Should be called from 'gs_m_heartbeat' every RL minute.
void ar_UpdateShips();

//::  Called from within 'ar_UpdateShips' and it simply updates oShip and does the neccesary checks
//::  based on oShip's status, ie pirating, traveling/out at sea and such.
void ar_Update(object oShip);

//::  Is called every hour within 'ar_UpdateShips', it updates current destination status
//::  and if oShip has arrived to its destination it acts accordingly.
//::  Returns TRUE if we have arrived, FALSE if oShip is still out in the sea.
//::  'ar_Update' will only be called if this function returns FALSE.
int ar_Arrive(object oShip);

//::  This function docks or boards a player to/from a ship.  Is called from the zdlg
//::  of rowboats, boarding ladders etc.  And helps as an internal function for
//::  'ar_BoardTargetShip' and 'ar_BoardNPCShip'.
//:: - oShip    The ship to board/leave to/from.
//:: - oPC      The player to dock or board
//:: - bDock    Set to TRUE to to leave oShip, FALSE to board it.
//:: - bParty   Set to TRUE to board oPCs party within a 10m radius.
void ar_DockBoardPlayer(object oShip, object oPC, int bDock, int bParty = FALSE);

//::  Removes or Adds the rowboat placeable from a port/harbor/destination
//::  belonging to oShip.  Only 1 rowboat is active at a time and only when oShip
//::  is anchored, ie not out at sea.  Otherwise it is removed.
//:: - oShip    The ship the rowboat belongs to, its parent.
//:: - bAdd     Set to TRUE to add a rowboat, FALSE to remove it.
void ar_AddRemoveRowboat(object oShip, int bAdd);

//::  Checks oShips destination to wether adjust the Skiff position or not.
int ar_AdjustSkiffPosition(object oShip);

//::  Calculates the neccisary checks and sees if oShip got a player target ship to
//::  engage.  Returns TRUE if all checks were successful, otherwise FALSE.
//:: - sTargetName   If this parameter has a name we will search for a ship with that name.
//::                 Leave blank to search for any PC ship.
//:: - nBonus        Adds a bonus to the search check for oShip, default is 0.
int ar_SetTargetPCShip(object oShip, string sTargetName = "", int nBonus = 0);

//::  Calculates the neccisary checks and sees if oShip got an enemy NPC vessel to
//::  engage.  Returns TRUE if all checks were successful, otherwise FALSE.
//::  If TRUE oShip is also under attack.
//::  This function makes use of the 'AR_SHP_ENEMY_AREA' and 'AR_SHP_ENEMY_WP' variables to
//::  keep track of which enemy area and where in that area we are to engage.
//:: - nCR      Specify a challenge raiting to search for, if 0 any CR will be choosen.
//::            1 - Merchant, 2 - Pirate, 3 - Cordorian, 4 - Amnish)
//:: - nBonus   Adds a bonus to the search check for oShip, default is 0.
int ar_SetTargetNPCShip(object oShip, int nCR = 0, int nBonus = 0);

//::  A bit different from the other functions  'ar_SetTargetPCShip'  and  'ar_SetTargetNPCShip'.
//::  There are no DC checks in this function, once its run oShip will always find something as
//::  long as its not busy by another PC ship.
//::  It sets the following targets and this is for all ships: Ghost ships, sandbanks, islets, hidden coves or the UD Dreadnaught.
//:: - oShip        The player ship to find one of these targets.
void ar_SetTargetOther(object oShip);

//::  Lets oShip grapple onto its current player target ship.  Can also release it.
//:: - oShip        The ship to do the grapple
//:: - bRelease     If TRUE oShip will release the target ship from the grapple
//::                and FALSE actually does the grapple.
//::  A grappled ship cannot move and is stuck until the grapple chain is released
//::  or the chain is destroyed.
void ar_DoGrappleOnTarget(object oShip, int bRelease = FALSE);

//::  Adds or removes the grapple chain/iron from oShip's target (player vessel).
//::  Is called from 'ar_DoGrappleOnTarget' and the script 'ar_grapple_death.nss'.
void ar_AddRemoveGrappleIron(object oShip, int bRemove = FALSE);

//::  Lets a PC board/leave oShip's current player target ship.
//:: - oShip    The ship who's current target the PC will board/leave
//:: - oPC      The player object to jump
//:: - bBoard   Set to TRUE to board/enter the target ship, FALSE to leave it.
//:: - bParty   Set to TRUE to bring oPC's party as well within a 10m radius.
void ar_BoardTargetShip(object oShip, object oPC, int bBoard = TRUE, int bParty = FALSE);

//::  Lets a PC board/leave a oShip's current enemy NPC vessel ship.
//::  This function makes use of the 'AR_SHP_ENEMY_AREA' and 'AR_SHP_ENEMY_WP' variables
//::  to keep track of which enemy area and where in that area we are to engage.
//:: - oShip    The ship who's current enemy NPC ship the PC will board/leave
//:: - oPC      The player object to jump
//:: - bBoard   Set to TRUE to board/enter the target ship, FALSE to leave it.
//:: - bParty   Set to TRUE to bring oPC's party as well within a 10m radius.
void ar_BoardNPCShip(object oShip, object oPC, int bBoard = TRUE, int bParty = FALSE);

//::  Resets a bunch of variables and status information on oShip.  Used in a couple
//::  of functions mostly to cancel out oShip's current order/action.
//::  Ie, if oShip gets grappled we cancel everything else.
void ar_ResetShip(object oShip);

//::  Resets oShip's current attack position on an enemy NPC vessel or 'others' target.
//::  Also unreserves that slot/position on the ship so other PC vessels
//::  can board it.
void ar_ResetNPCAttackPosition(object oShip);

//::  This function is a "special ability" for the Cordorian Flagship.
//::  It searches for a target ship to engage.
//:: - oShip            The ship to use the search
//:: - sTargetName      The target ship's name to search for
void ar_SearchForSpecificShip(object oShip, string sTargetName);

//::  Creates 4 fishing spots around oShip located at waypoints
//::  AR_WP_FISHING_1   -   AR_WP_FISHING_4
//::  Will always try to remove fishing spots when called and create four new
//::  if bCreate is TRUE.
void ar_DoFishing(object oShip, int bCreate = FALSE);

//::  Either returns a message of the ship type of the NPC vessel oShip is encountering
//::  or a specific 'other' target like the sandbanks, ghost ship, hiden coves etc.
string ar_GetTargetTypeMsg(object oShip);

//::  When called there is a chance to spawn an enemy encounter for oShip.
//::  See  'ar_CreateEncounter'  for more details.
void ar_DoEnemyEncounter(object oShip);

//::  An internal helper function to spawn enemies used by  'ar_DoEnemyEncounter'
void ar_SpawnEncounter(string sResRef, location lLoc, int nAmount);

//::  Sets up the spawn table, look into function implementation for more details.
//::  I moved the spawn table code from  'ar_DoEnemyEncounter'  into a seperate
//::  function so we can delay this function (i.e weaker PCs can retreat below deck).
//::  Also good if we want to keep seperate spawns for the UD for future updates.
void ar_CreateEncounter(object oShip);

//::----------------------------------------------------------------------------
//:: IMPLEMENTATION
//::----------------------------------------------------------------------------
string GetShipName(object oShip) { return GetLocalString(oShip, AR_NAME); }
string GetShipStatus(object oShip) { return GetLocalString(oShip, AR_STATUS); }
string GetShipDestination(object oShip) { return GetLocalString(oShip, AR_DESTINATION); }
int    GetShipUnderAttack(object oShip) { return GetLocalInt(oShip, AR_ATTACK); }
object GetTargetShip(object oShip) { return GetObjectByTag(GetLocalString(oShip, AR_TARGET)); }
string GetTargetShipName(object oShip) { return GetShipName(GetTargetShip(oShip)); }
string GetSearchName(object oShip) { return GetLocalString(oShip, AR_SEARCH_TARGET); }
int    IsShipAtSea(object oShip) { return GetLocalInt(oShip, AR_AT_SEA); }
int    IsShipPirating(object oShip) { return GetLocalInt(oShip, AR_PIRATING); }
int    GetHasShipTarget(object oShip) { return GetLocalString(oShip, AR_TARGET) != ""; }
int    GetIsGrappled(object oShip) { return GetLocalInt(oShip, AR_IS_GRAPPLED); }
int    GetCanShipPirate(object oShip) { return GetLocalInt(oShip, AR_CAN_PIRATE); }
int    GetCanShipSearch(object oShip) { return GetLocalInt(oShip, AR_CAN_SEARCH); }
int    GetCanShipRayne(object oShip) { return GetLocalInt(oShip, AR_CAN_RAYNE); }
int    GetCanShipFish(object oShip) { return GetLocalInt(oShip, AR_CAN_FISH); }
int    GetIsUDVessel(object oShip) { return GetLocalInt(oShip, AR_UD_VESSEL); }
int    GetIsShipRentable(object oShip) { return GetLocalInt(oShip, AR_RENTABLE); }

void SetShipStatus(object oShip, string sStatus) { SetLocalString(oShip, AR_STATUS, sStatus); AssignCommand(GetObjectByTagInArea("AR_NAVIGATOR", oShip), PlaySound("as_cv_bellship1")); }
void SetShipDestination(object oShip, string sDestination) { SetLocalString(oShip, AR_DESTINATION, sDestination); }


object GetObjectByTagInArea(string sTag, object oArea)
{
    object oObject = GetFirstObjectInArea(oArea);

    while ( GetIsObjectValid(oObject) )
    {
        if ( GetTag(oObject) == sTag)
        {
            return oObject;
        }

        oObject = GetNextObjectInArea(oArea);
    }

    return OBJECT_INVALID;
}

void AlertPlayersOnShip(object oShip, string sMessage)
{
    object oPC = GetFirstObjectInArea(oShip);

    while ( GetIsObjectValid(oPC) )
    {
        if ( GetIsPC(oPC) ) FloatingTextStringOnCreature(sMessage, oPC, FALSE);

        oPC = GetNextObjectInArea(oShip);
    }
}

int ArePlayersOnDeck(object oShip)
{
    object oPC = GetFirstObjectInArea(oShip);

    while ( GetIsObjectValid(oPC) )
    {
        if ( GetIsPC(oPC) ) return TRUE;

        oPC = GetNextObjectInArea(oShip);
    }

    return FALSE;
}

int GetAveragePlayerLevel(object oShip) {
    int nLevel = 0;
    int nAmount = 0;
    object oPC = GetFirstObjectInArea(oShip);

    while (GetIsObjectValid(oPC))
    {
        if (GetIsPC(oPC)) {
            nLevel += GetHitDice(oPC);
            nAmount++;
        }

        oPC = GetNextObjectInArea(oShip);
    }

    return nLevel / nAmount;
}

int GetNumberOfPlayersOnDeck(object oShip) {
    int nAmount = 0;
    object oPC = GetFirstObjectInArea(oShip);

    while (GetIsObjectValid(oPC))
    {
        if (GetIsPC(oPC)) {
            nAmount++;
        }

        oPC = GetNextObjectInArea(oShip);
    }

    return nAmount;
}

int GetSpawnAmount(int min, int max, float fPercentage) {
    return min + Random(FloatToInt(fPercentage * (max+1)));
}

void DoNavigatorMessage(object oShip, string sMessage)
{
    object oNavi = GetObjectByTagInArea("AR_NAVIGATOR", oShip);
    AssignCommand( oNavi, SpeakString(sMessage) );
}

void SetShipDestinationStatus(object oShip)
{
    if (GetShipDestination(oShip) == "") return;

    int    nHour = GetLocalInt(oShip, AR_DURATION);
    string sHour = IntToString( nHour ) + "</c> hours";

    if (nHour < 2)  sHour = IntToString( nHour ) + "</c> hour";

    //string sStatus = "at sea heading towards " + GetShipDestination(oShip) + ".  I estimate we will reach our destination in <c þ >" + sHour;
    string sStatus = "at sea heading towards " + GetShipDestination(oShip);

    if (IsShipPirating(oShip))
    {
        if ( GetCanShipSearch(oShip) && GetSearchName(oShip) != "")
        {
            if ( GetSearchName(oShip) != "NPC" )
                sStatus += ". We are also looking for the <c þ >" + GetSearchName(oShip) + "</c>";
            else
                sStatus += ". We are also looking for other vessels";
        }
        else    sStatus += ". We are also searching the seas";
    }

    SetShipStatus(oShip, sStatus);
}

int GetIsRayneOpen()
{
    object oArea = GetObjectByTag("AR_A_RAYNE");

    return GetLocalInt(oArea, "AR_RAYNE_OPEN");
}

int GetDreadCoalStorage()
{
    string sValue = miDAGetKeyedValue("gs_system", "ar_dread_coal_storage", "value");
    int nCoal = StringToInt(sValue);

    if (sValue == "")   return 0;
    if (nCoal < 0)      return 0;
    if (nCoal > 3000)   return 3000;

    return nCoal;
}

void AddDreadCoalStorage(int nAmount)
{
    int nCoal = GetDreadCoalStorage();

    nCoal += nAmount;

    if (nCoal < 0)           nCoal = 0;
    else if (nCoal > 3000)   nCoal = 3000;

    miDASetKeyedValue("gs_system", "ar_dread_coal_storage", "value", IntToString(nCoal));
}

void SubDreadCoalStorage(int nAmount)
{
    int nCoal = GetDreadCoalStorage();

    nCoal -= nAmount;

    if (nCoal < 0)           nCoal = 0;
    else if (nCoal > 3000)   nCoal = 3000;

    miDASetKeyedValue("gs_system", "ar_dread_coal_storage", "value", IntToString(nCoal));
}


//::----------------------------------------------------------------------------
//::  Ship System specific functions below, everyone with the prefix ar_
//::----------------------------------------------------------------------------
void ar_DoVoyage(object oShip, string sDestination = "Cordor", string sTagDestination = "AR_DOCK_CORDOR", int bInstant = FALSE)
{
    //::  If grappled you can't do voyage!
    if (GetIsGrappled(oShip)) return;

    //::  Extra check to cancel voyage if coal is drained.
    if ( GetIsUDVessel(oShip) && GetDreadCoalStorage() <= 0)    return;

    ar_ResetNPCAttackPosition(oShip);

    //::  New destination
    if (sTagDestination != "")
    {
        //:: UPDATE 7 JUNE 2016:  Rather than using hours and do hourly updates the ship system now uses
        //:: each RL minute as a "tick".  More precise control here and can speed travel a bit.
        int nMinutes = 4 + d2();
        //::  Extra duration if Rayne's Landing or Blackfin Rock is the destination.
        if (sTagDestination == "AR_DOCK_RAYNE" || sTagDestination == "AR_DOCK_SHARK") nMinutes += 2;
        sTagDestination = sTagDestination + "_" + IntToString( GetLocalInt(oShip, AR_ID) );

        //::  Flagged to reach destination next tick.
        if (bInstant){
            nMinutes = 1;
        }

        //::  Check if we are anchored at the destination or are heading towards the destination.
        if ( sTagDestination == GetLocalString(oShip, AR_TRUE_DEST) )
        {
            if (IsShipAtSea(oShip))
                DoNavigatorMessage(oShip, "We are already heading for " + GetShipDestination(oShip) + ".");
            else
                DoNavigatorMessage(oShip, "But we have already reached " + GetShipDestination(oShip) + "!");

            return;
        }

        ar_AddRemoveRowboat(oShip, FALSE);
        SetLocalString(oShip, AR_TRUE_DEST, sTagDestination);
        SetLocalInt(oShip, AR_DURATION, nMinutes);
        SetLocalInt(oShip, AR_PIRATING, FALSE);

        SetShipDestination(oShip, sDestination);
        SetShipDestinationStatus(oShip);

        DoNavigatorMessage(oShip, "Set sail for " + GetShipDestination(oShip) + "!" );
    }
    //::  Lay out at sea
    else
    {
        ar_AddRemoveRowboat(oShip, FALSE);
        ar_ResetShip(oShip);
        DoNavigatorMessage(oShip, "To the seas!");
    }

    SetLocalInt( oShip, AR_AT_SEA, TRUE );
}

void ar_DoPirating(object oShip)
{
    ar_ResetNPCAttackPosition(oShip);

    if (!IsShipAtSea(oShip))
    {
        ar_AddRemoveRowboat(oShip, FALSE);
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_PIRATING, TRUE);
        SetLocalInt(oShip, AR_AT_SEA, TRUE);

        SetShipStatus(oShip, "scouring the seas, searching for anything");
    }
    else
    {
        SetLocalInt(oShip, AR_PIRATING, TRUE);
        SetLocalInt(oShip, AR_AT_SEA, TRUE);

        //::  No destination, just out at sea
        if (GetShipDestination(oShip) == "")
            SetShipStatus(oShip, "scouring the seas, searching for anything");
        //::  Have a destination update status with some extra input
        else
            SetShipDestinationStatus(oShip);
    }


    DoNavigatorMessage(oShip, "Alright mates it be time to search!  To open waters!");
}

void ar_InitShips() {
    int i = 1;
    string sTag;
    object oShip;

    for (; i < (AR_SHIPS + 1); i++)
    {
        sTag  = "AR_SHIP_" + IntToString(i);
        oShip = GetObjectByTag(sTag);

    //::  TODO:   Not USED!
    }
}

void ar_UpdateShips()
{
    int i = 1;
    string sTag;
    object oShip;

    for (; i < (AR_SHIPS + 1); i++)
    {
        sTag  = "AR_SHIP_" + IntToString(i);
        oShip = GetObjectByTag(sTag);

        //::  If ship has arrived don't update sea specific events
        if ( ar_Arrive( oShip ) == FALSE )
        {
            ar_Update(oShip);
        }

        //::  Increase timer for rentable ships and abandon ownership if needed.
        //::  Only update this timer if Ship has a owner
        if ( GetIsShipRentable(oShip) && !gsQUGetIsVacant(oShip) ) {
            int nTick       = GetLocalInt(oShip, AR_RENT_HOUR) + 1;
            int nRentTimer  = GetShipCurrentRentTimer(oShip);

            //::  Updates has been changed from 1 IG Hour to 1 RL Minute, so only do this
            //::  every 6th tick which essentially is 1 IG Hour.
            if (nTick >= 6) {
                nTick = 0;
                nRentTimer++;
            }

            //::  Renting ship has expired, return vessel and abandon ownership
            if ( nRentTimer >= GetShipRentTimeout(oShip) ) {
                gsQUAbandon(oShip);
                nRentTimer = 0;
                nTick      = 0;

                string sReturnPort = GetLocalString(oShip, AR_STORED_PORT);
                string sReturnLoc  = GetLocalString(oShip, AR_STORED_DEST);
                DoNavigatorMessage(oShip, "Ship rental expired!  We are returning to " + sReturnPort + "!");
                ar_ResetShip(oShip);
                ar_DoVoyage(oShip, sReturnPort, sReturnLoc, TRUE);

                Log(LOG_SHIP, "Returning rental ship " + GetShipName(oShip) + " to " + sReturnPort + " (" + sReturnLoc + ")");
            }

            SetLocalInt(oShip, AR_RENT_HOUR, nTick);
            SetLocalInt(oShip, AR_RENT_TIMER, nRentTimer);
        }
    }
}

void ar_Update(object oShip)
{
    int bPirating = GetLocalInt(oShip, AR_PIRATING);
    int bDoCheck  = TRUE;

    //::  Check Coal storage for the UD vessel
    if ( GetIsUDVessel(oShip) && IsShipAtSea(oShip) )
    {
        bDoCheck = GetDreadCoalStorage() > 0 ? TRUE : FALSE;

        if (!bDoCheck)      //::  No Fuel left
        {
            DoNavigatorMessage(oShip, "She is out of fuel!  We need more coal!");
            AlertPlayersOnShip(oShip, "The Dreadnought is out of fuel.  The ship is immovable.");
            ar_ResetShip(oShip);
        }
        else                //::  Still have fuel?  Drain some.
        {
            //::  Drains 1 coal every 2nd minute
            if ( !GetLocalInt(oShip, "AR_DREAD_SKIPCOAL") ) {
                SetLocalInt(oShip, "AR_DREAD_SKIPCOAL", TRUE);
                SubDreadCoalStorage(1);
            } else SetLocalInt(oShip, "AR_DREAD_SKIPCOAL", FALSE);
        }
    }

    //::  Ship is pirating, do checks.  But only when we are out on the sea and not under attack.
    if ( bDoCheck && bPirating && IsShipAtSea(oShip) && !GetShipUnderAttack(oShip) )
    {
        int check1 = d3();  //::  Encounter something?   66% chance.
        int check2 = d4();  //::  What did we encounter?  (pc/npc/other)
        int check3 = FALSE; //::  Did we find a ship?  Checks done below.
        int bShipSearch = FALSE;

        if (check1 >= 2)
        {
            //::  Cordorian Flagship only, but only do this if we are actually seaching for another ship.
            if (GetCanShipSearch(oShip) && GetSearchName(oShip) != "")
            {
                //::  If we have target PC ship, only search for that.  ADDED: Search feature gives +3 Search bonus.
                if ( GetSearchName(oShip) != "NPC")
                    check3 = ar_SetTargetPCShip(oShip, GetSearchName(oShip), 3);
                //::  Else search for pirate NPC vessels.  ADDED: Search feature gives +3 Search bonus.
                else
                    check3 = ar_SetTargetNPCShip(oShip, 2, 3);
            }
            //::  Regular Pirating (This includes searching for PC and NPC vessels as well as the 'other' targets)
            else
            {
                int bCanPirate = GetCanShipPirate(oShip);

                switch (check2)
                {
                    case 1:                                                             //::  ADDED:  A +1 on search checks to increase PC warfare.  Also greater chance of PC ship check (50%)
                    case 2:     //::  PC ships
                        if (bCanPirate) {
                            check3 = ar_SetTargetPCShip(oShip, "", 1);
                            bShipSearch = TRUE;
                        }
                        else    ar_SetTargetOther(oShip);
                        break;

                    case 3:     //::  NPC ships
                        if (bCanPirate) {
                            check3 = ar_SetTargetNPCShip(oShip);
                            bShipSearch = TRUE;
                        }
                        else    ar_SetTargetOther(oShip);
                        break;

                    case 4:     //::  Other (Ghostships, Sandbanks etc)
                        ar_SetTargetOther(oShip);
                        break;
                }
            }

            //::  Was searching for a ship, yet found nothing.
            //::  We increase our Event Chance then and will keep on increasing
            //::  until we find something each tick.
            if (!check3 && bShipSearch) {
                int nEventChance = GetLocalInt(oShip, AR_EVENT_CHANCE) + 1;

                if (nEventChance + d10() > 10) {
                    Log(LOG_SHIP, GetShipName(oShip) + " got fallback event at Event Chance: " + IntToString(nEventChance));
                    ar_SetTargetOther(oShip);
                    nEventChance = 0;
                }

                SetLocalInt(oShip, AR_EVENT_CHANCE, nEventChance);
            }

            //::  All checks successful, we have a ship target!
            if (check3) {
                DoNavigatorMessage(oShip, "Ship Ahoy!");
            }
        }
    }

    //::  Ship is under attack
    //::  Do Enemy Encounter but skip this if no PCs are present (So creatures do not stack up!)
    if ( IsShipAtSea(oShip) && !GetShipUnderAttack(oShip) && ArePlayersOnDeck(oShip) ) {
        ar_DoEnemyEncounter(oShip);
    }
}

int ar_Arrive(object oShip)
{
    //::  Docked/Anchored?
    if (IsShipAtSea(oShip) == FALSE) return TRUE;
    //::  Out at sea or attacked, don't do progress
    else if (GetShipDestination(oShip) == "" || GetShipUnderAttack(oShip)) return FALSE;

    int nHoursLeft = GetLocalInt(oShip, AR_DURATION);
    nHoursLeft--;
    SetLocalInt(oShip, AR_DURATION, nHoursLeft);

    //::  Done once when we actually DO arrive
    if (nHoursLeft <= 0)
    {
        ar_AddRemoveRowboat(oShip, TRUE);
        ar_DoFishing(oShip, FALSE);
        SetShipStatus( oShip, "anchored off at " + GetShipDestination(oShip) );
        SetLocalInt( oShip, AR_AT_SEA, FALSE );

        DoNavigatorMessage(oShip, "We have arrived at " + GetShipDestination(oShip) + "!");

        return TRUE;
    }

    //::  We have not arrived yet so just update the time remaining.
    SetShipDestinationStatus(oShip);

    return FALSE;
}

void ar_DockBoardPlayer(object oShip, object oPC, int bDock, int bParty = FALSE)
{
    //::  Send PC to the port/harbor
    if (bDock)
    {
        string sTag = GetLocalString(oShip, AR_TRUE_DEST);
        object oWP  = GetWaypointByTag(sTag);

        AssignCommand( oPC, JumpToObject(oWP) );
    }
    else
    {
        object oTarget = GetObjectByTagInArea("AR_BOATSWAIN", oShip);

        //::  Jump party as well
        if (bParty)
        {
            int i = 0;
            int nAmount = GetNumberPartyMembers(oPC);
            float fDistance;
            object oPlayer;

            //:: Loop through party
            for (; i < nAmount; i++)
            {
                oPlayer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, i);
                fDistance = GetDistanceBetween(oPC, oPlayer);

                //::  Added 31st Oct:  We have to make sure oPlayer is in the same party as oPC!
                if(fDistance <= 10.0 && GetFactionEqual(oPC, oPlayer))
                {
                    AssignCommand(oPlayer, ClearAllActions());
                    AssignCommand(oPlayer, JumpToObject(oTarget));
                }
            }
        }

        AssignCommand(oPC, JumpToObject(oTarget));
    }

}

void ar_AddRemoveRowboat(object oShip, int bAdd)
{
    string sTag = GetLocalString(oShip, AR_TRUE_DEST);

    if (sTag == "") return;

    if (bAdd)
    {
        //::  UPDATE:  19th April 2015 - Lower Skiff a bit under the ground to avoid collision issues in troubled areas.
        object oWP      = GetWaypointByTag(sTag);
        object oArea    = GetArea(oWP);
        vector vPos     = GetPosition(oWP);
        if ( ar_AdjustSkiffPosition(oShip) ) vPos.z -= 0.2;
        float fRot      = GetFacing(oWP);
        location lLoc   = Location(oArea, vPos, fRot);

        object oObject = CreateObject( OBJECT_TYPE_PLACEABLE, "ar_shp_rowboat", lLoc);
        SetLocalString(oObject, "AR_SHP_PARENT", GetTag(oShip));
        return;
    }

    //::  Find Skiff that has oShip as parent and remove it.
    object oArea = GetArea( GetWaypointByTag(sTag) );
    object oBoat = GetFirstObjectInArea(oArea);

    while ( GetIsObjectValid(oBoat) )
    {
        if ( GetLocalString(oBoat, "AR_SHP_PARENT") == GetTag(oShip) )
        {
            DestroyObject(oBoat);
            break;
        }

        oBoat = GetNextObjectInArea(oArea);
    }
}

int ar_AdjustSkiffPosition(object oShip) {
    string sDest = GetShipDestination(oShip);

    if (sDest == "Cordor")              return TRUE;
    if (sDest == "Wharftown")           return TRUE;
    if (sDest == "Sencliff")            return TRUE;
    if (sDest == "Red Dragon Isle")     return TRUE;
    //if (sDest == "Cordor")      return TRUE;
    //if (sDest == "Cordor")      return TRUE;

    return FALSE;
}

int ar_SetTargetPCShip(object oShip, string sTargetName = "", int nBonus = 0)
{
    int i = 1;
    string sTag;
    object oTargetShip;

    for (; i < (AR_SHIPS + 1); i++)
    {
        sTag  = "AR_SHIP_" + IntToString(i);
        oTargetShip = GetObjectByTag(sTag);

        //::  A viable target found
        if ( oTargetShip != oShip && IsShipAtSea(oTargetShip) && !GetShipUnderAttack(oTargetShip) )
        {
            //::  Did we find a ship?
            if ( ( d20() + nBonus ) > GetLocalInt(oTargetShip, AR_HIDE) )
            {
                //::  Flagship only (Only flagship can engage UD vessels)
                if ( GetCanShipSearch(oShip) && sTargetName == GetShipName(oTargetShip) )
                {
                    SetLocalString(oShip, AR_TARGET, sTag);

                    if (GetIsUDVessel(oTargetShip))     SetShipStatus(oShip, "alongside a ship shrouded in darkness");                  //::  Specific description for the Dreadnought
                    else                                SetShipStatus(oShip, "alongside <c þ >" + GetShipName(oTargetShip) + "</c>");
                    return TRUE;
                }
                //::  Pirating  (Can't engage UD vessels)
                else if ( sTargetName == "" && !GetIsUDVessel(oTargetShip) )
                {
                    SetLocalString(oShip, AR_TARGET, sTag);
                    SetShipStatus(oShip, "alongside <c þ >" + GetShipName(oTargetShip) + "</c>");
                    return TRUE;
                }
            }
        }
    }

    return FALSE;
}

int ar_SetTargetNPCShip(object oShip, int nCR = 0, int nBonus = 0)
{
    //::  What type of ship (Merchant, Pirate, Cordorian, Amnish)?
    int check1 = 1 + Random(AR_NPC_VESSELS);
    //::  If oShip wants to encounter a specific CR NPC ship
    if (nCR != 0)  check1 = nCR;
    //::  What size of ship type (Cog, Galley, Brigantine, Galleon)?
    int check2 = d4();
    //::  Hide check.
    //::  Merchant (low) Cordorian (Medium) Pirate (high) Amnish (very high)
    //::  Better size on ship also increases the hide.
    int check3 = 2 + (2 * check1) + (2 * check2);

    //::  Did we find the ship?
    if ( ( d20() + nBonus ) >= check3)
    {
        string sAreaTag = "AR_SHP_ENEMY_AREA_" + IntToString(check1);
        string sWPTag   = "AR_SHP_ENEMY_WP_" + IntToString(check2);

        //::  Reserve the area's location
        object oArea = GetObjectByTag(sAreaTag);
        string sVar  = "AR_ATTACK_" + IntToString(check2);

        //::  That location is already occupied, return FALSE
        if ( GetLocalInt(oArea, sVar) == TRUE)
            return FALSE;

        SetLocalInt(oArea, sVar, TRUE);

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the ladder to know its ship parent
        string sTag = "AR_BOARD_LADDER_" + IntToString(check2);
        object oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside another vessel");
        return TRUE;
    }

    return FALSE;
}

void ar_SetTargetOther(object oShip)
{
    //::  What did we find? (Ghost ships, sandbanks, islets, hidden coves or UD Dreadnaught)
    int check1 = 1 + Random(AR_SEA_TARGETS);
    int check2 = d4();
    string sAreaTag = "AR_SHP_ATS_AREA_";       //::  Keeps track of the target Area oShip is to dock
    string sWPTag   = "AR_SHP_ENEMY_WP_";       //::  Keeps track where in the Area oShip will dock
    string sVar     = "AR_ATTACK_";             //::  Builds up the correct variable to flag it as "reserved"
    string sTag     = "AR_BOARD_LADDER_";       //::  Identifies which skiff/ladder to mark oShip as its parent
    object oArea;                               //::  Stores the active area object with help from sAreaTag
    object oLadder;                             //::  Stores the ladder/skiff object (basically the entry point) for oShip

    switch(check1)
    {
    //::  Abandoned Sea Fortress
    case 1:
        sAreaTag += "1";
        check2   = d2();     //::  Sea Fortress only have 2 waypoints
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside a a ruined fortress");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    //::  Ghost Ships
    case 2:
        sAreaTag += "2";
        check2   = d2();    //::  Ghost ships only have 2 waypoints
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the ladder to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside an abandoned ship");
        DoNavigatorMessage(oShip, "Ship Ahoy!");
        break;
    //::  Hidden Coves
    case 3:
        sAreaTag += "3";
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside a cove");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    //::  Islets
    case 4:
        sAreaTag += "4";
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside an islet");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    //::  Sandbanks
    case 5:
        sAreaTag += "5";
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside a sandbank");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    //::  Shipwrecks
    case 6:
        sAreaTag += "6";
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if ( GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside a shipwreck");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    //::  Isle of Gnitheidr/Vedr
    case 7:
        sAreaTag += "7";
        check2   = 1;    //::  Only have 1 waypoint
        sWPTag   += IntToString(check2);

        oArea    = GetObjectByTag(sAreaTag);
        sVar     += IntToString(check2);

        if (GetLocalInt(oArea, sVar) == TRUE)  //::  Area is occupied
            return;

        SetLocalInt(oArea, sVar, TRUE);         //::  Reserve area

        //::  Setup some variables for oShip
        ar_ResetShip(oShip);
        SetLocalInt(oShip, AR_ATTACK, TRUE);    //::  Comment this line to still enable attacks on ship
        SetLocalString(oShip, AR_ENEMY_AREA, sAreaTag);
        SetLocalString(oShip, AR_ENEMY_WP, sWPTag);

        //::  We also need to adjust the rowboat to know its ship parent
        sTag += IntToString(check2);
        oLadder = GetObjectByTagInArea(sTag, oArea);
        SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));

        SetShipStatus(oShip, "alongside an island");
        DoNavigatorMessage(oShip, "Land Ahoy!");
        break;
    }
}

void ar_DoGrappleOnTarget(object oShip, int bRelease = FALSE)
{
    string sTag = GetLocalString(oShip, AR_TARGET);
    object oTarget = GetObjectByTag(sTag);

    //::  Release target ship
    if (bRelease == TRUE)
    {
        AlertPlayersOnShip(oShip, "The grapple is being released on the " + GetShipName(oTarget) + "!");
        AlertPlayersOnShip(oTarget, "The " + GetShipName(oShip) + " is releasing the grapple!");

        //::  TODO:  Should this be called here anyway?  What's best?
        //::  They are now called from within ar_AddRemoveGrappleIron when you pass TRUE in the 2nd param.
        //ar_ResetShip(oShip);
        //ar_ResetShip(oTarget);

        //::  Remove grappling iron after 30 seconds
        DelayCommand(30.0, ar_AddRemoveGrappleIron(oShip, TRUE));
        return;
    }

    //::  Extra check, always good
    if ( IsShipAtSea(oTarget) && !GetShipUnderAttack(oTarget) )
    {
        AlertPlayersOnShip(oShip, "The " + GetShipName(oTarget) + " has been grappled!");
        AlertPlayersOnShip(oTarget, "The ship has been grappled by the " + GetShipName(oShip) + "!");

        SetLocalInt(oShip, AR_ATTACK, TRUE);
        SetLocalInt(oTarget, AR_ATTACK, TRUE);
        SetLocalInt(oTarget, AR_IS_GRAPPLED, TRUE);

        //::  Add grappling iron
        ar_AddRemoveGrappleIron(oShip, FALSE);
    }
    //::  Target ship lost, this can happen if the ship is updated
    //::  later than oShip and is no longer at sea or already attacked.
    else
    {
        DoNavigatorMessage(oShip, "I'm afraid we lost the ship!");
        ar_ResetShip(oShip);
    }
}

void ar_AddRemoveGrappleIron(object oShip, int bRemove = FALSE)
{
    object oTarget = GetTargetShip(oShip);

    if (bRemove)
    {
        object oChild = GetFirstObjectInArea(oTarget);

        //::  Removes all child objects belonging to their oShip parent (ladder, rowboat, chain)
        while ( GetIsObjectValid(oChild) )
        {
            if ( GetLocalString(oChild, "AR_SHP_PARENT") == GetTag(oShip) )
            {
                DestroyObject(oChild);
            }

            oChild = GetNextObjectInArea(oTarget);
        }

        //::  Also reset both ships once this is over
        ar_ResetShip(oShip);
        ar_ResetShip(oTarget);

        return;
    }


    object oWP1 = GetObjectByTagInArea("AR_SHP_LADDER", oTarget);
    object oWP2 = GetObjectByTagInArea("AR_SHP_ROWBOAT", oTarget);
    object oWP3 = GetObjectByTagInArea("AR_SHP_GRAPPLE", oTarget);
    //::  Added Fix: 2014 Nov 16th
    object oWP4 = GetObjectByTagInArea("AR_SHP_BOARD", oTarget);

    object oBoat            = CreateObject(OBJECT_TYPE_PLACEABLE, "ar_shp_rowboat", GetLocation(oWP2));
    object oLadder          = CreateObject(OBJECT_TYPE_PLACEABLE, "ar_board_ladder", GetLocation(oWP4));    //::  Changed Position
    object oChain           = CreateObject(OBJECT_TYPE_PLACEABLE, "ar_iron_chain", GetLocation(oWP3));
    object oStaticLadder    = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_weatheredladd", GetLocation(oWP1));   //::  Static Ladder

    SetUseableFlag(oBoat, FALSE);

    SetLocalString(oBoat, "AR_SHP_PARENT", GetTag(oShip));
    SetLocalString(oLadder, "AR_SHP_PARENT", GetTag(oShip));
    SetLocalString(oChain, "AR_SHP_PARENT", GetTag(oShip));
    SetLocalString(oStaticLadder, "AR_SHP_PARENT", GetTag(oShip));

    //::  If UD vessel, the Dreadnought, add darkness effect over Grappling Iron for 3 min.
    if (GetIsUDVessel(oShip))
    {
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectDarkness(), GetLocation(oWP3), 180.0f );
    }
}

void ar_BoardTargetShip(object oShip, object oPC, int bBoard = TRUE, int bParty = FALSE)
{
    //::  Leave pc target ship
    if (bBoard == FALSE)
    {
        ar_DockBoardPlayer(oShip, oPC, FALSE, bParty);
        return;
    }

    object oTarget = GetTargetShip(oShip);
    object oWP = GetObjectByTagInArea("AR_SHP_BOARD", oTarget);

    //AssignCommand(oPC, ClearAllActions());
    //AssignCommand(oPC, JumpToObject(oWP));

    //::  Added 31 Oct
    //::  Jump party as well
    if (bParty)
    {
        int i = 0;
        int nAmount = GetNumberPartyMembers(oPC);
        float fDistance;
        object oPlayer;

        //:: Loop through party
        for (; i < nAmount; i++)
        {
            oPlayer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, i);
            fDistance = GetDistanceBetween(oPC, oPlayer);

            if(fDistance <= 10.0 && GetFactionEqual(oPC, oPlayer))
            {
                AssignCommand(oPlayer, ClearAllActions());
                AssignCommand(oPlayer, JumpToObject(oWP));
            }
        }
    }

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(oWP));
}

void ar_BoardNPCShip(object oShip, object oPC, int bBoard = TRUE, int bParty = FALSE)
{
    //::  Leave npc ship
    if (bBoard == FALSE)
    {
        ar_DockBoardPlayer(oShip, oPC, FALSE, bParty);
        return;
    }

    string sEnemyAreaTag = GetLocalString(oShip, AR_ENEMY_AREA);
    object oTarget = GetObjectByTag( sEnemyAreaTag );
    object oWP = GetObjectByTagInArea( GetLocalString(oShip, AR_ENEMY_WP), oTarget );

    //::  Added 7 June 2016
    //::  Store NPC Vessel Hostile Action for Naval Intel
    if( sEnemyAreaTag == "AR_SHP_ENEMY_AREA_1")         //::  Merchant
        SetLocalInt(oShip, AR_WAR_MERCHANT, TRUE);
    else if( sEnemyAreaTag == "AR_SHP_ENEMY_AREA_2")    //::  Pirate
        SetLocalInt(oShip, AR_WAR_PIRATE, TRUE);
    else if( sEnemyAreaTag == "AR_SHP_ENEMY_AREA_3")    //::  Cordorian
        SetLocalInt(oShip, AR_WAR_CORDOR, TRUE);
    else if( sEnemyAreaTag == "AR_SHP_ENEMY_AREA_4")    //::  Amnish
        SetLocalInt(oShip, AR_WAR_AMN, TRUE);


    //::  Added 31 Oct
    //::  Jump party as well
    if (bParty)
    {
        int i = 0;
        int nAmount = GetNumberPartyMembers(oPC);
        float fDistance;
        object oPlayer;

        //:: Loop through party
        for (; i < nAmount; i++)
        {
            oPlayer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, i);
            fDistance = GetDistanceBetween(oPC, oPlayer);

            if(fDistance <= 10.0 && GetFactionEqual(oPC, oPlayer))
            {
                AssignCommand(oPlayer, ClearAllActions());
                AssignCommand(oPlayer, JumpToObject(oWP));
            }
        }
    }

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToObject(oWP));
}

void ar_ResetShip(object oShip)
{
    SetShipStatus(oShip, "at sea");
    SetShipDestination(oShip, "");

    SetLocalString(oShip, AR_TRUE_DEST, "");
    SetLocalString(oShip, AR_TARGET, "");
    SetLocalString(oShip, AR_SEARCH_TARGET, "");
    SetLocalString(oShip, AR_ENEMY_AREA, "");
    SetLocalString(oShip, AR_ENEMY_WP, "");

    SetLocalInt(oShip, AR_AT_SEA, TRUE);
    SetLocalInt(oShip, AR_ATTACK, FALSE);
    SetLocalInt(oShip, AR_IS_GRAPPLED, FALSE);
    SetLocalInt(oShip, AR_DURATION, 0);
    SetLocalInt(oShip, AR_PIRATING, FALSE);

    ar_DoFishing(oShip, FALSE);
}

void ar_ResetNPCAttackPosition(object oShip)
{
    //::  ADDED:  Also reset 'AR_SEARCH_TARGET', specifically for the Flagship.
    SetLocalString(oShip, AR_SEARCH_TARGET, "");

    string sAreaTag = GetLocalString(oShip, AR_ENEMY_AREA);
    string sWPTag   = GetLocalString(oShip, AR_ENEMY_WP);

    if (sAreaTag == "" || sWPTag == "")
        return;

    SetLocalInt(oShip, AR_ATTACK, FALSE);
    SetLocalString(oShip, AR_ENEMY_AREA, "");
    SetLocalString(oShip, AR_ENEMY_WP, "");

    //::  Unreserve the area's location
    string sAttackID = GetSubString(sWPTag, 16, 1);

    object oArea = GetObjectByTag(sAreaTag);
    string sVar  = "AR_ATTACK_" + sAttackID;

    SetLocalInt(oArea, sVar, FALSE);
}

void ar_SearchForSpecificShip(object oShip, string sTargetName)
{
    int i = 1;
    object oTargetShip;
    string sTag;

    for (; i < (AR_SHIPS + 1); i++)
    {
        sTag  = "AR_SHIP_" + IntToString(i);
        oTargetShip = GetObjectByTag(sTag);

        //::  Ship found?
        if (oShip != oTargetShip && GetShipName(oTargetShip) == sTargetName)
        {
            ar_DoPirating(oShip);
            SetLocalString(oShip, AR_SEARCH_TARGET, GetShipName(oTargetShip));

            //::  Correct status messages, 'ar_DoPirating' doesn't update them right for this ability.
            if (GetShipDestination(oShip) == "")
                SetShipStatus(oShip, "at sea looking for the <c þ >" + GetSearchName(oShip) + "</c>");
            else
                SetShipDestinationStatus(oShip);

            break;
        }
    }
}

void ar_DoFishing(object oShip, int bCreate = FALSE)
{
    if ( !GetCanShipFish(oShip) ) return;

    if (!IsShipAtSea(oShip))
    {
        ar_AddRemoveRowboat(oShip, FALSE);
        ar_ResetShip(oShip);
        SetShipStatus(oShip, "at sea");
    }

    int i = 1;
    string sTag;
    string sNewTag;
    location lLoc;
    object oFishing;

    //::  Always try and remove fishing spots first
    for (; i <= 4; i++)
    {
        sTag = "AR_SHP_FISH_" + IntToString(i);
        oFishing = GetObjectByTagInArea(sTag, oShip);
        DestroyObject(oFishing);
    }

    if (!bCreate)
        return;

    //::  Create fishing spots
    for (i = 0; i <= 4; i++)
    {
        sTag    = "AR_WP_FISHING_" + IntToString(i);
        sNewTag = "AR_SHP_FISH_" + IntToString(i);

        lLoc = GetLocation( GetObjectByTagInArea(sTag, oShip) );
        CreateObject(OBJECT_TYPE_PLACEABLE, "ar_pl_fishspot", lLoc, FALSE, sNewTag);
    }
}

string ar_GetTargetTypeMsg(object oShip)
{
    string sArea = GetLocalString(oShip, AR_ENEMY_AREA);
    string sMsg  = "We're alongside ";

    //::  NPC Ships
    if (sArea == "AR_SHP_ENEMY_AREA_1")         sMsg += "a Merchantile vessel";
    else if (sArea == "AR_SHP_ENEMY_AREA_2")    sMsg += "a Pirate vessel";
    else if (sArea == "AR_SHP_ENEMY_AREA_3")    sMsg += "a Cordorian vessel";
    else if (sArea == "AR_SHP_ENEMY_AREA_4")    sMsg += "an Amnian vessel";

    //::  Other Targets (Islands, Coves, Sandbanks etc)
    else if (sArea == "AR_SHP_ATS_AREA_1")      sMsg += "a Naval Fort";
    else if (sArea == "AR_SHP_ATS_AREA_2")      sMsg += "an abandoned ship";
    else if (sArea == "AR_SHP_ATS_AREA_3")      sMsg += "a cove";
    else if (sArea == "AR_SHP_ATS_AREA_4")      sMsg += "an islet";
    else if (sArea == "AR_SHP_ATS_AREA_5")      sMsg += "a sandbank";
    else if (sArea == "AR_SHP_ATS_AREA_6")      sMsg += "a ship wreck";
    else if (sArea == "AR_SHP_ATS_AREA_7")      sMsg += "an island";
    else                                        sMsg += "a...  I have no clue what that is";

    sMsg += " and ready to board mate";

    return sMsg;
}

void ar_DoEnemyEncounter(object oShip)
{
    int nEncounter = d100();

    if ( GetShipUnderAttack(oShip) ) return;

    //::  33% chance for NPC encounter
    if (nEncounter >= 66)
    {
        AlertPlayersOnShip(oShip, "Enemies are closing in!  Prepare to be boarded!");
        AssignCommand(GetObjectByTagInArea("AR_NAVIGATOR", oShip), PlaySound("as_cv_bellship1"));

        //::  Delay a bit before we spawn the enemies.
        DelayCommand(10.0, ar_CreateEncounter(oShip));
    }
}

void ar_SpawnEncounter(string sResRef, location lLoc, int nAmount)
{
    int i = 0;

    for (; i < nAmount; i++)
    {
        CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
    }
}



void ar_CreateEncounter(object oShip)
{
    //::  Reworked encounter system (Check below for more details)
    //::  Weaker encounters should spawn more often and all encounters
    //::  have been reduced, usually 1-3 monsters at a time.
    object   oWP  = GetObjectByTagInArea("AR_SHP_GRAPPLE", oShip);
    location lLoc = GetLocation(oWP);

    int nPlayers        = GetNumberOfPlayersOnDeck(oShip);
    int nAvgLevel       = GetAveragePlayerLevel(oShip);
    float fPercentage   = ClampFloat(nPlayers/5.0f, 0f, 1f);
    int nType, nAmount;

    //:: Low Level
    if (nAvgLevel <= 10) {
        nType = d6();

        switch (nType) {
        case 1:     //::  Weak Pirates
            nAmount = GetSpawnAmount(1, 4, fPercentage);
            ar_SpawnEncounter("ar_pirate", lLoc, nAmount);
            break;
        case 2:     //::  Weak Harpy
            nAmount = GetSpawnAmount(1, 4, fPercentage);
            ar_SpawnEncounter("x2_harpy001", lLoc, nAmount);
            break;
        case 3:     //::  Sea Mephits
            nAmount = GetSpawnAmount(1, 4, fPercentage);
            ar_SpawnEncounter("nw_mepwater", lLoc, nAmount);
            break;
        case 4:     //::  Kuo Toan
            nAmount = GetSpawnAmount(1, 2, fPercentage);
            ar_SpawnEncounter("kuotoa", lLoc, nAmount);
            break;
        case 5:     //::  Impressed Half-Orc, Press Ganger
        case 6:
            ar_SpawnEncounter("cj_seacre005", lLoc, GetSpawnAmount(1, 3, fPercentage));
            ar_SpawnEncounter("cj_seacre006", lLoc, GetSpawnAmount(1, 3, fPercentage));
            break;
        }
    }
    //:: Medium Level
    else if (nAvgLevel <= 18) {
        nType = d6();

        switch (nType) {
        case 1:     //::  Weak Pirates
            nAmount = GetSpawnAmount(1, 6, fPercentage);
            ar_SpawnEncounter("ar_pirate", lLoc, nAmount);
            break;
        case 2:     //::  Weak Sahuagin
            nAmount = GetSpawnAmount(1, 6, fPercentage);
            ar_SpawnEncounter("ar_sahuagin_war", lLoc, nAmount);
            ar_SpawnEncounter("ar_sahuagin_clr", lLoc, 1);
            break;
        case 3:     //::  Strong Harpy
            nAmount = GetSpawnAmount(1, 3, fPercentage);
            ar_SpawnEncounter("ar_grharpy", lLoc, nAmount);
            break;
        case 4:     //::  Wyvern
            nAmount = GetSpawnAmount(1, 2, fPercentage);
            ar_SpawnEncounter("j3wyvern", lLoc, nAmount);
            break;
        case 5:     //::  Kuo Toan (Warrior, Whip)
            ar_SpawnEncounter("kuotoa", lLoc, GetSpawnAmount(1, 4, fPercentage));
            ar_SpawnEncounter("kuotoa001", lLoc, GetSpawnAmount(1, 2, fPercentage));
            break;
        case 6:     //::  Aquatic Goblins (Aquatic Goblin, Sea-Witch)
            ar_SpawnEncounter("cj_seacre001", lLoc, GetSpawnAmount(2, 5, fPercentage));
            ar_SpawnEncounter("cj_seacre002", lLoc, GetSpawnAmount(0, 2, fPercentage));
            break;
        }
    }
    //:: High Level
    else if (nAvgLevel <= 26) {
        nType = d4();

        switch (nType) {
        case 1:     //::  Strong Pirates
            ar_SpawnEncounter("ar_buccaneer", lLoc, GetSpawnAmount(1, 3, fPercentage));
            ar_SpawnEncounter("ar_swashbuckler", lLoc, GetSpawnAmount(0, 2, fPercentage));
            break;
        case 2:     //::  Strong Sahagin
            ar_SpawnEncounter("ar_sahuagin_mas", lLoc, GetSpawnAmount(1, 3, fPercentage));
            ar_SpawnEncounter("ar_sahuagin_pri", lLoc, GetSpawnAmount(0, 2, fPercentage));
            break;
        case 3:     //::  Ghostly Siren
            ar_SpawnEncounter("ar_ghostsiren", lLoc, GetSpawnAmount(1, 3, fPercentage));
            break;
        case 4:     //::  Ghost Pirate, Skeletal Pirate
            ar_SpawnEncounter("cj_seacre003", lLoc, GetSpawnAmount(1, 3, fPercentage));
            ar_SpawnEncounter("cj_seacre004", lLoc, GetSpawnAmount(1, 2, fPercentage));
            break;
        }
    }
    //::  Epic
    else {
        nType = d4();

        switch (nType) {
        case 1:     //::  Strong Pirates
            ar_SpawnEncounter("ar_buccaneer", lLoc, GetSpawnAmount(1, 5, fPercentage));
            ar_SpawnEncounter("ar_swashbuckler", lLoc, GetSpawnAmount(1, 4, fPercentage));
            break;
        case 2:     //::  Strong Sahagin
            ar_SpawnEncounter("ar_sahuagin_mas", lLoc, GetSpawnAmount(2, 3, fPercentage));
            ar_SpawnEncounter("ar_sahuagin_pri", lLoc, GetSpawnAmount(1, 2, fPercentage));
            break;
        case 3:     //::  Dagonian Destroyer, Dagonian Vizier
            ar_SpawnEncounter("cj_seacre007", lLoc, GetSpawnAmount(1, 3, fPercentage));
            ar_SpawnEncounter("cj_seacre008", lLoc, GetSpawnAmount(1, 3, fPercentage));
            break;
        case 4:     //::  Marid
            ar_SpawnEncounter("ar_el_marid", lLoc, GetSpawnAmount(1, 2, fPercentage));
            break;
        }
    }

    AlertPlayersOnShip(oShip, "Ship is under attack!");
    AssignCommand(GetObjectByTagInArea("AR_NAVIGATOR", oShip), PlaySound("as_cv_bellship1"));
}

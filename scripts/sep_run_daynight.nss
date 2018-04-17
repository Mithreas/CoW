/*
    sep_run_daynight
	Concept and initial design by Septire, heavily adapted by Mithreas.
	
	Allow merchants (or other NPCs) to kick PCs out of their homes/shops when they close, and lock their doors.
	
	Variables to set on the NPC:
    STRING   "sep_merch_door"               : The Tag of the Door to lock when the merchant is closed.
	INT      "sep_merch_nightowl"           : Closes the merchant at night rather than during the day.
    INT      "sep_respect_steath"           : Allow a PC to stay in the area if NPC can't see them during a kick? 
	
	Waypoints that may exist in the module. 
    WAYPOINT "NPCTag_kick_to"               : Waypoint must exist with specified tag if we're kicking them out at day or night.
	
	Related systems:
	- Gigaschatten engine day/night post waypoints can be used to move the NPC.  GS_WP_DPOST_tag / GS_WP_NPOST_tag
	- The inc_crime system can be used to punish PCs for being caught breaking in.  Put the owned_dr_unlock script
	  on the OnDamaged / OnUnlock event handler for any door or chest to be handled in this way. 
*/
	
#include "inc_event"
//..............................................................................
// Kick players out of the area
void handlePlayerKick(object oKickWP, int nEventNum, int bNightOwl);
//..............................................................................
// Lock or unlock the NPC's door.
void handleDoor(string sDoorTagToHandle, int nEventNum, int bNightOwl);

//..............................................................................
void handlePlayerKick(object oKickWP, int nEventNum, int bNightOwl)
{
	// Only kick players if we are closing. 
	if (bNightOwl && nEventNum == SEP_EV_ON_NIGHTPOST) return; 
	if (!bNightOwl && nEventNum == SEP_EV_ON_DAYPOST) return;
	
    object oNPC         = OBJECT_SELF;
    object oThisArea    = GetArea(OBJECT_SELF);
    int bRespectStealth = GetLocalInt(OBJECT_SELF, "sep_respect_stealth");
    string sTime;
	
    if (nEventNum == SEP_EV_ON_DAYPOST)
    {
        sTime = "day";
    }
    else if (nEventNum == SEP_EV_ON_NIGHTPOST)
    {
        sTime = "night";
    }
	
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (GetArea(oPC) == oThisArea &&
            !GetIsDM(oPC))
        {
            if (bRespectStealth &&
                GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED &&
                GetObjectHeard(oPC, oNPC) == FALSE &&
                GetObjectSeen(oPC, oNPC) == FALSE)
            {
                SendMessageToPC(oPC, GetName(oNPC) + " has closed up shop, but "+
                "hasn't realized you're still in the building!");
            }
            else
            {
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, JumpToLocation(GetLocation(oKickWP)));
                AssignCommand(oPC, SetFacing(GetFacingFromLocation(GetLocation(oKickWP))));
                SendMessageToPC(oPC, GetName(oNPC) + " has closed up shop for the " +
                sTime + " and has escorted you out for closing hours.");
            }
        }
		
        oPC = GetNextPC();
    }
}
//..............................................................................
void handleDoor(string sDoorTagToHandle, int nEventNum, int bNightOwl)
{	
    int nDoorState = FALSE;

    if (nEventNum ==  SEP_EV_ON_DAYPOST)
    {
        // Day Post behaviour here.
        if (bNightOwl) nDoorState = TRUE;
    }
    else if (nEventNum == SEP_EV_ON_NIGHTPOST)
    {
        // Night Post behaviour here.
        if (!bNightOwl) nDoorState = TRUE;
    }

    if (sDoorTagToHandle != "")
    {
        // Handle the door's locked state
        SetLocked(GetObjectByTag(sDoorTagToHandle), nDoorState);
    }
}
//..............................................................................
void main()
{
    int nEventNum = GetUserDefinedEventNumber();
    if (!nEventNum)
    {
        nEventNum = GetLocalInt(OBJECT_SELF, "sep_run_daynight");
    }
	
    object oNPC             = OBJECT_SELF;
    string sDoorTagToHandle = GetLocalString(oNPC, "sep_merch_door");
	int    bNightOwl        = GetLocalInt(oNPC, "sep_merch_nightowl");
    object oKickWP          = GetWaypointByTag(GetLocalString(oNPC, "NPCTag_kick_to"));
	

    if (GetIsObjectValid(oKickWP)) handlePlayerKick(oKickWP, nEventNum, bNightOwl);
    
	if (sDoorTagToHandle != "") handleDoor(sDoorTagToHandle, nEventNum, bNightOwl);
}
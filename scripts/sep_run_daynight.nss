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
	  on the OnDamaged / OnUnlock event handler for any door or chest to be handled in this way (and lock it). 
*/

#include "inc_daynight"	

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
	

    if (GetIsObjectValid(oKickWP)) DN_HandlePlayerKick(oKickWP, nEventNum, bNightOwl);
    
	if (sDoorTagToHandle != "") DN_HandleDoor(sDoorTagToHandle, nEventNum, bNightOwl);
}
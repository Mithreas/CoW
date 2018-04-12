#include "inc_event"
//..............................................................................
// Kick players out of the area
void handlePlayerKick(int nEventNum, int bRespectStealth);
//..............................................................................
// NPC behaviour for the day or night cycle
void doShiftChange(int nEventNum, int bForceful);
//..............................................................................
// Rotate a guard or some other NPC with his day or night counterpart.
void _PathfindNPC(object oNPC, location lChangePoint, location lFinalPoint);
//..............................................................................

void _WalkToRotationPoint(object oNPC, location lDestinationPoint);

//..............................................................................
void main()
{
    /*
    MAJOR VARIABLES USED IN THIS SYSTEM:

    INT      "sep_merch_daykick"            : Kick PCs out of the area during the DayCycle? 1 Yes, 0 No
    INT      "sep_merch_nightkick"          : Kick PCs out of the area during the NightCycle? 1 Yes, 0 No
    INT      "sep_respect_steath"           : Allow a PC to stay in the area if NPC can't see them during a kick? 1 Yes, 0 No
    WAYPOINT "NPCTag_kick_day"              : Waypoint must exist with specified tag if we're kicking them on a DayCycle.
    WAYPOINT "NPCTag_kick_night"            : Waypoint must exist with specified tag if we're kicking them on a NightCycle.
    STRING   "sep_merch_door"               : The Tag of the Door to fiddle with, with either unlocking or locking. Merchant-specific.
    INT      "sep_merch_door_lockatnight"   : Merchant outer door locks during the NightCycle? 1 Yes, 0 No
    INT      "sep_merch_door_lockatday"     : Merchant outer door locks during the DayCycle? 1 Yes, 0 No
    WAYPOINT "NPCTag_finalpoint_day"        : Waypoint must exist as one of the Patrol posts, NPCs alternate between Day and Night depending on where they are placed.
    WAYPOINT "NPCTag_finalpoint_night"      : Waypoint must exist as one of the Patrol posts, NPCs alternate between Day and Night depending on where they are placed.
    WAYPOINT "NPCTag_changepoint"           : Waypoint must exist as one of the Patrol posts, NPCs move to their Change Point before moving on to their Final Point.
    STRING   "sep_shift_conv_break"         : If set, this is what the NPC will say this line when breaking off a conversation during a post change.
    */
	
    int nEventNum = GetUserDefinedEventNumber();
    if (!nEventNum)
    {
        nEventNum = GetLocalInt(OBJECT_SELF, "sep_run_daynight");
    }
    int bDayPostKick = GetLocalInt(OBJECT_SELF, "sep_merch_daykick");
    int bNightPostKick = GetLocalInt(OBJECT_SELF, "sep_merch_nightkick");
    int bForceful = GetLocalInt(OBJECT_SELF, "sep_forceful");


    if ((nEventNum == SEP_EV_ON_DAYPOST && bDayPostKick) ||
        (nEventNum == SEP_EV_ON_NIGHTPOST && bNightPostKick))
    {
        int bRespectStealth = GetLocalInt(OBJECT_SELF, "sep_respect_stealth");
        handlePlayerKick(nEventNum, bRespectStealth);
    }
    doShiftChange(nEventNum, bForceful);
}

//..............................................................................
void handlePlayerKick(int nEventNum, int bRespectStealth)
{
    object oNPC = OBJECT_SELF;
    object oThisArea = GetArea(OBJECT_SELF);
    object oKickWP;
    string sTime;

    if (nEventNum == SEP_EV_ON_DAYPOST)
    {
        sTime = "day";
        oKickWP = GetWaypointByTag(GetLocalString(oNPC, "KICKPLAYER_DAY_TAG"));
    }
    else if (nEventNum == SEP_EV_ON_NIGHTPOST)
    {
        sTime = "night";
        oKickWP = GetWaypointByTag(GetLocalString(oNPC, "KICKPLAYER_NIGHT_TAG"));
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
void doShiftChange(int nEventNum, int bForceful)
{
    object oNPC = OBJECT_SELF;
    object oThisArea = GetArea(oNPC);
    string sTime;

    // Merchant Related
    string sDoorTagToHandle = GetLocalString(oNPC, "sep_merch_door");
    int nDoorLockNight = GetLocalInt(oNPC, "sep_merch_door_lockatnight");
    int nDoorLockDay = GetLocalInt(oNPC, "sep_merch_door_lockatday");
    int nDoorState = FALSE;

    // Guard/Generic NPC related
    object oWaypointChangePoint = GetWaypointByTag(GetLocalString(oNPC, "CHANGEPOINT_TAG"));
    int bHasValidChangepoint = GetIsObjectValid(oWaypointChangePoint) ? TRUE : FALSE;
    location lChangePoint = GetLocation(oWaypointChangePoint);
    object oWaypointFinalPointDay = GetWaypointByTag(GetLocalString(oNPC, "DAY_TAG"));
    object oWaypointFinalPointNight = GetWaypointByTag(GetLocalString(oNPC, "NIGHT_TAG"));
    int bIsDynamicMerchant = GetIsObjectValid(oWaypointFinalPointDay) ? TRUE : FALSE;

    if (!bHasValidChangepoint && !bIsDynamicMerchant)
    {
        return;
    }

    if (bForceful)
    {
        AssignCommand(oNPC, ClearAllActions());
        location lFinalLoc;

        if (nEventNum == SEP_EV_ON_DAYPOST)
        {
            lFinalLoc = GetLocation(oWaypointFinalPointDay);
            nDoorState = nDoorLockDay;
        }
        else
        {
            lFinalLoc = GetLocation(oWaypointFinalPointNight);
            nDoorState = nDoorLockNight;
        }
            AssignCommand(oNPC, ActionJumpToLocation(lFinalLoc));
            AssignCommand(oNPC, SetFacing(GetFacingFromLocation(lFinalLoc)));
        if (sDoorTagToHandle != "")
        {
            // Handle the door's locked state
            SetLocked(GetObjectByTag(sDoorTagToHandle), nDoorState);
        }
    return;
    }

    location lFinalPoint;
    float fDistance;
    int bNoAlternate = GetLocalInt(oNPC, "NoAlternateLogic");

    if (nEventNum ==  SEP_EV_ON_DAYPOST)
    {
        // Day Post behaviour here. This runs at ~6 am game time.
        if (nDoorLockDay) nDoorState = TRUE;
        sTime = "day";
        lFinalPoint = GetLocation(oWaypointFinalPointDay);
/*
        fDistance = GetDistanceBetweenLocations(GetLocation(oNPC), lFinalPoint);

        if ((fDistance > 0.0 && fDistance < 6.0) &&
            (bHasValidChangepoint) &&
            (!bNoAlternate))
        {
            lFinalPoint = GetLocation(oWaypointFinalPointNight);
        }
*/
    }
    else if (nEventNum == SEP_EV_ON_NIGHTPOST)
    {

       if (nDoorLockNight) nDoorState = TRUE;
       // Night Post behaviour here. This runs at ~6 pm game time.
       sTime = "night";
       lFinalPoint = GetLocation(oWaypointFinalPointNight);
/*
       fDistance = GetDistanceBetweenLocations(GetLocation(oNPC), lFinalPoint);
       if ((fDistance > 0.0 && fDistance < 6.0) &&
           (bHasValidChangepoint) &&
           (!bNoAlternate))
       {
           lFinalPoint = GetLocation(oWaypointFinalPointDay);
       }
*/
    }
    // Shift change action here:
    if (bHasValidChangepoint)
    {
        // Make the guards move to their Change Point!
        AssignCommand(oNPC, ClearAllActions());
        if (IsInConversation(oNPC))
        {
            AssignCommand(oNPC, ActionSpeakString("My shift has ended. Speak with my reliever."));
        }
            // Normal behaviour
            _PathfindNPC(oNPC, lChangePoint, lFinalPoint);
    }
    else
    {
        // Jump the merchant into position
        AssignCommand(oNPC, ActionJumpToLocation(lFinalPoint));
        AssignCommand(oNPC, SetFacing(GetFacingFromLocation(lFinalPoint)));
    }
    if (sDoorTagToHandle != "")
    {
        // Handle the door's locked state
        SetLocked(GetObjectByTag(sDoorTagToHandle), nDoorState);
    }
}

//..............................................................................
void _PathfindNPC(object oNPC, location lChangePoint, location lFinalPoint)
{
    // First step is to move to the Change Point. Second step is to move to the Final Point.
    float fDistanceBetweenCP = GetDistanceBetweenLocations(GetLocation(oNPC), lChangePoint);
    float fDistanceBetweenFP = GetDistanceBetweenLocations(GetLocation(oNPC), lFinalPoint);

    // Destination is either 0: Change point, or 1: Final point.
    int nDestination = GetLocalInt(oNPC, "sep_shift_destination");
    int nArrived = GetLocalInt(oNPC, "sep_shift_arrived");
	
    if (GetTimeHour() != 6 && GetTimeHour() != 20)
    {
        // We have spent too long trying to reach our location, so jump there.
        AssignCommand(oNPC, ClearAllActions());
        AssignCommand(oNPC, ActionJumpToLocation(lFinalPoint));
        SetLocalInt(oNPC, "sep_shift_arrived", 1);
    }
    // This gets triggered when the shift-change is completed.
    if (nArrived)
    {
        // Shift change completed, post-arrival at Finalpoint.
        // Reset variables for next shift change.
        SetLocalInt(oNPC, "sep_shift_destination", 0);
        SetLocalInt(oNPC, "sep_shift_arrived", 0);
        AssignCommand(oNPC, SetFacing(GetFacingFromLocation(lFinalPoint)));
        //AssignCommand(oNPC, SpeakString("DEBUG: Done. Arrived where I needed to go."));
        return;
    }

    // Moving to CP --[
    if (nDestination == 0 && fDistanceBetweenCP < 0.0)
    {
        // Change point is in another area, so just jump to it.
        AssignCommand(oNPC, ClearAllActions());
        AssignCommand(oNPC, ActionJumpToLocation(lChangePoint));
        SetLocalInt(oNPC, "sep_shift_destination", 1);
        //AssignCommand(oNPC, SpeakString("DEBUG: Change point is in another area, I am portalling!"));
    }
    else if (nDestination == 0 && fDistanceBetweenCP < 2.0 && fDistanceBetweenCP >= 0.0)
    {
        // Arriving at Changepoint in same area
        SetLocalInt(oNPC, "sep_shift_destination", 1);
        object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oNPC);
        if (GetDistanceBetween(oNPC, oDoor) < 9.0 && GetIsOpen(oDoor) == FALSE)
        {
            AssignCommand(oNPC, ActionOpenDoor(oDoor));
            DelayCommand(20.0, AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_DOOR_CLOSE)));
        }
        //AssignCommand(oNPC, SpeakString("DEBUG: I've arrived at my changepoint."));
    }
    // ]--

    // Moving to FP --[
    else if (nDestination == 1 && fDistanceBetweenFP < 0.0)
    {
        //Final point in another area, jump to it.
        AssignCommand(OBJECT_SELF, ClearAllActions());
        AssignCommand(oNPC, ActionJumpToLocation(lFinalPoint));
        SetLocalInt(oNPC, "sep_shift_arrived", 1);
        //AssignCommand(oNPC, SpeakString("DEBUG: My Final point is in another area, I am portalling!"));
        // Done.
    }
    else if (nDestination == 1 && fDistanceBetweenFP < 2.0 && fDistanceBetweenFP >= 0.0)
    {
        // Arriving at Finalpoint in same area
        SetLocalInt(oNPC, "sep_shift_arrived", 1);
        AssignCommand(oNPC, SetFacing(GetFacingFromLocation(lFinalPoint)));
        //AssignCommand(oNPC, SpeakString("DEBUG: I've arrived at my finalpoint."));
    }
    // ]--


    if (nDestination == 0)
    {
        _WalkToRotationPoint(oNPC, lChangePoint);
    }
    else if (nDestination == 1)
    {
        _WalkToRotationPoint(oNPC, lFinalPoint);
    }
    // Recursive call until we actually get there!
    DelayCommand(6.0, _PathfindNPC(oNPC, lChangePoint, lFinalPoint));
}

//..............................................................................
void _WalkToRotationPoint(object oNPC, location lDestinationPoint)
{
    // Am I already at the Destination Point?
    float fDistanceToPoint = GetDistanceBetweenLocations(GetLocation(oNPC), lDestinationPoint);
    if (fDistanceToPoint < 1.0 && fDistanceToPoint >= 0.0)
    {
        return;
    }

    int nAction = GetCurrentAction(oNPC);
    int bIsGeneric = (GetLocalString(oNPC, "sep_shift_conv_break") == "") ? TRUE : FALSE;

    // Not moving and not in combat...
    if (nAction != ACTION_MOVETOPOINT &&
        !GetIsInCombat(oNPC))
        {
            //AssignCommand(oNPC, SpeakString("DEBUG: Entered Conditional"));
            // Ah, some PC must be talking to us, but we really need to get to the change point!
            if (IsInConversation(oNPC))
            {
                string sRandomLine;
                if (bIsGeneric)
                {
                    string sSex = (GetGender(oNPC) == GENDER_FEMALE) ? "woman" : "man";
                    string sPartner = (GetGender(oNPC) == GENDER_FEMALE) ? "husband" : "wife";
                    switch(d20())
                    {
                        case 1:  sRandomLine = "I have to go now."; break;
                        case 2:  sRandomLine = "Sorry, we'll have to chat next time."; break;
                        case 3:  sRandomLine = "It's been nice talking, but I must go."; break;
                        case 4:  sRandomLine = "I don't want to be late, I have somewhere to be."; break;
                        case 5:  sRandomLine = "We'll speak again tomorrow."; break;
                        case 6:  sRandomLine = "Must go now, so sorry."; break;
                        case 7:  sRandomLine = "I'm done for today, I must go."; break;
                        case 8:  sRandomLine = "I need to go."; break;
                        case 9:  sRandomLine = "We'll talk later."; break;
                        case 10: sRandomLine = "Another time."; break;
                        case 11: sRandomLine = "We need to end this conversation for now."; break;
                        case 12: sRandomLine = "Another time!"; break;
                        case 13: sRandomLine = "Not now, I need to go."; break;
                        case 14: sRandomLine = "I have to leave now, sorry."; break;
                        case 15: sRandomLine = "We will speak again another time."; break;
                        case 16: sRandomLine = "Can we talk about this later? I need to go."; break;
                        case 17: sRandomLine = "I can't stay a moment longer, I'm afraid."; break;
                        case 18: sRandomLine = "I don't have time for any more questions, sorry."; break;
                        case 19: sRandomLine = "My " + sPartner + " will be waiting on me. I need to go"; break;
                        case 20: sRandomLine = "I have to go home and be a family " + sSex +  " too, you know."; break;
                    }
                }
                else
                {
                    sRandomLine = GetLocalString(oNPC, "sep_shift_conv_break");
                }
                // Sorry buddy, have to go!
                AssignCommand(oNPC, SpeakString(sRandomLine));
                //AssignCommand(oNPC, ActionPauseConversation());
                AssignCommand(oNPC, ActionStartConversation(oNPC, "sep_stub", TRUE, FALSE));
                //ExecuteScript("sep_clearall", GetPCSpeaker());

            }
            // Start walking to the destination
            //AssignCommand(oNPC, SpeakString("DEBUG: Continuing onto Destination."));
            //AssignCommand(oNPC, ClearAllActions());
            AssignCommand(oNPC, ActionMoveToLocation(lDestinationPoint));
        }
        // Already on the moving or killing things, don't interrupt.
        //AssignCommand(oNPC, SpeakString("DEBUG: I am not interrupted."));
        //AssignCommand(oNPC, SpeakString("DEBUG: Current Action is: "+ IntToString(nAction)));

}

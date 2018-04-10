// CHECKLOOP
// Is run every 1 turn, it isn't attached to a heartbeat script so it won't execute
// unless a player has been in the area to trigger it, it will however decrement and
// shutdown without a player being present in case they disconnect mid transit.
///////////////////////////////////////////////////////////
void CheckLoop(){
    object oCaptain     = GetObjectByTag("aas_captain");
    int iTimer          = GetLocalInt(oCaptain, "liTimer");
    int iAtSea          = GetLocalInt(oCaptain, "liAtSea");

    // If it's still in transit decrement time remaining
    if(iTimer > 0 && iAtSea == TRUE){
        //SendMessageToPC(GetFirstPC(), "Timer decrement, " + IntToString(iTimer) + " turns left");
        SetLocalInt(oCaptain, "liTimer", iTimer - 1);
    }

    // If time's out get the extra variables in place, find all PC's in area and shift them
    if(iTimer == 0 && iAtSea == TRUE){
        object oPlayer      = GetFirstObjectInArea(GetArea(oCaptain));
        string sTargetWP    = GetLocalString(oCaptain, "lsDestination");

        // Find ALL PCs in the area and jump them to target
        while(GetIsObjectValid(oPlayer)){
            int iIsPC           = GetIsPC(oPlayer);

            if (iIsPC){
                AssignCommand(oPlayer, ClearAllActions(TRUE));
                AssignCommand(oPlayer, JumpToObject(GetWaypointByTag(sTargetWP)));
                SetLocalInt(oPlayer, "liTravelling", FALSE);
            }

            oPlayer         = GetNextObjectInArea(GetArea(oCaptain));
        }

        // Reset the Captain's Local variables ready for next voyage
        SetLocalInt(oCaptain, "liAtSea", FALSE);
        SetLocalInt(oCaptain, "liTimer", 0);
    }

    if(iAtSea == TRUE){
        DelayCommand(6.0, CheckLoop());
    }
}

// MAIN
// Nothing much to see here, it's just the kick start
///////////////////////////////////////////////////////////
void main()
{
    CheckLoop();
}

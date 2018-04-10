// If a player has become stuck on the ship the captain will run this script
// to kick them off at the "nearest" port.
void main()
{
    object oPlayer      = GetPCSpeaker();
    object oCaptain     = GetObjectByTag("aas_captain");
    object oWP          = GetWaypointByTag(GetLocalString(oCaptain, "lsDestination"));

    // If the ship's just been somewhere then leave them at nearest port
    if (GetIsObjectValid(oWP)){
        AssignCommand(oPlayer, ClearAllActions(TRUE));
        AssignCommand(oPlayer, JumpToObject(oWP));
    }
    // If there wasn't a previous destination just chuck him off at default
    else if (!GetIsObjectValid(oWP)){
        AssignCommand(oPlayer, ClearAllActions(TRUE));
        AssignCommand(oPlayer, JumpToObject(GetWaypointByTag("wp_default")));
    }
}

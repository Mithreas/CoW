// This little script changes the captains conversation if the player is stuck on the ship
// If a player disconnects adrift, then comes back he'll be stuck there so the captain
// Changes his conversation to drop off the player.
int StartingConditional()
{
    object oCaptain     = GetObjectByTag("aas_captain");
    int iAtSea          = GetLocalInt(oCaptain, "liAtSea");

    if (iAtSea == FALSE){
        return TRUE;
    }

    return FALSE;
}

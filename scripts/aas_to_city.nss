// GENERIC SCRIPT FOR N00BS
// Just follow the step's I've marked and you're away
///////////////////////////////////////////////////
void main()
{

    ///////////////////////////////////////////////////
    // USER EDITTABLE VARIABLES
    // Step 1:
    //  Check you've created a waypoint at the destination and editted it's "tag" value
    //
    // Step 2:
    //  Where it says "waypointtag" put in the destination WP's "tag" value ("between speech marks "like this" ");
    //
    // Step 3:
    //  Where it says "my destination" put in an appropriate name (the player will shout "all aboard who's coming aboard for [insert name here]")
    //
    // Step 4:
    //  Choose "save as" and give it a name
    //
    // Thats all for this bit, go back to the read me file for the rest of the instructions.
    //
    ///////////////////////////////////////////////////
    int iJourneyTime    = 10;               // Put number of turns journey will take here, 1 turn = 6 seconds.
    string sDestination = "wp_default";    // Put the tag of the destination Waypoint here
    string sNameToShout = "The City"; // This is the name the player will shout out announcing departure
    ///////////////////////////////////////////////////

    object oCaptain     = GetObjectByTag("aas_captain");
    object oPlayer      = GetPCSpeaker();

    AssignCommand(oPlayer, SpeakString("All aboard who's coming aboard for " + sNameToShout + "!"));

    // Set up the Local Variables
    SetLocalInt(oCaptain, "liAtSea", TRUE);
    SetLocalInt(oCaptain, "liTimer", iJourneyTime);
    SetLocalString(oCaptain, "lsDestination", sDestination);

    // Delay the jump to the high seas in case people need to shift about
    DelayCommand(6.0, ExecuteScript("aas_depart", oPlayer));

    // Start the timer
    ExecuteScript("aas_checkusers", oCaptain);
}

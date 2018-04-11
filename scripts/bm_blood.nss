/*
    Filename: I_bm_it_cleanup
    Author: Barking_Mad
    Created: 8/11/2008
    Modified: 8/11/2008
    Description:
                  When this script is called on a player the
                  nearest blood patch to the player that activated it is found
                  and, if in range and of sufficient age, the player will clean it up.

    Notes:      Requires the blood patch and water puddle placeables with
                the corresponding item tags and ResRefs as described in the
                the include file "inc_bloodstains".

    EDIT: Now calls to a script so that the same functionality can be called from an item
            or directly from another script, executed on the player in question

*/
#include "inc_bloodstains"

void main()
{
    object oPlayer = OBJECT_SELF;
    object oBlood = BMGetNearestBloodStain( oPlayer );

    //Found a nearby stain
    if( GetIsObjectValid( oBlood ) && GetIsObjectValid( oPlayer ) )
    {
        //Stains ready for cleanup
        if( BMIsBloodStainExpired( oBlood ) )
        {
            //Do the cleanup stuff
            BMActionCleanupBloodStain( oPlayer, oBlood );
        }
        else
        {
            SendMessageToPC( oPlayer, "This blood is too fresh to be easily cleaned. Perhaps wait a while and try again." );
        }
    }
}

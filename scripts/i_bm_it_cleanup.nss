/*
    Filename: I_bm_it_cleanup
    Author: Barking_Mad
    Created: 8/11/2008
    Modified: 8/11/2008
    Description: This is an Item even script for the PC blood cleanup kit.
                  When an item with a tag matching this script name is activated
                  nearest blood patch to the player that activated it is found
                  and, if in range and of sufficient age, the player will clean it up.

    Notes:      Requires the blood patch and water puddle placeables with
                the corresponding item tags and ResRefs as described in the
                the include file "bm_inc_blood".

    EDIT: Now calls to a script so that the same functionality can be called from an item
            or directly from another script, executed on the player in question

*/
#include "x2_inc_switches"

void main()
{
    //If this isnt an activate event, get out
    if ( GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE ) return;

    object oPlayer = GetItemActivator();

    if( GetIsObjectValid( oPlayer ) ) ExecuteScript( "bm_blood", oPlayer );
}

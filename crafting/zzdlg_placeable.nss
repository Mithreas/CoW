// zzdlg_placeable
//
// Copyright 2005-2006 by Greyhawk0
//
// A placeable's onUsed conversation starter. It uses placeable's properties for
//      parameters. This will reference a dialog script that is

// PARAMETERS (Variables belonging to the item)

// "dialog"
// Variable type: STRING
// Default: Does nothing if not defined.
// Description: Name of the script to use for this item. (Required)

// "makeprivate"
// Variable type: INT
// Default: Lets others hear the conversation.
// Description: 0 to let others hear conversation, 1 to not.

// "nohello"
// Variable type: INT
// Default: Doesn't play a hello.
// Description: 1 to play a hello, 0 to not play a hello.

// "nozoom"
// Variable type: INT
// Default: Zooms in on the player
// Description: 0 to zoom in on the player, 1 to not zoom.

#include "zzdlg_tools_inc"

void main()
{
    object oPlayer = GetLastUsedBy( );
    object oPlaceable = OBJECT_SELF;

    if ( GetIsPC(oPlayer) == FALSE || GetIsObjectValid(oPlaceable) == FALSE ) return;

    // Get dialog script name from placeable.
    string sScript = GetLocalString( oPlaceable, DLG_VARIABLE_SCRIPTNAME );
    if ( sScript == "" ) return;

    // Gets extra parameters from placeable.
    int iMakeprivate = GetLocalInt( oPlaceable, DLG_VARIABLE_MAKEPRIVATE );
    int iNoHello = GetLocalInt( oPlaceable, DLG_VARIABLE_NOHELLO );
    int iNoZoom = GetLocalInt( oPlaceable, DLG_VARIABLE_NOZOOM );

    // Start the dialog between the placeable and the player
    _dlgStart( oPlayer, oPlaceable, sScript, iMakeprivate, iNoHello, iNoZoom );
}

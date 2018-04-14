/**
 *  $Id: zdlg_check_init.nss,v 1.3 2004/09/18 19:11:45 paul Exp $
 *
 *  Dialog Page initialization for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
#include "inc_zdlg"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    Trace(ZDIALOG, "Talking to:" + GetName(oSpeaker) );
    int nBaseToken = 5000;
    SetLocalInt(oSpeaker, ZDLG_BASE_TOKEN, nBaseToken);

    string sOverrideScript = GetLocalString(OBJECT_SELF, VAR_SCRIPT);
    if (sOverrideScript != "")
    {
      SetCurrentDlgHandlerScript(sOverrideScript);
      DeleteLocalString(OBJECT_SELF, VAR_SCRIPT);
    }

    // Check to see if the conversation is done.  This
    // is the only way we can end a conversation programmatically
    // without making the user abort.
    int state =_GetDlgState( oSpeaker );
    if( state == DLG_STATE_ENDED )
        return( FALSE );

    int hasPrev = _HasDlgPrevious( oSpeaker );
    int hasNext = _HasDlgNext( oSpeaker );

    if( !hasPrev && !hasNext )
        {
        // Initialize the page and possibly the entire conversation
        _InitializePage( oSpeaker );
        }

    // Initialize the values from the dialog configuration
    SetCustomToken( nBaseToken, GetDlgPrompt() );

    int first = _GetDlgFirstResponse( oSpeaker );
    int count = GetDlgResponseCount( oSpeaker );

    // In a multipage response list we reserver entry 13
    // for an End Dialog for later configurability.
    hasPrev = FALSE;
    int maxCount = 13;
    if( first > 0 )
        {
        hasPrev = TRUE;
        maxCount = 10;
        }

    hasNext = FALSE;
    if( count - first >= maxCount )
        hasNext = TRUE;

    // Setup the state to show the previous and next
    // buttons.
    _SetDlgPreviousNext( oSpeaker, hasPrev, hasNext );

    return TRUE;
}

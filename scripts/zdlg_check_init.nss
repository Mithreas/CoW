/**
 *  $Id: zdlg_check_init.nss,v 1.3 2004/09/18 19:11:45 paul Exp $
 *
 *  Dialog Page initialization for the Z-Dialog system.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 *
 *  Horribly hacked by Mithreas to allow us to run this script once, at the
 *  start of the conversation.  All future pages will hit zdlg_check_init0..9
 *  instead.
 */
#include "zdlg_include_i"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    // Clear up any previous dialog that may be hanging around
    _CleanupDlg(oSpeaker);

    Trace(ZDIALOG, "Talking to:" + GetName(oSpeaker) );
    // Addition by Mithreas. To handle heavy load & the resulting cross-use of
    // custom tokens, we have 10 different instances of the Z-dialog master
    // conversation, and select one at random. Each one has its own
    // instance of this script and its own set of custom token numbers but
    // is otherwise unchanged.
    int nTokenSet = GetLocalInt(GetModule(), "ZDLG_TOKEN_SET");
    nTokenSet++;

    if (nTokenSet > 9)
    {
      SetLocalInt(GetModule(), "ZDLG_TOKEN_SET", 0);
    }
    else
    {
      SetLocalInt(GetModule(), "ZDLG_TOKEN_SET", nTokenSet);
      Trace(ZDIALOG, "Starting conversation: zdlg_converse_" + IntToString(nTokenSet));
      ActionStartConversation(oSpeaker, "zdlg_converse_" + IntToString(nTokenSet),
                                                                     TRUE, FALSE);
      return FALSE;
    }

    // If we're still here, use the default token set.
    int nBaseToken = 4200;
    SetLocalInt(oSpeaker, ZDLG_BASE_TOKEN, nBaseToken);

    string sOverrideScript = GetLocalString(OBJECT_SELF, VAR_SCRIPT);
    if (sOverrideScript != "")
    {
      Trace(ZDIALOG, "Using script " + sOverrideScript);
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

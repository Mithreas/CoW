// zzdlg_check_init
//
// Original filename under Z-Dialog: zdlg_check_init
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

#include "zzdlg_tools_inc"

int StartingConditional()
{
    object oSpeaker = _dlgGetPcSpeaker();

    int nCurrent = GetLocalInt(oSpeaker, "FB_DLG_CURRENT") + 1;
    Trace(ZDIALOG, GetName(oSpeaker) + " initializing ZZ-Dialog conversation tree. nCurrent = " + IntToString(nCurrent));

    {
      // Check to see if the conversation is done.
      int iState = GetLocalInt( oSpeaker, DLG_STATE );

      // This code is to show a final farewell, and have an "End Dialog" option like the normal conversations.
      if ( iState == DLG_STATE_ENDED )
      {
        string sFarewellMessage = GetLocalString( oSpeaker, DLG_FAREWELL );
        if (sFarewellMessage=="") return ( FALSE ); // Normal behavior.

        // This sets everything up for the final farewell and end dialog.
        SetLocalString( oSpeaker, DLG_PROMPT, sFarewellMessage );
        SetLocalString( oSpeaker, DLG_PAGE_NAME, "" );
        SetLocalString( oSpeaker, DLG_RESPONSE_LIST, "" );
        SetLocalInt( oSpeaker, DLG_HAS_END, FALSE );
        SetLocalInt( oSpeaker, DLG_HAS_RESET, FALSE );
      }

      // Initialize the page but not the entire conversation.
      else if ( iState == DLG_STATE_RUNNING )
      {
        if (!GetLocalInt(oSpeaker, "FB_DLG_INITIALIZING"))
        {
            Trace(ZDIALOG, "Initializing page.");
            _dlgInitializePage( oSpeaker );
        }
      }

      // Initialize the page and the entire conversation
      else
      {
        Trace(ZDIALOG, "Initializing conversation.");
        _dlgInitializePage( oSpeaker );
        SetLocalInt(oSpeaker, "FB_DLG_INITIALIZING", TRUE);
      }

      // Just for continue chains.  (Not currently being used).
      _SetupContinueChainedPrompt( oSpeaker );
    }

    // Should we go ahead and view the page or wait a bit?
    // This ONLY APPLIES on the first page, while initializing the convo.
    // After that we are returned directly to the correct top level node and
    // don't need to wait.
    int nSet = GetLocalInt(oSpeaker, DLG_CURRENT_SET);
    Trace(ZDIALOG, "Current token set is: " + IntToString(nSet));
    if (GetLocalInt(oSpeaker, "FB_DLG_INITIALIZING") && (nSet > nCurrent))
    {
        SetLocalInt(oSpeaker, "FB_DLG_CURRENT", nCurrent);
        return FALSE;
    }

    // Clean up initialization variables
    DeleteLocalInt(oSpeaker, "FB_DLG_CURRENT");
    DeleteLocalInt(oSpeaker, "FB_DLG_INITIALIZING");

    // Initialize the values from the dialog configuration
    int nToken = _dlgGetToken(oSpeaker, DLG_BASE_TOKEN);
    string sPrompt = GetLocalString( oSpeaker, DLG_PROMPT );
    Trace(ZDIALOG, "Token is: " + IntToString(nToken) + ", setting to " + sPrompt);
    SetCustomToken( nToken, sPrompt);

    return TRUE;
}

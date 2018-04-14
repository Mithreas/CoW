// zzdlg_tools_inc
//
// Original filename under Z-Dialog: inc_zdlg
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/
//
// Additions and changes from original copyright (c) 2005-2006 Greyhawk0

#include "zzdlg_lists_inc"
#include "inc_log"
const string ZDIALOG = "ZDIALOG"; // For tracing

// SOURCE FILE CONVENTIONS - START
//
// "oThis" - The object (NPC, item, or placeable) that is being talked to by a
//      player's character ("oThis"). Should always be OBJECT_SELF within _this_
//      file and a dialog script file. Items are exceptioned.
//
// "oSpeaker" - The player's character who is talking to the current object
//      ("oThis"). Always use "GetPcDlgSpeaker()" to get the PC if not already
//      provided (and provide it to others as often as possible!).
//
// SOURCE FILE CONVENTIONS - END

// DIALOG EVENTS
const int DLG_EVENT_INIT      = 0; // new dialog is started
const int DLG_EVENT_PAGE_INIT = 1; // new page is started
const int DLG_EVENT_SELECTION = 2; // response was selected
const int DLG_EVENT_ABORT     = 3; // dialog was aborted
const int DLG_EVENT_END       = 4; // dialog ended normally
const int DLG_EVENT_RESET     = 5; // dialog was reset
const int DLG_EVENT_CONTINUE  = 6; // dialog was continued

// DIALOG STATES
const int DLG_STATE_INIT = 0;      // Dialog is new and uninitialized
const int DLG_STATE_RUNNING = 1;   // Dialog is running normally
const int DLG_STATE_ENDED = 2;     // Dialog has ended

// Local variables on the speakee that are placed in toolkit.
const string DLG_VARIABLE_SCRIPTNAME = "dialog";       // STRING - The script filename
const string DLG_VARIABLE_MAKEPRIVATE = "makeprivate"; // INT - Non-zero means private conversation
const string DLG_VARIABLE_NOHELLO = "nohello";         // INT - Non-zero means no hello
const string DLG_VARIABLE_NOZOOM = "nozoom";           // INT - Non-zero means don't zoom-in

// Local String - Speaker - Holds script filename.
const string DLG_CURRENT_SCRIPT = "zzdlgCurrentDialog";

// Local Int    - Speaker - Holds current set.
const string DLG_CURRENT_SET = "FB_CURRENT_SET";

// Local String - Speaker - Current speakee's dialog.
const string DLG_PROMPT = "zzdlgPrompt";

// Local List   - Speaker - List of responses.
const string DLG_RESPONSE_LIST = "zzdlgResponseList";

// Local Int    - Speaker - Current DLG_EVENT_*.
const string DLG_EVENT_TYPE = "zzdlgEventType";

// Local Int    - Speaker - Current selection OnSelection.
const string DLG_SELECTION = "zzdlgEventSelection";

// Local String - Speaker - Current page name
const string DLG_PAGE_NAME = "zzdlgPageName";

// Local Object - Speaker - Current item that is a speakee.
const string DLG_ITEM = "zzdlgItem";

// Local Object - Speakee - Current PC that is speaking to the object (non-talkable).
const string DLG_OBJECT_CONVERSER = "zzdlgConverser";

// Local Int    - Speaker - Current state of dialog.
const string DLG_STATE = "zzdlgState";

// Local Int    - Speaker - Flag if the last selection was next or previous.
const string DLG_LAST_PREVORNEXT = "zzdlgPrevorNext";

// Local Int    - Speaker - Current page's starting response index.
const string DLG_CURRENTPAGE_STARTINDEX = "zzdlgCurrentPageStartIndex";

// Local Int    - Speaker - Flag that preserves the page on selection.
const string DLG_NORESETPAGEONSELECTION = "zzdlgNoResetPageOnSelection";

// Local Int    - Speaker - Current page during continue chain.
const string DLG_CONTINUE_PAGE = "zzdlgContinuePage";

// Local Int    - Speaker - Flag that specifies if a continue chain is active.
const string DLG_CONTINUE_MODE = "zzdlgContinueMode";

// Local List   - Speaker - A list containing a list of dialog pages for continue chain.
const string DLG_CONTINUE_LIST = "zzdlgContinueList";

// Local String - Speaker - The final farewell dialog before the player clicks "End Dialog".
const string DLG_FAREWELL = "zzdlgFarewell";

// Local Int    - Speaker - The maximum allowed responses to be shown.
const string DLG_CURRENT_MAX_RESPONSES = "zzdlgMaxResponses";

// Local Int    - Speaker - Flag for if the "Reset" response should be shown.
const string DLG_HAS_RESET = "zzdlgHasReset";

// Local Int    - Speaker - Flag for if the "End" response should be shown.
const string DLG_HAS_END = "zzdlgHasEnd";

// Local String - Speaker - Name given to the "Next Page" response.
const string DLG_LABEL_NEXT = "zzdlgLabelNext";

// Local String - Speaker - Name given to the "Previous Page" response.
const string DLG_LABEL_PREVIOUS = "zzdlgLabelPrevious";

// Local String - Speaker - Name given to the "Reset" response.
const string DLG_LABEL_RESET = "zzdlgLabelReset";

// Local String - Speaker - Name given to the "End" response.
const string DLG_LABEL_END = "zzdlgLabelEnd";

// Local String - Speaker - Name given to the "Continue" response.
const string DLG_LABEL_CONTINUE = "zzdlgLabelContinue";

// Local Int    - Speakee - A flag if the speakee is actually a ghost for 2-way conversations.
const string DLG_GHOST = "zzdlgGhost";

// Local Object - Speakee - The PC that the ghost is talking to.
const string DLG_GHOSTTALKER = "zzdlgGhostTalker";

// Local Object - Speakee - The NPC that the ghost is possessing.
const string DLG_GHOSTPOSSESSOR = "zzdlgGhostPossessor";

// TOKEN RESERVATIONS
const int DLG_BASE_TOKEN     = 5200; // Prompt
const int DLG_FIRST_TOKEN    = 5201; // Responses are +0 to +14
const int DLG_INCREMENT_SET  = 20;   // Each set has a gap of twenty between them
const int DLG_NUM_TOKEN_SETS = 20;   // Number of sets of tokens

int _dlgGetToken(object oSpeaker, int nBase)
{
    return nBase + ((GetLocalInt(oSpeaker, DLG_CURRENT_SET) - 1) * DLG_INCREMENT_SET);
}

void _dlgFindTokenSet(object oSpeaker)
{
    object oModule = GetModule();
    int nI = 1;
    for (; nI <= DLG_NUM_TOKEN_SETS; nI++)
    {
        if (!GetLocalInt(oModule, "FB_DLG_USING"+IntToString(nI)))
        {
            SetLocalInt(oSpeaker, DLG_CURRENT_SET, nI);
            SetLocalInt(oModule, "FB_DLG_USING"+IntToString(nI), TRUE);
            return;
        }
    }
    // By default there's nothing to do but log the fact that we've gone over
    // and just pick one at random in the hopes that it's not too active.
    Warning(ZDIALOG, "ZZ-Dialog token sets are all full!");
    SetLocalInt(oSpeaker, DLG_CURRENT_SET, Random(DLG_NUM_TOKEN_SETS) + 1);
}

void _dlgFreeTokenSet(object oSpeaker)
{
    int nSet = GetLocalInt(oSpeaker, DLG_CURRENT_SET);
    SetLocalInt(GetModule(), "FB_DLG_USING"+IntToString(nSet), FALSE);
    SetLocalInt(oSpeaker, DLG_CURRENT_SET, 0);
}

// Called to initiate a conversation programmatically between the dialog source
//      and the object to converse with.
//
// oSpeaker - This is the player's character that is starting a conversation.
//      This is important because we want the ability for many players to talk
//      to the same object.
// oThis - This is the object (NPC, item or placeable) that the player's
//      character is attempting to speak to.
// sDlgScript - This is the script file to use for the conversation. If left as
//      "" (the default), it will read the object's "dialog" parameter to
//      determine which script file to use.
// iMakePrivate - TRUE == don't let others hear the conversation.
//                FALSE == let other hear the conversation. (Default)
// iNoHello - TRUE == don't play the hello.
//            FALSE == play the hello. (Default)
// iNoZoom - TRUE == don't zoom in.
//         FALSE == zoom in towards the character during conversation. (Default)
void _dlgStart( object oSpeaker, object oThis = OBJECT_SELF, string sDlgScript = "", int iMakePrivate = 0, int iNoHello = 0, int iNoZoom = 0 )
{
    // Setup the conversation
    if( sDlgScript != "" )
    {
        SetLocalString( oSpeaker, DLG_CURRENT_SCRIPT, sDlgScript );
    }

    // Special case: If the PC is talking to themselves, have them talk to the
    // first item in their inventory instead, due to a bug in the system.
    if (oSpeaker == oThis)
    {
        oThis = GetFirstItemInInventory(oSpeaker);
        // No item? It can't use a token set which doesn't exist, so just cop out.
        if (!GetIsObjectValid(oThis))
        {
            SendMessageToPC(oSpeaker, "Conversation note: You must have at least one item in your inventory to talk with yourself.");
            return;
        }
    }

    iMakePrivate = (iMakePrivate==1)?TRUE: FALSE;
    iNoHello = (iNoHello==1)?FALSE: TRUE;

    string sDialogResRef = "zzdlg_conv";
    if( iNoZoom == 1 ) sDialogResRef = "zzdlg_conv_nz";

    // Objects that can't talk to the player, need the player to talk to him/herself.
    int bTalkable = FALSE;
    int iType = GetObjectType( oThis );

    if (iType == OBJECT_TYPE_CREATURE || iType == OBJECT_TYPE_PLACEABLE)  bTalkable = TRUE;
    if (GetLocalInt(OBJECT_SELF, DLG_GHOST)==TRUE) bTalkable = TRUE ;

    if( !bTalkable )
    {
        // We presume that only one player can talk to an item at
        // a time... we could check, but we don't.
        SetLocalObject( oThis, DLG_OBJECT_CONVERSER, oSpeaker );

        // We can't actually talk to items so we fudge it.
        SetLocalObject( oSpeaker, DLG_ITEM, oThis );
        oThis = oSpeaker;

        // Must tell the PC to talk to him/herself.
        AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, sDialogResRef,iMakePrivate,iNoHello));
        return;
    }

    if(iType == OBJECT_TYPE_DOOR) //just in case a door makes it this far
        AssignCommand(oThis, ActionStartConversation(oSpeaker, sDialogResRef, iMakePrivate, iNoHello));
    else
        AssignCommand(oSpeaker, ActionStartConversation(oThis, sDialogResRef, iMakePrivate, iNoHello));
}

// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware
// limitations with item dialogs.
object _dlgGetPcSpeaker()
{
    object oPC = GetPCSpeaker();
    if( oPC == OBJECT_INVALID )
    {
        // See if we're an item and if we're connected to a PC already.
        // Note: GetItemActivator won't work in multiplayer because other
        //       players will be trouncing on its state.
        oPC = GetLocalObject( OBJECT_SELF, DLG_OBJECT_CONVERSER );
    }
    if( oPC == OBJECT_INVALID )
    {
        PrintString( "WARNING: Unable to retrieve a PC speaker." );
    }
    return ( oPC );
}

// Returns the current PC speakee for this dialog.
object _dlgGetObjSpeakee(object oSpeaker)
{
    object oTemp = GetLocalObject( oSpeaker, DLG_ITEM );
    if (GetIsObjectValid(oTemp) == FALSE)
    {
        oTemp = OBJECT_SELF;
    }
    return (oTemp);
}

// Returns the response string for the specified entry.
string _dlgGetResponse( object oSpeaker, int iIndex )
{
    string sList = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return ( GetStringElement( iIndex, sList, oSpeaker ) );
}

// Returns the number of responses that will be displayed
// in the dialog when talking to the specified speaker.
int _dlgGetDlgResponseCount( object oSpeaker )
{
    string sList = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return ( GetElementCount( sList, oSpeaker ) );
}

// "_dlgGetType()" possible return values
const int DLG_TYPE_NONE = 0;
const int DLG_TYPE_NEXT = 1;
const int DLG_TYPE_PREVIOUS = 2;
const int DLG_TYPE_RESET = 3;
const int DLG_TYPE_END = 4;

// Gets the type, "Next", "Previous", "Reset", or "End".
int _dlgGetType(object oSpeaker, int responseindex, int iMaxResponses, int iFirstResponseIndex, int iResponseCount)
{
    int iRemainingResponses = iResponseCount - iFirstResponseIndex;

    int iMaxResponsesMinusOne = iMaxResponses-1;

    int hasNext = 0;
    int hasPrev = 0;
    int hasReset = GetLocalInt( oSpeaker, DLG_HAS_RESET )?1:0;
    int hasEnd = GetLocalInt( oSpeaker, DLG_HAS_END )?1:0;;

    // Prev?
    if ( iFirstResponseIndex!=0 ) hasPrev = 1;

    int iHeaderSize = hasReset + hasPrev + hasEnd;

    // Next?
    if ( ( iRemainingResponses + iHeaderSize ) > iMaxResponses )
    {
        hasNext=1;
        ++iHeaderSize;
    }

    // Now we know the header's size, see if we need to use this index for
    //  our automated purpose.
    if( responseindex >= ( iMaxResponses - iHeaderSize ) )
    {
        int i;
        // Populate responses temporarily to find out who should be where.
        for ( i = iMaxResponsesMinusOne; i > ( iMaxResponsesMinusOne - iHeaderSize ); i-- )
        {
            if      ( hasEnd == 1 ) hasEnd = i;
            else if ( hasReset == 1 ) hasReset = i;
            else if ( hasNext == 1 ) hasNext = i;
            else if ( hasPrev == 1 ) hasPrev = i;
            if ( responseindex == i ) break;
        }
        // Find out who we are and return the type.
        if      ( hasEnd == responseindex ) return ( DLG_TYPE_END );
        else if ( hasReset == responseindex ) return ( DLG_TYPE_RESET );
        else if ( hasPrev == responseindex ) return ( DLG_TYPE_PREVIOUS );
        else if ( hasNext == responseindex ) return ( DLG_TYPE_NEXT );
    }

    return ( DLG_TYPE_NONE );
}

// Sends the specified dialog event to the specified NPC
// using the current script handler.  The selection parameter
// is used for select events.  The speaker is provided for
// event specific paramaters to be stored onto.
void _dlgSendEvent( object oSpeaker,
                    int iEventType,
                    int iSelection = -1,
                    object oThis = OBJECT_SELF )
{
    // Get the dlg file's name.
    string sScriptName = GetLocalString( oSpeaker, DLG_CURRENT_SCRIPT );

    // This is to resolve the hack to allow talking to items in inventory.
    if( oThis == oSpeaker )
    {
        oThis = GetLocalObject( oSpeaker, DLG_ITEM );
    }

    // This sets the values that are to be passed into the dlg file's main().
    SetLocalInt( oSpeaker, DLG_EVENT_TYPE, iEventType );
    if (iSelection >= 0) SetLocalInt( oSpeaker, DLG_SELECTION, iSelection );

    // Call dlg file's main.
    ExecuteScript( sScriptName, oThis );
}

//  Gets the next prompt in the continue chain setup.
void _SetupContinueChainedPrompt( object oSpeaker )
{
    if ( GetLocalInt( oSpeaker, DLG_CONTINUE_MODE ) == TRUE )
    {
        // Put text on prompt.
        string sList = GetLocalString( oSpeaker, DLG_CONTINUE_LIST );
        int iPage = GetLocalInt( oSpeaker, DLG_CONTINUE_PAGE );

        string text = GetStringElement( iPage, sList, oSpeaker );

        SetLocalString( oSpeaker, DLG_PROMPT, text );

        // Increment page counter.
        int listsize = GetElementCount( sList, oSpeaker );
        if ( ( iPage + 1 ) < listsize ) iPage += 1;
        else iPage = -1;

        SetLocalInt( oSpeaker, DLG_CONTINUE_PAGE, iPage );
    }
}

// Sets the token for the response string and returns true
// if there is a valid response entry for the specified num.
//  (ie. populates responses once piece at a time)
int _SetupDlgResponse( int responseIndex, object oSpeaker )
{
    Trace(ZDIALOG, " Setting up response for " + GetName(oSpeaker) +
      " with index " + IntToString(responseIndex));
    int iFirstResponseIndex = GetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX );
    int iResponseCount = _dlgGetDlgResponseCount( oSpeaker );

    int iMaxResponses = GetLocalInt( oSpeaker, DLG_CURRENT_MAX_RESPONSES );
    int iMaxResponsesMinusOne = iMaxResponses-1;
    int iMaxResponsesMinusFour = iMaxResponses-4;

    int iHasReset = GetLocalInt( oSpeaker, DLG_HAS_RESET );
    int iHasEnd = GetLocalInt( oSpeaker, DLG_HAS_END );

    // START CONTINUE MODE INTERCEPTION
    if ( GetLocalInt( oSpeaker, DLG_CONTINUE_MODE ) == TRUE )
    {
        if ( responseIndex == 0 )
        {
            // Send the event with the incremented page number.
            _dlgSendEvent( oSpeaker, DLG_EVENT_CONTINUE );
        }

        // Check if we still need to show "Continue".
        if ( GetLocalInt( oSpeaker, DLG_CONTINUE_PAGE ) != -1 )
        {
            // See if we make it blank or "continue".
            if ( responseIndex == 0 )
            {
                SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN), GetLocalString( oSpeaker, DLG_LABEL_CONTINUE ) );

                return ( TRUE );
            }
            else
            {
                // Only return false if there are no auto adds.
                int autocount = (iHasEnd==TRUE)?iMaxResponsesMinusOne:iMaxResponses;
                if ( iHasReset == TRUE) --autocount;
                if ( responseIndex < autocount ) return ( FALSE );
            }
        }

        // No more continue then.
        else
        {
            SetLocalString( oSpeaker, DLG_CONTINUE_LIST, "" );
            SetLocalInt( oSpeaker, DLG_CONTINUE_MODE, FALSE );
        }
    }
    // END CONTINUE MODE INTERCEPTION

    // iMaxResponses-4 is the lowest possible auto-generated selection.
    if ( responseIndex >= iMaxResponsesMinusFour )
    {
        int type = _dlgGetType( oSpeaker, responseIndex, iMaxResponses, iFirstResponseIndex, iResponseCount );

        switch ( type )
        {

        // We don't handle it!
        case DLG_TYPE_NONE:
            break;

        // Sets the response to the setting on "next's" label.
        case DLG_TYPE_NEXT:
            SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN + responseIndex), GetLocalString( oSpeaker, DLG_LABEL_NEXT ) );
            return ( TRUE );

        // Sets the response to the setting on "prev's" label.
        case DLG_TYPE_PREVIOUS:
            SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN + responseIndex), GetLocalString( oSpeaker, DLG_LABEL_PREVIOUS ) );
            return ( TRUE );

        // Sets the response to the setting on "reset's" label.
        case DLG_TYPE_RESET:
            SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN + responseIndex), GetLocalString( oSpeaker, DLG_LABEL_RESET ) );
            return ( TRUE );

        // Sets the response to the setting on "end's" label.
        case DLG_TYPE_END:
            SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN + responseIndex), GetLocalString( oSpeaker, DLG_LABEL_END ) );
            return ( TRUE );
        }
    }

    // Check if this response should actually exist.
    if( iFirstResponseIndex + responseIndex < iResponseCount )
    {
        // Grab the response from the user's list.
        string response = _dlgGetResponse( oSpeaker,
                                          iFirstResponseIndex + responseIndex );
        Trace(ZDIALOG, " Got configured response: " + response);
        // And set the response.
        SetCustomToken( _dlgGetToken(oSpeaker, DLG_FIRST_TOKEN + responseIndex), response );
        return ( TRUE );
    }
    else
      Trace(ZDIALOG, " No response configured (and not autogenerated).");
    return ( FALSE );
}

// Called to clean-up the current conversation related resources.
void _CleanupDlg( object oSpeaker )
{
    DeleteLocalString( oSpeaker, DLG_CURRENT_SCRIPT );
    DeleteLocalString( oSpeaker, DLG_PROMPT );
    DeleteLocalString( oSpeaker, DLG_RESPONSE_LIST );
    DeleteLocalInt( oSpeaker, DLG_EVENT_TYPE );
    DeleteLocalInt( oSpeaker, DLG_SELECTION );
    DeleteLocalString( oSpeaker, DLG_PAGE_NAME );

    // See if the PC was associated with an item
    object oItem = GetLocalObject( oSpeaker, DLG_ITEM );
    DeleteLocalObject( oSpeaker, DLG_ITEM );
    if( oItem != OBJECT_INVALID )
    {
        DeleteLocalObject( oItem, DLG_OBJECT_CONVERSER );
    }

    DeleteLocalInt( oSpeaker, DLG_STATE );
    DeleteLocalInt( oSpeaker, DLG_LAST_PREVORNEXT );
    DeleteLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX );
    DeleteLocalInt( oSpeaker, DLG_NORESETPAGEONSELECTION );
    DeleteLocalInt( oSpeaker,  DLG_CONTINUE_PAGE );
    DeleteLocalInt( oSpeaker,  DLG_CONTINUE_MODE );
    DeleteLocalString( oSpeaker, DLG_CONTINUE_LIST );
    DeleteLocalString( oSpeaker, DLG_FAREWELL );
    DeleteLocalInt( oSpeaker,  DLG_CURRENT_MAX_RESPONSES );
    DeleteLocalInt( oSpeaker, DLG_HAS_RESET );
    DeleteLocalInt( oSpeaker, DLG_HAS_END );

    DeleteLocalString( oSpeaker, DLG_LABEL_NEXT );
    DeleteLocalString( oSpeaker, DLG_LABEL_PREVIOUS );
    DeleteLocalString( oSpeaker, DLG_LABEL_RESET );
    DeleteLocalString( oSpeaker, DLG_LABEL_END );
    DeleteLocalString( oSpeaker, DLG_LABEL_CONTINUE );

    DeleteLocalObject( OBJECT_SELF, DLG_GHOSTPOSSESSOR );

    if (GetLocalInt( OBJECT_SELF, DLG_GHOST)==TRUE)
    {
        DeleteLocalInt( OBJECT_SELF, DLG_GHOST);
        DestroyObject(OBJECT_SELF);
    }

    // Free the token set
    _dlgFreeTokenSet(oSpeaker);
}

// On Selection event. Check if we need to handle an automated response first,
//      but if not then pass it to the dialog script.
void _dlgDoSelection( object oSpeaker,
                      int iSelection,
                      object oThis = OBJECT_SELF )
{
    int iHeaderSize;

    int iMaxResponses = GetLocalInt( oSpeaker, DLG_CURRENT_MAX_RESPONSES );
    int iMaxResponsesMinusOne = iMaxResponses-1;
    int iMaxResponsesMinusFour = iMaxResponses-4;
    int iHasReset = GetLocalInt( oSpeaker, DLG_HAS_RESET )?1:0;
    int iHasEnd = GetLocalInt( oSpeaker, DLG_HAS_END )?1:0;

    // START CONTINUE MODE INTERCEPTION
    if ( GetLocalInt( oSpeaker, DLG_CONTINUE_MODE ) == TRUE )
    {
        int iCount = (iHasEnd==TRUE)?iMaxResponsesMinusOne:iMaxResponses;
        if ( iHasReset == TRUE) --iCount;

        if ( iSelection < iCount )
            return; // We know what had to be selected.
    }
    // END CONTINUE MODE INTERCEPTION

    // Grab first response on current page.
    int iStartIndex = GetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX );

    // Clear flag so that non-next/previous selections call page_init.
    SetLocalInt( oSpeaker, DLG_LAST_PREVORNEXT, FALSE );

    // iMaxResponses-4 is the lowest possible auto-generated selection.
    if ( iSelection >= iMaxResponsesMinusFour )
    {
        int iFirstResponseIndex = GetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX );
        int iResponseCount = _dlgGetDlgResponseCount( oSpeaker );

        // See if this type is from an auto-generated selection, and what it is.
        int iType = _dlgGetType(oSpeaker, iSelection, iMaxResponses, iFirstResponseIndex, iResponseCount);

        // This will make sure that the page_init event is not executed on a
        //  previous or next selection.
        if ( iType == DLG_TYPE_NEXT || iType == DLG_TYPE_PREVIOUS )
        {
            SetLocalInt( oSpeaker, DLG_LAST_PREVORNEXT, TRUE );
        }

        // Find out which selection is called, if any.
        switch (iType)
        {

        // Not auto-generated.
        case DLG_TYPE_NONE:

            break;

        // End the dialog (Autogenerated).
        case DLG_TYPE_END:

            SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_ENDED );
            return;

        // Go to next page of selections (Autogenerated).
        case DLG_TYPE_NEXT:

            // Add reset and end (where applicable) and "next".
            iHeaderSize = iHasReset + iHasEnd + 1; // Reset+End+Next

            // Add a previous selection if it exists.
            if ( iStartIndex > 0 ) ++iHeaderSize;

            // Get the first response index for the next page and assign it.
            SetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX, iStartIndex + ( iMaxResponses - iHeaderSize ) );

            return;

        // Go to previous page of selections (Autogenerated).
        case DLG_TYPE_PREVIOUS:

            // Add reset and end (where applicable) and "next".
            iHeaderSize = iHasReset + iHasEnd + 1; // Reset+End+Next

            // If we are on 3-n page, we know there is a "previous".
            if ( iStartIndex != ( iMaxResponses - iHeaderSize ) )
            {
                // Add "previous".
                ++iHeaderSize;
            }

            SetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX, iStartIndex - ( iMaxResponses - iHeaderSize) );

            return;

        // User-defined event, usually to reset or backup the conversation
        //  (Autogenerated).
        case DLG_TYPE_RESET:
            _dlgSendEvent( oSpeaker, DLG_EVENT_RESET );
            return;
        }
    }

    // Bring the selection value to page context.
    iSelection += iStartIndex;

    // Shoot off the event.
    _dlgSendEvent( oSpeaker, DLG_EVENT_SELECTION, iSelection, oThis );
}

// Called by the dialog internals to initialize the page and possibly the
//      conversation.
void _dlgInitializePage( object oSpeaker, object oThis = OBJECT_SELF )
{
    int iCurrentState = GetLocalInt( oSpeaker, DLG_STATE );
    Trace(ZDIALOG, " Initializing page.  Current state: " + IntToString(iCurrentState));
    string sScriptName = GetLocalString( oSpeaker, DLG_CURRENT_SCRIPT );

    // This is needed for item conversations.
    if( oThis == oSpeaker )
    {
        oThis = GetLocalObject( oSpeaker, DLG_ITEM );
    }

    Trace(ZDIALOG, " Script: " + sScriptName + ", speaking with " + GetName(oThis));
    //  Retrieve the script file if it hasn't already been retrieved
    // (NPCs don't use "_dlgStart()")
    if( sScriptName == "" )
    {
        // Grab and assign it. We can change the script in the later.
        sScriptName = GetLocalString( oThis, DLG_VARIABLE_SCRIPTNAME );
        SetLocalString( oSpeaker, DLG_CURRENT_SCRIPT, sScriptName );

        // We need to set this since "_dlgStart()" didn't fire.
        iCurrentState = DLG_STATE_INIT;
    }

    // If we aren't initialized...
    if( iCurrentState == DLG_STATE_INIT )
    {
        // We need a maximum just in case.
        SetLocalInt( oSpeaker, DLG_CURRENT_MAX_RESPONSES, 15 );

        // Send the init event.
        _dlgSendEvent( oSpeaker, DLG_EVENT_INIT, -1, oThis );

        // and we're off!
        SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_RUNNING );
    }

    // Send the page initialization event, if:
    // - We aren't using Next or Previous.
    // - We aren't using Continue. (OnContinue is instead)
    if ( ( GetLocalInt( oSpeaker, DLG_LAST_PREVORNEXT ) == FALSE ) &&
         ( GetLocalInt( oSpeaker, DLG_CONTINUE_MODE ) == FALSE ) )
    {
        Trace(ZDIALOG, " Sending init page event");
        // Reset the page count IF the flag to preserve it is set.
        if ( GetLocalInt( oSpeaker, DLG_NORESETPAGEONSELECTION ) == FALSE )
        {
            SetLocalInt( oSpeaker, DLG_CURRENTPAGE_STARTINDEX, 0 );
        }

        // Send the page_init event.
        _dlgSendEvent( oSpeaker, DLG_EVENT_PAGE_INIT, -1, oThis );
    }
    else
      Trace(ZDIALOG, " No need to init page, next/previous/continue mode");
}

/*
//I keep this here to uncomment when compiling to test for
//errors that can't be found otherwise.  Just ignore it.
void main()
{

}
*/

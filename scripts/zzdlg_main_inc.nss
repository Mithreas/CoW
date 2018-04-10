// zzdlg_main_inc
//
// Copyright 2005-2006 by Greyhawk0
//
// Special thanks to Z-Dialog creator Paul Speed.
//
//  This is the standard interface for dealing with ZZ-Dialog. Originally a
// wrapper for Z-Dialog, it has grown and became fully autonomous (as far as
// the end-user is concerned).
//

#include "zzdlg_tools_inc"
#include "zzdlg_config_inc"

//  These are functions that should be implemented in a dialog script file. This
// is my form of a callback and makes it simplier to process events.
void OnInit( );                       // Called at initialization
void OnPageInit( string sPage );      // Called at page initialization
void OnSelection( string sPage );     // Called a user-defined selection
void OnReset( string sPage );         // Called at reset selection
void OnAbort( string sPage );         // Called at 'ESC'
void OnEnd( string sPage );           // Called at proper exit
void OnContinue( string sPage, int iContinuePage ); // Called each continue page

// Global helpers. Only valid during an event (not a problem really).
//object oCurrentSpeaker;
//object oCurrentSpeakee;
//string sCurrentSelection;
//int iCurrentSelection;
//

// Gets the talking player.
object dlgGetSpeakingPC( );
object dlgGetSpeakingPC( )
{
    return _dlgGetPcSpeaker();
}

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void dlgChangeDlgScript( object oSpeaker, string sNewScriptName );
void dlgChangeDlgScript( object oSpeaker, string sNewScriptName )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_CURRENT_SCRIPT, sNewScriptName );
}

// Ends the dialog, but only within an event, like onSelection or onReset.
void dlgEndDialog();
void dlgEndDialog()
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_STATE, DLG_STATE_ENDED );
}

//  Adds an page of dialog to the continue chain's queued dialog list! Returns
// it's index number.
int dlgAddContinueChainMsg( string sContinueList, string sContinueMsg );
int dlgAddContinueChainMsg( string sContinueList, string sContinueMsg )
{
    int iIndex = GetElementCount( sContinueList, _dlgGetPcSpeaker() );
    return ( AddStringElement( sContinueMsg ,
                               sContinueList,
                               _dlgGetPcSpeaker() ) );
}

//  Gets the current continue page. Only valid during a continue chain.
// (-1 is last page or no continue page)
int dlgGetCurrentContinuePage( )
{
    return ( GetLocalInt( _dlgGetPcSpeaker(), DLG_CONTINUE_PAGE ) );
}

// Sets up the continue chain, and passes in the queued dialog's list name.
void dlgSetupContinueChain( string sContinueList );
void dlgSetupContinueChain( string sContinueList )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_CONTINUE_LIST, sContinueList );
    SetLocalInt( _dlgGetPcSpeaker(), DLG_CONTINUE_PAGE, 0 );
    SetLocalInt( _dlgGetPcSpeaker(), DLG_CONTINUE_MODE, TRUE );
}

// Clears a continue chain's queued dialog's list.
void dlgClearContinueList( string sContinueList );
void dlgClearContinueList( string sContinueList )
{
    DeleteList( sContinueList, _dlgGetPcSpeaker() );
}

// Sets the player's local integer to an integer.
void dlgSetPlayerDataInt( string sName, int iValue );
void dlgSetPlayerDataInt( string sName, int iValue )
{
    SetLocalInt( _dlgGetPcSpeaker(), sName, iValue );
}

// Gets the player's local integer.
int dlgGetPlayerDataInt( string sName );
int dlgGetPlayerDataInt( string sName )
{
    return ( GetLocalInt( _dlgGetPcSpeaker(), sName ) );
}

// Delete's the player's local integer.
void dlgClearPlayerDataInt( string sName );
void dlgClearPlayerDataInt( string sName )
{
    DeleteLocalInt( _dlgGetPcSpeaker(), sName );
}

// Sets the player's local integer to a string.
void dlgSetPlayerDataString( string sName, string sValue );
void dlgSetPlayerDataString( string sName, string sValue )
{
    SetLocalString( _dlgGetPcSpeaker(), sName, sValue );
}

// Gets the player's local string.
string dlgGetPlayerDataString( string sName );
string dlgGetPlayerDataString( string sName )
{
    return ( GetLocalString( _dlgGetPcSpeaker(), sName ) );
}

// Delete's the player's local string.
void dlgClearPlayerDataString( string sName );
void dlgClearPlayerDataString( string sName )
{
    DeleteLocalString( _dlgGetPcSpeaker(), sName );
}

// Sets the player's local integer to a float.
void dlgSetPlayerDataFloat( string sName, float fValue );
void dlgSetPlayerDataFloat( string sName, float fValue )
{
    SetLocalFloat( _dlgGetPcSpeaker(), sName, fValue );
}

// Gets the player's local float.
float dlgGetPlayerDataFloat( string sName );
float dlgGetPlayerDataFloat( string sName )
{
    return ( GetLocalFloat( _dlgGetPcSpeaker(), sName ) );
}

// Delete's the player's local float.
void dlgClearPlayerDataFloat( string sName );
void dlgClearPlayerDataFloat( string sName )
{
    DeleteLocalFloat( _dlgGetPcSpeaker(), sName );
}

// Sets the player's local integer to a location.
void dlgSetPlayerDataLocation( string sName, location lValue );
void dlgSetPlayerDataLocation( string sName, location lValue )
{
    SetLocalLocation( _dlgGetPcSpeaker(), sName, lValue );
}

// Gets the player's local location.
location dlgGetPlayerDataLocation( string sName );
location dlgGetPlayerDataLocation( string sName )
{
    return ( GetLocalLocation( _dlgGetPcSpeaker(), sName ) );
}

// Delete's the player's local location.
void dlgClearPlayerDataLocation( string sName );
void dlgClearPlayerDataLocation( string sName )
{
    DeleteLocalLocation( _dlgGetPcSpeaker(), sName );
}

// Sets the player's local integer to an object.
void dlgSetPlayerDataObject( string sName, object oValue );
void dlgSetPlayerDataObject( string sName, object oValue )
{
    SetLocalObject( _dlgGetPcSpeaker(), sName, oValue );
}

// Gets the player's local object.
object dlgGetPlayerDataObject( string sName );
object dlgGetPlayerDataObject( string sName )
{
    return ( GetLocalObject( _dlgGetPcSpeaker(), sName ) );
}

// Delete's the player's local object.
void dlgClearPlayerDataObject( string sName );
void dlgClearPlayerDataObject( string sName )
{
    DeleteLocalObject( _dlgGetPcSpeaker(), sName );
}

//  Makes it so that on large response lists, the page number won't reset
// automatically. onPageInit only!
void dlgActivatePreservePageNumberOnSelection( );
void dlgActivatePreservePageNumberOnSelection( )
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_NORESETPAGEONSELECTION, TRUE );
}

//  Makes it so that on large response lists, the page number will reset
// automatically. onPageInit only!
void dlgDeactivatePreservePageNumberOnSelection( );
void dlgDeactivatePreservePageNumberOnSelection( )
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_NORESETPAGEONSELECTION, FALSE );
}

// This will reset the page #. This is required to have it reset if
//      dlgActivatePreservePageNumberOnSelection is in effect.
void dlgResetPageNumber( );
void dlgResetPageNumber( )
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_CURRENTPAGE_STARTINDEX, 0 );
}

// Sets the list that has all the responses. onPageInit only!
void dlgSetActiveResponseList( string sResponseList );
void dlgSetActiveResponseList( string sResponseList )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_RESPONSE_LIST, sResponseList );
}

//  Clears the named list's contents. NOTE: This will not dereference the named
// list for responses! You must either change the list referenced with
// dlgSetActiveResponseList() or repopulate the list with dlgAddResponse*().
//
void dlgClearResponseList( string sResponseList );
void dlgClearResponseList( string sResponseList )
{
    DeleteList( sResponseList, _dlgGetPcSpeaker() );
}

// Adds a response, in the form of talking, to the response list.
//      Returns index to action. onInit or onPageInit only!
int dlgAddResponseTalk( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_TALK_COLOR );
int dlgAddResponseTalk( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_TALK_COLOR )
{
    int iIndex = GetElementCount( sResponseList, _dlgGetPcSpeaker() );
    AddStringElement( MakeTextColor( sResponse, sTxtColor ),
                      sResponseList,
                      _dlgGetPcSpeaker() );
    return ( iIndex );
}

// Adds a response, in the form of an action, to the response list.
//      Returns index to action. onInit or onPageInit only!
int dlgAddResponseAction( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_ACTION_COLOR );
int dlgAddResponseAction( string sResponseList, string sResponse, string sTxtColor = DLG_DEFAULT_TXT_ACTION_COLOR )
{
    int iIndex = GetElementCount( sResponseList, _dlgGetPcSpeaker() );
    AddStringElement( MakeTextColor( sResponse, sTxtColor ),
                      sResponseList,
                      _dlgGetPcSpeaker() );
    return ( iIndex );
}

// Adds a response with no coloring or nothing.
//      Returns index to action. onInit or onPageInit only!
int dlgAddResponse( string sResponseList, string sResponse );
int dlgAddResponse( string sResponseList, string sResponse )
{
    int iIndex = GetElementCount( sResponseList, _dlgGetPcSpeaker() );
    AddStringElement( sResponse,
                      sResponseList,
                      _dlgGetPcSpeaker() );
    return ( iIndex );
}

// Gets the index of the selected response.
//      onSelection event only!
int dlgGetSelectionIndex( );
int dlgGetSelectionIndex( )
{
    return ( GetLocalInt( _dlgGetPcSpeaker(), DLG_SELECTION ) );
}

// Gets the name of the selected response.
//      onSelection event only!
string dlgGetSelectionName( );
string dlgGetSelectionName( )
{
    int iCurrentSelection = GetLocalInt( _dlgGetPcSpeaker(), DLG_SELECTION );

    string s = _dlgGetResponse( _dlgGetPcSpeaker(), iCurrentSelection );
    if (GetStringLeft(s, 2) == "<c")
        return GetSubString( s, 6, GetStringLength( s ) - 10 );
    else
        return s;
}

// Checks if the index of the selected response matches the parameter.
//      onSelection event only!
int dlgIsSelectionEqualToIndex( int iIndex );
int dlgIsSelectionEqualToIndex( int iIndex )
{
    return ( GetLocalInt( _dlgGetPcSpeaker(), DLG_SELECTION ) == iIndex );
}

// Checks if the name of the selected response matches the parameter.
//      onSelection event only!
int dlgIsSelectionEqualToName( string sTest );
int dlgIsSelectionEqualToName( string sTest )
{
    string sCurrentSelection = dlgGetSelectionName();
    if ( GetStringLength( sCurrentSelection ) == GetStringLength( sTest ) )
    {
        if ( FindSubString ( sCurrentSelection, sTest ) == 0 ) return ( TRUE );
    }
    return ( FALSE );
}

// Sets what this object is currently saying. onInit and onPageInit only!
void dlgSetPrompt( string sPrompt );
void dlgSetPrompt( string sPrompt )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_PROMPT, sPrompt );
}

// Changes the page. Will trigger "OnPageInit" later. Use during OnSelection,
// OnInit or OnReset only!!!
void dlgChangePage( string sNewPage );
void dlgChangePage( string sNewPage )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_PAGE_NAME, sNewPage );
}

// Changes the automated "Next" response's label. onInit or onPageInit only!
void dlgChangeLabelNext( string sNewLabel = DLG_DEFAULTLABEL_NEXT, string sTxtColor = DLG_DEFAULT_TXT_NEXT_COLOR );
void dlgChangeLabelNext( string sNewLabel = DLG_DEFAULTLABEL_NEXT, string sTxtColor = DLG_DEFAULT_TXT_NEXT_COLOR )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_LABEL_NEXT, MakeTextColor( sNewLabel, sTxtColor ) );
}

//  Changes the automated "Previous Page" response's label. onInit or onPageInit
// only!
void dlgChangeLabelPrevious( string sNewLabel = DLG_DEFAULTLABEL_PREV, string sTxtColor = DLG_DEFAULT_TXT_PREVIOUS_COLOR );
void dlgChangeLabelPrevious( string sNewLabel = DLG_DEFAULTLABEL_PREV, string sTxtColor = DLG_DEFAULT_TXT_PREVIOUS_COLOR )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_LABEL_PREVIOUS, MakeTextColor( sNewLabel, sTxtColor ) );
}

//  Changes the automated "Continue" response's label. onInit, onPageInit, or
// onContinue only!
void dlgChangeLabelContinue( string sNewLabel = DLG_DEFAULTLABEL_CONTINUE, string sTxtColor = DLG_DEFAULT_TXT_CONTINUE_COLOR );
void dlgChangeLabelContinue( string sNewLabel = DLG_DEFAULTLABEL_CONTINUE, string sTxtColor = DLG_DEFAULT_TXT_CONTINUE_COLOR )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_LABEL_CONTINUE, MakeTextColor( sNewLabel, sTxtColor ) );
}

// Activates the automated "Reset" response. onInit, onContinue, or onPageInit
//      only!
void dlgActivateResetResponse( string sNewLabel = DLG_DEFAULTLABEL_RESET, string sTxtColor = DLG_DEFAULT_TXT_RESET_COLOR );
void dlgActivateResetResponse( string sNewLabel = DLG_DEFAULTLABEL_RESET, string sTxtColor = DLG_DEFAULT_TXT_RESET_COLOR )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_LABEL_RESET, MakeTextColor( sNewLabel, sTxtColor ) );
    SetLocalInt( _dlgGetPcSpeaker(), DLG_HAS_RESET, TRUE );
}

// Deactivates the automated "Reset" response. onInit, onContinue, or onPageInit
//      only!
void dlgDeactivateResetResponse( );
void dlgDeactivateResetResponse( )
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_HAS_RESET, FALSE );
}

// Activates the automated "End" response. onInit, onContinue, or onPageInit
//      only!
void dlgActivateEndResponse( string sNewLabel = DLG_DEFAULTLABEL_END, string sTxtColor = DLG_DEFAULT_TXT_END_COLOR );
void dlgActivateEndResponse( string sNewLabel = DLG_DEFAULTLABEL_END, string sTxtColor = DLG_DEFAULT_TXT_END_COLOR )
{
    SetLocalString( _dlgGetPcSpeaker(), DLG_LABEL_END, MakeTextColor( sNewLabel, sTxtColor ) );
    SetLocalInt( _dlgGetPcSpeaker(), DLG_HAS_END, TRUE );
}

// Deactivates the automated "End" response. onInit, onContinue, or onPageInit
//      only!
void dlgDeactivateEndResponse( );
void dlgDeactivateEndResponse( )
{
    SetLocalInt( _dlgGetPcSpeaker(), DLG_HAS_END, FALSE );
}

//  Sets the maximum number of responses to be displayed. The limit is 5-15.
void dlgSetMaximumResponses(int iMaximumResponses = DLG_DEFAULT_MAX_RESPONSES);
void dlgSetMaximumResponses(int iMaximumResponses = DLG_DEFAULT_MAX_RESPONSES)
{
    if (iMaximumResponses<5) iMaximumResponses=5;
    if (iMaximumResponses>15) iMaximumResponses=15;
    SetLocalInt( _dlgGetPcSpeaker(), DLG_CURRENT_MAX_RESPONSES, iMaximumResponses );
}

//  Sets an farewell message after the conversation is ended in a
// non-interrupted or non-aborted fasion.
void dlgSetFarewell(string sFarewellMessage);
void dlgSetFarewell(string sFarewellMessage)
{
    SetLocalString(_dlgGetPcSpeaker(), DLG_FAREWELL, sFarewellMessage);
}

//  Retrieves the NPC that the ghost is possessing. If call on non-ghost, this
// will return OBJECT_INVALID. Otherwise the NPC will be returned.
object dlgGetGhostPossessor();
object dlgGetGhostPossessor()
{
    return ( GetLocalObject( OBJECT_SELF, DLG_GHOSTPOSSESSOR ) );
}

//  This changes the current speakee. In reality we are only talking to a ghost,
// who is a copy of the original NPC.
// Requires 1.67! The NPC should have the OnConversation script set to
// "zdlg_ghostconver", and the dialog used, "zdlg_converse*" for example, to
// be blank. This requires that you enable the setname and set portrait commands
// which I wasn't privy to.
void dlgChangeSpeakee(object oNewSpeakee);
void dlgChangeSpeakee(object oNewSpeakee)
{
    if (GetLocalInt( OBJECT_SELF, DLG_GHOST ) == TRUE)
    {
        // Find the guy.
        if (GetIsObjectValid(oNewSpeakee)==FALSE) return;

        // Make the ghost look like the tagged object.
        SetName(OBJECT_SELF, GetName(oNewSpeakee) );
        SetPortraitId(OBJECT_SELF, GetPortraitId(oNewSpeakee));

        // Make PC face the new guy and new guy to face PC.
        ActionJumpToLocation(GetLocation(oNewSpeakee));
        AssignCommand( oNewSpeakee, SetFacingPoint(GetPosition(_dlgGetPcSpeaker())));
        AssignCommand( _dlgGetPcSpeaker(), SetFacingPoint(GetPosition(oNewSpeakee)));

        // We have to pause because it takes time to switch name and portrait.
        AssignCommand( _dlgGetPcSpeaker(), ActionPauseConversation());
        AssignCommand( _dlgGetPcSpeaker(), DelayCommand(0.5, ActionResumeConversation()));

        // Update which object is possessed.
        SetLocalObject( OBJECT_SELF, DLG_GHOSTPOSSESSOR, oNewSpeakee );
    }
}

//  This changes the current speakee. In reality we are only talking to a ghost,
// who is a copy of the original NPC. This uses a tag to grab both the name and
// portrait of the object, then is applied to the ghost. THIS IS NOT TESTED!
// Requires 1.67! The NPC should have the OnConversation script set to
// "zdlg_ghostconver", and the dialog used, "zdlg_converse*" for example, to
// be blank. This requires that you enable the setname and set portrait commands
// which I wasn't privy to. NOTE: Make object parameter version.
void dlgChangeSpeakeeByTag(string sTag);
void dlgChangeSpeakeeByTag(string sTag)
{
    dlgChangeSpeakee( GetObjectByTag( sTag ) );
}

// Sets the speakee's local integer to an integer.
void dlgSetSpeakeeDataInt( string sName, int iValue );
void dlgSetSpeakeeDataInt( string sName, int iValue )
{
    SetLocalInt( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName, iValue );
}

// Gets the speakee's local integer.
int dlgGetSpeakeeDataInt( string sName );
int dlgGetSpeakeeDataInt( string sName )
{
    return ( GetLocalInt( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName ) );
}

// Delete's the speakee's local integer.
void dlgClearSpeakeeDataInt( string sName );
void dlgClearSpeakeeDataInt( string sName )
{
    DeleteLocalInt( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName );
}

// Sets the speakee's local integer to a string.
void dlgSetSpeakeeDataString( string sName, string sValue );
void dlgSetSpeakeeDataString( string sName, string sValue )
{
    SetLocalString( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName, sValue );
}

// Gets the speakee's local string.
string dlgGetSpeakeeDataString( string sName );
string dlgGetSpeakeeDataString( string sName )
{
    return ( GetLocalString( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName ) );
}

// Delete's the speakee's local string.
void dlgClearSpeakeeDataString( string sName );
void dlgClearSpeakeeDataString( string sName )
{
    DeleteLocalString( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName );
}

// Sets the speakee's local integer to a float.
void dlgSetSpeakeeDataFloat( string sName, float fValue );
void dlgSetSpeakeeDataFloat( string sName, float fValue )
{
    SetLocalFloat( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName, fValue );
}

// Gets the speakee's local float.
float dlgGetSpeakeeDataFloat( string sName );
float dlgGetSpeakeeDataFloat( string sName )
{
    return ( GetLocalFloat( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName ) );
}

// Delete's the speakee's local float.
void dlgClearSpeakeeDataFloat( string sName );
void dlgClearSpeakeeDataFloat( string sName )
{
    DeleteLocalFloat( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName );
}

// Sets the speakee's local integer to a location.
void dlgSetSpeakeeDataLocation( string sName, location lValue );
void dlgSetSpeakeeDataLocation( string sName, location lValue )
{
    SetLocalLocation( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName, lValue );
}

// Gets the speakee's local location.
location dlgGetSpeakeeDataLocation( string sName );
location dlgGetSpeakeeDataLocation( string sName )
{
    return ( GetLocalLocation( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName ) );
}

// Delete's the speakee's local location.
void dlgClearSpeakeeDataLocation( string sName );
void dlgClearSpeakeeDataLocation( string sName )
{
    DeleteLocalLocation( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName );
}

// Sets the speakee's local integer to an object.
void dlgSetSpeakeeDataObject( string sName, object oValue );
void dlgSetSpeakeeDataObject( string sName, object oValue )
{
    SetLocalObject( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName, oValue );
}

// Gets the speakee's local object.
object dlgGetSpeakeeDataObject( string sName );
object dlgGetSpeakeeDataObject( string sName )
{
    return ( GetLocalObject( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName ) );
}

// Delete's the speakee's local object.
void dlgClearSpeakeeDataObject( string sName );
void dlgClearSpeakeeDataObject( string sName )
{
    DeleteLocalObject( _dlgGetObjSpeakee(_dlgGetPcSpeaker()), sName );
}

//  Processes an event. This should only be called once during the script and
// should really be the only thing in a dialog file's main().
void dlgOnMessage();
void dlgOnMessage()
{
    object oCurrentSpeaker = _dlgGetPcSpeaker();
    object oCurrentSpeakee = _dlgGetObjSpeakee(oCurrentSpeaker);

    int iEvent = GetLocalInt( oCurrentSpeaker, DLG_EVENT_TYPE );

    switch( iEvent )
    {
    case DLG_EVENT_INIT:
        // Setup defaults.
        dlgChangeLabelNext( );
        dlgChangeLabelPrevious( );
        dlgChangeLabelContinue( );
        dlgActivateEndResponse( );
        dlgDeactivatePreservePageNumberOnSelection( );
        dlgSetMaximumResponses( );
        SetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE, -1 );
        // Find a good token set to use
        _dlgFindTokenSet(oCurrentSpeaker);

        OnInit( );

        break;
    case DLG_EVENT_PAGE_INIT:
        OnPageInit( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_SELECTION:
    {
        OnSelection( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );

        break;
    }
    case DLG_EVENT_ABORT:
        OnAbort( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_END:
        OnEnd( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_RESET:
        OnReset( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ) );
        break;
    case DLG_EVENT_CONTINUE:
        OnContinue( GetLocalString( oCurrentSpeaker, DLG_PAGE_NAME ),
                    GetLocalInt( oCurrentSpeaker, DLG_CONTINUE_PAGE ) );
        break;
    }

    //oCurrentSpeaker = OBJECT_INVALID;
    //oCurrentSpeakee = OBJECT_INVALID;
}

// This will recover a page makes a call to:
//      dlgActivatePreservePageNumberOnSelection is in effect.
//Use in onPageInit.
//Page must be saved using dlg.
void md_dlgRecoverPageNumber( );
void md_dlgRecoverPageNumber( )
{
    //dlgActivatePreservePageNumberOnSelection();
    string sPage = GetLocalString(_dlgGetPcSpeaker(), DLG_PAGE_NAME);
    SetLocalInt( _dlgGetPcSpeaker(), DLG_CURRENTPAGE_STARTINDEX, GetLocalInt(_dlgGetPcSpeaker(), "MD_ZZ_SP_"+sPage ));
    //Reset var
    DeleteLocalInt( _dlgGetPcSpeaker(), "MD_ZZ_SP_"+sPage);
}

// This will save a page it makes a call to:
// To be used in onSelection.
// Must use md_dlgRecoverPageNumber to recover page.
void md_dlgSavePageNumber( );
void md_dlgSavePageNumber( )
{
    //dlgDeactivatePreservePageNumberOnSelection();
    string sPage = GetLocalString(_dlgGetPcSpeaker(), DLG_PAGE_NAME);
    SetLocalInt( _dlgGetPcSpeaker(), "MD_ZZ_SP_"+sPage, GetLocalInt( _dlgGetPcSpeaker(), DLG_CURRENTPAGE_STARTINDEX ));
}

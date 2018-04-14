/**
 *  $Id: inc_zdlg.nss,v 1.4 2004/09/20 07:59:12 paul Exp $
 *
 *  Include file for using the Z-Dialog runtime conversation
 *  system.
 *
 *  This system allows a user to define conversation trees at
 *  runtime and handle the selections programmatically.  Really
 *  useful for menu systems without script explosion.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 *
 *  Additions by Mithreas and Fireboar:
 *   Added features:
 * - Ability to add "sticky" dialog options which persist over multiple pages,
 *   optionally at the top and bottom of the list.
 * - Action colourizer.
 * - Generic customizable "Are you sure?" interface.
 * - "Waiting for speech input" interface.
 */
#include "inc_chatutils"
#include "inc_log"
#include "zzdlg_lists_inc"

const string ZDIALOG = "ZDIALOG"; // For tracing

// Constants defined for dialog events
const int DLG_INIT = 0; // new dialog is started
const int DLG_PAGE_INIT = 1; // a new page is started
const int DLG_SELECTION = 2; // item is selected
const int DLG_ABORT = 3; // dialog was aborted
const int DLG_END = 4; // dialog ended normally

const string DLG_CURRENT_HANDLER = "currentDialog";
const string DLG_HANDLER = "dialog";
const string DLG_PROMPT = "zdlgPrompt";
const string DLG_RESPONSE_LIST = "zdlgResponseList";
const string DLG_RESPONSE_LIST_HOLDER = "zdlgResponseHolder";
const string DLG_EVENT_TYPE = "zdlgEventType";
const string DLG_EVENT_SELECTION = "zdlgEventSelection";
const string DLG_PAGE_ID = "zdlgPageId";
const string DLG_ITEM = "zdlgItem";
const string DLG_STATE = "zdlgState";

const string DLG_START_ENTRY = "zdlgStartEntry";
const string DLG_HAS_PREV = "zdlgHasPrevious";
const string DLG_HAS_NEXT = "zdlgHasNext";
const string DLG_HAS_END = "zdlgHasEnd";

// Temporary holder for splitting off different zdlg convos
const string VAR_SCRIPT = "MI_ZDLG_CURRENT_SCRIPT";

// Some state constants that the zdlg_page_init check
// can use to determine current conversation state.
const int DLG_STATE_INIT = 0;
const int DLG_STATE_RUNNING = 1;
const int DLG_STATE_ENDED = -1;

// The base token for the dialog inserts.  +0 is the
// prompt.  +1 - +13 is the item text.  These values
// must match the .dlg file exactly.
const int DLG_BASE_TOKEN = 4200;

// Addition by Mithreas - this variable is set on the PC
// to support using 10 copies of the Z-dialog conversation.
// This reduces the chance of custom token overlap.
const string ZDLG_BASE_TOKEN = "ZDLG_BASE_TOKEN";

const int MI_ZD_STICKY_NO     = 0;
const int MI_ZD_STICKY_TOP    = 1;
const int MI_ZD_STICKY_BOTTOM = 2;

const int MI_ZD_OPTIONS_PER_PAGE = 10;

const string MI_ZD_PREFIX  = "MI_ZD_";
const string MI_ZD_CONFIRM = "MI_ZD_CONFIRM";
const string MI_ZD_INPUT   = "MI_ZD_INPUT";
const string MI_ZD_TEXT    = "MI_ZD_TEXT";

const string MI_ZD_TAKEOVER      = "MI_ZD_TAKEOVER";
const string MI_ZD_TO_CLEAN      = "MI_ZD_TO_CLEAN";
const int MI_ZD_TAKEOVER_CONFIRM = 1;
const int MI_ZD_TAKEOVER_INPUT   = 2;

const string MI_ZD_INPUT_TEXT = "\n\n<c  þ>((Speak the text into the chat channel, then click <c þ >[Continue]</c>.))</c>";

/* Prototypes for methods to implement in Z-Dialog scripts */
// Must be implemented into the conversation file. Fires when the conversation
// first starts.
void Init();
// Must be implemented into the conversation file. Fires when each page loads.
void PageInit();
// Must be implemented into the conversation file. Fires when an option is
// selected.
void HandleSelection();
// Must be implemented into the conversation file. Fires at the end of the
// conversation, handy for cleaning variables up afterwards.
void Cleanup();

// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware
// limitations with item dialogs.
object GetPcDlgSpeaker();

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void SetCurrentDlgHandlerScript( string script );

// Returns the current dialog handler script for the current conversation.
string GetCurrentDlgHandlerScript();

// Returns the current conversation's default dialog handler script if
// it has one defined.  This is used when there is otherwise
// not a current handler script set.
string GetDefaultDlgHandlerScript( object oNPC = OBJECT_SELF );

// Sets the prompt that will be displayed in the dialog
// when talking to the current speaker.
void SetDlgPrompt( string prompt );

// Returns the current prompt that will be displayed in the
// dialog when talking to the current speaker.
string GetDlgPrompt();

// Set to TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
void SetShowEndSelection( int flag );

// Returns TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
int GetShowEndSelection();

// Sets the list of responses that will be displayed in the
// dialog when talking to the current speaker.
void SetDlgResponseList( string listId, object oListHolder = OBJECT_SELF);

// Returns the list id for the list of responses that will be
// displayed in the dialog when talking to the current speaker.
string GetDlgResponseList();

// Returns the dialog type of event that caused the handler
// script to be executed.
int GetDlgEventType();

// Returns the response string for the specified entry.
// The speaker can be specified for looping optimization
// so that the functions don't have to retrieve it every time.
string GetDlgResponse( int num, object oSpeaker );

// Returns the selected item in a DLG_SELECTION event.
int GetDlgSelection();

// Sets a page string that the handler scripts can use to track
// progress through the conversation.  This is really just a
// convenience function that tacks a local var onto the PC dlg
// speaker.  It has the added benefit of getting auto-cleaned
// with the dialog clean-up.
void SetDlgPageString( string page );

// Returns a page string that the handler scripts can use to track
// progress through the conversation.
string GetDlgPageString();

// Sets a page integer that the handler scripts can use to track
// progress through the conversation.  This is really just a
// convenience function that tacks a local var onto the PC dlg
// speaker.  It has the added benefit of getting auto-cleaned
// with the dialog clean-up.
void SetDlgPageInt( int page );

// Returns a page integer that the handler scripts can use to track
// progress through the conversation.
int GetDlgPageInt();

// Called to initiate a conversation programmatically between
// the dialog source and the object to converse with.  If
// dlgHandler is "" then the object's default script will be used.
void StartDlg( object oPC, object oObjectToConverseWith, string dlgHandler = "", int bPrivate = FALSE, int bPlayHello = TRUE );

// Ends the current conversation and will fire the DLG_END event.
void EndDlg();

// Z-Dialog run function: should be implemented in every main() method as it is.
// If more functionality is needed, such as cleanup, simply use the return value
// as the action type (DLG_ABORT, etc.) and add your extra code underneath.
int miZDRun();

// Adds a response. You can not use AddStringElement any more: this function is
// the only way to add new responses to a dialog.
//
// This additionally allows highlighted action text (set bAction to TRUE) and
// "sticky" options. Sticky options appear on all pages of long lists, not just
// the first or last. Set nPersistent to one of the following: MI_ZD_STICKY_NO,
// MI_ZD_STICKY_TOP, MI_ZD_STICKY_BOTTOM. If you have 10 or more sticky
// responses, they all become unsticky because otherwise it will quite literally
// glue the whole conversation up.
//
// If sConfirmPrompt is given, after being selected the player will be presented
// with sConfirmPrompt, to which the answer is either [Continue] or [Cancel].
// On [Continue], the page will switch to sConfirmYes (or the dialog will end if
// this is not given. On [Cancel] likewise, but it will switch to sConfirmNo
// instead.
int miZDAddResponse(string sResponse, string sList, int bAction = FALSE, int nPersistent = MI_ZD_STICKY_NO, string sConfirmPrompt = "", string sConfirmYes = "", string sConfirmNo = "");

// Sets up nResponse to use a confirmation dialog.
void miZDConfirmResponse(int nResponse, string sConfirmPrompt, string sConfirmYes = "", string sConfirmNo = "");
// Sets up nResponse to use a text input dialog. If sMatchPattern is given, the
// input must match the given text string pattern to pass. If bContinue is TRUE,
// will ask once then fire the dialog action with page string MI_ZD_INPUT. If
// bContinue is FALSE, will fire the dialog action with page string MI_ZD_INPUT,
// and continue to ask until miZDEndInput() is called, or the speaker chooses
// [Back].
//
// The response text is held in the local variable MI_ZD_TEXT, which is always
// guaranteed to be valid according to sMatchPattern. If the player chooses the
// [Back] option, the most recent page is shown.
void miZDInputText(int nResponse, string sTextPrompt, string sMatchPattern = "", int bContinue = TRUE);

// Changes the text prompt for the current miZDInputText cycle to sTextPrompt.
void miZDSetInputPrompt(string sTextPrompt);

// Ends a continuous loop of miZDInputText. If sPage is given, it will be used
// as the page string, otherwise the most recent page will be used.
void miZDEndInput(object oSpeaker, string sPage = "");

// Returns the index of the selected item. Exactly the same as the Z-Dialog
// implementation of GetDlgSelection except it works with sticky responses.
// Responses are ordered as follows: Those stuck to the top, then those stuck to
// the bottom, then those not stuck.
int miZDGetSelectionIndex();

// You must use this to clean up lists instead of DeleteList if you are using
// the miZDAddResponse function.
void miZDCleanList(string sList);

//----------------------------------------------------------------------------//
// Internal functions
//----------------------------------------------------------------------------//
void _miZDCleanup()
{
    DeleteList(MI_ZD_CONFIRM);
}
//----------------------------------------------------------------------------//
void _miZDDoElements(object oPC, string sList, int nLimit, string sSuffix = "", int nStart = 0)
{
  for (; nStart < nLimit; nStart++)
  {
    AddStringElement(GetLocalString(oPC, MI_ZD_PREFIX + sList + sSuffix +
     IntToString(nStart)), sList);
  }
}
//----------------------------------------------------------------------------//
void _miZDDeleteElements(object oPC, string sList, string sSuffix = "")
{
  string sVar = MI_ZD_PREFIX + sList + sSuffix;
  int nLimit = GetLocalInt(oPC, sVar);
  int nI     = 0;
  for (; nI < nLimit; nI++)
  {
    DeleteLocalString(oPC, sVar + IntToString(nI));
  }
  DeleteLocalInt(oPC, sVar);
}
//----------------------------------------------------------------------------//
void _miZDInit()
{
  if (GetElementCount(MI_ZD_CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", MI_ZD_CONFIRM);
    AddStringElement("<c þ >[Cancel]</c>", MI_ZD_CONFIRM);
  }

  if (GetElementCount(MI_ZD_INPUT) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", MI_ZD_INPUT);
    AddStringElement("<c þ >[Back]</c>", MI_ZD_INPUT);
  }
}
//----------------------------------------------------------------------------//
int _miZDPageInit()
{
  object oPC = GetPcDlgSpeaker();

  // For confirmation prompts
  if (GetDlgPageString() == MI_ZD_CONFIRM)
  {
    SetDlgPrompt(GetLocalString(oPC, MI_ZD_CONFIRM + "_PROMPT"));
    SetDlgResponseList(MI_ZD_CONFIRM);
    return TRUE;
  }

  // For input prompts
  if (GetDlgPageString() == MI_ZD_INPUT)
  {
    SetDlgPrompt(GetLocalString(oPC, MI_ZD_INPUT + "_PROMPT") + MI_ZD_INPUT_TEXT);
    SetDlgResponseList(MI_ZD_INPUT);
    chatClearLastMessage(oPC);
    return TRUE;
  }

  // Improve perf by only dealing with changed lists
  string sList = GetDlgResponseList();
  int nChanged = GetLocalInt(oPC, MI_ZD_PREFIX + sList + "_CHANGED");
  if (!nChanged)
  {
    return FALSE;
  }
  DeleteLocalInt(oPC, MI_ZD_PREFIX + sList + "_CHANGED");

  int nTops    = GetLocalInt(oPC, MI_ZD_PREFIX + sList + "_TOP");
  int nBottoms = GetLocalInt(oPC, MI_ZD_PREFIX + sList + "_BOTTOM");
  int nNormals = GetLocalInt(oPC, MI_ZD_PREFIX + sList);
  int nLimit   = MI_ZD_OPTIONS_PER_PAGE - nTops - nBottoms;
  int nPages   = nNormals / nLimit;

  DeleteList(sList);

  // Too many or no sticky options: put them in standard list form.
  if (nLimit < 1 || nLimit == MI_ZD_OPTIONS_PER_PAGE)
  {
    _miZDDoElements(oPC, sList, nTops, "_TOP");
    _miZDDoElements(oPC, sList, nNormals);
    _miZDDoElements(oPC, sList, nBottoms, "_BOTTOM");
  }

  // Repeat elements as necessary
  else
  {
    int nI = 0;
    for (; nI <= nPages; nI++)
    {
      _miZDDoElements(oPC, sList, nTops, "_TOP");
      if (nI < nPages)
      {
        _miZDDoElements(oPC, sList, nLimit * (nI + 1), "", nLimit * nI);
      }
      else
      {
        _miZDDoElements(oPC, sList, nNormals, "", nLimit * nI);
      }
      _miZDDoElements(oPC, sList, nBottoms, "_BOTTOM");
    }
  }
  return FALSE;
}
//----------------------------------------------------------------------------//
int _miZDHandleSelection()
{
  object oPC    = GetPcDlgSpeaker();
  int nIndex    = miZDGetSelectionIndex();
  string sVar   = MI_ZD_TAKEOVER + "_" + IntToString(nIndex);
  int nTakeover = GetLocalInt(oPC, sVar);

  // Clean up flagged vars
  int nI     = 1;
  string sI  = "";
  int nClean = GetLocalInt(oPC, MI_ZD_TO_CLEAN);
  for (; nI <= nClean; nI++)
  {
    sI = IntToString(nI);
    int nToClean = GetLocalInt(oPC, MI_ZD_TO_CLEAN + "_" + sI);
    DeleteLocalInt(oPC, MI_ZD_TAKEOVER + "_" + IntToString(nToClean));
    DeleteLocalInt(oPC, MI_ZD_TO_CLEAN + "_" + sI);
  }
  DeleteLocalInt(oPC, MI_ZD_TO_CLEAN);

  if (nTakeover == MI_ZD_TAKEOVER_CONFIRM)
  {
    SetLocalString(oPC, MI_ZD_CONFIRM + "_PROMPT", GetLocalString(oPC, sVar + "_PROMPT"));
    SetLocalString(oPC, MI_ZD_CONFIRM + "_YES", GetLocalString(oPC, sVar + "_YES"));
    SetLocalString(oPC, MI_ZD_CONFIRM + "_NO", GetLocalString(oPC, sVar + "_NO"));
    SetDlgPageString(MI_ZD_CONFIRM);
    DeleteLocalString(oPC, sVar + "_PROMPT");
    DeleteLocalString(oPC, sVar + "_YES");
    DeleteLocalString(oPC, sVar + "_NO");
    return TRUE;
  }
  // Input requested
  else if (nTakeover == MI_ZD_TAKEOVER_INPUT)
  {
    SetLocalInt(oPC, MI_ZD_INPUT + "_CONTINUE", GetLocalInt(oPC, sVar + "_CONTINUE"));
    SetLocalString(oPC, MI_ZD_INPUT + "_PROMPT", GetLocalString(oPC, sVar + "_PROMPT"));
    SetLocalString(oPC, MI_ZD_INPUT + "_MATCH", GetLocalString(oPC, sVar + "_MATCH"));
    SetDlgPageString(MI_ZD_INPUT);
    DeleteLocalInt(oPC, sVar + "_CONTINUE");
    DeleteLocalString(oPC, sVar + "_PROMPT");
    DeleteLocalString(oPC, sVar + "_MATCH");
    return TRUE;
  }
  // Looking for an input
  else if (GetLocalString(oPC, MI_ZD_INPUT + "_PROMPT") != "")
  {
    // [Continue] - Look for a response.
    if (nIndex == 0)
    {
      string sResponse = chatGetLastMessage(oPC);
      if (sResponse != "")
      {
        string sPattern = GetLocalString(oPC, MI_ZD_INPUT + "_MATCH");

        // Pattern matches - if so we SHOULD allow the normal dialog script to
        // be executed.
        if (sPattern == "" || TestStringAgainstPattern(sPattern, sResponse))
        {
          // Should this be shown more than once?
          if (GetLocalInt(oPC, MI_ZD_INPUT + "_CONTINUE"))
          {
            DeleteLocalInt(oPC, MI_ZD_INPUT + "_CONTINUE");
            DeleteLocalString(oPC, MI_ZD_INPUT + "_PREVIOUS");
            DeleteLocalString(oPC, MI_ZD_INPUT + "_PROMPT");
            DeleteLocalString(oPC, MI_ZD_INPUT + "_MATCH");
          }
          SetLocalString(oPC, MI_ZD_TEXT, sResponse);
          return FALSE;
        }
      }
    }
    // [Back] - Return to previous page
    else
    {
      SetDlgPageString(GetLocalString(oPC, MI_ZD_INPUT + "_PREVIOUS"));
      DeleteLocalInt(oPC, MI_ZD_INPUT + "_CONTINUE");
      DeleteLocalString(oPC, MI_ZD_INPUT + "_PREVIOUS");
      DeleteLocalString(oPC, MI_ZD_INPUT + "_PROMPT");
      DeleteLocalString(oPC, MI_ZD_INPUT + "_MATCH");
    }

    return TRUE;
  }
  else if (GetDlgPageString() == MI_ZD_CONFIRM)
  {
    string sSuffix;
    if (GetDlgSelection()) // "Cancel"
    {
      sSuffix = "_NO";
    }
    else                  // "Continue"
    {
      sSuffix = "_YES";
    }

    string sContinue = GetLocalString(oPC, MI_ZD_CONFIRM + sSuffix);
    if (sContinue == "")
    {
      EndDlg();
    }
    else
    {
      SetDlgPageString(sContinue);
    }

    DeleteLocalString(oPC, MI_ZD_CONFIRM + "_PROMPT");
    DeleteLocalString(oPC, MI_ZD_CONFIRM + "_YES");
    DeleteLocalString(oPC, MI_ZD_CONFIRM + "_NO");
    return TRUE;
  }
  return FALSE;
}
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
// Public functions
//----------------------------------------------------------------------------//
// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware
// limitations with item dialogs.
object GetPcDlgSpeaker()
{
    object oPC = GetPCSpeaker();
    if( oPC == OBJECT_INVALID )
        {
        oPC = GetItemActivator();
        }
    if( oPC == OBJECT_INVALID )
        PrintString( "WARNING: Unable to retrieve a PC speaker." );
    return( oPC );
}

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void SetCurrentDlgHandlerScript( string script )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_CURRENT_HANDLER, script );
}

// Returns the current dialog handler script for the current conversation.
string GetCurrentDlgHandlerScript()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_CURRENT_HANDLER ) );
}

// Returns the current conversation's default dialog handler script if
// it has one defined.  This is used when there is otherwise
// not a current handler script set.
string GetDefaultDlgHandlerScript( object oNPC = OBJECT_SELF )
{
    return( GetLocalString( oNPC, DLG_HANDLER ) );
}

// Sets the prompt that will be displayed in the dialog
// when talking to the current speaker.
void SetDlgPrompt( string prompt )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_PROMPT, prompt );
}

// Returns the current prompt that will be displayed in the
// dialog when talking to the current speaker.
string GetDlgPrompt()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_PROMPT ) );
}

// Set to TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
void SetShowEndSelection( int flag )
{
    SetLocalInt( GetPcDlgSpeaker(), DLG_HAS_END, flag );
}

// Returns TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
int GetShowEndSelection()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_HAS_END ) );
}

// Sets the list of responses that will be displayed in the
// dialog when talking to the current speaker.
void SetDlgResponseList( string listId, object oListHolder = OBJECT_SELF)
{
    object oSpeaker = GetPcDlgSpeaker();
    SetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER, oListHolder );
    SetLocalString( oSpeaker, DLG_RESPONSE_LIST, listId );
}

// Returns the list id for the list of responses that will be
// displayed in the dialog when talking to the current speaker.
string GetDlgResponseList()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_RESPONSE_LIST ) );
}

// Returns the dialog type of event that caused the handler
// script to be executed.
int GetDlgEventType()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_EVENT_TYPE ) );
}

// Returns the selected item in a DLG_SELECTION event.
int GetDlgSelection()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_EVENT_SELECTION ) );
}

// Sets a page string that the scripts can use to track
// progress through the conversation.
void SetDlgPageString( string page )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_PAGE_ID, page );
}

// Returns a page string that the scripts can use to track
// progress through the conversation.
string GetDlgPageString()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_PAGE_ID ) );
}

// Sets a page string that the scripts can use to track
// progress through the conversation.
void SetDlgPageInt( int page )
{
    SetLocalInt( GetPcDlgSpeaker(), DLG_PAGE_ID, page );
}

// Returns a page string that the scripts can use to track
// progress through the conversation.
int GetDlgPageInt()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_PAGE_ID ) );
}

// Called to initiate a conversation programmatically between
// the dialog source and the object to converse with.  If
// dlgHandler is "" then the object's default script will be used.
void StartDlg( object oPC, object oObjectToConverseWith, string dlgHandler = "",
               int bPrivate = FALSE, int bPlayHello = TRUE )
{

    if( GetObjectType( oObjectToConverseWith ) == OBJECT_TYPE_ITEM )
        {
        // We can't actually talk to items so we fudge it.
        // NB - this code is currently useless.  All the check_init scripts
        // need updating to make it work.
        SetLocalObject( oPC, DLG_ITEM, oObjectToConverseWith );
        oObjectToConverseWith = oPC;
        }

    // Setup the conversation
    if( dlgHandler != "" )
        SetLocalString( oObjectToConverseWith, VAR_SCRIPT, dlgHandler );

    if(GetObjectType(oObjectToConverseWith) == OBJECT_TYPE_DOOR)
        AssignCommand( oObjectToConverseWith,
                   ActionStartConversation( oPC, "zdlg_converse",
                                            bPrivate, bPlayHello ) );
    else
        AssignCommand( oPC,
                   ActionStartConversation( oObjectToConverseWith, "zdlg_converse",
                                            bPrivate, bPlayHello ) );
}

// Ends the current conversation and will fire the DLG_END event.
void EndDlg()
{
    object oSpeaker = GetPcDlgSpeaker();
    SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_ENDED );
}


// Returns the number of responses that will be displayed
// in the dialog when talking to the specified speaker.
// The speaker can be specified for looping optimization
// so that the functions don't have to retrieve it every time.
int GetDlgResponseCount( object oSpeaker )
{
    object oHolder = GetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    string listId = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return( GetElementCount( listId, oHolder ) );
}

// Returns the response string for the specified entry.
// The speaker can be specified for looping optimization
// so that the functions don't have to retrieve it every time.
string GetDlgResponse( int num, object oSpeaker )
{
    object oHolder = GetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    string listId = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return( GetStringElement( num, listId, oHolder ) );
}

// Sets up the previous/next buttons
void _SetDlgPreviousNext( object oSpeaker, int hasPrevious, int hasNext )
{
    SetLocalInt( oSpeaker, DLG_HAS_PREV, hasPrevious );
    SetLocalInt( oSpeaker, DLG_HAS_NEXT, hasNext );
}

// Returns true if the "previous" entry is turned on in the
// response list
int _HasDlgPrevious( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_PREV ) );
}

// Returns true if the "next" entry is turned on in the
// response list
int _HasDlgNext( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_NEXT ) );
}

// Returns true if the "end" entry is turned on in the
// response list
int _HasDlgEnd( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_END ) );
}

// Sets the starting entry for when a response list is
// broken into multiple pages.
void _SetDlgFirstResponse( object oSpeaker, int start )
{
    SetLocalInt( oSpeaker, DLG_START_ENTRY, start );
}

// Returns the starting entry for when a response list is
// broken into multiple pages.
int _GetDlgFirstResponse( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_START_ENTRY ) );
}

// Sets the token for the response string and returns true
// if there is a valid response entry for the specified num.
int _SetupDlgResponse( int num, object oSpeaker )
{
    int nBaseToken = GetLocalInt(oSpeaker, ZDLG_BASE_TOKEN);
    if (!nBaseToken) nBaseToken = DLG_BASE_TOKEN;

    Trace(ZDIALOG, "Using base token number: " + IntToString(nBaseToken));

    int hasNext = _HasDlgNext( oSpeaker );
    int hasPrev = _HasDlgPrevious( oSpeaker );
    int hasEnd = _HasDlgEnd( oSpeaker );
    if( (hasNext || hasPrev || hasEnd) && num >= 10 )
        {
        if( hasNext && num == 10 )
            {
            SetCustomToken( nBaseToken + 11, "Next" );
            return( TRUE );
            }
        if( hasPrev && num == 11 )
            {
            SetCustomToken( nBaseToken + 12, "Previous" );
            return( TRUE );
            }
        if( hasEnd && num == 12 )
            {
            SetCustomToken( nBaseToken + 13, "End" );
            return( TRUE );
            }
        return( FALSE );
        }

    int i = _GetDlgFirstResponse( oSpeaker ) + num;
    int count = GetDlgResponseCount( oSpeaker );
    if( i < count )
        {
        string response = GetDlgResponse( i, oSpeaker );
        SetCustomToken( nBaseToken + num + 1, response );
        return( TRUE );
        }
    return( FALSE );
}

// Called to clean-up the current conversation related
// resources.
void _CleanupDlg( object oSpeaker )
{
    Trace(ZDIALOG, "Cleaning up Z-Dialog conversation");
    DeleteLocalInt( oSpeaker, DLG_STATE );
    DeleteLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    DeleteLocalString( oSpeaker, DLG_RESPONSE_LIST );
    DeleteLocalString( oSpeaker, DLG_PROMPT );
    DeleteLocalString( oSpeaker, DLG_CURRENT_HANDLER );
    DeleteLocalString( oSpeaker, DLG_PAGE_ID );
    DeleteLocalObject( oSpeaker, DLG_ITEM );
    DeleteLocalInt( oSpeaker, DLG_HAS_PREV );
    DeleteLocalInt( oSpeaker, DLG_HAS_NEXT );
    DeleteLocalInt( oSpeaker, DLG_HAS_END );
    DeleteLocalInt( oSpeaker, DLG_START_ENTRY );
}

// Sends the specified dialog event to the specified NPC
// using the current script handler.  The selection parameter
// is used for select events.  The speaker is provided for
// event specific paramaters to be stored onto.
void _SendDlgEvent( object oSpeaker, int dlgEvent, int selection = -1, object oNPC = OBJECT_SELF )
{
    Trace(ZDIALOG, "Sending dialog event: " + IntToString(dlgEvent));

    if (dlgEvent == DLG_SELECTION)
    {
      // Clear the page-specific vars as we've just selected
      // a page. They'll be reset by the initialise page code if needed.
      DeleteLocalInt( oSpeaker, DLG_HAS_PREV );
      DeleteLocalInt( oSpeaker, DLG_HAS_NEXT );
      DeleteLocalInt( oSpeaker, DLG_HAS_END );
      DeleteLocalInt( oSpeaker, DLG_START_ENTRY );
    }

    string dlg = GetCurrentDlgHandlerScript();
    Trace(ZDIALOG, "Current script: " + dlg);
    if( oNPC == oSpeaker )
        oNPC = GetLocalObject( oSpeaker, DLG_ITEM );

    if (!GetIsObjectValid(oNPC)) oNPC = oSpeaker;

    SetLocalInt( oSpeaker, DLG_EVENT_TYPE, dlgEvent );
    SetLocalInt( oSpeaker, DLG_EVENT_SELECTION, selection );
    ExecuteScript( dlg, oNPC );
    DeleteLocalInt( oSpeaker, DLG_EVENT_TYPE );
    DeleteLocalInt( oSpeaker, DLG_EVENT_SELECTION );
}

void _DoDlgSelection( object oSpeaker, int selection, object oNPC = OBJECT_SELF )
{
    // Check to see if this is one or our internal events
    int first = _GetDlgFirstResponse( oSpeaker );

    switch( selection )
        {
        case 10:
            if( _HasDlgNext( oSpeaker ) )
                {
                // Next page
                _SetDlgFirstResponse( oSpeaker, first + 10 );
                return;
                }
            break;
        case 11:
            if( _HasDlgPrevious( oSpeaker ) )
                {
                // Previous page
                _SetDlgFirstResponse( oSpeaker, first - 10 );
                return;
                }
            break;
        case 12:
            if( _HasDlgEnd( oSpeaker ) )
                {
                // End dialog
                EndDlg();
                return;
                }
            break;
        }

    selection += first;

    _SendDlgEvent( oSpeaker, DLG_SELECTION, selection, oNPC );
}

// Returns the current conversation state.
int _GetDlgState( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_STATE ) );
}

// Called by the dialog internals to initialize the page
// and possibly the conversation
void _InitializePage(object oSpeaker, object oNPC = OBJECT_SELF)
{
    int    state = GetLocalInt( oSpeaker, DLG_STATE );
    string dlg = GetCurrentDlgHandlerScript();

    if( oNPC == oSpeaker )
        oNPC = GetLocalObject( oSpeaker, DLG_ITEM );
    if (!GetIsObjectValid(oNPC)) oNPC = oSpeaker;

    // See if the NPC has a dialog file defined
    if( dlg == "" )
        {
        // Try to see if they have a default defined
        dlg = GetDefaultDlgHandlerScript( oNPC );
        SetCurrentDlgHandlerScript( dlg );
        state = 0;
        }

    // If we aren't initialized
    if( state == DLG_STATE_INIT )
        {
        // Then we'll send the conversation init event
        _SendDlgEvent( oSpeaker, DLG_INIT, -1, oNPC );
        SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_RUNNING );
        }

    // Send the page initialization event
    _SendDlgEvent( oSpeaker, DLG_PAGE_INIT, -1, oNPC );
}

int miZDRun()
{
  int nEvent    = GetDlgEventType();
  object oPC    = GetPcDlgSpeaker();
  int nTakeover = GetLocalInt(oPC, MI_ZD_TAKEOVER + "_" + IntToString(GetDlgSelection()));

  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
  case DLG_INIT:
    _miZDInit();
    Init();
    break;
  case DLG_PAGE_INIT:
    if (!_miZDPageInit())
    {
      PageInit();
    }
    break;
  case DLG_SELECTION:
    if (!_miZDHandleSelection())
    {
      HandleSelection();
    }
    break;
  case DLG_ABORT:
  case DLG_END:
    _miZDCleanup();
    Cleanup();
    break;
  }
  return nEvent;
}
//----------------------------------------------------------------------------//
int miZDAddResponse(string sResponse, string sList, int bAction = FALSE, int bPersistent = MI_ZD_STICKY_NO,
    string sConfirmPrompt = "", string sConfirmYes = "", string sConfirmNo = "")
{
  object oPC  = GetPcDlgSpeaker();

  // Handle persistence
  string sVar = MI_ZD_PREFIX + sList;
  switch (bPersistent)
  {
    case MI_ZD_STICKY_TOP:
      sVar += "_TOP";
      break;
    case MI_ZD_STICKY_BOTTOM:
      sVar += "_BOTTOM";
      break;
  }

  // Handle action highlighting
  if (bAction)
  {
    sResponse = "<c þ >" + sResponse + "</c>";
  }

  // Handle confirmation
  int nLimit = GetLocalInt(oPC, sVar);
  if (sConfirmPrompt != "")
  {
    miZDConfirmResponse(nLimit, sConfirmPrompt, sConfirmYes, sConfirmNo);
  }

  // Store the response
  SetLocalInt(oPC, sVar, nLimit + 1);
  SetLocalString(oPC, sVar + IntToString(nLimit), sResponse);
  SetLocalInt(oPC, MI_ZD_PREFIX + sList + "_CHANGED", TRUE);

  return nLimit;
}
//----------------------------------------------------------------------------//
void miZDConfirmResponse(int nResponse, string sConfirmPrompt, string sConfirmYes = "", string sConfirmNo = "")
{
  object oPC = GetPcDlgSpeaker();
  string sVar = MI_ZD_TAKEOVER + "_" + IntToString(nResponse);
  SetLocalInt(oPC, sVar, MI_ZD_TAKEOVER_CONFIRM);
  SetLocalString(oPC, sVar + "_PROMPT", sConfirmPrompt);
  SetLocalString(oPC, sVar + "_YES", sConfirmYes);
  SetLocalString(oPC, sVar + "_NO", sConfirmNo);

  // This must not last more than one conversation option, so flag the vars for
  // deletion.
  int nClean = GetLocalInt(oPC, MI_ZD_TO_CLEAN) + 1;
  SetLocalInt(oPC, MI_ZD_TO_CLEAN + "_" + IntToString(nClean), nResponse);
  SetLocalInt(oPC, MI_ZD_TO_CLEAN, nClean);
}
//----------------------------------------------------------------------------//
void miZDInputText(int nResponse, string sTextPrompt, string sMatchPattern = "", int bContinue = TRUE)
{
  object oPC = GetPcDlgSpeaker();
  string sVar = MI_ZD_TAKEOVER + "_" + IntToString(nResponse);
  SetLocalInt(oPC, sVar, MI_ZD_TAKEOVER_INPUT);
  SetLocalInt(oPC, sVar + "_CONTINUE", bContinue);
  SetLocalString(oPC, sVar + "_PROMPT", sTextPrompt);
  SetLocalString(oPC, sVar + "_MATCH", sMatchPattern);
  SetLocalString(oPC, MI_ZD_INPUT + "_PREVIOUS", GetDlgPageString());

  // This must not last more than one conversation option, so flag the vars for
  // deletion.
  int nClean = GetLocalInt(oPC, MI_ZD_TO_CLEAN) + 1;
  SetLocalInt(oPC, MI_ZD_TO_CLEAN + "_" + IntToString(nClean), nResponse);
  SetLocalInt(oPC, MI_ZD_TO_CLEAN, nClean);
}
//----------------------------------------------------------------------------//
void miZDSetInputPrompt(string sTextPrompt)
{
  SetLocalString(GetPcDlgSpeaker(), MI_ZD_INPUT + "_PROMPT", sTextPrompt);
}
//----------------------------------------------------------------------------//
void miZDEndInput(object oSpeaker, string sPage = "")
{
  if (sPage == "")
  {
    sPage = GetLocalString(oSpeaker, MI_ZD_INPUT + "_PREVIOUS");
  }
  SetDlgPageString(sPage);
  DeleteLocalInt(oSpeaker, MI_ZD_INPUT + "_CONTINUE");
  DeleteLocalString(oSpeaker, MI_ZD_INPUT + "_PREVIOUS");
  DeleteLocalString(oSpeaker, MI_ZD_INPUT + "_PROMPT");
  DeleteLocalString(oSpeaker, MI_ZD_INPUT + "_MATCH");
}
//----------------------------------------------------------------------------//
int miZDGetSelectionIndex()
{
  string sList = GetDlgResponseList();
  object oPC   = GetPcDlgSpeaker();
  int nTops    = GetLocalInt(oPC, MI_ZD_PREFIX + sList + "_TOP");
  int nBottoms = GetLocalInt(oPC, MI_ZD_PREFIX + sList + "_BOTTOM");
  int nLimit   = MI_ZD_OPTIONS_PER_PAGE - nTops - nBottoms;
  int nSelect  = GetDlgSelection();
  int nPageSel = nSelect % MI_ZD_OPTIONS_PER_PAGE;

  // Too many or no sticky options: nSelect will be correct.
  if (nLimit < 1 || nLimit == MI_ZD_OPTIONS_PER_PAGE)
  {
    return nSelect;
  }
  else
  {
    // A top is selected
    if (nPageSel < nTops)
    {
      return nPageSel;
    }
    // A bottom is selected
    else if (nPageSel >= MI_ZD_OPTIONS_PER_PAGE - nBottoms)
    {
      return nPageSel - nLimit;
    }
    // A normal is selected
    else
    {
      //------------------------------------------------------------------------
      // This one warrants a bit of explaining. Basically we want the total
      // number of tops, plus the total number of bottoms, plus the ID of the
      // normal selected. To do so, we subtract the current page multiplied by
      // the number of tops, and also subtract the current page minus 1
      // multiplied by the number of bottoms. THEN we add on one the number of
      // tops and the number of bottoms. But this is already done indirectly in
      // finding nCurrentPage, because nCurrentPage is actually one less than
      // the current page. So if we're on page 1 and have sticky bottoms (:D)
      // this is actually ADDED to the index. Don't worry if you don't get it,
      // it just works.
      //------------------------------------------------------------------------
      int nCurrentPage = nSelect / MI_ZD_OPTIONS_PER_PAGE;
      return nSelect - ((nCurrentPage - 1) * nBottoms) - (nCurrentPage * nTops);
    }
  }

  // Failsafe to keep the compiler happy
  return FALSE;
}
//----------------------------------------------------------------------------//
void miZDCleanList(string sList)
{
  object oPC = GetPcDlgSpeaker();
  DeleteList(sList);
  _miZDDeleteElements(oPC, sList, "_TOP");
  _miZDDeleteElements(oPC, sList, "_BOTTOM");
  _miZDDeleteElements(oPC, sList);
}


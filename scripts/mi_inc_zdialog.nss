/*
  mi_inc_zdialog
  Z-Dialog interface library
  Status: Alpha
  Original: Fireboar, 11th October 2008
  Last modified: Fireboar, 14th March 2009

  An interface library containing useful functions for managing things that go
  on in conversations. Features:
  - Ability to add "sticky" dialog options which persist over multiple pages,
    optionally at the top and bottom of the list.
  - Action colourizer.
  - Generic customizable "Are you sure?" interface.
  - "Waiting for speech input" interface.
*/

#include "fb_inc_chatutils"
#include "zdlg_include_i"

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
// Implementation
//----------------------------------------------------------------------------//
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

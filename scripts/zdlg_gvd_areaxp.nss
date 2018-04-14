#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_zdlg"
#include "inc_chatutils"
#include "inc_adv_xp"

const string VARNAMES = "VARNAMES";
const string VARTYPES = "VARTYPES";
const string ADD_PAGE = "ADD_PAGE";
const string ADD_OPTIONS = "ADD_OPTIONS";
const string TYPE_OPTIONS = "TYPE_OPTIONS";
const string EDIT_PAGE = "EDIT_PAGE";
const string EDIT_OPTIONS = "EDIT_OPTIONS";

const string TYPE_PAGE = "TYPE_PAGE";

const string PAGE_DONE    = "DONE";
const string PAGE_FAILED  = "FAILED";

void Init()
{

  if (GetElementCount(EDIT_OPTIONS) == 0) {
    AddStringElement("[confirm]", EDIT_OPTIONS);
    AddStringElement("[cancel]", EDIT_OPTIONS);
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Speak the exploration XP value, then press [confirm]. Current setting = " + IntToString(gvd_AdventuringXP_GetAreaXP(GetArea(oPC))));
    chatClearLastMessage(oPC);
    SetDlgResponseList(EDIT_OPTIONS);
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgPrompt("Done.");
    SetDlgResponseList(PAGE_DONE);
  }
  else if (sPage == PAGE_FAILED)
  {
    SetDlgPrompt("No XP value entered.");
    SetDlgResponseList(PAGE_DONE);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "") {
    // handle the PCs selection
  
    if (selection == 0) {

      object oArea = GetArea(oPC);

      string sVarValue = chatGetLastMessage(oPC);

      if (sVarValue != "") {
        object oArea = GetArea(oPC);
        gvd_AdventuringXP_SetAreaXP(oArea, StringToInt(sVarValue));

        SendMessageToPC(oPC, "Area exploration XP is set to " + sVarValue);

        SetDlgPageString(PAGE_DONE); 

      } else {
        SetDlgPageString(PAGE_FAILED);
      }


    } else {
      // The Done response list has only one option, to end the conversation.
      EndDlg();
    }

  } else {
    // The Done response list has only one option, to end the conversation.
    EndDlg();
  }

}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}

       



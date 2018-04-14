/*
  zdlg_messengers

  Z-Dialog conversation script for bar recruiter

*/

#include "inc_zdlg"
#include "inc_bar"

const string MAINOPTIONS = "MAINOPTIONS";
const string DONE    = "MES_DONE";

const string PAGE_WORK = "PAGE_WORK";
const string PAGE_DONE    = "DONE";

void Init()
{
  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE);
  }

  if (GetElementCount(MAINOPTIONS) == 0)
  {
    AddStringElement("Sign me up.", MAINOPTIONS);
    AddStringElement("No thanks <cþ  >[Leave]</c>", MAINOPTIONS);
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    // check if the PC talking is already working inside the bar
    string sBarID = GetBarID(OBJECT_SELF);
    if (GetIsBarkeeper(oPC, sBarID) == 1) {
      // already working?
      SetDlgPrompt("I'm a recruiter, you already work here, remember?");
      SetDlgPageString(PAGE_DONE);
      SetDlgResponseList(DONE);       
 
    } else {
      SetDlgPrompt("Looking for a job as barkeeper? I can sign you up as a server. If you work hard enough you might make it to bartender eventually.");
      SetDlgResponseList(MAINOPTIONS);
    }

  }
  else if (sPage == PAGE_WORK)
  {

    string sBarID = GetBarID(OBJECT_SELF);

    if (HireBarkeeper(oPC, sBarID) == 1) {
      SetDlgPrompt("Done, you have 1 week to prove yourself. Start selling drinks!");
      SetDlgResponseList(DONE);
    } else {
      // failed
      SetDlgPrompt("You failed your previous trial period. Come back later.");
      SetDlgResponseList(DONE);
    }

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
    switch (selection) {
      case 0:
        // sign up for work
        SetDlgPageString(PAGE_WORK);
        break;
      case 1:
        // leave
        EndDlg();
        break;
    }

  } else {
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

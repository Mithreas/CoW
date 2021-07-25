/**
 *  Fey Escape conversation script.  Will free the PC, but only if they haven't got any open quests.
 *
 *  A PC won't be able to leave the fey diner area until they complete all the quests they've been given.
 */
#include "inc_achievements"
#include "inc_challenge"
#include "zdlg_include_i"

const string OPTIONS1   = "FEYE_OPTIONS1";
const string OPTIONS2   = "FEYE_OPTIONS2";
const string FEY_QUEST  = "CH_Q_FEY"; // Shared with zdlg_feydiner

void Init()
{
  // Set up dialog options - depends on whether they can leave or not.
  if (!GetElementCount(OPTIONS1))
  {
    AddStringElement("I'll be back.", OPTIONS1);
  }

  if (!GetElementCount(OPTIONS2))
  {
    AddStringElement("Not just yet, please.", OPTIONS2);
    AddStringElement("Yes, please send me out of here!", OPTIONS2);
  }
}

void PageInit()
{
  object oPC    = GetPcDlgSpeaker();

  // Check whether the PC has any open quests.
  if (CHGetQuestCount(oPC, FEY_QUEST))
  {
    SetDlgPrompt("Well, well, it seems you're in a bit of a pickle, aren't you?  I'll release you... but only if you've done " +
    "everything the others have asked you to.  I have no desire to get into trouble for disrupting the feast, you see.");
    SetDlgResponseList(OPTIONS1);
  }
  else
  {
    SetDlgPrompt("It looks like you're ready to leave.  Time to go?");
    SetDlgResponseList(OPTIONS2);
  }
}

void HandleSelection()
{
  int selection = GetDlgSelection();
  object oPC    = GetPcDlgSpeaker();

  if (selection)
  {
    //destroy corpse
    object oCorpse = GetLocalObject(oPC, "GS_CORPSE");

    if (GetIsObjectValid(oCorpse)) DestroyObject(oCorpse);
    DeleteLocalObject(oPC, "GS_CORPSE");
	
	// Achievement.
	acAwardAchievement(oPC, "feydiner");
	
    // Escape!
	if (GetRacialType(oPC) == RACIAL_TYPE_ELF)
	{
      gsCMTeleportToObject(oPC, GetObjectByTag("WP_FF_FWEXIT"));
	}
	else
	{
      gsCMTeleportToObject(oPC, GetObjectByTag("WP_PVVSWBL_FWEXIT"));
	}  
  }

  EndDlg();
}

void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_feyescape script");
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
/*
  Name: zdlg_dmwand
  Author: Mithreas
  Date: Apr 30 2006
  Description: DM Wand conversation script. Uses Z-Dialog.

*/
#include "inc_zdlg"
#include "inc_reputation"
// inc_reputation includes inc_log, inc_crime and inc_database
const string DMWAND = "DMWAND"; // for logging

// pages
const string MAIN_MENU     = "main_options";
const string LIST_FACTIONS = "list_factions";
const string ADJUST_REP    = "adjust_reputation";
const string ADJUST_BOUNTY = "adjust_bounty";
const string CONFIRM       = "confirm";

// var names
const string DM_FACTION    = "DM_FACTION"; // To store the faction we work with.
const string DM_ACTION     = "DM_ACTION";  // To store what sort of action we do.
const string DM_VALUE      = "DM_VALUE";   // To store the magnitude of the change.

// values for DM_ACTION.
const int ACTION_ADJUST_REP    = 0;
const int ACTION_ADJUST_BOUNTY = 1;
const int ACTION_REMOVE_CAP    = 2;

void Init()
{
  // This function sets up player responses, assuming they don't change. If
  // you want player responses to change based on what they've said in the
  // conversation, put the code in PageInit() instead.

  // Main menu.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Check ranks of all PCs.", MAIN_MENU);
    AddStringElement("Adjust PC reputation.", MAIN_MENU);
    AddStringElement("Adjust PC bounty with faction.", MAIN_MENU);
    AddStringElement("Remove PC level cap.", MAIN_MENU);
  }

  // List of factions.
  if (GetElementCount(LIST_FACTIONS) == 0)
  {
    int nCount = 0;
    while (nCount < NUM_NATIONS)
    {
      AddStringElement(GetFactionName(nCount), LIST_FACTIONS);
      nCount++;
    }
  }

  // Reputation adjustment
  if (GetElementCount(ADJUST_REP) == 0)
  {
    AddStringElement("Add one rep point.", ADJUST_REP);
    AddStringElement("Add five rep points.", ADJUST_REP);
    AddStringElement("Remove one rep point.", ADJUST_REP);
    AddStringElement("Remove five rep points.", ADJUST_REP);
  }

  // Bounty adjustment
  if (GetElementCount(ADJUST_BOUNTY) == 0)
  {
    AddStringElement("Remove bounty from PC.", ADJUST_BOUNTY);
    AddStringElement("Add fine for stealing.", ADJUST_BOUNTY);
    AddStringElement("Add fine for assault.", ADJUST_BOUNTY);
    AddStringElement("Add fine for murder.", ADJUST_BOUNTY);
  }

  // Confirmation dialog.
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("Yes, do it.", CONFIRM);
    AddStringElement("No, cancel.", CONFIRM);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("What do you want to do?");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == LIST_FACTIONS)
  {
    SetDlgPrompt("With which faction?");
    SetDlgResponseList(LIST_FACTIONS, OBJECT_SELF);

  }
  else if (sPage == ADJUST_REP)
  {
    object oTargetPC = GetLocalObject(OBJECT_SELF, "TARGET");
    int nFaction = GetLocalInt(OBJECT_SELF, DM_FACTION);
    int nRep = GetRepScore(oTargetPC, nFaction);
    SetDlgPrompt("PC's current rep score with "+ GetFactionName(nFaction) +
                 " is " + IntToString(nRep) + " Adjust by how much?");
    SetDlgResponseList(ADJUST_REP, OBJECT_SELF);
  }
  else if (sPage == ADJUST_BOUNTY)
  {
    object oTargetPC = GetLocalObject(OBJECT_SELF, "TARGET");
    int nFaction = GetLocalInt(OBJECT_SELF, DM_FACTION);
    int nRep = GetBounty(nFaction, oTargetPC);
    SetDlgPrompt("PC's current bounty with "+ GetFactionName(nFaction) +
                 " is " + IntToString(nRep) + " Adjust by how much?");
    SetDlgResponseList(ADJUST_BOUNTY, OBJECT_SELF);
  }
  else if (sPage == CONFIRM)
  {
    int nAction = GetLocalInt(OBJECT_SELF, DM_ACTION);
    int nValue = GetLocalInt(OBJECT_SELF, DM_VALUE);
    string sActionName = "";

    switch (nAction)
    {
      case 0:
        sActionName = "Change PC reputation";
        break;
      case 1:
        sActionName = "Change PC bounty";
        break;
      case 2:
        sActionName = "Remove PC level cap.";
        break;
    }

    string sPrompt = "You have chosen to: " + sActionName;

    if (nAction < 2)
    {
      if (nAction == 1 && nValue == 0)
      {
        sPrompt += " - remove bounty.";
      }
      else
      {
        sPrompt += ". Change: " + IntToString(nValue) + ".";
      }
    }

    SetDlgPrompt(sPrompt);
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (GetDlgResponseList() == MAIN_MENU)
  {
    switch (selection)
    {
      case 0:
        // Check ranks
        {
          object oPC = GetFirstPC();

          while (GetIsObjectValid(oPC))
          {
            if (!GetIsDM(oPC))
            {
              struct repRank rRank = GetPCFactionRank(oPC);
              SendMessageToPC(GetItemActivator(), GetName(oPC)+" has rank "+
                                                rRank.sName+" with "+GetSubRace(oPC));
            }

            oPC = GetNextPC();
          }
          break;
        }
      case 1:
        // Adjust rep
        {
          SetLocalInt(OBJECT_SELF, DM_ACTION, ACTION_ADJUST_REP);
          SetDlgPageString(LIST_FACTIONS);
          break;
        }
      case 2:
        // Adjust bounty
        {
          SetLocalInt(OBJECT_SELF, DM_ACTION, ACTION_ADJUST_BOUNTY);
          SetDlgPageString(LIST_FACTIONS);
          break;
        }
      case 3:
        // Remove cap
        {
          SetLocalInt(OBJECT_SELF, DM_ACTION, ACTION_REMOVE_CAP);
          SetDlgPageString(CONFIRM);
          break;
        }
    }
  }
  else if (GetDlgResponseList() == LIST_FACTIONS)
  {
    SetLocalInt(OBJECT_SELF, DM_FACTION, selection);
    int nAction = GetLocalInt(OBJECT_SELF, DM_ACTION);

    if (nAction == 0)
    {
      SetDlgPageString(ADJUST_REP);
    }
    else
    {
      SetDlgPageString(ADJUST_BOUNTY);
    }
  }
  else if (GetDlgResponseList() == ADJUST_REP)
  {
    switch (selection)
    {
      case 0:  // +1
        SetLocalInt(OBJECT_SELF, DM_VALUE, 1);
        break;
      case 1:  // +5
        SetLocalInt(OBJECT_SELF, DM_VALUE, 5);
        break;
      case 2:  // -1
        SetLocalInt(OBJECT_SELF, DM_VALUE, -1);
        break;
      case 3:  // -5
        SetLocalInt(OBJECT_SELF, DM_VALUE, -5);
        break;
    }

    SetDlgPageString(CONFIRM);
  }
  else if (GetDlgResponseList() == ADJUST_BOUNTY)
  {
    switch (selection)
    {
      case 0:  // remove
        SetLocalInt(OBJECT_SELF, DM_VALUE, 0);
        break;
      case 1:  // theft
        SetLocalInt(OBJECT_SELF, DM_VALUE, FINE_THEFT);
        break;
      case 2:  // assault
        SetLocalInt(OBJECT_SELF, DM_VALUE, FINE_ASSAULT);
        break;
      case 3:  // murder
        SetLocalInt(OBJECT_SELF, DM_VALUE, FINE_MURDER);
        break;
    }

    SetDlgPageString(CONFIRM);
  }
  else if (GetDlgResponseList() == CONFIRM)
  {
    switch (selection)
    {
      case 0: // Do it.
        {
          object oTargetPC = GetLocalObject(OBJECT_SELF, "TARGET");
          int nFaction     = GetLocalInt(OBJECT_SELF, DM_FACTION);
          int nAction      = GetLocalInt(OBJECT_SELF, DM_ACTION);
          int nValue       = GetLocalInt(OBJECT_SELF, DM_VALUE);

          if (nAction == 0) // Change rep.
          {
            GiveRepPoints(oTargetPC, nValue, nFaction, 0);
          }
          else if (nAction == 1) // Change bounty.
          {
            if (nValue == 0) // remove
            {
              RemoveBountyToken(nFaction, oTargetPC);
            }
            else
            {
              AddToBounty(nFaction, nValue, oTargetPC);
            }
          }
          else if (nAction == 2) // Remove level cap.
          {
            SetPersistentInt(oTargetPC, "APPROVED", 1);
          }

          EndDlg();
          break;
        }
      case 1: // Cancel
        EndDlg();
        break;
    }
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}

void main()
{
  int nEvent = GetDlgEventType();
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

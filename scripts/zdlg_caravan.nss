/*
  Name: zdlg_caravan
  Author: Mithreas (includes code adapted from the All At Sea vault package)
  Date: 10 Nov 2008
  Description: Caravan destination script. Uses Z-Dialog.

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "zdlg_include_i"
#include "gs_inc_subrace"
#include "mi_inc_caravan"

//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------
const string CONFIRM_MENU = "mica_confirm_menu";
const string TRAVEL_MENU  = "mica_travel_menu";

const string SELECTION      = "mica_selection";

const string DESTINATIONS    = "mica_destinations";
const string CONFIRM_OPTIONS = "mica_confirm_options";
const string TRAVEL_OPTIONS  = "mica_travel_options";
const string DONE            = "mica_done";

void Init()
{
  // This method is called once, at the start of the conversation.

  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(CONFIRM_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Buy ticket for 25 gold]</c>", CONFIRM_OPTIONS);
    AddStringElement("<cþ  >[Back]</c>", CONFIRM_OPTIONS);
  }

  if (GetElementCount(DESTINATIONS) == 0)
  {
    int nNth = 1; // Note - DESTINATIONS is 0-based, but the vars are 1-based.
    string sDest = GetLocalString(OBJECT_SELF, "DEST_NAME_" + IntToString(nNth));

    while (sDest != "")
    {
      AddStringElement(sDest, DESTINATIONS);
      nNth++;
      sDest = GetLocalString(OBJECT_SELF, "DEST_NAME_" + IntToString(nNth));
    }

    AddStringElement("Nowhere, I'll stay here thankyou.", DESTINATIONS);
  }

  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<cþ  >[Done]</c>", DONE);
  }

  if (GetElementCount(TRAVEL_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Continue journey now]</c>", TRAVEL_OPTIONS);
    AddStringElement("<c þ >[Wait for next caravan]</c>", TRAVEL_OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage    = GetDlgPageString();
  object oPC      = GetPcDlgSpeaker();
  string sDestTag = GetLocalString(oPC, MICA_DESTINATION);
  object oArea    = GetLocalObject(oPC, MICA_AREA);
  string sDest    = GetName(GetArea(GetWaypointByTag(sDestTag)));

  if (sPage == "")
  {
    int nSubrace = gsSUGetSubRaceByName(GetSubRace(oPC));
    if (gsSUGetIsUnderdarker(nSubrace))
    {
      SetDlgPrompt("Argh!  Git ye awa' fram me, ya monster!");
      SetDlgResponseList(DONE);
    }
    else if (sDest != "" && GetArea(OBJECT_SELF) == oArea)
    {
      string sNextDept = "";
      int nCurrentHour = GetTimeHour();

      switch (nCurrentHour)
      {
        case 6:
        case 7:
        case 8:
          sNextDept = "at the ninth hour";
          break;
        case 9:
        case 10:
        case 11:
          sNextDept = "at noon";
          break;
        case 12:
        case 13:
        case 14:
          sNextDept = "at the fifteenth hour";
          break;
        case 15:
        case 16:
        case 17:
          sNextDept = "at the eighteenth hour";
          break;
        default:
          sNextDept = "at the sixth hour";
          break;
      }

      SetDlgPrompt("Next caravan ta " + sDest + " leaves " + sNextDept + ".  Jus' " +
      "be back 'ere afore then, aye?");
      SetDlgResponseList(DONE);
    }
    else if (GetLocalInt(oPC, MICA_TRAVELLING))
    {
      SetDlgPrompt("Ya wanna move on now?");
      SetDlgResponseList(DESTINATIONS);
    }
    else
    {
      SetDlgPrompt("'ullo there!  Ya be wantin' ta travel? I'll be takin' " +
      "ye along yer way fer jus' twenty five coins, aye?  Where ye be wantin' "+
      "ta go?\n\nWe go at six an' nine in th'mornin', or noon, or three or six"+
      " in th'evenin', reg'lar.  No sense in bein' out at night, aye.");
      SetDlgResponseList(DESTINATIONS);
    }
  }
  else if (sPage == CONFIRM_MENU)
  {
    string sDest = GetStringElement(GetLocalInt(OBJECT_SELF, SELECTION),
                                    DESTINATIONS);

    if (GetGold (oPC) > 24)
    {
      SetDlgPrompt("Ye want ta go ta " + sDest + "?  Ya sure?");
      SetDlgResponseList(CONFIRM_OPTIONS, OBJECT_SELF);
    }
    else
    {
      SetDlgPrompt("Ye don't be havin' enough coins, mate.");
      DeleteLocalInt(OBJECT_SELF, SELECTION);
      SetDlgResponseList(DONE);
    }
  }
  else if (sPage == TRAVEL_MENU)
  {
    SetDlgPrompt("Ya wanna carry on wi' yer journey now, or wait a bit?");
    SetDlgResponseList(TRAVEL_OPTIONS);
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
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (GetDlgResponseList() == DONE)
  {
    EndDlg();
  }
  else if (sPage == "")
  {
    if (selection == GetElementCount(DESTINATIONS) - 1)
    {
      EndDlg();
    }
    else
    {
      SetLocalInt(OBJECT_SELF, SELECTION, selection);
      sPage = CONFIRM_MENU;
    }
  }
  else if (sPage == CONFIRM_MENU)
  {
    switch (selection)
    {
      case 0:  // OK
      {
        int nDest = GetLocalInt(OBJECT_SELF, SELECTION) + 1; // 0-based to 1-based list
        string sTag = GetLocalString(OBJECT_SELF, "DEST_TAG_" + IntToString(nDest));
        Trace(CARAVANS, GetName(oPC) + " has paid to travel to " + sTag);
        SetLocalString(oPC, MICA_DESTINATION, sTag);
        SetLocalObject(oPC, MICA_AREA, GetArea(OBJECT_SELF));
        TakeGoldFromCreature(25, oPC, TRUE);

        if (GetLocalInt(oPC, MICA_TRAVELLING))
        {
          sPage = TRAVEL_MENU;
        }
        else
        {
          EndDlg();
        }
        break;
      }
      case 1: // Back
        sPage = "";
        break;
    }
  }
  else if (sPage == TRAVEL_MENU)
  {
    switch (selection)
    {
      case 0:  // Go now
        EndDlg();
        AssignCommand(oPC, miCADoJourney(GetLocalString(oPC, MICA_DESTINATION)));
      case 1:  // Wait
        EndDlg();
        break;
    }
  }

  SetDlgPageString(sPage);
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
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

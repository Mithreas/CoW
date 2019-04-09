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
	
  Variables on the caravan master:
    TRAVEL_TYPE - 0 = normal caravan, 1 = by sea, 2 = ranger escort
	DEST_NAME_n - the name to display for each destination.  Numbered 1 and up.
	DEST_TAG_n - the waypoint tag to teleport to for this destination.
	DEST_KEY_n - optional - require a PC to possess an item with this tag to show this option.
*/
#include "inc_zdlg"
#include "inc_subrace"
#include "inc_caravan"

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
  int bType = GetLocalInt(OBJECT_SELF, "TRAVEL_TYPE");

  // Options for confirming or canceling. These are static so we can set them
  // up once.
  if (GetElementCount(CONFIRM_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Buy ticket for 25 gold]</c>", CONFIRM_OPTIONS);
    AddStringElement("<cþ  >[Back]</c>", CONFIRM_OPTIONS);
  }

  // Always rebuild the list now that we have some locked destinations. 
  DeleteList(DESTINATIONS);
  
  int nNth = 1; // Note - DESTINATIONS is 0-based, but the vars are 1-based.
  string sDest = GetLocalString(OBJECT_SELF, "DEST_NAME_" + IntToString(nNth));

  while (sDest != "")
  {
    string sKeyTag = GetLocalString(OBJECT_SELF, "DEST_KEY_" + IntToString(nNth));
    if (sKeyTag == "" || GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), sKeyTag))) AddStringElement(sDest, DESTINATIONS);
    nNth++;
    sDest = GetLocalString(OBJECT_SELF, "DEST_NAME_" + IntToString(nNth));
  }

  AddStringElement("Nowhere, I'll stay here thankyou.", DESTINATIONS);

  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<cþ  >[Done]</c>", DONE);
  }

  if (GetElementCount(TRAVEL_OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Continue journey now]</c>", TRAVEL_OPTIONS);
    if (bType == TRAVEL_TYPE_LAND) AddStringElement("<c þ >[Wait for next caravan]</c>", TRAVEL_OPTIONS);
	if (bType == TRAVEL_TYPE_SEA) AddStringElement("<c þ >[Wait for next ship]</c>", TRAVEL_OPTIONS);
    if (bType == TRAVEL_TYPE_RANGER) AddStringElement("<c þ >[Wait for next departure]</c>", TRAVEL_OPTIONS);
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
  int nType       = GetLocalInt(OBJECT_SELF, "TRAVEL_TYPE");
  string sType    = "";
  
  if (nType == TRAVEL_TYPE_LAND) sType = "caravan";
  else if (nType == TRAVEL_TYPE_SEA) sType = "ship";
  else if (nType == TRAVEL_TYPE_RANGER) sType = "ranger";

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
       
	  if (GetRacialType (OBJECT_SELF) == RACIAL_TYPE_ELF)
	    SetDlgPrompt("The next departure to " + sDest + " leaves at " + sNextDept + ".  Be ready to depart, for we will not wait.");
	  else
        SetDlgPrompt("Next " + sType + " ta " + sDest + " leaves at " + sNextDept + ".  Jus' " +
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
	  if (nType == TRAVEL_TYPE_LAND || nType == TRAVEL_TYPE_RANGER)
	  {
	    if (GetRacialType (OBJECT_SELF) == RACIAL_TYPE_ELF)
		  SetDlgPrompt("Welcome.  I can lead you through the wilds... I will depart " +
		    "after we have given others a chance to join us, every three hours from six " +
			"in the morning to six in the evening.  We do not travel at night, for I " +
			"cannot guarantee your safety.  Should you wish to travel, let me know.");
		else 
          SetDlgPrompt("'ullo there!  Ya be wantin' ta travel? I'll be takin' " +
      "ye along yer way fer jus' twenty five coins, aye?  Where ye be wantin' "+
      "ta go?\n\nWe go at six an' nine in th'mornin', or noon, or three or six"+
      " in th'evenin', reg'lar.  No sense in bein' out at night, aye.");
      SetDlgResponseList(DESTINATIONS);
	  }
	  else if (nType == TRAVEL_TYPE_SEA)
	  {
	    if (GetRacialType(oPC) != RACIAL_TYPE_HUMAN && !GetIsObjectValid(GetItemPossessedBy(oPC, "permission_sea")))
		{
		  SpeakString("Sorry, no travelling without a certificate of seaworthiness.  Can't risk you sinking the ship.");
		  EndDlg();
		}
	    else
		{
	      SetDlgPrompt("Lookin' ta travel 'cross the sea?  Ye can book passage " +
		  "wi'me fer jus' twenty five coins.  Don't even have ta work, aye?\n\n" +
		  "We go at six an' nine in th'mornin', or noon, or three or six"+
          " in th'evenin', reg'lar.");
          SetDlgResponseList(DESTINATIONS);
		}  
	  }
    }
  }
  else if (sPage == CONFIRM_MENU)
  {
    string sDest = GetStringElement(GetLocalInt(OBJECT_SELF, SELECTION),
                                    DESTINATIONS);

    if (GetGold (oPC) > 24)
    {
	  if (GetRacialType (OBJECT_SELF) == RACIAL_TYPE_ELF)
	    SetDlgPrompt(sDest + " it is, then.");
	  else
        SetDlgPrompt("Ye want ta go ta " + sDest + "?  Ya sure?");
      SetDlgResponseList(CONFIRM_OPTIONS, OBJECT_SELF);
    }
    else
    {
	  if (GetRacialType (OBJECT_SELF) == RACIAL_TYPE_ELF)
	    SetDlgPrompt("You require 25 coins for the supplies we'll need for the journey.");
	  else
        SetDlgPrompt("Ye don't be havin' enough coins, mate.");
      DeleteLocalInt(OBJECT_SELF, SELECTION);
      SetDlgResponseList(DONE);
    }
  }
  else if (sPage == TRAVEL_MENU)
  {
	if (GetRacialType (OBJECT_SELF) == RACIAL_TYPE_ELF)
	  SetDlgPrompt("Let me know if you wish to continue.");
	else
      SetDlgPrompt("Ya wanna carry on wi' yer journey now, or wait a bit?");
    SetDlgResponseList(TRAVEL_OPTIONS);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  int bType      = GetLocalInt(OBJECT_SELF, "TRAVEL_TYPE");

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
		SetLocalInt(oPC, MICA_TYPE, bType);
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
        AssignCommand(oPC, miCADoJourney(GetLocalString(oPC, MICA_DESTINATION), bType));
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

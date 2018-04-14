/*
  zdlg_messengers

  Z-Dialog conversation script for wyvern riders

  Pages:
    Introduction and prompt
      - sure
      - no thanks
    Sure, where do you want to go?
      - locations...
      - cancel
    Here we go
      - Done


*/

#include "inc_zdlg"
#include "x0_i0_position"

const string MAINOPTIONS = "MAINOPTIONS";
const string LOCATIONOPTIONS = "LOCATIONOPTIONS";
const string DONE    = "MES_DONE";

const string PAGE_LOCATIONS = "PAGE_LOCATION";
const string PAGE_DONE    = "DONE";
const string PAGE_FAILED  = "FAILED";
const string PAGE_RIDE_FAILED  = "RIDE_FAILED";

void WyvernTransport(object oSteed, object oPC, location lDest)
{

  FloatingTextStringOnCreature("*Departs on the Wyvern*", oPC);

  effect eFly = EffectDisappearAppear(lDest);
  effect eFly2 = EffectDisappear();
  effect eFly3 = EffectAppear();
  effect eInv=EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
  DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInv, oPC, 9.0f));

  // this one doesn't work across areas for some reason, you'll end up in a mixture of both areas
  //DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly, oPC, 10.0));


  DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly, oSteed, 9.0));
  DelayCommand(2.0f, AssignCommand(oPC,JumpToLocation(lDest)));
  DelayCommand(9.9f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly3, oPC, 3.0));
  DelayCommand(10.0f, SendMessageToPC(oPC,"The Wyvern ride was rough and very dangerous, but somehow you made it to your destination."));
  DelayCommand(15.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly2, oSteed, 5.0));

}

void Init()
{
  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE);
  }

  if (GetElementCount(MAINOPTIONS) == 0)
  {
    AddStringElement("Sure", MAINOPTIONS);
    AddStringElement("No thanks <cþ  >[Leave]</c>", MAINOPTIONS);
  }

  // make sure the list of Wyvern locations is always accurate
  DeleteList(LOCATIONOPTIONS);

  if (GetElementCount(LOCATIONOPTIONS) == 0)
  {
    // determine the wyvern locations on the server

    int iDest = 0;
    object oDest = GetObjectByTag("gvd_wp_wyverndest",iDest);
    string sLocationName;
    int iLocationCost;

    while (oDest != OBJECT_INVALID) {
       
      // determine location name
      sLocationName = GetLocalString(oDest,"location");

      // determine cost of the location
      iLocationCost = GetLocalInt(oDest,"cost");

      // check is location variable is used, if not default to areaname of the destination placeable
      if ((sLocationName == "ENTER_NAME_OF_LOCATION_HERE") || (sLocationName == "")) {
        sLocationName = GetName(GetArea(oDest));
      }
 
      // default cost = 500
      if (iLocationCost == 0) iLocationCost = 500;

      // add location to list
      AddStringElement(sLocationName + " (cost: " + IntToString(iLocationCost) + " gold)", LOCATIONOPTIONS);

      // next destination
      iDest = iDest + 1;
      oDest = GetObjectByTag("gvd_wp_wyverndest",iDest);
    }

  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
      // check if the PC has at least 5 ride skill points
      if (GetSkillRank(SKILL_RIDE,oPC) >= 5) {
        SetDlgPrompt("You want me to call a Wyvern for you? It can take you to several places impossible to reach otherwise.");
        SetDlgResponseList(MAINOPTIONS);
      } else {
        SetDlgPrompt("I wouldn't trust you on the back of a rothe, let alone a Wyvern. Come back when you've learned how to ride.");
        EndDlg();
      }
  }
  else if (sPage == PAGE_LOCATIONS)
  {
    SetDlgPrompt("Alright, where do you want to go?");
    SetDlgResponseList(LOCATIONOPTIONS);
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgPrompt("Take a seat and hold tight!");
    SetDlgResponseList(DONE);
  }
  else if (sPage == PAGE_FAILED)
  {
    SetDlgPrompt("Leave if you don't have money for my services or I'll have the Wyverns feed you to the hatchlings!");
    SetDlgResponseList(DONE);
  }
  else if (sPage == PAGE_RIDE_FAILED)
  {
    SetDlgPrompt("That destination is difficult to reach even for a Wyvern, your ride skills are not sufficient for this.");
    SetDlgResponseList(DONE);
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
        // go someplace
        SetDlgPageString(PAGE_LOCATIONS);
        break;
      case 1:
        // leave
        EndDlg();
        break;
    }

  } else if (sPage == PAGE_LOCATIONS) {
    // PC wants to go someplace

    object oDest = GetObjectByTag("gvd_wp_wyverndest",selection);

    // check if PC has enough ride skill to go to selected destination, default: 5
    int iRideDC = GetLocalInt(oDest,"ride_dc");
    if (iRideDC == 0) iRideDC = 5;

    if (GetSkillRank(SKILL_RIDE, oPC) >= iRideDC) {
      // ride skill passed

      // check if he has enough gold, default: 500
      int iLocationCost = GetLocalInt(oDest,"cost");
      if (iLocationCost == 0) iLocationCost = 500;

      if (GetGold(oPC) < iLocationCost) {
        SetDlgPageString(PAGE_FAILED);
      } else {
         // get gold from PC
         TakeGoldFromCreature(iLocationCost, oPC, TRUE);

         // remember where the PC wants to go
         SetLocalInt(oPC,"wyvernrider_selection",selection);

         SetDlgPageString(PAGE_DONE);

      }
    } else {
      // ride skill failed
      SetDlgPageString(PAGE_RIDE_FAILED);

    }

  } else {
    // The Done response list has only one option, to end the conversation.

    // check if there was a payment
    if (sPage == PAGE_DONE) {
      // yes, let's go
      object oDest = GetObjectByTag("gvd_wp_wyverndest",GetLocalInt(oPC,"wyvernrider_selection"));
      location lDest = GetLocation(oDest);
      DeleteLocalInt(oPC,"wyvernrider_selection");

      // have a Wyvern appear and then fly off to and land at destination
      SpeakString("*whistles sharply, a moment later one of the Wyverns lands near you*");
      //vector vNearPC = GetChangedPosition(GetPosition(oPC), 1.0f, GetFacing(oPC));
      //location lNearPC = Location(GetArea(oPC), vNearPC, GetFacing(oPC));

      object oSteed = CreateObject(OBJECT_TYPE_CREATURE, "gvd_wyvernsteed", GetLocation(GetObjectByTag("gvd_wyvern_takeoff")), 1);
      DelayCommand(3.0f, WyvernTransport(oSteed, oPC, lDest));

    } else {
      // nope, let's stay right here.
    }

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

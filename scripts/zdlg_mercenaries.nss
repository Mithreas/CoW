/*
  Name: zdlg_mercenaries
  Author: Mithreas
  Date: Apr 14 2006
  Description: Mercenary hire conversation script. Uses Z-Dialog.

  Mercenary captains need:
  conversation: zdlg_converse
  variables:
    dialog: zdlg_mercenaries
    description: A description of the band.
    resref: the resref of the mercenary soldiers to deploy
    cost: the cost of each mercenary

  Then set up mercenaries for each faction with tag and resref set to:
  resref_2 - Drannis mercenaries
  resref_3 - Erenia mercenaries
  resref_4 - Renerrin mercenaries
  resref_5 - Shadow mercenaries
  resref_6 - Vyvian mercenaries
  resref_7 - Fernvale mercenaries
  resref_8 - Airevorn mercenaries

  Make sure you assign the copies of the mercenaries to the correct faction!
  You should also use House colours, too, for easy identification.

*/
#include "inc_zdlg"
#include "inc_resource"
 // includes inc_reputation, inc_crime, inc_log and inc_database
#include "inc_perspeople"
 // includes inc_log, inc_database and pg_lists_i
#include "nw_i0_generic"
const string MERC         = "MERCENARIES"; // For logging
const string MERC_WP_TAG  = "merc_spawn";
const string MERC_WP_LIST = "merc_wps";
const string VALID_WAYPOINTS = "valid_wps";
// Replies
const string MAIN_MENU = "mrc_main_options";
const string REPLY_1   = "reply_1";
const string REPLY_2   = "reply_2";
const string REPLY_3   = "reply_3";
const string REPLY_4   = "reply_4";
const string REPLY_5   = "reply_5";
// Pages
const string ABOUT     = "about";
const string HOW_MANY  = "how_many";
const string WHERE     = "where";

// Variables on the merc captain
const string DESCRIPTION = "description";
const string RESREF      = "resref";
const string COST        = "cost";
const string NUM_HIRED   = "num_hired";

void Init()
{
  // Set up the list of mercenary spawn waypoints.
  DeleteList(MERC_WP_LIST);
  int iCount = 0;
  object oWaypoint = GetObjectByTag(MERC_WP_TAG, iCount);

  while (GetIsObjectValid(oWaypoint))
  {
    AddObjectElement(oWaypoint, MERC_WP_LIST);

    iCount ++;
    oWaypoint = GetObjectByTag(MERC_WP_TAG, iCount);
  }

  // PC responses to greeting.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Yes, I am. Tell me about your band.", MAIN_MENU);
    AddStringElement("Not at the moment.",
                     MAIN_MENU);
  }

  // Replies to the description of the mercenary band
  if (GetElementCount(REPLY_1) == 0)
  {
    AddStringElement("Sounds good. I'll hire you.", REPLY_1);
    AddStringElement("Not quite what I'm looking for.", REPLY_1);
  }

  // Pick how many mercenaries you want.
  if (GetElementCount(REPLY_2) == 0)
  {
    AddStringElement("One.", REPLY_2);
    AddStringElement("Two.", REPLY_2);
    AddStringElement("Five.", REPLY_2);
    AddStringElement("Ten.", REPLY_2);
    AddStringElement("On second thoughts, none.", REPLY_2);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  int bElf     = GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELF;
  int bEnt     = GetRacialType(OBJECT_SELF) == RACIAL_TYPE_CONSTRUCT;
  
  if (sPage == "")
  {
    string sPrompt = "Solkin watch over you, sir. Are you looking to hire?";
	if (bElf) sPrompt = "I can deploy rangers to watch over our claims in the wilderness, if you can cover their supply costs.";
	if (bEnt) sPrompt = "The trees cry out for revenge for their slain comrades.  We would be led to war, were you to wish it.";
  
    SetDlgPrompt(sPrompt);
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == DESCRIPTION)
  {
    SetDlgPrompt(GetLocalString(OBJECT_SELF, DESCRIPTION));
    SetDlgResponseList(REPLY_1, OBJECT_SELF);
  }
  else if (sPage == HOW_MANY)
  {
    int nCost = GetLocalInt(OBJECT_SELF, COST);
    SetDlgPrompt(bElf ? "You will need to indicate how many of my Rangers you wish to supply.  Each will need " + IntToString(nCost) + " for supplies." : 
	                    "How many of my band do you want? The cost will be " + IntToString(nCost) + " for each man I send.");
    SetDlgResponseList(REPLY_2, OBJECT_SELF);
  }
  else if (sPage == WHERE)
  {
    int nNum = GetLocalInt(OBJECT_SELF, NUM_HIRED);
    int nCost = GetLocalInt(OBJECT_SELF, COST);
    int nTotalCost = nNum * nCost;

    SetDlgPrompt(bElf ? 
	             "That's "+IntToString(nNum)+" rangers for a total cost of "+
                 IntToString(nTotalCost)+".  I assume you have a location in mind " +
				 "for them to ward.  Somewhere of value that you have claimed for our people."
	             :
	             "That's "+IntToString(nNum)+" of my band for a total cost of "+
                 IntToString(nTotalCost)+". Where shall I send them?\n\n"+
                 "(I will only send my men to guard a location for your House. "+
                 "They won't attack an area for you.)");

    // Where do you want to deploy your mercenaries? Only allow options that are
    // in places owned by the PC's faction.
    DeleteList(REPLY_3);
    DeleteList(VALID_WAYPOINTS);

    AddStringElement("Cancel", REPLY_3);

    int iCount = 0;
    object oWP = GetFirstObjectElement(MERC_WP_LIST);
    while (GetIsObjectValid(oWP))
    {
      string sName = GetName(oWP);
      Trace(MERC, "Found waypoint: "+sName);

      if (GetPCFactionOwnsArea(oPC, GetArea(oWP)))
      {
        AddStringElement(sName, REPLY_3);
        AddObjectElement(oWP, VALID_WAYPOINTS);
      }

      oWP = GetNextObjectElement();
    }

    SetDlgResponseList(REPLY_3, OBJECT_SELF);
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
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  { //Main page. Options are to find out more about the band, or end.
    switch (selection)
    {
      case 0:
        SetDlgPageString(DESCRIPTION);
        break;
      case 1:
        EndDlg();
        break;
    }
  }
  else if (sPage == DESCRIPTION)
  { // Description. Options are to hire, or end.
    switch (selection)
    {
      case 0:
        SetDlgPageString(HOW_MANY);
        break;
      case 1:
        EndDlg();
        break;
    }
  }
  else if (sPage == HOW_MANY)
  { // Options are 1, 2, 5, 10 and cancel.
    DeleteLocalInt(OBJECT_SELF, NUM_HIRED);
    switch (selection)
    {
      case 0:
        SetLocalInt(OBJECT_SELF, NUM_HIRED, 1);
        SetDlgPageString(WHERE);
        break;
      case 1:
        SetLocalInt(OBJECT_SELF, NUM_HIRED, 2);
        SetDlgPageString(WHERE);
        break;
      case 2:
        SetLocalInt(OBJECT_SELF, NUM_HIRED, 5);
        SetDlgPageString(WHERE);
        break;
      case 3:
        SetLocalInt(OBJECT_SELF, NUM_HIRED, 10);
        SetDlgPageString(WHERE);
        break;
      case 4:
        EndDlg();
        break;
    }
  }
  else if (sPage == WHERE)
  {
    switch (selection)
    { // Options are cancel, or a waypoint.
      case 0:
        EndDlg();
        break;
      default:
      {
        // Get the waypoint out of the list. The selection is 1 higher than the
        // index of the waypoint in the list, because we've got the cancel
        // option.
        object oWP = GetObjectElement(selection - 1, VALID_WAYPOINTS);
        int nNumMercs = GetLocalInt(OBJECT_SELF, NUM_HIRED);
        string sResRef = GetLocalString(OBJECT_SELF, RESREF);
		int nFaction = miBAGetBackground(GetPCSpeaker());
        int nCost = GetLocalInt(OBJECT_SELF, COST);
        int nTotalCost = nNumMercs * nCost;

        if (sResRef == "")
        {
          SendMessageToPC(GetPCSpeaker(), "((This merc captain isn't set up "
           + "correctly. Missing resref. Please report this message.))");
        }
        else if (!GetIsObjectValid(oWP) || (nNumMercs == 0))
        {
          SendMessageToPC(GetPCSpeaker(), "((Sorry, an error occurred. "
           + "Please report this message.))");
        }
        else if (GetGold(GetPCSpeaker()) < nTotalCost)
        {
          SendMessageToPC(GetPCSpeaker(), "((Sorry, you don't have enough gold))");
        }
        else if (!GetPCFactionOwnsArea(GetPCSpeaker(), GetArea(oWP)) )
        {
          SendMessageToPC(GetPCSpeaker(), "Your faction must own an area "
           + "before you can assign mercenaries there!");
        }
        else
        {
          TakeGoldFromCreature(nTotalCost,GetPCSpeaker());

          int nRepPoints = nTotalCost/1500;
          if (nRepPoints == 0) nRepPoints = 1;
          GiveRepPoints(oPC, nRepPoints, nFaction);

          sResRef = sResRef + "_" + IntToString(nFaction);
          int nCount = 0;
          while (nCount < nNumMercs)
          {
            object oNPC = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oWP));
			SetLocalObject(oNPC, "HOME_WP", oWP);
            AddPersistentPerson(oWP, sResRef);
            nCount++;
          }

          SpeakString("It is done. Your mercenaries will be in place shortly.");
        }
        EndDlg();
        break;
      }
    }
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
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

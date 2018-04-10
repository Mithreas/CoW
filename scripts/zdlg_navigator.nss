#include "zdlg_include_i"
#include "zzdlg_color_inc"
#include "ar_sys_ship"
#include "mi_inc_factions"
#include "gvd_inc_contain"

const string PRE_SELECTIONS = "PRE_SELECTIONS";
const string MAIN_SELECTIONS = "MAIN_SELECTIONS";
const string DEST_SELECTIONS = "DEST_SELECTIONS";
const string SEARCH_SELECTIONS = "SEARCH_SELECTIONS";

object oShip = GetArea(OBJECT_SELF);

//::  Wraps code for the pre selections.
void DoPreSelection(int nSelection);
//::  Wraps code for the root/main selections.
void DoRootSelection(int nSelection);
//::  Wraps code for the Destinations selections
void DoDestinationSelections(int nSelection);
//::  Adds specific ship commands based on the oShip's variables.
void AddSpecificShipCommands();
//::  Does the specific ship commands
void DoSpecificShipCommands();


void Init()
{
    object oPC = GetPcDlgSpeaker();

    //::  Show pre selections only if Rayne's Landing is open
    if (GetIsRayneOpen() && GetShipDestination(oShip) != "Rayne's Landing")
        SetDlgPageString("pre");
    //::  Else default
    else
        SetDlgPageString("root");

    //::  Removes all previous elements, we do this so we can setup MAIN_SELECTIONS differently
    RemoveElements(0, GetElementCount(MAIN_SELECTIONS), MAIN_SELECTIONS, OBJECT_SELF);
    //::  Not sure if this line is needed
    //RemoveElements(0, GetElementCount(DEST_SELECTIONS), DEST_SELECTIONS, OBJECT_SELF);

    if (GetElementCount(PRE_SELECTIONS) == 0)
    {
        AddStringElement("Yes.  Take us to Rayne's Landing.", PRE_SELECTIONS);
        AddStringElement("No.  I have other orders.", PRE_SELECTIONS);
    }

    if (GetElementCount(MAIN_SELECTIONS) == 0)
    {
        //::  Ship is pirating, has a target and the grapple mechanism.  We can engage it.
        if (IsShipPirating(oShip) && GetHasShipTarget(oShip))
        {
            int bTargetGrappled = GetIsGrappled(GetTargetShip(oShip));
            int bAttacking = GetShipUnderAttack(oShip);

            //::  Target ship grappled
            if (bTargetGrappled && bAttacking)
            {
                AddStringElement("Yes. Let her go.", MAIN_SELECTIONS);
                AddStringElement("No, I want to board her. I'll speak with the Boatswain.", MAIN_SELECTIONS);
            }
            else
            {
                AddStringElement("Aye, get us as close as you can.", MAIN_SELECTIONS);
                AddStringElement("I think it might be a bad idea. Leave her and keep hunting elsewhere.", MAIN_SELECTIONS);
            }
        }
        //::  Default
        else
        {
            AddStringElement("Yes.", MAIN_SELECTIONS);
            AddStringElement(txtRed + "[Done]</c>", MAIN_SELECTIONS);
        }
    }

    if (GetElementCount(DEST_SELECTIONS) == 0)
    {
      if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
      {
        AddStringElement("<c _ >[Set sail for Sibayad]</c>", DEST_SELECTIONS);
        AddStringElement("<c _ >[Set sail for Fort Cordor]</c>", DEST_SELECTIONS);
        AddStringElement("<c _ >[Set sail for Smugglers' Port]</c>", DEST_SELECTIONS);
      }
      else
      {
        AddStringElement("<c þ >[Set sail for the Crows Nest]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Cordor]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Wharftown]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Guldorand]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Brogendenstein]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for the Blackfin Rock]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for the Skull Crags]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for the Red Dragon Isle]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Sencliff]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for the Island Ruins]</c>", DEST_SELECTIONS);
        AddStringElement("<c þ >[Set sail for Sibayad]</c>", DEST_SELECTIONS);
      }

      AddSpecificShipCommands();

      AddStringElement("Head to open water and scour the seas!", DEST_SELECTIONS);
      AddStringElement("Nowhere just put out to sea and await my orders.", DEST_SELECTIONS);
      AddStringElement("Actually maintain our current status.", DEST_SELECTIONS);
    }

    if (GetElementCount(SEARCH_SELECTIONS) == 0)
    {
        AddStringElement("Search for the Sea Leopard.", SEARCH_SELECTIONS);
        AddStringElement("Search for the Penny Rose.", SEARCH_SELECTIONS);
        AddStringElement("Search for the Troubadour.", SEARCH_SELECTIONS);
        if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) AddStringElement("Search for the Timberfleet.", SEARCH_SELECTIONS);
        if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) AddStringElement("Search for the Warship.", SEARCH_SELECTIONS);
        if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) AddStringElement("Search for the Liberator.", SEARCH_SELECTIONS);
        if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) AddStringElement("Search for the Dreadnought.", SEARCH_SELECTIONS);
        AddStringElement("No, we're only after pirates.", SEARCH_SELECTIONS);
        AddStringElement(txtRed + "[Done]</c>", SEARCH_SELECTIONS);
    }
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage      = GetDlgPageString();
    object oPC        = GetPcDlgSpeaker();

    object oQuarter   = GetArea(OBJECT_SELF);
    int bOwner        = gsQUGetIsOwner(oQuarter, oPC);
    int bAccess       = gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter));

    //::  Only owner, players with a key or a DM can interact with the ship. Key no longer. Now they need the power
    if (bAccess || bOwner || md_GetHasPowerShop(MD_PR2_CAP, oPC, md_SHLoadFacID(oQuarter), "2") || GetIsDM(oPC))
    {
        //:: Display Conversation
        //::  Pre
        if (sPage == "pre")
        {
            int bTargetGrappled = GetIsGrappled(GetTargetShip(oShip));

            //::  If we are grappled, we can't move (ie no new orders).
            if (GetIsGrappled(oShip))
            {
                SetDlgPrompt("We have been grappled by another ship and cannot move!");
                return;
            }
            //::  We have a target
            else if (IsShipPirating(oShip) && GetHasShipTarget(oShip))
            {
                if (bTargetGrappled)
                    SetDlgPrompt("We're grappled on to <c þ >" + GetTargetShipName(oShip) + "</c>, do you want us to set 'em free?");
                else
                    SetDlgPrompt("SHIP AHOY! It's the <c þ >" + GetTargetShipName(oShip) + "</c>. You want to attempt boarding?");

                SetDlgPageString("root");
                SetDlgResponseList(MAIN_SELECTIONS);
            }
            //::  Rayne's Landing Lighthouse is activated
            else
            {
                //::  UD Vessel out of fuel?
                if ( GetIsUDVessel(oShip) && GetDreadCoalStorage() <= 0)
                {
                    SetDlgPrompt("The Lighthouse at Rayne's Landing is shining.  However the vessel is out of fuel.  We can go nowhere.");
                    return;
                }

                SetDlgPrompt("The Lighthouse at Rayne's Landing is shining, do you wish to set sail?");
                SetDlgResponseList(PRE_SELECTIONS);
                return;
            }
        }
        //::  Root
        else if (sPage == "root")
        {
            int bTargetGrappled = GetIsGrappled(GetTargetShip(oShip));

            //::  If we are grappled, we can't move (ie no new orders).
            if (GetIsGrappled(oShip))
            {
                SetDlgPrompt("We have been grappled by another ship and cannot move!");
                return;
            }
            //::  We have a target
            else if (IsShipPirating(oShip) && GetHasShipTarget(oShip))
            {
                if (bTargetGrappled)
                    SetDlgPrompt("We're grappled on to <c þ >" + GetTargetShipName(oShip) + "</c>, do you want us to set 'em free?");
                else
                    SetDlgPrompt("SHIP AHOY! It's the <c þ >" + GetTargetShipName(oShip) + "</c>. You want to attempt boarding?");
            }
            //::  UD Vessel out of fuel
            else if ( GetIsUDVessel(oShip) && GetDreadCoalStorage() <= 0)
            {
                SetDlgPrompt("We are out of fuel and need more coal to get her running again.");
                return;
            }
            else {
                string sSuffixRent = "";
                //::  Display extra information for rentable ships
                if ( GetIsShipRentable(oShip) ) {
                    int nTimeLeft = GetShipRentTimeout(oShip) - GetShipCurrentRentTimer(oShip);

                    sSuffixRent = "The ship rental will expire in " + txtSilver + IntToString(nTimeLeft) + (nTimeLeft <= 1 ? "</c> hour." : "</c> hours.");
                    sSuffixRent += "\n";
                }

                SetDlgPrompt(sSuffixRent + "We're currently " + GetShipStatus(oShip) + ". You want a new course?");
            }

            SetDlgResponseList(MAIN_SELECTIONS);
        }
        //::  Destinations
        else if (sPage == "dest")
        {
            SetDlgPrompt("Where do you want to go?");
            SetDlgResponseList(DEST_SELECTIONS);
        }
        //::  Searching (Flagship only)
        else if (sPage == "search")
        {
            SetDlgPrompt("Any particular ship you want us to find?");
            SetDlgResponseList(SEARCH_SELECTIONS);
        }
        else
        {
            SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
        }
    }
    else
        SetDlgPrompt("I only take orders from Captain n' Crew, and you're neither...");

}

void HandleSelection()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    int nSelection  = GetDlgSelection();
    object oPC      = GetPcDlgSpeaker();

    //::  Pre (When Rayne's Landing is open)
    if (sPage == "pre")
    {
        DoPreSelection(nSelection);
    }
    //::  Root
    else if (sPage == "root")
    {
        DoRootSelection(nSelection);
    }
    //::  Destinations
    else if (sPage == "dest")
    {
        DoDestinationSelections(nSelection);
    }
    //::  Search
    else if (sPage == "search")
    {
        if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nSelection > 2) nSelection += 4;

        switch (nSelection)
        {
            case 0:             //::  The Sea Leopard
                ar_SearchForSpecificShip(oShip, "Sea Leopard");
                EndDlg();
                break;

            case 1:             //::  The Penny Rose
                ar_SearchForSpecificShip(oShip, "Penny Rose");
                EndDlg();
                break;

            case 2:             //::  The Troubadour
                ar_SearchForSpecificShip(oShip, "Troubadour");
                EndDlg();
                break;

            case 3:             //::  The Timberfleet
                ar_SearchForSpecificShip(oShip, "Timberfleet");
                EndDlg();
                break;

            case 4:             //::  The Warship
                ar_SearchForSpecificShip(oShip, "Warship");
                EndDlg();
                break;

            case 5:             //::  The Liberator
                ar_SearchForSpecificShip(oShip, "Liberator");
                EndDlg();
                break;

            case 6:             //::  The Dreadnought
                ar_SearchForSpecificShip(oShip, "Dreadnought");
                EndDlg();
                break;

            case 7:             //::  Search NPC Pirates
                ar_DoPirating(oShip);
                SetLocalString(oShip, AR_SEARCH_TARGET, "NPC");

                if (GetShipDestination(oShip) == "")
                    SetShipStatus(oShip, "at sea looking for other vessels");
                else
                    SetShipDestinationStatus(oShip);

                EndDlg();
                break;

            case 8:
                EndDlg();
                break;
        }
    }
}

void main()
{
    // Don't you dare!!
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

void DoPreSelection(int nSelection)
{
    switch (nSelection)
    {
        case 0:
            //::  UD Vessel out of fuel?
            if ( GetIsUDVessel(oShip) && GetDreadCoalStorage() <= 0)
            {
                DoNavigatorMessage(oShip, "We are out of fuel!");
                EndDlg();
                return;
            }

            ar_DoVoyage(oShip, "Rayne's Landing", "AR_DOCK_RAYNE");
            EndDlg();
            break;

        case 1:
            SetDlgPageString("root");
            break;
    }
}

void DoRootSelection(int nSelection)
{
    if (IsShipPirating(oShip) && GetHasShipTarget(oShip))
    {
        int bTargetGrappled = GetIsGrappled(GetTargetShip(oShip));

        switch (nSelection)
        {
            case 0:
                ar_DoGrappleOnTarget(oShip, bTargetGrappled);
                EndDlg();
                break;

            case 1:
                if (!bTargetGrappled) SetDlgPageString("dest");
                else  EndDlg();
                break;
        }
    }
    else
    {
        switch (nSelection)
        {
            case 0:
                SetDlgPageString("dest");
                break;

            case 1:
                EndDlg();
                break;
        }
    }
}

void DoDestinationSelections(int nSelection)
{
    int bPirate = GetCanShipPirate(oShip);
    int bSearch = GetCanShipSearch(oShip);
    int bRayne  = !GetLocalInt(GetModule(), "STATIC_LEVEL") && GetCanShipRayne(oShip);
    int bFish   = GetCanShipFish(oShip);
    int bUD     = GetIsUDVessel(oShip);
    int nSub    = 0;
    int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

    //::  If the ship can ONLY pirate then we need to adjust the selections here.
    if (bPirate && !bSearch && !bRayne && !bFish && !bUD) nSub = 1;

    if (nSelection == 0) { ar_DoVoyage(oShip, bStaticLevel ? "Sibayad" : "Crows Nest", "AR_DOCK_CROW");         EndDlg(); return; }
    if (nSelection == 1) { ar_DoVoyage(oShip, bStaticLevel ? "Fort Cordor" : "Cordor", "AR_DOCK_CORDOR");       EndDlg(); return; }
    if (nSelection == 2) { ar_DoVoyage(oShip, bStaticLevel ? "Smugglers' Port" : "Wharftown", "AR_DOCK_WHARF"); EndDlg(); return; }

    // FL server only has three destinations.  Skip the other options.
    if (bStaticLevel) nSelection += 8;

    if (nSelection == 3) { ar_DoVoyage(oShip, "Guldorand", "AR_DOCK_GULD");         EndDlg(); return; }
    if (nSelection == 4) { ar_DoVoyage(oShip, "Brogendenstein", "AR_DOCK_BROG");    EndDlg(); return; }
    if (nSelection == 5) { ar_DoVoyage(oShip, "Blackfin Rock", "AR_DOCK_SHARK");    EndDlg(); return; }
    if (nSelection == 6) { ar_DoVoyage(oShip, "Skull Crags", "AR_DOCK_CRAG");       EndDlg(); return; }
    if (nSelection == 7) { ar_DoVoyage(oShip, "Red Dragon Isle", "AR_DOCK_RED");    EndDlg(); return; }
    if (nSelection == 8) { ar_DoVoyage(oShip, "Sencliff", "AR_DOCK_SENCLIFF");      EndDlg(); return; }
    if (nSelection == 9) { ar_DoVoyage(oShip, "Island Ruins", "AR_DOCK_RUINS");     EndDlg(); return; }
    if (nSelection == 10){ ar_DoVoyage(oShip, "Sibayad", "AR_DOCK_SIBA");           EndDlg(); return; }
    //::  Only do Specific Ship Command option if we have any other skill but the Pirate one.
    if (nSelection == 11 && nSub == 0) { DoSpecificShipCommands(); return; }
    //::  ADDED:  New option for all ships, to search for 'other' targets.  Pirate vessels use this as well to search for NPC/PC ships.
    if (nSelection == (12-nSub)) { ar_DoPirating(oShip);                            EndDlg(); return; }
    if (nSelection == (13-nSub)) { ar_DoVoyage(oShip, "", "");                      EndDlg(); return; }
    if (nSelection == (14-nSub)) { EndDlg(); return; }
}

void AddSpecificShipCommands()
{
    //::  ADDED:  All ships are given the "pirate option" but only those ships that actually can pirate can do so still
    //::          The other ships will search for the 'other' targets.
    //if      (GetCanShipPirate(oShip))    AddStringElement("It's a pirates life for us.  Head to open water and find me a ship to board!", DEST_SELECTIONS);
    if (GetCanShipSearch(oShip))         AddStringElement("I want to go pirate hunting.", DEST_SELECTIONS);
    else if (!GetLocalInt(GetModule(), "STATIC_LEVEL") && GetCanShipRayne(oShip))     AddStringElement("<c þ >[Set sail for the Rayne's Landing]</c>", DEST_SELECTIONS);
    else if (GetIsUDVessel(oShip))       AddStringElement("<c þ >[Set sail for the Underdark]</c>", DEST_SELECTIONS);
    else if (GetCanShipFish(oShip))      AddStringElement("Lower the nets, time to fish!", DEST_SELECTIONS);
}

void DoSpecificShipCommands()
{
    /*
    if (GetCanShipPirate(oShip))
    {
        ar_DoPirating(oShip);
        EndDlg();
    }
    */
    if (GetCanShipSearch(oShip))
    {
        SetDlgPageString("search");
    }
    else if (!GetLocalInt(GetModule(), "STATIC_LEVEL") && GetCanShipRayne(oShip))
    {
        ar_DoVoyage(oShip, "Rayne's Landing", "AR_DOCK_RAYNE");
        EndDlg();
    }
    else if (GetIsUDVessel(oShip))
    {
        ar_DoVoyage(oShip, "Gnomish Shipyard", "AR_DOCK_UD");
        EndDlg();
    }
    else if (GetCanShipFish(oShip))
    {
        ar_DoFishing(oShip, TRUE);
        EndDlg();
    }
}

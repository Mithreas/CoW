#include "gs_inc_quarter"
#include "zdlg_include_i"
#include "zzdlg_color_inc"
#include "ar_sys_ship"
#include "mi_inc_factions"
#include "gvd_inc_contain"

const string ANCHOR_SELECTIONS = "ANCHOR_SELECTIONS";
const string ATTACK_SELECTIONS = "ATTACK_SELECTIONS";


void Init()
{
    object oPC   = GetPcDlgSpeaker();
    object oShip = GetArea(OBJECT_SELF);
    string sTag  = GetLocalString(OBJECT_SELF, "AR_SHP_PARENT");
    int bRow     = FALSE;

    //::  If Rowboat or ladder, adjust convo acording to rowboat/ladder instead of boatswain
    if ( sTag != "")
    {
        oShip = GetObjectByTag(sTag);
        bRow  = TRUE;
    }

    //::  Removes all previous elements, we do this so we can setup ANCHOR_SELECTIONS differently
    RemoveElements(0, GetElementCount(ANCHOR_SELECTIONS), ANCHOR_SELECTIONS, OBJECT_SELF);
    //RemoveElements(0, GetElementCount(ATTACK_SELECTIONS), ATTACK_SELECTIONS, OBJECT_SELF);

    if (GetElementCount(ANCHOR_SELECTIONS) == 0)
    {
        if (bRow)
        {
            AddStringElement("<c þ >[Board]</c>", ANCHOR_SELECTIONS);
            AddStringElement("<c þ >[Board Party]</c>", ANCHOR_SELECTIONS);
            AddStringElement(txtRed + "[Done]</c>", ANCHOR_SELECTIONS);
        }
        else
        {
            AddStringElement("Yes, lower the skiff.", ANCHOR_SELECTIONS);
            AddStringElement("No thanks, I'll stay here.", ANCHOR_SELECTIONS);
        }
    }

    //::  NOTE:   !bRow &&   was removed from  if-statement below
    if (GetElementCount(ATTACK_SELECTIONS) == 0)
    {
        AddStringElement("Best I stay here to guard this one.", ATTACK_SELECTIONS);
        AddStringElement("Take me across!", ATTACK_SELECTIONS);
        AddStringElement("Send us all over!", ATTACK_SELECTIONS);
    }
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage      = GetDlgPageString();
    object oShip      = GetArea(OBJECT_SELF);
    object oPC        = GetPcDlgSpeaker();

    int bAtSea          = IsShipAtSea(oShip);
    int bUnderAttack    = GetShipUnderAttack(oShip);
    int bRow            = FALSE;
    int bForce          = FALSE;
    string sTag         = GetLocalString(OBJECT_SELF, "AR_SHP_PARENT");

    //::  If Rowboat or ladder, adjust convo acording to rowboat/ladder instead of boatswain
    if (sTag != "")
    {
        oShip = GetObjectByTag(sTag);
        bRow = TRUE;
    }
    //::  But if we are on the ship talking to boatswain
    else if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
    {
        bForce = TRUE;
        sTag = GetTag(oShip);
    }



    //::  Check quarter access
    object oQuarter   = GetObjectByTag(sTag);
    int bOwner        = gsQUGetIsOwner(oQuarter, oPC);
    int bAccess       = gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) || md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2");

    if (bOwner || bAccess || bForce)
    {
        //::  Added 31st Oct:  We need to update the quarter's status as well!  Bad miss there.
        //::  But only for non-rentable ships
        if ( bOwner && !GetIsShipRentable(oShip) )
        {
            gsQUTouchWithNotification(oQuarter, oPC);
        }

        //:: Display Conversation
        //::  Rowboat / Ladder
        if (bRow && (bOwner || bAccess))
        {
            SetDlgPrompt("Would you like to board the <c þ >" + GetShipName(oShip) + "</c>?");
            SetDlgResponseList(ANCHOR_SELECTIONS);
            SetDlgPageInt(3);
        }
        //::  At Sea
        else if ( bAtSea && !bUnderAttack )
        {
            SetDlgPrompt("We're at sea mate, there's nowhere to go.");
            SetDlgPageInt(0);
        }
        //::  Anchored
        else if ( !bAtSea )
        {
            SetDlgPrompt("We're anchored just off <c þ >" + GetShipDestination(oShip) + "</c>. You want to go across?");
            SetDlgResponseList(ANCHOR_SELECTIONS);
            SetDlgPageInt(1);
        }
        //::  Attack
        else if ( bUnderAttack && (bOwner || bAccess) )
        {
            int bGrappled       = GetIsGrappled( oShip );
            int bTargetGrappled = GetIsGrappled( GetTargetShip(oShip) );

            //::  If we are not grappled we can attack, but if target ship is grappled we can also attack to work around dead-lock.
            if (!bGrappled || bTargetGrappled)
            {
                //::  Target ship is a player ship
                if ( GetIsObjectValid(GetTargetShip(oShip)) )
                {
                    SetDlgPrompt("We're alongside the <c þ >" + GetTargetShipName(oShip) + "</c> and ready to board mate.");
                    SetDlgResponseList(ATTACK_SELECTIONS);
                    SetDlgPageInt(2);
                }
                //::  Else we have encountered an NPC ship or an 'other' target.
                else
                {
                    SetDlgPrompt(ar_GetTargetTypeMsg(oShip));
                    SetDlgResponseList(ATTACK_SELECTIONS);
                    SetDlgPageInt(2);
                }
            }
            //::  If we are the grappled target
            else
            {
                SetDlgPrompt("We're at sea mate, there's nowhere to go.");
            }
        }
        else
        {
            SetDlgPrompt("Oi!  Git out of me way mate!");
            //SendMessageToPC(oPC, "Oops!  You found a bug.  Please report it.");
        }
    }
    else
    {
        SetDlgPrompt("You don't have the means to access the <c þ >" + GetShipName(oShip) + "</c>!");
    }
}

void HandleSelection()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    int nSelection  = GetDlgSelection();
    object oPC      = GetPcDlgSpeaker();
    object oShip    = GetArea(OBJECT_SELF);
    string sTag     = GetLocalString(OBJECT_SELF, "AR_SHP_PARENT");

    //::  If Rowboat or ladder, adjust convo acording to rowboat/ladder instead of boatswain
    if ( sTag != "")
    {
        oShip = GetObjectByTag(sTag);
    }


    //::  Anchored
    if (GetDlgPageInt() == 1)
    {
        switch (nSelection)
        {
            case 0:
                ar_DockBoardPlayer(oShip, oPC, TRUE);
                EndDlg();
                break;

            case 1:
                EndDlg();
                break;
        }
    }
    //::  Attack
    else if (GetDlgPageInt() == 2)
    {
        switch (nSelection)
        {
            case 0:
                EndDlg();
                break;

            case 1:
                if ( GetIsObjectValid(GetTargetShip(oShip)) ) ar_BoardTargetShip(oShip, oPC, TRUE);
                else ar_BoardNPCShip(oShip, oPC, TRUE);
                EndDlg();
                break;

            //::  Added 31st Oct: Option to take across party as well.
            case 2:
                if ( GetIsObjectValid(GetTargetShip(oShip)) ) ar_BoardTargetShip(oShip, oPC, TRUE, TRUE);
                else ar_BoardNPCShip(oShip, oPC, TRUE, TRUE);
                EndDlg();
                break;
        }
    }
    //::  Rowboat / Ladder
    else if (GetDlgPageInt() == 3)
    {
        int bTargetGrappled = GetIsGrappled( GetTargetShip(oShip) );

        switch (nSelection)
        {
            case 0:
                if ( bTargetGrappled ) ar_BoardTargetShip(oShip, oPC, FALSE, FALSE);
                else ar_DockBoardPlayer(oShip, oPC, FALSE, FALSE);
                EndDlg();
                break;

            case 1:
                if ( bTargetGrappled ) ar_BoardTargetShip(oShip, oPC, FALSE, TRUE);
                else ar_DockBoardPlayer(oShip, oPC, FALSE, TRUE);
                EndDlg();
                break;

            case 2:
                EndDlg();
                break;
        }
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

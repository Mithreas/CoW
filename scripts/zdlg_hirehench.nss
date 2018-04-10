#include "gs_inc_quarter"
#include "zdlg_include_i"
#include "zzdlg_color_inc"
#include "ar_sys_hench"

const string ROOT_SELECTIONS    = "ROOT_SELECTIONS";
const string INFO_SELECTION     = "INFO_SELECTION";
const string RETURN_SELECTIONS  = "RETURN_SELECTIONS";
const string HIRE_SELECTIONS    = "HIRE_SELECTIONS";


int GetNumHenchmen(object oPC);

void Init()
{
    object oPC    = GetPcDlgSpeaker();
    object oFixer = OBJECT_SELF;

    //::  Setup prompts
    if (GetElementCount(ROOT_SELECTIONS) == 0)
    {
        AddStringElement("<c þ >[Hire Henchman]</c>", ROOT_SELECTIONS);
        AddStringElement("Could you explain how this works?", ROOT_SELECTIONS);
        AddStringElement(txtRed + "[Leave]</c>", ROOT_SELECTIONS);
    }

    if (GetElementCount(INFO_SELECTION) == 0)
    {
        AddStringElement("<c þ >[Hire Henchman]</c>", INFO_SELECTION);
        AddStringElement(txtRed + "[Leave]</c>", INFO_SELECTION);
    }

    if (GetElementCount(RETURN_SELECTIONS) == 0)
    {
        AddStringElement(txtFuchsia + "[Return Henchman]</c>", RETURN_SELECTIONS);
        AddStringElement(txtRed + "[Leave]</c>", RETURN_SELECTIONS);
    }

    if (GetElementCount(HIRE_SELECTIONS) == 0)
    {
        AddStringElement(txtFuchsia + "[Hire " + ar_GetHenchName(oFixer, 1) + "]</c> " + ar_GetHenchCost(1), HIRE_SELECTIONS);
        AddStringElement(txtFuchsia + "[Hire " + ar_GetHenchName(oFixer, 2) + "]</c> " + ar_GetHenchCost(2), HIRE_SELECTIONS);
        AddStringElement(txtFuchsia + "[Hire " + ar_GetHenchName(oFixer, 3) + "]</c> " + ar_GetHenchCost(3), HIRE_SELECTIONS);
        AddStringElement(txtRed + "[Back]</c>", HIRE_SELECTIONS);
    }

    //::  Starting branch
    if( ar_CanHireHenchman(oPC) )                           SetDlgPageString(ROOT_SELECTIONS);
    else if ( ar_BelongsToMaster(oFixer, oPC) )             SetDlgPageString(RETURN_SELECTIONS);
    else SetDlgPrompt("Get Lost!'");
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage      = GetDlgPageString();
    object oPC        = GetPcDlgSpeaker();
    object oFixer     = OBJECT_SELF;

    //::  ROOT
    if (sPage == ROOT_SELECTIONS)
    {
        SetDlgPrompt("Yes?  Need a Henchman?");
        SetDlgResponseList(ROOT_SELECTIONS);
    }
    //::  INFO
    else if (sPage == INFO_SELECTION) {
        SetDlgPrompt("Simple. If you are strong enough to handle one of my henchmen you can sign a contract.\n" +
                      "A fee will be given to me but also a deposit. The deposit is based on the henchman you contract.\n" +
                      "The deposit will be given back to you upon returning my henchman ALIVE! If you get the henchman killed you can kiss that money good bye!");
        SetDlgResponseList(INFO_SELECTION);
    }
    //::  RETURN
    else if (sPage == RETURN_SELECTIONS) {
        SetDlgPrompt("You want to return your Henchman?");
        SetDlgResponseList(RETURN_SELECTIONS);
    }
    //::  HIRE
    else if (sPage == HIRE_SELECTIONS) {
        SetDlgPrompt("This is what I have to offer?");
        SetDlgResponseList(HIRE_SELECTIONS);
    }
    else
    {
        SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
    }
}

void HandleSelection()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    int nSelection  = GetDlgSelection();
    object oPC      = GetPcDlgSpeaker();
    object oFixer   = OBJECT_SELF;

    //::  ROOT
    if (sPage == ROOT_SELECTIONS)
    {
        if (nSelection == 0) {
            if ( ar_GetFailedResponse(oFixer, oPC) ) { EndDlg(); return; }

            SetDlgResponseList(HIRE_SELECTIONS);
            SetDlgPageString(HIRE_SELECTIONS);
        }
        else if (nSelection == 1) {
            SetDlgResponseList(INFO_SELECTION);
            SetDlgPageString(INFO_SELECTION);
        }
        else EndDlg();
    }

    //::  INFO
    else if (sPage == INFO_SELECTION)
    {
        if (nSelection == 0) {
            if ( ar_GetFailedResponse(oFixer, oPC) ) { EndDlg(); return; }

            SetDlgResponseList(HIRE_SELECTIONS);
            SetDlgPageString(HIRE_SELECTIONS);
        }
        else EndDlg();
    }

    //::  RETURN
    else if (sPage == RETURN_SELECTIONS)
    {
        if (nSelection == 0)        { ar_ReturnHenchman(oFixer, oPC); EndDlg(); }
        else EndDlg();
    }

    //::  HIRE
    else if (sPage == HIRE_SELECTIONS)
    {
        if (nSelection == 0)        { ar_HireHenchman(oFixer, oPC, 1); EndDlg(); }
        else if (nSelection == 1)   { ar_HireHenchman(oFixer, oPC, 2); EndDlg(); }
        else if (nSelection == 2)   { ar_HireHenchman(oFixer, oPC, 3); EndDlg(); }
        else {
            SetDlgResponseList(ROOT_SELECTIONS);
            SetDlgPageString(ROOT_SELECTIONS);
        }
    }
}



int GetNumHenchmen(object oPC)
{
    if (!GetIsPC(oPC)) return -1;

    int nLoop, nCount = 0;

    for (nLoop = 1; nLoop <= GetMaxHenchmen(); nLoop++)
    {
        if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, nLoop)))
            nCount++;
    }

   return nCount;
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

#include "gs_inc_listener"
#include "gs_inc_area"
#include "zdlg_include_i"
#include "zzdlg_color_inc"
#include "nwnx_creature"
#include "nwnx_object"

const string MAIN_SELECTIONS    = "MAIN_SELECTIONS";
const string VAR_SELECTIONS     = "VAR_SELECTIONS";

void Init()
{
    object oPC   = GetPcDlgSpeaker();
    object oArea = GetArea(oPC);

    if ( !GetIsDM(oPC) ) return;

    SetDlgPageString("root");

    //::  Removes all previous elements, we do this so we can setup MAIN_SELECTIONS differently
    RemoveElements(0, GetElementCount(MAIN_SELECTIONS), MAIN_SELECTIONS, OBJECT_SELF);
    RemoveElements(0, GetElementCount(VAR_SELECTIONS), VAR_SELECTIONS, OBJECT_SELF);

    if (GetElementCount(MAIN_SELECTIONS) == 0)
    {
        AddStringElement(txtGreen + "[Local Variables]</c>", MAIN_SELECTIONS);
        AddStringElement(txtGreen + "[PC Hide Variables]</c>", MAIN_SELECTIONS);
        //AddStringElement(txtGreen + "[Area Variables]</c>", MAIN_SELECTIONS);
        AddStringElement(txtRed + "[Exit]</c>", MAIN_SELECTIONS);
    }

    if (GetElementCount(VAR_SELECTIONS) == 0)
    {
        AddStringElement(txtGreen + "[Back]</c>", VAR_SELECTIONS);
        AddStringElement(txtRed + "[Exit]</c>", VAR_SELECTIONS);
    }
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    object oPC      = GetPcDlgSpeaker();
    object oArea    = GetArea(oPC);
    object oSource  = GetLocalObject(oPC, "AR_DM_STORED_PC");

    if ( !GetIsDM(oPC) ) return;

    //:: Display Conversation
    if (sPage == "root") {
        SetDlgPrompt(txtSilver + "Choose the type of Variables to display from " + GetName(oSource) + ".");
        SetDlgResponseList(MAIN_SELECTIONS);
    }
    //::  Local Variables
    else if (sPage == "page_local")
    {
        int iVar = 0;
        int iVars = NWNX_Object_GetLocalVariableCount(oSource);
        struct NWNX_Object_LocalVariable var = NWNX_Object_GetLocalVariable(oSource, iVar);
        string sVarList = "";

        while (iVar < iVars)
        {
            string sVarName = var.key;
            string sValue   = "";
            string sType    = "";

            switch(var.type)
            {
                case VARIABLE_TYPE_INT:
                    sValue = IntToString( GetLocalInt(oSource, sVarName) );
                    sType = "INT";
                    break;
                case VARIABLE_TYPE_FLOAT:
                    sValue = FloatToString( GetLocalFloat(oSource, sVarName) );
                    sType = "FLOAT";
                    break;
                case VARIABLE_TYPE_STRING:
                    sValue = GetLocalString(oSource, sVarName);
                    sType = "STRING";
                    break;
                case VARIABLE_TYPE_OBJECT:
                    break;
                case VARIABLE_TYPE_LOCATION:
                    break;
            }

            //::  Output this variable
            if (sVarName != "" && sValue != "" && sType != "") {
                sVarList = sVarList + sVarName + " (" + sType + "): " + sValue;
                sVarList = sVarList + "\n-----------\n";
            }

            iVar = iVar + 1;
            var = NWNX_Object_GetLocalVariable(oSource, iVar);
        }

        SetDlgPrompt(txtSilver + "Current Local Variables on</c> " + GetName(oSource) + "\n" + sVarList);
        SetDlgResponseList(VAR_SELECTIONS);
    }
    //::  Hide Variables
    else if (sPage == "page_hide")
    {
        if ( !GetIsPC(oSource) ) {
            SendMessageToPC(oPC, "Reading Hide variables only works on PCs.");
            EndDlg();
            return;
        }

        object oHide = gsPCGetCreatureHide(oSource);
        int iVar = 0;
        int iVars = NWNX_Object_GetLocalVariableCount(oHide);
        struct NWNX_Object_LocalVariable var = NWNX_Object_GetLocalVariable(oHide, iVar);
        string sVarList = "";

        while (iVar < iVars)
        {
            string sVarName = var.key;
            string sValue   = "";
            string sType    = "";

            switch(var.type)
            {
                case VARIABLE_TYPE_INT:
                    sValue = IntToString( GetLocalInt(oHide, sVarName) );
                    sType = "INT";
                    break;
                case VARIABLE_TYPE_FLOAT:
                    sValue = FloatToString( GetLocalFloat(oHide, sVarName) );
                    sType = "FLOAT";
                    break;
                case VARIABLE_TYPE_STRING:
                    sValue = GetLocalString(oHide, sVarName);
                    sType = "STRING";
                    break;
                case VARIABLE_TYPE_OBJECT:
                    break;
                case VARIABLE_TYPE_LOCATION:
                    break;
            }

            //::  Output this variable
            if (sVarName != "" && sValue != "" && sType != "") {
                sVarList = sVarList + sVarName + " (" + sType + "): " + sValue;
                sVarList = sVarList + "\n-----------\n";
            }

            iVar = iVar + 1;
            var = NWNX_Object_GetLocalVariable(oHide, iVar);
        }

        SetDlgPrompt(txtSilver + "Current Hide Variables on</c> " + GetName(oSource) + "\n" + sVarList);
        SetDlgResponseList(VAR_SELECTIONS);
    }
    //::  Area Variables
    //::  NOT WORKING! CRASHING THE SERVER OUCHIE!
    /*
    else if (sPage == "page_area")
    {
        if ( !GetIsObjectValid(oArea) ) {
            SendMessageToPC(oPC, "Could not fetch Area object.");
            EndDlg();
            return;
        }

        int iVar = 0;
        int iVars = NWNX_Object_GetLocalVariableCount(oArea);
        struct NWNX_Object_LocalVariable var = NWNX_Object_GetLocalVariable(oArea, iVar);
        string sVarList = "";
        int iAreaVars = 0;

        while ((iVar < iVars) && (iVar < 30))
        {
            iAreaVars++;
            string sVarName = var.key;
            string sValue   = "";
            string sType    = "";

            switch(var.type)
            {
                case VARIABLE_TYPE_INT:
                    sValue = IntToString( GetLocalInt(oArea, sVarName) );
                    sType = "INT";
                    break;
                case VARIABLE_TYPE_FLOAT:
                    sValue = FloatToString( GetLocalFloat(oArea, sVarName) );
                    sType = "FLOAT";
                    break;
                case VARIABLE_TYPE_STRING:
                    sValue = GetLocalString(oArea, sVarName);
                    sType = "STRING";
                    break;
                case VARIABLE_TYPE_OBJECT:
                    break;
                case VARIABLE_TYPE_LOCATION:
                    break;
            }

            //::  Output this variable
            if (sVarName != "" && sValue != "" && sType != "") {
                sVarList = sVarList + sVarName + " (" + sType + "): " + sValue;
                sVarList = sVarList + "\n-----------\n";
            }

            iVar = iVar + 1;
            var = NWNX_Object_GetLocalVariable(oArea, iVar);
        }

        SetDlgPrompt(txtSilver + "Current Local Area Variables on </c> " + GetName(oArea) + "\n" + sVarList);
        SetDlgResponseList(VAR_SELECTIONS);
    }
    */
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

    if ( !GetIsDM(oPC) ) return;

    //::  Root
    if (sPage == "root")
    {
        switch (nSelection)
        {
            case 0:
                SetDlgPageString("page_local");
                break;
            case 1:
                SetDlgPageString("page_hide");
                break;
            case 2:
                EndDlg();
                break;
        }
    }
    //::  Var Pages
    else if (sPage == "page_local" || sPage == "page_hide" || sPage == "page_area")
    {
        switch (nSelection)
        {
            case 0:
                SetDlgPageString("root");
                break;
            case 1:
                EndDlg();
                break;
        }
    }
}

void main()
{
    object oPC = GetPcDlgSpeaker();

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
            DeleteLocalObject(oPC, "AR_DM_STORED_PC");
            break;
    }
}

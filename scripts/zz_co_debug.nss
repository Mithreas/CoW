/*
zz_co_debug

DM/Dev debug conversation in ZZ-Dialog.

Designed to allow random information to be retrieved from various in-game
objects for debug purposes, and to allow additional information retrieval
to be scripted with minimal effort.

By Gulni
*/

#include "zzdlg_main_inc"
#include "gs_inc_common"
#include "gs_inc_language"
#include "inc_log"
#include "inc_chat"

const string DEBUG = "DEBUG";

const string GU_RESPONSES = "GU_RESPONSES";

const string GU_TARGET    = "GU_TARGET";
const string GU_LOCATION  = "GU_LOCATION";

const string PAGE_CREATURE  = "creature";
const string PAGE_LANGUAGES = "languages";
const string PAGE_OBJECT    = "object";
const string PAGE_LOCATION  = "location";

const string SEL_LANGUAGES  = "[Show languages]";
const string SEL_CREATURE   = "[Back to creature page]";

void Cleanup();

void InitCreature(string sSubPage);
void InitObject();
void InitLocation();

void SelCreature();
void SelObject();
void SelLocation();

string GetEventName(int nEvent)
{
    switch(nEvent)
    {
    case EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR: return "Blocked";
    case EVENT_SCRIPT_DOOR_ON_DAMAGE:
    case EVENT_SCRIPT_PLACEABLE_ON_DAMAGED:
    case EVENT_SCRIPT_CREATURE_ON_DAMAGED: return "Damaged";
    case EVENT_SCRIPT_DOOR_ON_DEATH:
    case EVENT_SCRIPT_PLACEABLE_ON_DEATH:
    case EVENT_SCRIPT_CREATURE_ON_DEATH: return "Death";
    case EVENT_SCRIPT_DOOR_ON_DIALOGUE:
    case EVENT_SCRIPT_PLACEABLE_ON_DIALOGUE:
    case EVENT_SCRIPT_CREATURE_ON_DIALOGUE: return "Dialogue";
    case EVENT_SCRIPT_CREATURE_ON_DISTURBED: return "Disturbed";
    case EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND: return "End Combat Round";
    case EVENT_SCRIPT_DOOR_ON_HEARTBEAT:
    case EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT:
    case EVENT_SCRIPT_CREATURE_ON_HEARTBEAT: return "Heartbeat";
    case EVENT_SCRIPT_DOOR_ON_MELEE_ATTACKED:
    case EVENT_SCRIPT_PLACEABLE_ON_MELEEATTACKED:
    case EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED: return "Attacked";
    case EVENT_SCRIPT_CREATURE_ON_NOTICE: return "Perceived";
    case EVENT_SCRIPT_CREATURE_ON_RESTED: return "Rest";
    case EVENT_SCRIPT_CREATURE_ON_SPAWN_IN: return "Spawn";
    case EVENT_SCRIPT_DOOR_ON_SPELLCASTAT:
    case EVENT_SCRIPT_PLACEABLE_ON_SPELLCASTAT:
    case EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT: return "Spell Cast On";
    case EVENT_SCRIPT_DOOR_ON_USERDEFINED:
    case EVENT_SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT:
    case EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT: return "User Defined";
    case EVENT_SCRIPT_PLACEABLE_ON_OPEN:
    case EVENT_SCRIPT_DOOR_ON_OPEN: return "Open";
    case EVENT_SCRIPT_PLACEABLE_ON_CLOSED:
    case EVENT_SCRIPT_DOOR_ON_CLOSE: return "Close";
    case EVENT_SCRIPT_PLACEABLE_ON_DISARM:
    case EVENT_SCRIPT_DOOR_ON_DISARM: return "Trap Disarm";
    case EVENT_SCRIPT_PLACEABLE_ON_LOCK:
    case EVENT_SCRIPT_DOOR_ON_LOCK: return  "Lock";
    case EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED:
    case EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED: return  "Trap Triggered";
    case EVENT_SCRIPT_PLACEABLE_ON_UNLOCK:
    case EVENT_SCRIPT_DOOR_ON_UNLOCK: return  "Unlock";
    case EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK:
    case EVENT_SCRIPT_DOOR_ON_CLICKED: return "Clicked";
    case EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN: return "Fail to Open";
    case EVENT_SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED: return "Invetory Disturbed";
    case EVENT_SCRIPT_PLACEABLE_ON_USED: return "Used";

    }

    return "";
}

void ChangeEventScript(int nEventStart, int nSelectionIndex, object oTarget=OBJECT_INVALID)
{
    if(!GetIsObjectValid(oTarget)) oTarget = dlgGetPlayerDataObject(GU_TARGET);

    SetEventScript(oTarget, nEventStart+nSelectionIndex, chatGetLastMessage(dlgGetSpeakingPC()));
}
void OnInit()
{
    object oSpeaker    = dlgGetSpeakingPC();
    object oTarget     = GetLocalObject(oSpeaker, "GS_TARGET");
    location lLocation = GetLocalLocation(oSpeaker, "GS_LTARGET");

    dlgSetPlayerDataObject(GU_TARGET, oTarget);
    dlgSetPlayerDataLocation(GU_LOCATION, lLocation);

    DeleteLocalObject(oSpeaker, "GS_TARGET");
    DeleteLocalLocation(oSpeaker, "GS_LTARGET");

    dlgSetActiveResponseList(GU_RESPONSES);
    dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);

    // If we have selected an object, then use an appropriate conversation page
    // for the object's type
    if (GetIsObjectValid(oTarget))
    {
        Log(DEBUG, "object type " + IntToString(GetObjectType(oTarget)));
        switch (GetObjectType(oTarget))
        {
        case OBJECT_TYPE_CREATURE:
            dlgChangePage(PAGE_CREATURE);
            break;
        default:
            dlgChangePage(PAGE_OBJECT);
            break;
        }
    }
    else
    // No object, so use the target location page instead
    {
        Log(DEBUG, "location");
        dlgChangePage(PAGE_LOCATION);
    }
}
// Continue strings not used here
void OnContinue(string sPage, int nContinuePage)
{
}
// Reset strings not yet used
void OnReset(string sPage)
{
}
void OnEnd(string sPage)
{
    Cleanup();
}
void OnAbort(string sPage)
{
    Cleanup();
}
void main()
{
    dlgOnMessage();
}

// Initialisation, top page
void OnPageInit(string sPage)
{
    dlgClearResponseList(GU_RESPONSES);

    if (sPage == PAGE_CREATURE ||
        sPage == PAGE_LANGUAGES)
        InitCreature(sPage);
    else if (sPage == PAGE_OBJECT)
        InitObject();
    else
        InitLocation();
}

void OnSelection(string sPage)
{
    if (sPage == PAGE_CREATURE ||
        sPage == PAGE_LANGUAGES)
        SelCreature();
    else if (sPage == PAGE_OBJECT)
        SelObject();
    else
        SelLocation();
}

//
// Creature functions
//

string GetPlayerType(object oCreature)
{
    if (GetIsDMPossessed(oCreature))
        return "DM-Possessed";
    else if (GetIsDM(oCreature))
        return "DM avatar";
    else if (GetIsPossessedFamiliar(oCreature))
        return "PC-possessed familiar";
    else if (GetIsPC(GetMaster(oCreature)))
        return "PC-owned creature";
    else if (GetIsPC(oCreature))
        return "PC";
    else
        return "NPC";

}

string ShowLanguages(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);
    int nLang;

    string sResults = txtYellow + "Languages learned: </c>" +
                      IntToString(GetLocalInt(oHide, "GS_LA_LANGUAGES")) + "\n";

    for (nLang = 0; nLang <= 14; nLang++)
    {
        string sName = txtYellow + gsLAGetLanguageName(nLang) + "</c>: ";

        string sTag = "GS_LA_LANGUAGE_" + IntToString(nLang);

        if (GetLocalInt(oHide, sTag))
        {
            sResults += sName + "Known (HIDE)\n";
            continue;
        }

        if (GetIsObjectValid(GetItemPossessedBy(oPC, sTag)))
        {
            sResults += sName + "Known (EAR)\n";
            continue;
        }

        if (_gsLAGetCanSpeakLanguage(nLang, oPC, OBJECT_INVALID, sTag))
        {
            sResults += sName + "Known (NATURAL)\n";
            continue;
        }

        sTag = "MI_LA_PHRASEBK_" + IntToString(nLang);
        object oBook = GetItemPossessedBy(oPC, sTag);
        if (GetIsObjectValid(oBook))
        {
            int nScore = GetLocalInt(oBook, "PROGRESS_" + gsPCGetPlayerID(oPC));
            sResults += sName + "Learning (BOOK: score " + IntToString(nScore) + ")\n";
            continue;
        }
    }

    return sResults;
}

void InitCreature(string sSubPage)
{
    object oTarget = dlgGetPlayerDataObject(GU_TARGET);
    object oPC = OBJECT_INVALID;

    if (GetIsPC(oTarget))
        oPC = oTarget;
    else if (GetIsPC(GetMaster(oTarget)))
        oPC = GetMaster(oTarget);

    if (sSubPage == PAGE_LANGUAGES)
    {
        dlgSetPrompt(txtYellow + "Creature:         </c>" + GetName(oTarget) + "\n" +
                     ShowLanguages(oPC));
        dlgAddResponseAction(GU_RESPONSES, SEL_CREATURE);
    }
    else
    {
        dlgSetPrompt(txtYellow + "Creature:         </c>" + GetName(oTarget) + "\n" +
                     txtYellow + "Resref:           </c>" + GetResRef(oTarget) + "\n" +
                     txtYellow + "Tag:              </c>" + GetTag(oTarget) + "\n" +
                     "\n" +
                     txtYellow + "Player type:      </c>" + GetPlayerType(oTarget) + "\n" +
                     txtYellow + "Current AI level: </c>" + IntToString(GetAILevel(oTarget)) + "\n");

        int x;
        for(x = 5000; x <= 5012; x++)
        {
            dlgAddResponseAction(GU_RESPONSES, GetEventName(x)+ ": " + GetEventScript(oTarget, x));
        }
    }

    if (GetIsObjectValid(oPC))
        dlgAddResponseAction(GU_RESPONSES, SEL_LANGUAGES);

    dlgDeactivateResetResponse();
}

void SelCreature()
{
    string sName = dlgGetSelectionName();

    if (sName == SEL_LANGUAGES)
        dlgChangePage(PAGE_LANGUAGES);
    else if (sName == SEL_CREATURE)
        dlgChangePage(PAGE_CREATURE);
    else
        ChangeEventScript(5000, dlgGetSelectionIndex());
}

//
// Other object functions
//

string __flag(string sFlagname, int bEnabled)
{
    return (bEnabled ? "+" : "-") + sFlagname + " ";
}

void InitObject()
{
    object oTarget = dlgGetPlayerDataObject(GU_TARGET);

    string sType;
    int nType = GetObjectType(oTarget);
    switch (nType)
    {
    case OBJECT_TYPE_DOOR:
        sType = "Door"; break;
    case OBJECT_TYPE_ITEM:
        sType = "Item"; break;
    case OBJECT_TYPE_PLACEABLE:
        sType = "Placeable"; break;
    default:
        sType = "[type " + IntToString(nType) + "]";
        break;
    }

    string sFlags = __flag("plot", GetPlotFlag(oTarget));
    if (nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)
    {
        sFlags += __flag("locked", GetLocked(oTarget));
        sFlags += __flag("trapped", GetIsTrapped(oTarget));
    }
    if (nType == OBJECT_TYPE_PLACEABLE || nType == OBJECT_TYPE_ITEM)
    {
        sFlags += __flag("inventory", GetHasInventory(oTarget));
    }
    if (nType == OBJECT_TYPE_ITEM)
    {
        sFlags += __flag("identified", GetIdentified(oTarget));
        sFlags += __flag("pickpocketable", GetPickpocketableFlag(oTarget));
        sFlags += __flag("droppable", GetDroppableFlag(oTarget));
    }

    string sPrompt;
    int nCost = gsCMGetItemValue(oTarget);

    sPrompt  = txtYellow + sType + ": </c>" + GetName(oTarget) + "\n\n";
    sPrompt += txtYellow + "Resref:</c>   " + GetResRef(oTarget) + "\n";
    sPrompt += txtYellow + "Tag:</c>      " + GetTag(oTarget) + "\n";
    sPrompt += txtYellow + "Value:</c>    " + IntToString(nCost) + "\n";
    sPrompt += txtYellow + " (level):</c> " + IntToString(gsCMGetItemLevelByValue(nCost)) + "\n";
    sPrompt += txtYellow + "Flags:</c>    " + sFlags + "\n\n";

    dlgSetPrompt(sPrompt);
    dlgDeactivateResetResponse();

    int nStart;
    int nEnd;
    switch(nType)
    {
    case OBJECT_TYPE_DOOR: nStart = 10000; nEnd = 10014; break;
    case OBJECT_TYPE_PLACEABLE: nStart = 9000; nEnd = 9015; break;
    } //other objects don't have scripts
    int x;
    for(x=nStart; x <= nEnd; x++)
    {
        dlgAddResponseAction(GU_RESPONSES, GetEventName(x)+ ": " + GetEventScript(oTarget, x));
    }
}

void SelObject()
{
    int nStart;
    int nEnd;
    object oTarget =   dlgGetPlayerDataObject(GU_TARGET);
    switch(GetObjectType(oTarget))
    {
    case OBJECT_TYPE_DOOR: nStart = 10000; break;
    case OBJECT_TYPE_PLACEABLE: nStart = 9000; break;
    } //other objects don't have scripts

    ChangeEventScript(nStart, dlgGetSelectionIndex(), oTarget);
}

//
// Location functions
//

void InitLocation()
{
    dlgDeactivateResetResponse();
}

void SelLocation()
{
}

// Cleanup
void Cleanup()
{
    dlgClearResponseList(GU_RESPONSES);
    dlgClearPlayerDataObject(GU_TARGET);
    dlgClearPlayerDataLocation(GU_LOCATION);
}

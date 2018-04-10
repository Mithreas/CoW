/*
zz_co_forum

Gigaschatten's Forum Conversation (gs_fo_use) converted to ZZ-Dialog by Fireboar.
This is a very simple conversation that has no need for pages.

I've put the initialization code in OnPageInit rather than OnInit so that it
works when linked to from another conversation.
*/
#include "gs_inc_forum"
#include "gs_inc_message"
#include "zzdlg_main_inc"
#include "mi_log"
#include "mi_inc_factions"

const string FB_RESPONSES   = "FB_RESPONSES";
const string FB_VAR_CHECK   = "FB_DL_CHECK";
const string FB_VAR_MESSAGE = "FB_DL_MESSAGE";
const string FB_VAR_ENABLED = "GS_FORUM_ENABLED";

const string GS_TEMPLATE_LETTER = "gs_item370";

int GetCanRemoveMessage(object oPC, object oForum, string sMessageID)
{
  // Allow messages to be removed if one of the following holds:
  // - oPC is a DM
  // - oForum is a notebook
  // - oSpeaker owns sMessageID
  // - oSpeaker has their name on oForum
  return (GetIsDM(oPC) ||
          GetObjectType(oForum) == OBJECT_TYPE_ITEM ||
          gsFOGetOwner(sMessageID, oForum) == gsPCGetPlayerID(oPC) ||
          FindSubString(GetName(oForum), GetName(oPC)) != -1 ||
          md_GetHasPowerFixture(MD_PR_TDM, oPC, GetName(oForum)));
}

// Cleanup function
void Cleanup();

void OnInit()
{
    // We have to include this line somewhere to avoid nasty bugs.
    dlgChangePage("UNUSED");
}
void OnPageInit(string sPage)
{
    object oSpeaker   = dlgGetSpeakingPC();
    object oForum = _dlgGetObjSpeakee(_dlgGetPcSpeaker());
    int nMessageID    = dlgGetPlayerDataInt(FB_VAR_MESSAGE);
    string sMessageID = "";

    // Initialize conversation and possibly the board itself
    if (!dlgGetPlayerDataInt(FB_VAR_CHECK))
    {
        if (!dlgGetSpeakeeDataInt(FB_VAR_ENABLED))
        {
            Log(FORUMS, "Loading forum: " + GetName(OBJECT_SELF));
            gsFOLoadContent(oForum);
            dlgSetSpeakeeDataInt(FB_VAR_ENABLED, TRUE);
            dlgSetPrompt("Message board loaded.");
            dlgClearResponseList(FB_RESPONSES);
            dlgSetActiveResponseList(FB_RESPONSES);
            dlgActivateResetResponse("[Continue]", DLG_DEFAULT_TXT_ACTION_COLOR);
            // The reset path is shared with the message removal option, so mark
            // things such that we don't try removing a message now by mistake!
            dlgSetPlayerDataInt(FB_VAR_MESSAGE, -1);
            return;
        }

        // Message list
        dlgClearResponseList(FB_RESPONSES);
        int nSlot = 0;
        int nNth = gsFOGetFirstMessage(0, oForum);
        while (nNth != -1)
        {
            dlgSetSpeakeeDataInt("GS_SLOT_"+IntToString(++nSlot), nNth);

            sMessageID = gsFOGetMessage(nNth, oForum);

            dlgAddResponseTalk(FB_RESPONSES, "<cþë¦>"+gsMEGetTitle(sMessageID)+"</c> by <c(”þ>"+
                (gsMEGetAnonymous(sMessageID) ? "Anonymous" : gsMEGetAuthor(sMessageID)));

            nNth = gsFOGetNextMessage(nNth, oForum);
        }
        dlgSetActiveResponseList(FB_RESPONSES);

        // Make sure the page remains selected
        dlgActivatePreservePageNumberOnSelection();

        // Manage labels
        dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);
        dlgChangeLabelNext("[Next page]", txtLime);
        dlgChangeLabelPrevious("[Previous page]", txtLime);

        dlgSetPlayerDataInt(FB_VAR_CHECK, TRUE);
        dlgSetPlayerDataInt(FB_VAR_MESSAGE, -1);
        nMessageID = -1;
    }

    // No message selected
    if (nMessageID == -1)
    {
        dlgSetPrompt("Select the message you want to read.\n\nTo post a message use a writing on this board. You can create writings by using writing paper.");
        dlgDeactivateResetResponse();
    }
    // Message has been selected
    else
    {
        sMessageID = gsFOGetMessage(nMessageID, oForum);
        dlgSetPrompt(gsMEGetMessage(sMessageID, oSpeaker));
        if (sMessageID != "" && GetCanRemoveMessage(oSpeaker, oForum, sMessageID))
            dlgActivateResetResponse("[Remove message]", txtLime);
        else dlgDeactivateResetResponse();
    }
}
void OnSelection(string sPage)
{
    // Record the slot chosen
    int nID = dlgGetSpeakeeDataInt("GS_SLOT_"+IntToString(dlgGetSelectionIndex() + 1));
    dlgSetPlayerDataInt(FB_VAR_MESSAGE, nID);
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
    object oForum = _dlgGetObjSpeakee(_dlgGetPcSpeaker());
    int nNth = dlgGetPlayerDataInt(FB_VAR_MESSAGE);

    if (nNth != -1)
    {
        string sMessageID = gsFOGetMessage(nNth, oForum);

        if (sMessageID != "")
        {
            object oSpeaker = dlgGetSpeakingPC();

            if (GetCanRemoveMessage(oSpeaker, oForum, sMessageID))
            {
                object oObject = CreateItemOnObject(GS_TEMPLATE_LETTER,
                                                    oSpeaker,
                                                    1,
                                                    "GS_ME_" + sMessageID);

                if (GetIsObjectValid(oObject))
                {
                    string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

                    SetName(oObject, sDoubleQuote + gsMEGetTitle(sMessageID) + sDoubleQuote);
                    gsFORemoveMessage(sMessageID, oForum);
                    // Reset conversation
                    dlgClearPlayerDataInt(FB_VAR_CHECK);
                }
            }
        }
    }
}
void OnAbort(string sPage)
{
    Cleanup();
}
void OnEnd(string sPage)
{
    Cleanup();
}
void main()
{
    dlgOnMessage();
}
void Cleanup()
{
    dlgClearResponseList(FB_RESPONSES);
    dlgClearPlayerDataInt(FB_VAR_CHECK);
    dlgClearPlayerDataInt(FB_VAR_MESSAGE);
}

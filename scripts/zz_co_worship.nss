/*
zz_co_worship

Gigaschatten's Deity Selection Conversation (gs_wo_select) converted to ZZ-Dialog
by Fireboar. This is split into 3 pages:

Page 1: Service category selection
Page 2: Deity list
Page 3: Confirm selection

This uses the library fb_inc_worship. It's not so much a library as a text dump
since it is where all the deities and their respective portfolios are stored. It
also serves as a wrapper for all the libraries required for this script.
*/

#include "fb_inc_worship"
#include "inc_favsoul"

const string FB_RESPONSES = "FB_RESPONSES";

const string FB_VAR_CATEGORY = "FB_DL_CATEGORY";
const string FB_VAR_DEITY    = "FB_DL_DEITY";

// Cleanup function
void Cleanup();

void OnInit()
{
    dlgSetActiveResponseList(FB_RESPONSES);
    dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);
    dlgChangeLabelNext("[Next page]", txtLime);
    dlgChangeLabelPrevious("[Previous page]", txtLime);
    gsWOSetup();
    dlgChangePage("1");
}
void OnPageInit(string sPage)
{
    object oSpeaker = dlgGetSpeakingPC();
    dlgClearResponseList(FB_RESPONSES);
    switch (StringToInt(sPage))
    {
        case 1:
        {
            string sServing = GetDeity(oSpeaker);
            if (sServing == "") sServing = GS_T_16777332;
            dlgSetPrompt("You are serving "+sServing+". You can change your belief by selecting a deity from this book. It is only possible to choose deities that convene with your character. If you turn away from your deity it will punish you with a loss of 500 experience points.");
            dlgAddResponseTalk(FB_RESPONSES, "Major deities");
            dlgAddResponseTalk(FB_RESPONSES, "Intermediate deities");
            dlgAddResponseTalk(FB_RESPONSES, "Lesser deities");
            dlgAddResponseTalk(FB_RESPONSES, "Demigods");
            dlgAddResponseTalk(FB_RESPONSES, "Planar powers");
            dlgAddResponseTalk(FB_RESPONSES, "Setting-specific deities");
            dlgAddResponseAction(FB_RESPONSES, "[No deity]");
            dlgDeactivateResetResponse();
            break;
        }
        case 2:
        {
            int nCategory    = dlgGetPlayerDataInt(FB_VAR_CATEGORY);
            string sCategory = "";
            switch (nCategory)
            {
            case 1:
                sCategory = "Major deities";
                break;
            case 2:
                sCategory = "Intermediate deities";
                break;
            case 3:
                sCategory = "Lesser deities";
                break;
            case 4:
                sCategory = "Demigods";
                break;
            case 5:
                sCategory = "Planar powers";
                break;
            case 6:
                sCategory = "Setting-specific deities";
                break;
            }
            dlgSetPrompt(sCategory);

            int nNth = 0;
            int nDeity = 0;
            string sName;

            while (TRUE)
            {
                nDeity = fbWOGetNthDeity(nCategory, ++nNth);
                if (!nDeity) break;
                sName = gsWOGetNameByDeity(nDeity);
                sName += " (" + fbWOGetAspectName(nDeity);

                if (gsWOGetRacialType(nDeity) != RACIAL_TYPE_ALL)
                {
                  sName += "/" + fbWOGetRacialTypeName(nDeity);
                }

                sName += ")";

                dlgAddResponseTalk(FB_RESPONSES, sName);
            }
            dlgActivateResetResponse("[Back]", txtLime);
            break;
        }
        case 3:
        {
            int nCategory = dlgGetPlayerDataInt(FB_VAR_CATEGORY);
            int nDeity    = dlgGetPlayerDataInt(FB_VAR_DEITY);
            int nDeity2   = fbWOGetNthDeity(nCategory, nDeity);
            dlgSetPrompt(fbWOGetNthPortfolio(nCategory, nDeity)+"\n\nCleric alignments: "+gsWOGetAlignments(nDeity2));

            if (gsWOGetIsDeityAvailable(nDeity2, dlgGetSpeakingPC()))
                dlgAddResponseAction(FB_RESPONSES, "[Select deity]");
            dlgActivateResetResponse("[Back]", txtLime);
            break;
        }
    }
}
void OnSelection(string sPage)
{
    object oSpeaker = dlgGetSpeakingPC();
    int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

    switch (StringToInt(sPage))
    {
        case 1:
        {
            int nChoice = dlgGetSelectionIndex();
            // No deity
            if (nChoice == 6)
            {
                // Penalty
                string sCurrentDeity = GetDeity(oSpeaker);
                if (sCurrentDeity != "")
                {
                    int nCurrentDeity = gsWOGetDeityByName(sCurrentDeity);

                    // No deity or invalid deity selected
                    if (nCurrentDeity > 0)
                    {
                        SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777331, sCurrentDeity));
                        if (!bStaticLevel) gsXPGiveExperience(oSpeaker, -500);
                        gsWOAdjustPiety(oSpeaker, -(gsWOGetPiety(oSpeaker) + 100.0));
                    }
                }
                // Change deity
                SetDeity(oSpeaker, "");
                miFSApplyFavoredSoul(oSpeaker);
            }
            else
            {
                dlgSetPlayerDataInt(FB_VAR_CATEGORY, nChoice + 1);
                dlgChangePage("2");
            }
            break;
        }
        case 2:
        {
            // The only non-reset choice is to select a deity...
            dlgSetPlayerDataInt(FB_VAR_DEITY, dlgGetSelectionIndex() + 1);
            dlgChangePage("3");
            break;
        }
        case 3:
        {
            int nDeity = fbWOGetNthDeity(dlgGetPlayerDataInt(FB_VAR_CATEGORY),
                dlgGetPlayerDataInt(FB_VAR_DEITY));

            // Penalty
            string sCurrentDeity = GetDeity(oSpeaker);
            if (sCurrentDeity != "")
            {
                int nCurrentDeity = gsWOGetDeityByName(sCurrentDeity);

                if (nCurrentDeity && nCurrentDeity != nDeity)
                {
                    SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777331, sCurrentDeity));
                    if (!bStaticLevel) gsXPGiveExperience(oSpeaker, -500);
                    gsWOAdjustPiety(oSpeaker, -(gsWOGetPiety(oSpeaker) + 100.0));
                }
            }

            // Set deity
            SetDeity(oSpeaker, gsWOGetNameByDeity(nDeity));
            miFSApplyFavoredSoul(oSpeaker);

            // Change page
            dlgClearPlayerDataInt(FB_VAR_DEITY);
            dlgClearPlayerDataInt(FB_VAR_CATEGORY);
            dlgChangePage("1");
            break;
        }
    }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
    if (sPage == "2")
    {
        dlgClearPlayerDataInt(FB_VAR_CATEGORY);
        dlgChangePage("1");
    }
    else if (sPage == "3")
    {
        dlgClearPlayerDataInt(FB_VAR_DEITY);
        dlgChangePage("2");
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
    dlgClearPlayerDataInt(FB_VAR_DEITY);
    dlgClearPlayerDataString(FB_VAR_CATEGORY);
}

/*
zz_co_crafting

Adapted for CNR based crafting.

Page 1: Select repair, improve or create new.

*/

#include "cnr_recipe_utils"
#include "inc_istate"
#include "zzdlg_main_inc"

const string FB_RESPONSES = "FB_RESPONSES";

const string FB_VAR_ITEM            = "GS_ITEM";
const string FB_VAR_SKILL           = "GS_SKILL";
const string FB_VAR_WORK_PROGRESS   = "FB_DL_WORK_PROGRESS";
const string FB_VAR_CHOSEN_TRADE    = "FB_DL_CHOSEN_TRADE";

const string MD_LIST_FEAT_ID        = "LIST_FEAT_ID";

const string LIST_IDS               = "CR_LIST_ID";
// Function declaration

void Init1();
void Sel1();
void Cleanup();
void Setting();
void SettingS();

// Helper function to add a response with less typing :)
void fbResponse(string sResponse, int bIsAction = FALSE);
void fbResponse(string sResponse, int bIsAction = FALSE)
{
    if (bIsAction) dlgAddResponseAction(FB_RESPONSES, sResponse);
    else           dlgAddResponseTalk(FB_RESPONSES, sResponse);
}
// Helper functions for the Open inventory response
void fbOpen();
void fbOpen()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF))
        fbResponse("[Open inventory]", TRUE);
}
void fbOpenAction();
void fbOpenAction()
{
    object oSelf = OBJECT_SELF;
    AssignCommand(dlgGetSpeakingPC(), ActionInteractObject(oSelf));
    dlgEndDialog();
}

void OnInit()
{
    dlgSetActiveResponseList(FB_RESPONSES);
    dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);
    dlgChangePage("1");
}
void OnPageInit(string sPage)
{
    dlgClearResponseList(FB_RESPONSES);
    switch (StringToInt(sPage))
    {
        case 1: Init1(); break;
    }
}
void OnSelection(string sPage)
{
    switch (StringToInt(sPage))
    {
        case 1: Sel1(); break;
    }
}
// Continue strings not used here
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
    if (sPage == "1") dlgClearPlayerDataInt(FB_VAR_WORK_PROGRESS);
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

// Initialization pages
void Init1()
{
    // 3 possible prompts: proceed, repair or standard.
	// CNR integration: only repair or create/improve options will show up
    object oSpeaker   = dlgGetSpeakingPC();
    object oItem      = GetFirstItemInInventory();
	string sCraftMenu = GetTag(OBJECT_SELF);
    int nSkill        = GetLocalInt(GetModule(), sCraftMenu + "_TradeskillType");;
    int nRank         = CnrGetPlayerLevel(oSpeaker, sCraftMenu);
    string sRank      = IntToString(nRank);
    int nPoints       = 1; // CNR override.
    string sPoints    = IntToString(nPoints);
    int nState        = 0;
    int nStateMaximum = 0;
    int bProgress     = dlgGetPlayerDataInt(FB_VAR_WORK_PROGRESS);
	
    while (GetIsObjectValid(oItem))
    {
        if (gsISGetItemCraftSkill(oItem) == nSkill)
        {
            nState        = gsISGetItemState(oItem);
            nStateMaximum = gsISGetMaximumItemState(oItem);

            if (nState < nStateMaximum)
            {
                dlgSetPrompt("Damaged item\n\n"+txtBlue+"Item:</c> "+GetName(oItem)+"\n"+
                    txtBlue+"State:</c> "+txtRed+IntToString(nState)+"</c> / "+
                    txtLime+IntToString(nStateMaximum)+"</c>");

                if (nPoints > 0 && !bProgress) fbResponse("[Repair item]", TRUE);

                dlgSetSpeakeeDataObject(FB_VAR_ITEM, oItem);
                break;
            }
        }

        oItem = GetNextItemInInventory();
    }
    // No candidate found, use response 3
    if (!GetIsObjectValid(oItem))
    {
        if (nRank > -1) dlgSetPrompt(txtBlue+"[Select action]</c>\n\nYour skill rank: "+sRank);
		else dlgSetPrompt(txtBlue + "[Select action]</c>\n\nNo particular craft skill needed.");
    }

    // Display work options
    if (bProgress)
    {
        if (nRank > 0)
        {
            fbResponse("[Repair 1 point]", TRUE);
        }
		
        dlgActivateResetResponse("[Back]", txtLime);
        
    }
    // Display generic options
    else
    {
        if (nRank == -1 || nRank > 0) fbResponse("[Create new production]", TRUE); 
        if (nRank > 0) fbResponse("[Improve Item]", TRUE);
        fbOpen();
        dlgDeactivateResetResponse();
    }

    // Store the trade for the remainder of the conversation
    dlgSetPlayerDataInt(FB_VAR_CHOSEN_TRADE, nSkill);
}

// Selection pages
void Sel1()
{
    object oSpeaker = dlgGetSpeakingPC();
    object oSelf = OBJECT_SELF;
	
    if (!dlgGetPlayerDataInt(FB_VAR_WORK_PROGRESS))
    {
        string sName = dlgGetSelectionName();
        if (sName == "[Create new production]") 
		{
		    // Hook into CNR here.  
            Cleanup();
            AssignCommand(oSpeaker, ActionStartConversation(oSelf,"cnr_c_recipe", TRUE, FALSE));
		  
		}
        else if (sName == "[Improve Item]")
        {
            Cleanup();
            AssignCommand(oSpeaker, ActionStartConversation(oSelf,"gs_ip_add", TRUE, FALSE));
        }
        else if (sName == "[Open inventory]") fbOpenAction();
        else dlgSetPlayerDataInt(FB_VAR_WORK_PROGRESS, TRUE);
    }
    else
    {
        // Decide how much to repair or produce by
        int nValue = 0;
        switch (dlgGetSelectionIndex())
        {
            case 0: nValue = 1;     break;
            case 1: nValue = FALSE; break;
        }
		
        object oSelf = OBJECT_SELF;
        int nSkill   = dlgGetSpeakeeDataInt(FB_VAR_SKILL);

        object oItem = dlgGetSpeakeeDataObject(FB_VAR_ITEM);

        // Play fixture animation
		CnrRecipeDoAnimation(oSpeaker, oSelf, TRUE);
        // use the action queue so the object message shows
        // after the animation script completes
        AssignCommand(oSpeaker, ActionDoCommand(gsISRepairItem(oItem, oSpeaker, 1)));
		// Mark ourselves as "disturbed" so that the PC can carry on repairing without
		// needing to mess with the inventory.
		SetLocalInt(oSelf, "bCnrDisturbed", TRUE);
		
        // Play an appropriate sound (no animation - covered above)
        CnrRecipePlaySound(nSkill);

        // End the dialog - it'll come straight back up afterwards.
        dlgEndDialog();
    }
}
// Cleanup
void Cleanup()
{
    dlgClearResponseList(FB_RESPONSES);
    dlgClearPlayerDataInt(FB_VAR_WORK_PROGRESS);
    dlgClearSpeakeeDataObject(FB_VAR_ITEM);
}
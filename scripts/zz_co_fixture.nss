/*
zz_co_fixture

Gigaschatten's Use Fixture Conversation (gs_fx_use) converted to ZZ-Dialog by
Fireboar. This is a very simple conversation that has no need for pages.

The "use object" conversation option relies on zz_co_forum (a port of gs_fo_use
also converted to ZZ-Dialog) if the fixture in question is a message board.
*/
#include "inc_fixture"
#include "zzdlg_main_inc"

const string FB_RESPONSES = "FB_RESPONSES";

void OnInit()
{
    // We have to include this line somewhere to avoid nasty bugs.
    dlgChangePage("UNUSED");
}
void OnPageInit(string sPage)
{
    dlgClearResponseList(FB_RESPONSES);

    // Conversation options
    dlgSetPrompt(txtBlue+"[Select action]</c>");
    if (dlgGetSpeakeeDataInt("GS_LIGHT") ||
        dlgGetSpeakeeDataInt("GS_SIT_CHAIR") ||
        dlgGetSpeakeeDataInt("GS_SIT_FLOOR") ||
        dlgGetSpeakeeDataInt("GS_ALTAR") ||
        dlgGetSpeakeeDataInt("WT_ACTIVATE") ||
        dlgGetSpeakeeDataInt("MI_ENCHANTMENT_BASIN") ||
        dlgGetSpeakeeDataInt("MI_MESSAGE_BOARD"))
        dlgAddResponseAction(FB_RESPONSES, "[Use object]");
    dlgAddResponseAction(FB_RESPONSES, "[Take object]");

    dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);
    dlgDeactivateResetResponse();

    dlgSetActiveResponseList(FB_RESPONSES);
}
void OnSelection(string sPage)
{
    object oSpeaker = dlgGetSpeakingPC();
    if (dlgGetSelectionName() == "[Take object]")
    {
        object oFixture = gsFXPickupFixture(oSpeaker, OBJECT_SELF);
        if (GetIsObjectValid(oFixture))
        {
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));

            Log(FIXTURES, "Fixture " + GetName(OBJECT_SELF) + " in area " +
              GetName(GetArea(OBJECT_SELF)) + " was taken by " + GetName(oSpeaker));
            DestroyObject(OBJECT_SELF);
            gsFXWarn(oSpeaker, oFixture);
        }
    }
    else if (dlgGetSpeakeeDataInt("GS_LIGHT"))
    {
        AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.0));
        SetPlaceableIllumination(OBJECT_SELF, !GetPlaceableIllumination());
        DelayCommand(0.5, RecomputeStaticLighting(GetArea(OBJECT_SELF)));
    }
    else if (dlgGetSpeakeeDataInt("GS_SIT_CHAIR"))
    {
        if (!GetIsObjectValid(GetSittingCreature(OBJECT_SELF)))
        {
            object oSelf = OBJECT_SELF;
            AssignCommand(oSpeaker, ActionSit(oSelf));
        }
    }
    else if (dlgGetSpeakeeDataInt("GS_SIT_FLOOR"))
    {
        object oSelf   = OBJECT_SELF;
        AssignCommand(oSpeaker, ActionMoveToLocation(GetLocation(oSelf)));
        AssignCommand(oSpeaker, ActionDoCommand(SetFacing(GetFacing(oSelf) + 180.0)));
        AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
    }
    else if (dlgGetSpeakeeDataInt("MI_MESSAGE_BOARD"))
    {
        dlgChangeDlgScript(oSpeaker, "zz_co_forum");
        // Don't end dialog!
        return;
    }
    else if (dlgGetSpeakeeDataInt("GS_ALTAR"))
    {
      object oAltar = OBJECT_SELF;
      AssignCommand(oSpeaker, ActionStartConversation(oAltar, "gs_wo_sacrifice", TRUE, FALSE));
    }
    else if (dlgGetSpeakeeDataInt("WT_ACTIVATE"))
    {
        object oSelf = OBJECT_SELF;
        if(GetLocalInt(oSelf, "WT_PB_ACTIVATED") == FALSE)
        {
            AssignCommand(oSelf, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
            SetLocalInt(oSelf, "WT_PB_ACTIVATED", TRUE);
        }
        else
        {
            AssignCommand(oSelf, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
            SetLocalInt(oSelf, "WT_PB_ACTIVATED", FALSE);
        }
    }
    else if (dlgGetSpeakeeDataInt("MI_ENCHANTMENT_BASIN"))
    {
      object oBasin = OBJECT_SELF;
      AssignCommand(oSpeaker, ActionStartConversation(oBasin, "gs_ip_add", TRUE, FALSE));
    }

    dlgEndDialog();
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
}
void OnAbort(string sPage)
{
    dlgClearResponseList(FB_RESPONSES);
}
void OnEnd(string sPage)
{
    dlgClearResponseList(FB_RESPONSES);
}
void main()
{
    dlgOnMessage();
}

/*
Influencer script, written by ChatGPT and Mithreas, 9th July 2025.

Variables needed on the NPC:
- dialog
    [string] zdlg_influencer
- zdlg_greeting
    [string] Greeting the NPC will use. 
- zdlg_influence_mode
    0 = influence by dialog only
    1 = influence by quest only
    2 = influence by both quest and dialog
- zdlg_quest_key
    (string) name of the quest.  Needs to be initialised in rquest_init under category misc_quests
- zdlg_bonus_skill
    12 = persuade
    23 = bluff
    24 = intimidate
    28 = sense motive
    Other skills not supported currently.

The NPC's Bluff skill will be used to counter Sense Motive.
The NPC's Sense Motive skill will be used to counter the other skills.
The NPC's faction will set a bias - it will grant extra reputation towards it and be more easily influenced.toward this faction. 


*/
#include "inc_crime"
#include "inc_randomquest"
#include "inc_reputation"
#include "inc_time"
#include "inc_zdlg"

const string MAIN_MENU     = "main_menu";
const string QUEST_PAGE    = "quest_page";
const string ACCEPT_PAGE   = "accept_page";
const string COMPLETE_PAGE = "complete_page";
const string POLITICS_PAGE = "politics_page";
const string DECLINE_PAGE  = "decline_page";
const string END_PAGE      = "end_page";

const string QUEST_SET_MISC = "misc_quests";

// Influence modes
const int INFLUENCE_DIALOG_ONLY = 0;
const int INFLUENCE_QUEST_ONLY  = 1;
const int INFLUENCE_BOTH        = 2;

// Skill constants
const int SKILL_SENSE_MOTIVE = 28;

void SetMyInfluence(int nFaction)
{
  // TODO
    int nMyFaction  = CheckFactionNation(OBJECT_SELF); // give extra points if nFaction == nMyFaction
	
}

void Init()
{
    DeleteList(MAIN_MENU);

    object oPC  = GetPcDlgSpeaker();
    object oNPC = OBJECT_SELF;
    int nMode   = GetLocalInt(oNPC, "zdlg_influence_mode");
    int nSkill  = GetLocalInt(oNPC, "zdlg_bonus_skill");
    string sQuestKey = GetLocalString(oNPC, "zdlg_quest_key");

    if ((nMode == INFLUENCE_DIALOG_ONLY || nMode == INFLUENCE_BOTH) &&
	    GetLocalInt(oNPC, "POLITICS_TIMEOUT") < gsTIGetActualTimestamp())
    {
        string sSkillLabel = "[Skill Check]";
        if (nSkill == SKILL_PERSUADE)     sSkillLabel = "[Persuade Check]";
        else if (nSkill == SKILL_BLUFF)   sSkillLabel = "[Bluff Check]";
        else if (nSkill == SKILL_SENSE_MOTIVE) sSkillLabel = "[Sense Motive Check]";
        else if (nSkill == SKILL_INTIMIDATE) sSkillLabel = "[Intimidate Check]";

        AddStringElement("Let's talk politics. " + sSkillLabel, MAIN_MENU);
    }

    if ((nMode == INFLUENCE_QUEST_ONLY || nMode == INFLUENCE_BOTH) &&
        !HasDoneRandomQuest(oPC, sQuestKey, QUEST_SET_MISC))
    {
		if (GetQuestActive(oPC, sQuestKey, QUEST_SET_MISC))
		{
			AddStringElement("I've already completed your task.", MAIN_MENU);
		}
		else
		{
			AddStringElement("What do you need done?", MAIN_MENU);
		}
    }

    AddStringElement("Not interested right now.", MAIN_MENU);

    if (GetElementCount(QUEST_PAGE) == 0)
	{
        AddStringElement("I'll take care of it.", QUEST_PAGE);
        AddStringElement("I can't do that for you right now.", QUEST_PAGE);
	}
	
    if (GetElementCount(ACCEPT_PAGE) == 0)
        AddStringElement("I'll see you shortly.", ACCEPT_PAGE);

    if (GetElementCount(COMPLETE_PAGE) == 0)
        AddStringElement("Glad to help.", COMPLETE_PAGE);

    if (GetElementCount(POLITICS_PAGE) == 0)
        AddStringElement("I'll see what I can do.", POLITICS_PAGE);

    if (GetElementCount(DECLINE_PAGE) == 0)
        AddStringElement("Maybe another time.", DECLINE_PAGE);

    if (GetElementCount(END_PAGE) == 0)
        AddStringElement("Goodbye.", END_PAGE);
}

void PageInit()
{
    object oPC = GetPcDlgSpeaker();
    object oNPC = OBJECT_SELF;
    string sPage = GetDlgPageString();

    string sGreeting = GetLocalString(oNPC, "zdlg_greeting");
    string sQuestKey = GetLocalString(oNPC, "zdlg_quest_key");
    int nSkillBonus  = GetLocalInt(oNPC, "zdlg_bonus_skill");
    int nFaction     = CheckFactionNation(oNPC);

    if (sPage == "")
    {
        SetDlgPrompt(sGreeting != "" ? sGreeting : "Can I help you?");
        SetDlgResponseList(MAIN_MENU, oNPC);
    }
	else if (sPage == QUEST_PAGE)
	{
		SetDlgPrompt(GetQuestIntro(sQuestKey, QUEST_SET_MISC));
		SetDlgResponseList(QUEST_PAGE);
	}
    else if (sPage == ACCEPT_PAGE)
    {
        SetUpQuest(oPC, sQuestKey, QUEST_SET_MISC);
		SetQuestActive(oPC, sQuestKey, QUEST_SET_MISC);
        SetDlgPrompt("Very well. Return when it's done.");
        SetDlgResponseList(END_PAGE, oNPC);
    }
    else if (sPage == COMPLETE_PAGE)
    {
        if (QuestIsDone(oPC, sQuestKey, QUEST_SET_MISC))
        {
            // TODO: Replace with actual function to get PC's sponsored faction
            int nPCFaction = GetPCFaction(oPC);

			int nRep = 1;
            if (nPCFaction == nFaction)
                nRep += 1;
            if (nSkillBonus > 0 && GetSkillRank(nSkillBonus, oPC) >= 10)
                nRep += 1;
			
            GiveRepPoints(oPC, nRep, nFaction);

            SetDlgPrompt("Well done. I appreciate your efforts on behalf of " + GetFactionName(nPCFaction));
			SetMyInfluence(nPCFaction);
        }
        else
        {
            SetDlgPrompt("You haven't completed the task yet.");
        }
        SetDlgResponseList(END_PAGE, oNPC);
    }
    else if (sPage == POLITICS_PAGE)
    {
        int nPCSkill     = GetSkillRank(nSkillBonus, oPC);
        int nPCRoll      = d20();
        int nPCResult    = nPCRoll + nPCSkill;

        int nOpposingSkill;
        if (nSkillBonus == SKILL_SENSE_MOTIVE)
            nOpposingSkill = GetSkillRank(SKILL_BLUFF, oNPC);
        else
            nOpposingSkill = GetSkillRank(SKILL_SENSE_MOTIVE, oNPC);

        int nNPCRoll   = d20();
        int nDC        = nNPCRoll + nOpposingSkill;

        SendMessageToPC(oPC, "Skill Check: Roll " + IntToString(nPCRoll) +
            " + Skill " + IntToString(nPCSkill) + " = " + IntToString(nPCResult) +
            " vs DC " + IntToString(nDC));

        // Timeout.
		SetLocalInt(oNPC, "POLITICS_TIMEOUT", gsTIGetActualTimestamp() + 3600); // 1 RL hour

        if (nPCResult >= nDC)
        {
			SetMyInfluence(nFaction);

            int nPick = Random(5);
            string sSuccess;
            switch (nPick)
            {
                case 0: sSuccess = "You make a compelling case. " + GetName(OBJECT_SELF) + " nods thoughtfully."; break;
                case 1: sSuccess = "They seem swayed by your reasoning."; break;
                case 2: sSuccess = "Your words strike a chord. They reconsider their stance."; break;
                case 3: sSuccess = "They glance around and whisper, 'Perhaps you're right.'"; break;
                case 4: sSuccess = "They smile faintly. 'You've given me something to think about.'"; break;
            }
            SetDlgPrompt(sSuccess);
        }
        else
        {
            int nPick = Random(5);
            string sFail;
            switch (nPick)
            {
                case 0: sFail = "They raise an eyebrow. 'Is that supposed to convince me?'"; break;
                case 1: sFail = "They shake their head. 'You don't understand the stakes.'"; break;
                case 2: sFail = "They scoff. 'You're wasting your breath.'"; break;
                case 3: sFail = "They frown. 'I've heard better arguments from drunkards.'"; break;
                case 4: sFail = "They remain unmoved. 'Your words mean little here.'"; break;
            }
            SetDlgPrompt(sFail);
        }

        SetDlgResponseList(END_PAGE, oNPC);
    }
    else if (sPage == DECLINE_PAGE)
    {
        SetDlgPrompt("Very well. Come back if you change your mind.");
        SetDlgResponseList(END_PAGE, oNPC);
    }
    else if (sPage == END_PAGE)
    {
        SetDlgPrompt("Farewell.");
        SetDlgResponseList(END_PAGE, oNPC);
    }
    else
    {
        SendMessageToPC(oPC, "Z-Dialog error: unknown page.");
        EndDlg();
    }
}

void HandleSelection()
{
    int nSel = GetDlgSelection();
    object oNPC = OBJECT_SELF;
    object oPC = GetPcDlgSpeaker();
    int nMode = GetLocalInt(oNPC, "zdlg_influence_mode");
    string sQuestKey = GetLocalString(oNPC, "zdlg_quest_key");
    string sPage = GetDlgPageString();
    int nOffset = 0;

    if (sPage == "")
    {
        if ((nMode == INFLUENCE_DIALOG_ONLY || nMode == INFLUENCE_BOTH) &&
	        GetLocalInt(oNPC, "POLITICS_TIMEOUT") < gsTIGetActualTimestamp())
        {
            if (nSel == 0) { SetDlgPageString(POLITICS_PAGE); return; }
            nOffset = 1;
        }

        if ((nMode == INFLUENCE_QUEST_ONLY || nMode == INFLUENCE_BOTH) &&
            !HasDoneRandomQuest(oPC, sQuestKey, QUEST_SET_MISC))
        {
				
			if (GetQuestActive(oPC, sQuestKey, QUEST_SET_MISC))
			{
				if (nSel == nOffset) { SetDlgPageString(COMPLETE_PAGE); return; }
			}
			else
			{
				if (nSel == nOffset) { SetDlgPageString(QUEST_PAGE); return; }
			}
			
			nOffset += 1;
        }

        if (nSel == nOffset) { SetDlgPageString(DECLINE_PAGE); return; }
    }
	else if (sPage == QUEST_PAGE)
	{
	  if (nSel) SetDlgPageString(DECLINE_PAGE);
	  else SetDlgPageString(ACCEPT_PAGE);
	}
    else if (sPage == ACCEPT_PAGE || sPage == COMPLETE_PAGE || sPage == POLITICS_PAGE || sPage == DECLINE_PAGE || sPage == END_PAGE)
    {
        EndDlg();
    }
    else
    {
        SendMessageToPC(oPC, "Z-Dialog error: invalid selection.");
        EndDlg();
    }
}

void main()
{
    switch (GetDlgEventType())
    {
        case DLG_INIT: Init(); break;
        case DLG_PAGE_INIT: PageInit(); break;
        case DLG_SELECTION: HandleSelection(); break;
        case DLG_ABORT:
        case DLG_END: break;
    }
}

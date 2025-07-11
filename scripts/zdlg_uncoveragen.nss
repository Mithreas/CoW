// Written by ChatGPT, with help from Mithreas.
#include "inc_combat"
#include "inc_randomquest"
#include "inc_reputation"
#include "inc_zdlg"
#include "x2_inc_switches"

const int SKILL_SENSE_MOTIVE = 28;

const string MAIN_MENU     = "agent_main";
const string SUCCESS_PAGE  = "agent_success";
const string FAIL_PAGE     = "agent_fail";
const string ACCUSE_PAGE   = "agent_accuse";
const string DENY_PAGE     = "agent_deny";
const string END_PAGE      = "agent_end";

void Init()
{
    DeleteList(MAIN_MENU);

    AddStringElement("Just passing through.", MAIN_MENU);
    AddStringElement("Use Sense Motive to study them.", MAIN_MENU);
    AddStringElement("Accuse them of being an agent.", MAIN_MENU);

    if (GetElementCount(SUCCESS_PAGE) == 0)
        AddStringElement("Interesting... thank you.", SUCCESS_PAGE);

    if (GetElementCount(FAIL_PAGE) == 0)
        AddStringElement("Hmm... maybe not.", FAIL_PAGE);

    if (GetElementCount(ACCUSE_PAGE) == 0)
        AddStringElement("Prepare to defend yourself!", ACCUSE_PAGE);

    if (GetElementCount(DENY_PAGE) == 0)
        AddStringElement("I must have been mistaken.", DENY_PAGE);

    if (GetElementCount(END_PAGE) == 0)
        AddStringElement("Goodbye.", END_PAGE);
}

void SetRandomPrompt(string sPage, int bIsAgent = FALSE)
{
    int nPick = Random(5);
    string sPrompt;

    if (sPage == "")
    {
        switch (nPick)
        {
            case 0: sPrompt = "The NPC eyes you cautiously. Their posture is guarded, but their words are polite."; break;
            case 1: sPrompt = "They glance at you with a measured look, as if weighing your intentions."; break;
            case 2: sPrompt = "You sense a tension in the air as they greet you with a forced smile."; break;
            case 3: sPrompt = "Their voice is calm, but their eyes flicker toward the alley behind you."; break;
            case 4: sPrompt = "They nod in greeting, but something about their demeanor feels rehearsed."; break;
        }
    }
    else if (sPage == SUCCESS_PAGE)
    {
        switch (nPick)
        {
            case 0: sPrompt = bIsAgent ? "They hesitate slightly when discussing their duties. Something's off." :
                                         "Their tone is steady and their story checks out."; break;
            case 1: sPrompt = bIsAgent ? "You catch a subtle contradiction in their words." :
                                         "They seem genuinely unaware of any wrongdoing."; break;
            case 2: sPrompt = bIsAgent ? "Their eyes dart away when you press them. Suspicious." :
                                         "They answer confidently and without hesitation."; break;
            case 3: sPrompt = bIsAgent ? "A flicker of panic crosses their face. They're hiding something." :
                                         "They maintain eye contact and speak plainly."; break;
            case 4: sPrompt = bIsAgent ? "You sense they're concealing something beneath a calm exterior." :
                                         "Nothing in their behavior raises alarm bells."; break;
        }
    }
    else if (sPage == FAIL_PAGE)
    {
        switch (nPick)
        {
            case 0: sPrompt = "You can't get a good read on them."; break;
            case 1: sPrompt = "Their demeanor is unreadable - neither guilty nor innocent."; break;
            case 2: sPrompt = "They give nothing away, no matter how closely you watch."; break;
            case 3: sPrompt = "You second-guess yourself. No clear signs emerge."; break;
            case 4: sPrompt = "Their behavior is too neutral to draw any conclusions."; break;
        }
    }
    else if (sPage == ACCUSE_PAGE)
    {
        if (bIsAgent)
        {
            switch (nPick)
            {
                case 0: sPrompt = "The agent snarls and reaches for a hidden blade!"; break;
                case 1: sPrompt = "They curse and draw a weapon - your accusation was correct!"; break;
                case 2: sPrompt = "With a hiss, they lunge at you. The mask drops."; break;
                case 3: sPrompt = "They shout an oath and attack. You've found your mark."; break;
                case 4: sPrompt = "Their eyes narrow and they strike. The agent is revealed!"; break;
            }
        }
        else
        {
            switch (nPick)
            {
                case 0: sPrompt = "They look at you in shock. 'How dare you accuse me!'"; break;
                case 1: sPrompt = "'That's outrageous!' they exclaim, clearly offended."; break;
                case 2: sPrompt = "They recoil. 'I am no traitor!'"; break;
                case 3: sPrompt = "'You insult me with such claims!' they shout."; break;
                case 4: sPrompt = "They shake their head in disbelief. 'You're mistaken.'"; break;
            }
        }
    }
    else if (sPage == END_PAGE)
    {
        switch (nPick)
        {
            case 0: sPrompt = "Farewell."; break;
            case 1: sPrompt = "Safe travels."; break;
            case 2: sPrompt = "Until next time."; break;
            case 3: sPrompt = "Be well."; break;
            case 4: sPrompt = "Goodbye."; break;
        }
    }

    SetDlgPrompt(sPrompt);
}

void PageInit()
{
    object oPC = GetPcDlgSpeaker();
    object oNPC = OBJECT_SELF;
    string sPage = GetDlgPageString();
	string sQuestTag = GetLocalString(oNPC, "quest1name");

    string sAgentTag = GetPersistentString(oPC, sQuestTag + TARGET_TAG);
    int bIsAgent = (GetTag(oNPC) == sAgentTag);

    if (sPage == "")
    {
        SetRandomPrompt("");
        SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
    }
    else if (sPage == SUCCESS_PAGE)
    {
        SetRandomPrompt(SUCCESS_PAGE, bIsAgent);
        SetDlgResponseList(SUCCESS_PAGE, OBJECT_SELF);
    }
    else if (sPage == FAIL_PAGE)
    {
        SetRandomPrompt(FAIL_PAGE);
        SetDlgResponseList(FAIL_PAGE, OBJECT_SELF);
    }
    else if (sPage == ACCUSE_PAGE)
    {
        SetRandomPrompt(ACCUSE_PAGE, bIsAgent);
        if (bIsAgent)
        {
            AssignCommand(oNPC, gsCBDetermineCombatRound(oPC));
			DoneQuest(1);
            SetDlgResponseList(ACCUSE_PAGE, OBJECT_SELF);
        }
        else
        {
			TakeRepPoint(oPC, GetPCFaction(oPC), TRUE);
            SetDlgResponseList(DENY_PAGE, OBJECT_SELF);
        }
    }
    else if (sPage == DENY_PAGE)
    {
        SetRandomPrompt(DENY_PAGE);
        SetDlgResponseList(DENY_PAGE, OBJECT_SELF);
    }
    else if (sPage == END_PAGE)
    {
        SetRandomPrompt(END_PAGE);
        SetDlgResponseList(END_PAGE, OBJECT_SELF);
    }
    else
    {
        SendMessageToPC(oPC, "You've found a bug. Please report it.");
        EndDlg();
    }
}

void HandleSelection()
{
    int selection = GetDlgSelection();
    object oPC = GetPcDlgSpeaker();
    string sPage = GetDlgPageString();
	int nBaseDC = GetLocalInt(OBJECT_SELF, "DC");
	if (!nBaseDC) nBaseDC = 15;

    if (sPage == "")
    {
        switch (selection)
        {
            case 0: SetDlgPageString(END_PAGE); break;
            case 1:
            {
                int nSkill = GetSkillRank(SKILL_SENSE_MOTIVE, oPC);
                int nRoll = d20();
                int nDC = nBaseDC + d4();
                if ((nRoll + nSkill) >= nDC)
                    SetDlgPageString(SUCCESS_PAGE);
                else
                    SetDlgPageString(FAIL_PAGE);
                break;
            }
            case 2: SetDlgPageString(ACCUSE_PAGE); break;
        }
    }
    else if (sPage == SUCCESS_PAGE || sPage == FAIL_PAGE || sPage == ACCUSE_PAGE || sPage == END_PAGE)
    {
        EndDlg();
    }
    else
    {
        SendMessageToPC(oPC, "You've found a bug. Please report it.");
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

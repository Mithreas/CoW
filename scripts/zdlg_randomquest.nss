/*
  Name: zdlg_randomquest
  Author: Mithreas
  Date: Apr 9 2006
  Description: Random quest conversation script. Uses Z-Dialog.
*/
#include "zdlg_include_i"
#include "inc_randomquest"
  // inc_randomquest includes inc_database, inc_reputation and inc_log
#include "nw_i0_generic"

// response options
const string GREETING    = "greeting";
const string MAIN_MENU   = "main_options";
const string REPLY1      = "reply_1";
const string REPLY2      = "reply_2";
const string REPLY3      = "reply_3";
const string REPLY4      = "reply_4";
const string REPLY5      = "reply_5";

// pages
const string INITBRIEF   = "InitialBriefing";
const string BRIEFING    = "Briefing";
const string REFUSED     = "Refused";
const string DONE        = "Done";
const string NOT_DONE    = "Not_done";

void Init()
{
  // PC responses to briefing.
  if (GetElementCount(GREETING) == 0)
  {
    AddStringElement("I'm here to offer my services. Can I help you with anything?", GREETING);
    AddStringElement("Unfortunately, I'm needed elsewhere. Farewell.", GREETING);
    AddStringElement("Can you tell me more about the City?", GREETING);
  }

  // PC responses to task briefing.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("Yes, I'll do it.", MAIN_MENU);
    AddStringElement("Sorry, I don't think I'm up to that...",
                     MAIN_MENU);
  }

  // Responses to the second briefing.
  if (GetElementCount(REPLY2) == 0)
  {
    AddStringElement("Right. I'll be back soon.",
                     REPLY2);
    AddStringElement("Erm, sorry, I don't think I can do that after all.",
                     REPLY2);
  }

  // Responses to the "do you want another quest" prompt.
  if (GetElementCount(REPLY3) == 0)
  {
    AddStringElement("Yes, please.",
                     REPLY3);
    AddStringElement("I need to spend some time in reflection.",
                     REPLY3);
  }

  // Responses to the "do you need a reminder" prompt.
  if (GetElementCount(REPLY4) == 0)
  {
    AddStringElement("Yes, please.",
                     REPLY4);
    AddStringElement("Ah, no, sorry. I'll be back shortly.",
                     REPLY4);
  }

  // A handy "end" prompt.
  if (GetElementCount(REPLY5) == 0)
  {
    AddStringElement("Leave.",
                     REPLY5);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  string sQuestSet = GetLocalString(OBJECT_SELF, QUEST_DB_NAME);

  if (sQuestSet == "")
  {
    Trace(RQUEST, "No QUEST_DB_NAME var found on NPC!");
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
    return;
  }

  // Databases.
  string sQuestDB  = sQuestSet + QUEST_DB;
  string sVarsDB   = sQuestSet + QUEST_VAR_DB;
  string sPlayerDB = sQuestSet + QUEST_PLAYER_DB;

  string sCurrentQuest = GetPersistentString(oPC, CURRENT_QUEST);
  Trace(RQUEST, "Got current quest for PC " + GetName(oPC) + ": " + sCurrentQuest);

  if (sPage == "")
  {
    // Check whether PC is doing a quest, and if so, what sort of quest it is.
    // If no quest, greet.
    int nNPCFaction = CheckFactionNation(OBJECT_SELF);
    int nPCFaction  = GetPCFaction(oPC);
    Trace(RQUEST, "NPC faction: "+IntToString(nNPCFaction) +
                  ", PC faction: " + IntToString(nPCFaction));

    if (nPCFaction == nNPCFaction)
    {
      if (sCurrentQuest == "")
      {
        // Greet the PC
        string sCurrentRank = GetPCFactionRank(oPC);
        SetDlgPrompt("Welcome in the names of the Seven Divines, "+sCurrentRank+" "+
        GetName(oPC)+". Are you here to talk about the City of Winds? Or perhaps to "+
        "offer your services?");
        SetDlgResponseList(GREETING, OBJECT_SELF);
      }
      else
      {
        // Got a quest. What sort is it?
        string sQuestType = GetPersistentString(OBJECT_INVALID, sCurrentQuest, sQuestDB);
        Trace(RQUEST, "Got quest type of: " + sQuestType);
        DeleteList(REPLY1);

        if (sQuestType == RETRIEVE)
        {
          SetDlgPrompt("Have you got what I asked for?");

          // Responses
          AddStringElement("Yes, I have it here with me.",
                           REPLY1);
          AddStringElement("Sorry, can you tell me what I'm meant to fetch again?",
                           REPLY1);
          AddStringElement("Not yet, sorry.",
                           REPLY1);

        }
        else if (sQuestType == KILL)
        {
          SetDlgPrompt("Is my little problem resolved?");

          // Responses
          AddStringElement("Yes... it shouldn't bother you any more.",
                           REPLY1);
          AddStringElement("Sorry, can you tell me, ah, who your problem was again?",
                           REPLY1);
          AddStringElement("Not yet, sorry.",
                           REPLY1);
        }
        else if (sQuestType == MESSENGER)
        {
          SetDlgPrompt("Ah, I've been waiting for you. Is everything taken care of?");

          // Responses
          AddStringElement("Yes, all done.",
                           REPLY1);
          AddStringElement("Sorry, can you tell me what I'm meant to do again?",
                           REPLY1);
          AddStringElement("Not yet, sorry.",
                           REPLY1);
        }
        else if (sQuestType == HELP)
        {
          SetDlgPrompt("Did you sort everything out?");

          // Responses
          AddStringElement("Yes, all done.",
                           REPLY1);
          AddStringElement("Sorry, can you tell me what I'm meant to do again?",
                           REPLY1);
          AddStringElement("Not yet, sorry.",
                           REPLY1);
        }
        else if (sQuestType == PATROL)
        {
          SetDlgPrompt("Do you have a report for me?");

          // Responses
          AddStringElement("Yes, I've been everywhere you asked.",
                           REPLY1);
          AddStringElement("Sorry, can you tell me where I'm meant to go again?",
                           REPLY1);
          AddStringElement("Not yet, sorry.",
                           REPLY1);
        }
        else
        {
          SendMessageToPC(oPC,
                      "You've found a bug. How embarassing. Please report it.");
          Trace(RQUEST, "!!!Invalid quest type!");
          EndDlg();
        }

        SetDlgResponseList(REPLY1, OBJECT_SELF);
      }
    }
    else
    {
      SetDlgPrompt("You are not welcome here. Kindly leave the facility.");
      SetDlgResponseList(REPLY5, OBJECT_SELF);
    }

  }
  else if (sPage == INITBRIEF)
  {

    // No quest so create one.
    string sNewQuest = GenerateNewQuest(oPC, OBJECT_SELF);

    if (sNewQuest == "")
    {
      //Error generating quest, or none left.
      SetDlgPrompt("Sorry, I don't have anything for you right now.");
      SetDlgResponseList(REPLY5, OBJECT_SELF);
    }
    else
    {
      Trace(RQUEST, "Got new quest: " + sNewQuest);
      SetDlgPrompt("Here's a task you should be able to do. " +
                   GetPersistentString(OBJECT_INVALID,
                                       sNewQuest + DESCRIPTION,
                                       sVarsDB));
      SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
    }
  }
  else if (sPage == BRIEFING)
  {
    Trace(RQUEST, "Playing briefing.");
    SetDlgPrompt(GetPersistentString(OBJECT_INVALID,
                                     sCurrentQuest + DESCRIPTION,
                                     sVarsDB));
    SetDlgResponseList(REPLY2, OBJECT_SELF);
  }
  else if (sPage == REFUSED)
  {
    Trace(RQUEST, "Player refused quest.");
    SetDlgPrompt("Disappointing. Well, do you want something else to do?");
    SetDlgResponseList(REPLY3, OBJECT_SELF);
  }
  else if (sPage == DONE)
  {
    Trace(RQUEST, "Player completed quest.");
    SetDlgPrompt("Well done. Do you want something else to do?");
    SetDlgResponseList(REPLY3, OBJECT_SELF);
  }
  else if (sPage == NOT_DONE)
  {
    // What sort is our quest?
    string sQuestType = GetPersistentString(OBJECT_INVALID, sCurrentQuest, sQuestDB);
    Trace(RQUEST, "Got quest type of: " + sQuestType);

    if (sQuestType == RETRIEVE)
    {
      SetDlgPrompt("You don't seem to have what I asked for... do you need a reminder?");
    }
    else if (sQuestType == KILL)
    {
      SetDlgPrompt("I don't believe you have dealt with my problem... do you need a reminder?");
    }
    else if (sQuestType == MESSENGER)
    {
      SetDlgPrompt("No, you're not done yet. Do you need reminding of what you're meant to be doing?");
    }
    else if (sQuestType == HELP)
    {
      SetDlgPrompt("I received word only a couple of minutes ago that the " +
      "problem isn't solved yet. Do you need a reminder of what I asked you to do?");
    }
    else if (sQuestType == PATROL)
    {
      SetDlgPrompt("Your report doesn't cover all the areas. Do you need a reminder?");
    }
    else
    {
      SendMessageToPC(oPC,
                      "You've found a bug. How embarassing. Please report it.");
      Trace(RQUEST, "!!!Invalid quest type!");
      EndDlg();
    }

     SetDlgResponseList(REPLY4, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }

}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sResponseList   = GetDlgResponseList();

  if (sResponseList == GREETING)
  {
    switch (selection)
    {
      case 0:  // offer to help -> briefing
        SetDlgPageString(INITBRIEF);
        break;
      case 1:
        EndDlg();
        break;
      case 2:
        SpeakString("I'm afraid I don't have time to chat at the moment.");
        EndDlg();
        break;
    }
  }
  else if (sResponseList == MAIN_MENU)
  {
    switch (selection)
    {
      case 0:
        // Quest accepted. Now set it up...
        {
          SetUpQuest(oPC, OBJECT_SELF);
          EndDlg();
          break;
        }
      case 1:
        // Quest refused.
        {
          TakeRepPoint(oPC, CheckFactionNation(OBJECT_SELF));
          TidyQuest(oPC, OBJECT_SELF);
          SetDlgPageString(REFUSED);
          break;
        }
    }
  }
  else if (sResponseList == REPLY1)
  {
    switch (selection)
    {
      case 0:
      {
        // PC claims to be done. Check and clean up.
        if (QuestIsDone(oPC, OBJECT_SELF))
        {
          GivePointsToFaction(10, GetPCFaction(oPC));
          SetDlgPageString(DONE);
        }
        else
        {
          SetDlgPageString(NOT_DONE);
        }

        break;
      }
      case 1:
      {
        // Wants a briefing reminder.
        SetDlgPageString(BRIEFING);
        break;
      }
      case 2:
      {
        // Still working on it.
        EndDlg();
        break;
      }
    }

  }
  else if (sResponseList == REPLY2)
  {
    switch (selection)
    {
      case 0:
      {
        // PC has been rebriefed, and sent out into the world.
        EndDlg();
        break;
      }
      case 1:
      {
        // Backing out.
        TakeRepPoint(oPC, CheckFactionNation(OBJECT_SELF));
        TidyQuest(oPC, OBJECT_SELF);
        SetDlgPageString(REFUSED);
        break;
      }
    }
  }
  else if (sResponseList == REPLY3)
  {
    switch (selection)
    {
      case 0:
      {
        // PC wants another quest. Go back to the initial briefing and generate
        // a new one.
        SetDlgPageString(INITBRIEF);
        break;
      }
      case 1:
      {
        // PC doesn't want another quest right now.
        EndDlg();
        break;
      }
    }
  }
  else if (sResponseList == REPLY4)
  {
    switch (selection)
    {
      case 0:
      {
        // PC wants a rebrief.
        SetDlgPageString(BRIEFING);
        break;
      }
      case 1:
      {
        // PC doesn't want a rebrief.
        EndDlg();
        break;
      }
    }
  }
  else if (sResponseList == REPLY5)
  {
    EndDlg();
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
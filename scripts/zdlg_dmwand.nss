/*
  Name: zdlg_dmwand
  Author: Mithreas, converted to Z-Dialog from Gigaschatten's legacy convo.
  Description: DM player wand conversation script. Uses Z-Dialog.

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "inc_external"
#include "gs_inc_craft"
#include "gs_inc_finance"
#include "gs_inc_language"
#include "gs_inc_listener"
#include "gs_inc_xp"
#include "inc_log"
#include "inc_tells"
#include "zdlg_include_i"
#include "zzdlg_color_inc"

//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------
const string DMWAND    = "DMWAND"; // for tracing

const string OPTIONS     = "options";
const string CONFIRM     = "confirmation";
const string XP_AMOUNT   = "xp_amount";
const string RP_RATINGS  = "rp_ratings";
const string PIETY       = "piety_modifiers";
const string ACTION      = "action";

const string CONFIRM_PAGE = "CONFIRM_PAGE";
const string REWARD_PAGE  = "REWARD_PAGE";
const string RATE_RP_PAGE = "RATE_RP_PAGE";
const string A_PIETY_PAGE = "ADJUST_PIETY_PAGE";
const string LANGUAGE_PAGE = "LANGUAGE_PAGE";

const string ACTIONS   = "ACTIONS";
const string ACTION_0  = "Reward Party";
const string ACTION_1  = "Reward Player";
const string ACTION_2  = "Punish Player";
const string ACTION_3  = "Rate Roleplay";
const string ACTION_4  = "Reset Trade Skills";
const string ACTION_5  = "Find Corpse (if dead)";
const string ACTION_6  = "Follow";
const string ACTION_7  = "(Un)Highlight Player Text";
const string ACTION_8  = "Correct PC movement";
const string ACTION_9  = "(Dis/En)able non-DM Tells";
const string ACTION_10 = "Adjust PC Piety";
const string ACTION_11 = "Set creature tail model";
const string ACTION_12 = "Language";

//------------------------------------------------------------------------------
// Utility methods
//------------------------------------------------------------------------------
void gsFollow(object oTarget)
{
    if (! GetIsObjectValid(oTarget)) return;

    if (GetArea(OBJECT_SELF) != GetArea(oTarget))
        ActionJumpToObject(oTarget);
    else if (GetDistanceToObject(oTarget) > 5.0)
        ActionForceMoveToObject(oTarget, TRUE, 4.0, 12.0);
    else
        ActionWait(6.0);
    ActionDoCommand(gsFollow(oTarget));
}

string gsGetAlignmentAsString(object oTarget)
{
  string sReturn;

  switch (GetAlignmentLawChaos(oTarget))
  {
    case ALIGNMENT_LAWFUL:
      sReturn = GS_T_16777396;
      break;

    case ALIGNMENT_NEUTRAL:
      sReturn = GS_T_16777397;
      break;

    case ALIGNMENT_CHAOTIC:
      sReturn = GS_T_16777398;
      break;
  }

  sReturn += " ";

  switch (GetAlignmentGoodEvil(oTarget))
  {
    case ALIGNMENT_GOOD:
      sReturn += GS_T_16777399;
      break;

    case ALIGNMENT_NEUTRAL:
      sReturn += GS_T_16777400;
      break;

    case ALIGNMENT_EVIL:
      sReturn += GS_T_16777401;
      break;
  }

  return sReturn;
}

string gsGetPartyMembers(object oTarget)
{
  string sString = "";
  object oMember = GetFirstFactionMember(oTarget);

  while (GetIsObjectValid(oMember))
  {
    sString += GetName(oMember) + ", ";
    oMember  = GetNextFactionMember(oTarget);
  }

  return sString;
}

string miGetMarks(object oTarget)
{
  string sReturn = "";
  if (GetIsObjectValid(GetItemPossessedBy(oTarget, "mi_mark_despair")))
  {
    sReturn = "Mark of Despair ";
  }

  if (GetIsObjectValid(GetItemPossessedBy(oTarget, "mi_mark_destiny")))
  {
    sReturn = "Mark of Destiny ";
  }

  return sReturn;
}

void gsJumpToCorpse(object oTarget)
{
    if (GetIsObjectValid(oTarget))
    {
        object oCorpse = GetLocalObject(oTarget, "GS_CORPSE");

        if (GetIsObjectValid(oCorpse))
        {
            object oPossessor = OBJECT_INVALID;

            switch (GetObjectType(oCorpse))
            {
            case OBJECT_TYPE_ITEM:
                oPossessor = GetItemPossessor(oCorpse);
                if (GetIsObjectValid(oPossessor)) oCorpse = oPossessor;
                break;

            case OBJECT_TYPE_PLACEABLE:
                break;

            default:
                return;
            }

            JumpToObject(oCorpse);
        }
        else
        {
          SendMessageToPC(OBJECT_SELF, GetName(oTarget) + " has no corpse.");
        }
    }
}

string getOptionalInfo(object oPC)
{
  string sOptional = "";

  if (miTEGetTellsDisabled(oPC))
  {
    sOptional += "Tells disabled.";
  }

  return sOptional;
}

void DoTailModelChange()
{
  object oDM   = GetPcDlgSpeaker();
  object oPC   = GetLocalObject(OBJECT_SELF, "GS_TARGET");

  int nTail = StringToInt(gsLIGetLastMessage(oDM));
  SetCreatureTailType(nTail, oPC);
  SendMessageToPC(oDM, "Tail appearance set to " + IntToString(nTail));
}

//------------------------------------------------------------------------------
// Dialog methods
//------------------------------------------------------------------------------
void Init()
{
  // This method is called once, at the start of the conversation.
  Trace(DMWAND, "DM wand conversation initialising.");

  // Action array, created for easy reference in the conversation.
  if (GetElementCount(ACTIONS) == 0)
  {
    AddStringElement(ACTION_0, ACTIONS);
    AddStringElement(ACTION_1, ACTIONS);
    AddStringElement(ACTION_2, ACTIONS);
    AddStringElement(ACTION_3, ACTIONS);
    AddStringElement(ACTION_4, ACTIONS);
    AddStringElement(ACTION_5, ACTIONS);
    AddStringElement(ACTION_6, ACTIONS);
    AddStringElement(ACTION_7, ACTIONS);
    AddStringElement(ACTION_8, ACTIONS);
    AddStringElement(ACTION_9, ACTIONS);
    AddStringElement(ACTION_10, ACTIONS);
    AddStringElement(ACTION_11, ACTIONS);
    AddStringElement(ACTION_12, ACTIONS);
  }

  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement("<c þ >[" + ACTION_0 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_1 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_2 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_3 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_4 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_5 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_6 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_7 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_8 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_9 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_10 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_11 + "]</c>", OPTIONS);
    AddStringElement("<c þ >[" + ACTION_12 + "]</c>", OPTIONS);
    AddStringElement("<cþ  >[Back]</c>", OPTIONS);
  }

  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Select]</c>", CONFIRM);
    AddStringElement("<cþ  >[Back]</c>", CONFIRM);
  }

  if (GetElementCount(XP_AMOUNT) == 0)
  {
    AddStringElement("50", XP_AMOUNT);
    AddStringElement("100", XP_AMOUNT);
    AddStringElement("250", XP_AMOUNT);
    AddStringElement("500", XP_AMOUNT);
    AddStringElement("1000", XP_AMOUNT);
    AddStringElement("2000", XP_AMOUNT);
  }

  if (GetElementCount(RP_RATINGS) == 0)
  {
    AddStringElement("0", RP_RATINGS);
    AddStringElement("10", RP_RATINGS);
    AddStringElement("20", RP_RATINGS);
    AddStringElement("30", RP_RATINGS);
    AddStringElement("40", RP_RATINGS);
  }

  if (GetElementCount(PIETY) == 0)
  {
    AddStringElement("-25", PIETY);
    AddStringElement("-10", PIETY);
    AddStringElement("+10", PIETY);
    AddStringElement("+25", PIETY);
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oDM   = GetPcDlgSpeaker();
  object oPC   = GetLocalObject(OBJECT_SELF, "GS_TARGET");
  int nAction  = GetLocalInt(OBJECT_SELF, ACTION);

  Trace(DMWAND, "Setting up dialog page: " + sPage);

  string sPlayerStats =
   "Name : " + GetName(oPC) +
   "\nAlignment: " + gsGetAlignmentAsString(oPC) +
   "\nDeity: " + GetDeity(oPC) +
   "\nExperience: " + IntToString(GetXP(oPC)) + "/" + IntToString(GetHitDice(oPC) * (GetHitDice(oPC) + 1) / 2 * 1000) +
   "\nRP Rating: " + IntToString(gsPCGetRolePlay(oPC)) +
   "\nPiety: " + FloatToString(gsWOGetPiety(oPC), 1, 0) +
   "%\nGold: " + IntToString(GetGold (oPC)) + "/" + IntToString(gsFIGetBalance(oPC)) +
   "\nParty Members: " + gsGetPartyMembers(oPC) +
   "\nCD Key: " + GetPCPublicCDKey(oPC, TRUE) +
   "\nIP Address: " + GetPCIPAddress(oPC) +
   "\nMark: " + miGetMarks(oPC) + getOptionalInfo(oPC) +
   "\n\nNote - alignment change now accessed from the DMFI DM wand (pink flower)";

  if (sPage == "")
  {
    SetDlgPrompt(sPlayerStats);
    SetDlgResponseList(OPTIONS, OBJECT_SELF);
  }
  else if (sPage == CONFIRM_PAGE)
  {
    SetDlgPrompt("Action: " + GetStringElement(nAction, ACTIONS));
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == REWARD_PAGE)
  {
    SetDlgPrompt(GetStringElement(nAction, ACTIONS) + "\n\n" + sPlayerStats);
    SetDlgResponseList(XP_AMOUNT);
  }
  else if (sPage == RATE_RP_PAGE)
  {
    SetDlgPrompt(GetStringElement(nAction, ACTIONS) + "\n\n" + sPlayerStats);
    SetDlgResponseList(RP_RATINGS);
  }
  else if (sPage == A_PIETY_PAGE)
  {
    SetDlgPrompt(GetStringElement(nAction, ACTIONS) + "\n\n" + sPlayerStats);
    SetDlgResponseList(PIETY);
  }
  else if(sPage == LANGUAGE_PAGE)
  {
    object oHide = gsPCGetCreatureHide(oPC);
    SetDlgPrompt(GetStringElement(nAction, ACTIONS) + "\n\n" + "Green: Natural Speaker. Selection does nothing.\n"  +
      "Red: Knows language, possibly learned it. Selection removes language.\n" +
      "Blue: Does not know language. Selection grants language.\n" +
      "Language Count: " + IntToString(GetLocalInt(oHide, "GS_LA_LANGUAGES")) + "/" +
      IntToString(gsCMGetBaseAbilityModifier(oPC, ABILITY_INTELLIGENCE) + (GetLocalInt(oHide, "GIFT_OF_TONGUES") == 1 ? 4:0)));



    DeleteList(LANGUAGE_PAGE);
    int x;
    string sColor;
    string sTag;
    if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {
       AddStringElement("The PC is polymorphed, please wait until (s)he has reverted and select this option to reload this conversation tree.", LANGUAGE_PAGE);
    }
    else
    {
      for(x = 1; x<= GS_LA_LANGUAGE_LAST;x++)
      {
        sTag = "GS_LA_LANGUAGE_" + IntToString(x);
        if(_gsLAGetCanSpeakLanguage(x, oPC, oHide, sTag))
            sColor = txtGreen;
        else if(GetLocalInt(oHide, sTag))
            sColor = txtRed;
        else
            sColor = txtBlue;

        AddStringElement(sColor+gsLAGetLanguageName(x)+"</c> [" + IntToString(GetLocalInt(oHide, "PROGRESS_" + IntToString(x))) + "]", LANGUAGE_PAGE);
      }
    }

    SetDlgResponseList(LANGUAGE_PAGE);
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
  // This method handles what happens when the player selects an option.
  int selection = GetDlgSelection();
  int nAction   = GetLocalInt(OBJECT_SELF, ACTION);
  object oDM    = GetPcDlgSpeaker();
  object oPC    = GetLocalObject(OBJECT_SELF, "GS_TARGET");
  string sPage  = GetDlgPageString();

  if (!GetIsObjectValid(oPC))
  {
    // PC has logged off.
    EndDlg();
    return;
  }

  Trace(DMWAND, "Player has selected an option: " + IntToString(selection));
  Trace(DMWAND, "Page: " + sPage);
  if (sPage == "")
  {
    SetLocalInt(OBJECT_SELF, ACTION, selection);
    switch (selection)
    {
      case 0:
      case 1:
      case 2:
        SetDlgPageString(REWARD_PAGE);
        break;
      case 3:
        SetDlgPageString(RATE_RP_PAGE);
        break;
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        SetDlgPageString(CONFIRM_PAGE);
        break;
      case 10:
        SetDlgPageString(A_PIETY_PAGE);
        break;
      case 11:
        DoTailModelChange();
        break;
      case 12:
        SetDlgPageString(LANGUAGE_PAGE);
        break;
      case 13:
        EndDlg();
        break;
    }
  }
  else if (sPage == CONFIRM_PAGE)
  {
    switch (selection)
    {
      case 0:
      {
        // OK
        switch  (nAction)
        {
          case 4:  // Reset trade skills
            DMLog(oDM, oPC, "Reset trade skills");
            gsCRResetSkillRank(oPC);
            AssignCommand(oPC, ActionStartConversation(oPC, "gs_cr_recipe", TRUE, FALSE));
            break;
          case 5:  // Find corpse
            AssignCommand(oDM, gsJumpToCorpse(oPC));
            break;
          case 6:  // Follow PC
            AssignCommand(oDM, gsFollow(oPC));
            break;
          case 7: // (un)highlight text
          {
            string sDM = GetPCPlayerName(oDM);
            SetLocalInt(oPC, "MI_HIGHLIGHT_" + sDM, !GetLocalInt(oPC, "MI_HIGHLIGHT_" + sDM));
            break;
          }
          case 8: // Correct PC speed
            // reset the PC's speed. This fixes an issue we see occasionally with
            // people having bugged speed decreases due to armour.
            DMLog(oDM, oPC, "Correct PC speed");
            fbEXFixMovement(oPC);
            break;
          case 9: // (Dis/En)able non-DM Tells
            if (miTEGetTellsDisabled(oPC))
            {
              DMLog(oDM, oPC, "Unblock tells.");
              miTESetTellsDisabled(oPC, FALSE);
            }
            else
            {
              DMLog(oDM, oPC, "Block tells.");
              miTESetTellsDisabled(oPC, TRUE);
            }
            break;
          case 10: // Adjust piety
          {
              DMLog(oDM, oPC, "Adjust piety.");
              gsWOAdjustPiety(oPC, GetLocalFloat(oDM, "MOD_PIETY"));
              break;
          }
          default: // Other actions should not come through this page.
            SendMessageToPC(oPC,
                      "You've found a bug. How embarassing. Please report it.");
            EndDlg();
            break;
        }

        break;
      }
      case 1:
        // Back
        break;
    }

    // return to first page
    SetDlgPageString("");
  }
  else if (sPage == REWARD_PAGE)
  {
    int nAmount = StringToInt(GetStringElement(selection, XP_AMOUNT));

    switch (nAction)
    {
      case 0: // reward party
        DMLog(oDM, oPC, "Reward party: " + IntToString(nAmount));
        gsXPApply(oPC, nAmount, TRUE);
        break;
      case 1: // reward player
        DMLog(oDM, oPC, "Reward player: " + IntToString(nAmount));
        gsXPApply(oPC, nAmount, FALSE);
        break;
      case 2: // punish player
        DMLog(oDM, oPC, "Punish player: " + IntToString(nAmount));
        gsXPApply(oPC, -1 * nAmount, FALSE);
        break;
      default: // we shouldn't end up here for other actions.
        SendMessageToPC(oPC,
                      "You've found a bug. How embarassing. Please report it.");
        EndDlg();
        break;
    }

    SetDlgPageString("");
  }
  else if (sPage == RATE_RP_PAGE)
  {
    int nAmount = StringToInt(GetStringElement(selection, RP_RATINGS));
    DMLog(oDM, oPC, "Set RPR: " + IntToString(nAmount));
    gsPCSetRolePlay(oPC, nAmount);
    SetDlgPageString("");
  }
  else if (sPage == A_PIETY_PAGE)
  {
    float fPietyMod = 0.0;
    switch (selection)
    {
      case 0:  fPietyMod = -25.0; break;
      case 1:  fPietyMod = -10.0; break;
      case 2:  fPietyMod = 10.0; break;
      case 3:  fPietyMod = 25.0; break;
    }

    SetLocalFloat(oDM, "MOD_PIETY", fPietyMod);
    SetDlgPageString(CONFIRM_PAGE);
  }
  else if(sPage == LANGUAGE_PAGE)
  {
    selection += 1; //as selection starts at 0
    string sTag = "GS_LA_LANGUAGE_" + IntToString(selection);
    object oHide = gsPCGetCreatureHide(oPC);
    if(!_gsLAGetCanSpeakLanguage(selection, oPC, oHide, sTag))
    {
        if(GetLocalInt(oHide, sTag))
        {
          DeleteLocalInt(oHide, sTag);
          SendMessageToPC(oDM, gsLAGetLanguageName(selection) + " removed.");
        }
        else
        {
          SetLocalInt(oHide, sTag, 1);
          SendMessageToPC(oDM, gsLAGetLanguageName(selection) + " granted.");
        }
    }
  }
}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
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

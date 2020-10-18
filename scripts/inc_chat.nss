/*
inc_chat

Chat library, contains all functions required for managing the chat, working
alongside the chat scipt. Most of these methods are used by the chat_script or
are internal only.
*/

#include "__server_config"
#include "inc_chatalias"
#include "inc_chatcomm"
#include "inc_chatutils"
#include "inc_combat2"
#include "inc_language"
#include "inc_vampire"
#include "inc_class"
#include "inc_climb"
#include "inc_divination"
#include "inc_relations"
#include "inc_customspells"
#include "inc_tells"
#include "inc_xfer"
#include "inc_log"
#include "nwnx_chat"
#include "x0_i0_match"
#include "x3_inc_string"
#include "zzdlg_lists_inc"
#include "inc_pc"

struct fbCHChat
{
  object oSpeaker;
  object oTarget;
  string sText;
  int nChannel;
  int bIgnore;
};

const string CHAT_SCRIPT = "ar_chat";
const string CHAT    = "CHAT";         // for tracing

// Returns a chat structure with all the necessary information about the line of
// dialog spoken.
struct fbCHChat fbCHGetChat();
// Sends sText spoken by oSpeaker to oTarget to all DMs online.
void fbCHDistributeMessage(object oSpeaker, string sText, int nChannel);
// Parses the command given in stChat returning the actual command and its
// parameters.
struct fbCHCommand fbCHInterpretCommand(struct fbCHChat stChat);
// Causes oSpeaker to run stCommand, returning TRUE if such a command can be run
// or FALSE otherwise.
int fbCHRunCommand(struct fbCHCommand stCommand, object oSpeaker, int channel);
// Returns a string listing (separated by spaces) each command available to
// oSpeaker.
string fbCHCommandList(object oSpeaker);
// Suppresses the current line of dialog.
void fbCHMute(object oSpeaker);
// Changes the current language spoken by oSpeaker to sLanguage.
void fbCHSwitchLanguage(int nLanguage, object oSpeaker);
// Returns TRUE if nChannel is an IC channel, FALSE if it is an OOC channel.
int fbCHGetIsInCharacter(int nChannel);
// Returns the distance that a PC can hear text spoken from nChannel.
float fbCHGetChannelRange(int nChannel);
// Go through the routines required to translate and speak the chat given by
// stChat. Returns TRUE if the text spoken remains untouched, otherwise returns
// FALSE.
int fbCHSpeak(struct fbCHChat stChat);
// Attempt to rate nValue, 10 being average. If nInaccuracy is given, nValue will
// be rated within a boundary of width nInaccuracy.
string fbCHRateValue(object second, string sStat, int bBluffed);
// Get the result of a looks operation in string form.
string fbDoLooksAndGetString(object first, object second);
// Methods for dealing with emotes.
int fbCHEmote(object oSpeaker, string sString);
string GetPCDescriptionAttunement(object oExaminer, object oExaminee, int bDisguised = FALSE);

struct fbCHChat fbCHGetChat()
{
  struct fbCHChat stChat;
  stChat.bIgnore  = FALSE;
  stChat.nChannel = NWNX_Chat_GetChannel();
  stChat.oTarget = NWNX_Chat_GetTarget();
  stChat.oSpeaker = NWNX_Chat_GetSender();
  stChat.sText = NWNX_Chat_GetMessage();

  // Ignore some text
  if (GetStringLeft(stChat.sText, 6) == "GS_AI_")
  {
    // Don't mute - that stops AI from working.  But don't process further.
    // fbCHMute(stChat.oSpeaker);
    stChat.bIgnore = TRUE;
    return stChat;
  }

  // Forbidden channel
  if (stChat.nChannel == NWNX_CHAT_CHANNEL_PLAYER_PARTY)
  {
    fbCHMute(stChat.oSpeaker);
    SendMessageToPC(stChat.oSpeaker, txtRed + "Party chat is not allowed here, please keep OOC to Tells.</c>");
    stChat.bIgnore = TRUE;
    return stChat;
  }

  // BEGIN ADDITIONAL HOOKS

  // If this is a DM, check if they are renaming something.
  if (GetLocalInt(stChat.oSpeaker, "MI_NAMING"))
  {
    object oTarget = GetLocalObject(stChat.oSpeaker, "MI_NAME_TARGET");
    SetName(oTarget, stChat.sText);

    DeleteLocalInt(stChat.oSpeaker, "MI_NAMING");
    stChat.bIgnore = TRUE;
    fbCHMute(stChat.oSpeaker);
  }

  // If this is a DM, check if they are describing something.
  if (GetLocalInt(stChat.oSpeaker, "GVD_DM_DESCRIBE"))
  {
    object oTarget = GetLocalObject(stChat.oSpeaker, "GVD_DM_DESCRIBE_TARGET");
    SetDescription(oTarget, stChat.sText);

    DeleteLocalInt(stChat.oSpeaker, "GVD_DM_DESCRIBE");
    stChat.bIgnore = TRUE;
    fbCHMute(stChat.oSpeaker);
  }

  // If this is a DM, check if they are describing something.
  if (GetLocalInt(stChat.oSpeaker, "GVD_DM_DESCRIBE_ADD"))
  {
    object oTarget = GetLocalObject(stChat.oSpeaker, "GVD_DM_DESCRIBE_TARGET");
    SetDescription(oTarget, GetDescription(oTarget) + "\n\n" + stChat.sText);

    DeleteLocalInt(stChat.oSpeaker, "GVD_DM_DESCRIBE_ADD");
    stChat.bIgnore = TRUE;
    fbCHMute(stChat.oSpeaker);
  }

  // If this is a DM, check if they are setting the area's flavor text.
  if (GetLocalInt(stChat.oSpeaker, "BAT_SETTINGAREATEXT"))
  {
    DeleteLocalInt(stChat.oSpeaker, "BAT_SETTINGAREATEXT");

    if (stChat.sText == "-cancel")
    {
      SendMessageToPC(stChat.oSpeaker, "Canceled.");
    }
    else
    {
      object oArea = GetArea(stChat.oSpeaker);
      SetLocalString(oArea, "GS_TEXT", "[" + stChat.sText + "]");
      stChat.bIgnore = TRUE;
      fbCHMute(stChat.oSpeaker);
    }
  }

  // Check whether we're sending our image. If so, collect the text and move on.
  if (GetLocalInt(stChat.oSpeaker, "MI_SENDING"))
  {
    DeleteLocalInt(stChat.oSpeaker, "MI_SENDING");
    if (stChat.sText == "-cancel")
    {
      SendMessageToPC(stChat.oSpeaker, "Cancelled.");
    }
    else
    {
      miDoCastingAnimation(stChat.oSpeaker);
      if (GetIsObjectValid(GetLocalObject(stChat.oSpeaker, "MI_SEND_TARGET")))
      {
        Send_Image(stChat.oSpeaker, GetLocalObject(stChat.oSpeaker, "MI_SEND_TARGET"), stChat.sText);
        DeleteLocalObject(stChat.oSpeaker, "MI_SEND_TARGET");
      }
      else
      {
        miXFSendMessage(GetLocalString(stChat.oSpeaker, "MI_SEND_TARGET"),
                        GetLocalString(stChat.oSpeaker, "MI_SEND_TARGET_SERVER"),
                        "[" + GetName(stChat.oSpeaker) + "]: " + stChat.sText,
                        MESSAGE_TYPE_IMAGE);
        miSPHasCastSpell(stChat.oSpeaker, CUSTOM_SPELL_SEND_IMAGE);
      }

      SendMessageToPC(stChat.oSpeaker, stChat.sText);
    }

    stChat.bIgnore = TRUE;
    fbCHMute(stChat.oSpeaker);
  }

  // END ADDITIONAL HOOKS
  struct fbCHCommand igCommand = fbCHInterpretCommand(stChat);
  int censorOutput = FindSubString(stChat.sText, "-forum_password") != -1 || FindSubString("-"+igCommand.sText, "-usefeat") == 0;


  if (!censorOutput && !stChat.bIgnore && fbCHGetIsInCharacter(stChat.nChannel) && !GetIsDM(stChat.oSpeaker))
  {
    SetLocalInt(stChat.oSpeaker, "GS_ACTIVE", TRUE);
    fbCHDistributeMessage(stChat.oSpeaker, stChat.sText, stChat.nChannel);
  }

  if (!censorOutput && stChat.nChannel != NWNX_CHAT_CHANNEL_SERVER_MSG)
  {
      string sLog = GetName(stChat.oSpeaker) + "(" + GetPCPlayerName(stChat.oSpeaker) + ") ";
      sLog += chatGetChannelName(stChat.nChannel);

      if (stChat.oTarget != OBJECT_INVALID)
      {
        sLog += " -> " + GetName(stChat.oTarget) + "(" +  GetPCPlayerName(stChat.oTarget) + ")";
      }

      sLog += ": " + stChat.sText;

      if (stChat.bIgnore)
      {
        sLog += " (ignored)";
      }

      if (!censorOutput)
      {
        WriteTimestampedLogEntry(sLog);
      }
  }

  return stChat;
}
//----------------------------------------------------------------------------//
void fbCHDistributeMessage(object oSpeaker, string sText, int nChannel)
{
  string sLanguageName = gsLAGetLanguageName(GetLocalInt(oSpeaker, "CHAT_LANGUAGE"));
  string sChannel = chatGetChannelName(nChannel);
  string sColorCode = txtOrange;
  string sRoleplayRating = "N/A";
  if (GetIsPC(oSpeaker))
  {
    sRoleplayRating = IntToString(gsPCGetRolePlay(oSpeaker));
    switch(gsPCGetRolePlay(oSpeaker))
    {
        case 10: sColorCode = txtMaroon; break;
        case 20: sColorCode = txtOrange; break;
        case 30: sColorCode = txtGreen; break;
        case 40: sColorCode = txtAqua; break;
        default: sColorCode = txtOrange; break;
    }
  }
  string sMessage = sChannel + txtSilver + " [" + GetName(GetArea(oSpeaker)) +
                    "]</c> " + txtYellow + GetName(oSpeaker, TRUE) +
                    (GetIsPCDisguised(oSpeaker)? " (Disguised) </c>" : " </c>") +
                    sColorCode + "[" + sRoleplayRating + "]</c> " +
                    gsLAGetLanguageColor(GetLocalInt(oSpeaker, "CHAT_LANGUAGE")) +
                    sLanguageName + "</c>: " + txtWhite + sText + "</c>";

  string sHighlight = sChannel + txtSilver + " [" + GetName(GetArea(oSpeaker)) +
                      "]</c> " + txtYellow + GetName(oSpeaker, TRUE) +
                      (GetIsPCDisguised(oSpeaker)? " (Disguised) </c>" : " </c>") +
                      sColorCode + "[" + sRoleplayRating + "]</c> " +
                      gsLAGetLanguageColor(GetLocalInt(oSpeaker, "CHAT_LANGUAGE")) +
                      sLanguageName + "</c>: " + txtWhite + sText + "</c>";

  object oModule = GetModule();
  object oDM     = GetFirstObjectElement(FB_CH_DM_LIST, oModule);

  while (GetIsObjectValid(oDM))
  {
    int nFiltering = GetLocalInt(oDM, "MI_FILTERING_TEXT");
    int bHighlight = GetLocalInt(oSpeaker, "MI_HIGHLIGHT_" + GetPCPlayerName(oDM));
    int bNPCFilter = GetLocalInt(oDM, "SEP_FILTERING_NPC");
    string sRPR    = GetLocalString(oDM, "SEP_FILTERING_RPR");
    int bRPRFilter = GetLocalInt(oDM, "SEP_FILTERING_RPR_TOGGLE");
    if (sRPR == "")
    {
        sRPR = "0";
    }
    if (!nFiltering || bHighlight || GetArea(oSpeaker) == GetArea(oDM))
    {
      if (bHighlight)
      {
        SendMessageToPC(oDM, sHighlight);
      }
      // Filter RPR is turned on and the RPR does not match
      else if (bRPRFilter != 0 && GetIsPC(oSpeaker) && gsPCGetRolePlay(oSpeaker) != StringToInt(sRPR))
      {
        // Do nothing
      }
      // Filter NPC is turned on and the speaker is not a player or a familiar of a player
      else if (bNPCFilter &&
              (!GetIsPC(oSpeaker) || (!GetIsPC(GetMaster(oSpeaker)) && GetMaster(oSpeaker) != OBJECT_INVALID)))
      {
        // Do nothing
      }
      else
      {
        SendMessageToPC(oDM, sMessage);
      }
    }
    oDM = GetNextObjectElement();
  }
}
//----------------------------------------------------------------------------//
struct fbCHCommand fbCHInterpretCommand(struct fbCHChat stChat)
{
  struct fbCHCommand stCommand;

  string sText = chatGetStringFrom(stChat.sText);
  int nPos     = FindSubString(sText, " ");
  if (nPos == -1)
  {
    stCommand.sText = sText;
  }
  else
  {
    stCommand.sText   = GetStringLeft(sText, nPos);
    stCommand.sParams = chatGetStringFrom(sText, nPos + 1);
  }

  stCommand = chatResolveAlias(stCommand);

  stCommand.oSpeaker = stChat.oSpeaker;
  stCommand.oTarget  = stChat.oTarget;

  return stCommand;
}
//----------------------------------------------------------------------------//
int fbCHRunCommand(struct fbCHCommand stCommand, object oSpeaker, int channel)
{
  fbCHMute(oSpeaker);

  SetLocalInt(oSpeaker, "CHAT_CHANNEL", channel);
  SetLocalString(oSpeaker, "CHAT_PARAMS", stCommand.sParams);
  SetLocalObject(oSpeaker, "CHAT_TARGET", stCommand.oTarget);
  DeleteLocalInt(oSpeaker, "CHAT_RESULT");

  // Attempt to execute the script: it should set CHAT_RESULT to TRUE. Note: due
  // to bioware limitations, scripts can only be 16 characters long. Therefore,
  // commands cannot be more than 11 characters long. For instance, the
  // -delete_character command's script is called chat_delete_char. PCs may type
  // -delete_charabcdefghij and it will work just as well!
  if (GetStringLength(stCommand.sText) > 11)
  {
    stCommand.sText = GetStringLeft(stCommand.sText, 11);
  }
  ExecuteScript("chat_" + stCommand.sText, oSpeaker);
  return GetLocalInt(oSpeaker, "CHAT_RESULT");
}
//----------------------------------------------------------------------------//
void _prepareTempArrays()
{
    // We already have two arrays.
    //     ALIAS_ARRAY_KEY_TAG: {alias}.
    //     ALIAS_ARRAY_VALUE_TAG: {command}.
    //
    // We want to prepare a number of them for speed.
    //      ALIAS_ARRAY_COMMAND: {aliases}

    int aliasCount = StringArray_Size(GetModule(), ALIAS_ARRAY_KEY_TAG);

    int i;
    for (i = 0; i < aliasCount; ++i)
    {
        string alias = StringArray_At(GetModule(), ALIAS_ARRAY_KEY_TAG, i);
        string command = StringArray_At(GetModule(), ALIAS_ARRAY_VALUE_TAG, i);
        string firstPartOfCommand = StringParse(command);
        StringArray_PushBack(GetModule(), "ALIAS_ARRAY_" + firstPartOfCommand, alias);
    }
}
//----------------------------------------------------------------------------//
void _clearTempArrays()
{
    int aliasCount = StringArray_Size(GetModule(), ALIAS_ARRAY_KEY_TAG);

    int i;
    for (i = 0; i < aliasCount; ++i)
    {
        string command = StringArray_At(GetModule(), ALIAS_ARRAY_VALUE_TAG, i);
        string firstPartOfCommand = StringParse(command);
        StringArray_Clear(GetModule(), "ALIAS_ARRAY_" + firstPartOfCommand);
    }
}
//----------------------------------------------------------------------------//
string _fbCHPrepareChatCommand(string command, string colour)
{
    string formatted = StringToRGBString(command, colour);

    // Converts '-command' to 'command'.
    if (GetStringLeft(command, 1) == "-")
    {
        command = GetStringRight(command, GetStringLength(command) - 1);
    }

    string arrayName = "ALIAS_ARRAY_" + command;
    int aliasCount = StringArray_Size(GetModule(), arrayName);

    if (aliasCount)
    {
        StringArray_SortAscending(GetModule(), arrayName);
        string formattedAliases = "";

        int i;
        for (i = 0; i < aliasCount; ++i)
        {
            string alias = StringArray_At(GetModule(), arrayName, i);
            string formattedAlias = "-" + alias;

            if (i + 1 != aliasCount)
            {
                formattedAlias += ", ";
            }

            formattedAliases += chatCommandParameter(formattedAlias);
        }

        formatted += chatCommandParameter(" [") + formattedAliases + chatCommandParameter("]");
    }

    return formatted + "\n";
}
//----------------------------------------------------------------------------//
string fbCHCommandList(object oSpeaker)
{
  _prepareTempArrays();
    object oHide = gsPCGetCreatureHide(oSpeaker);

  string sList = "Player options:\n\n";

  sList += _fbCHPrepareChatCommand("-associate", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-balance",
    GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) ? STRING_COLOR_GREEN : STRING_COLOR_RED);

  sList += _fbCHPrepareChatCommand("-blind", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-cleanup", STRING_COLOR_GREEN);

  if (ALLOW_CLIMBING)
  {
    sList += _fbCHPrepareChatCommand("-climb",
      miCBGetCanClimb(oSpeaker) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }

  sList += _fbCHPrepareChatCommand("-colour_mode", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-console_mode", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-date", STRING_COLOR_GREEN);

  if (ALLOW_DELETE_CHARACTER)
  {
    sList += _fbCHPrepareChatCommand("-delete_character", STRING_COLOR_GREEN);
  }

  if (ALLOW_CHANGE_DESCRIPTION)
  {
    sList += _fbCHPrepareChatCommand("-description", STRING_COLOR_GREEN);
  }

  sList += _fbCHPrepareChatCommand("-detectevil",
    (GetDeity(oSpeaker) != "" && gsWOGetPiety(oSpeaker) >= 10.0 && GetAlignmentGoodEvil(oSpeaker) == ALIGNMENT_GOOD && GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_LAWFUL &&
    (GetLevelByClass(CLASS_TYPE_PALADIN, oSpeaker) || GetLocalInt(gsPCGetCreatureHide(oSpeaker), VAR_HARPER) == MI_CL_HARPER_PARAGON)) ? STRING_COLOR_GREEN :
     STRING_COLOR_RED);

  if (ALLOW_DISGUISE)
  {
    sList += _fbCHPrepareChatCommand("-disguise",
        GetCanPCDisguiseSelf(oSpeaker) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }

  sList += _fbCHPrepareChatCommand("-dispel", STRING_COLOR_GREEN);
  //rollback sList += _fbCHPrepareChatCommand("-onlinedrain", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-emote", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-emote_style", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-factions", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-fetch", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-follow", STRING_COLOR_GREEN);
  // sList += _fbCHPrepareChatCommand("-forum_password", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-guard", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-helm", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-hood", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-hostile", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-investigate", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-language", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-loadoutfit", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-losexp", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-makesafe", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-manual", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-meditate", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-mimic", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-move_fixture", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-name",
    GetLocalInt(GetArea(oSpeaker), "MI_RENAME") ? STRING_COLOR_GREEN : STRING_COLOR_RED);

  sList += _fbCHPrepareChatCommand("-notells", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-pickup_fixture", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-playerlist", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-polymorph", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-portrait",
    GetLocalInt(GetArea(oSpeaker), "MI_RENAME") ? STRING_COLOR_GREEN : STRING_COLOR_RED);

  sList += _fbCHPrepareChatCommand("-pray", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-prefix_mode", STRING_COLOR_GREEN);

  if (ALLOW_SENDING)
  {
    sList += _fbCHPrepareChatCommand("-project_image",
      (GetCanSendImage(oSpeaker) && !GetLocalInt(oHide, "SPELLSWORD")) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }
  
  sList += _fbCHPrepareChatCommand("-research", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-respite", (GetIsHealer(oSpeaker) && GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) >= 28) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  sList += _fbCHPrepareChatCommand("-reveal", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-revealparty", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-rotate_fixture", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-save", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-saveoutfit", STRING_COLOR_GREEN);

  if (ALLOW_SCRYING)
  {
    sList += _fbCHPrepareChatCommand("-scry",
      (GetCanScry(oSpeaker) && !GetLocalInt(oHide, "SPELLSWORD")) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }
  
  sList += _fbCHPrepareChatCommand("-secondwind", GetLevelByClass(CLASS_TYPE_FIGHTER, oSpeaker) ? STRING_COLOR_GREEN : STRING_COLOR_RED);

  sList += _fbCHPrepareChatCommand("-sense", 
             (GetLevelByClass(CLASS_TYPE_BARD, oSpeaker) || 
			  GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) ||
			  GetLevelByClass(CLASS_TYPE_RANGER, oSpeaker) ||
			  GetLevelByClass(CLASS_TYPE_SORCERER, oSpeaker) ||
			  GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker)) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
			  
  sList += _fbCHPrepareChatCommand("-soundset",
    GetLocalInt(GetArea(oSpeaker), "MI_RENAME") ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  sList += _fbCHPrepareChatCommand("-stream", STRING_COLOR_GREEN);
  
   // sList += _fbCHPrepareChatCommand("-subdual", STRING_COLOR_GREEN);
  
  if (ALLOW_TELEPORT)
  {
    sList += _fbCHPrepareChatCommand("-teleport",
      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oSpeaker) && !GetLocalInt(oHide, "SPELLSWORD")) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }

  sList += _fbCHPrepareChatCommand("-thrall", VampireIsVamp(oSpeaker) ? STRING_COLOR_RED : STRING_COLOR_GREEN);

  if (ALLOW_TRACKING)
  {
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oSpeaker));
    sList += _fbCHPrepareChatCommand("-track",
      (GetLevelByClass(CLASS_TYPE_HARPER, oSpeaker) || GetLevelByClass(CLASS_TYPE_RANGER, oSpeaker) ||
      nSubRace == GS_SU_GNOME_FOREST || nSubRace == GS_SU_DWARF_WILD || nSubRace == GS_SU_ELF_WILD || nSubRace == GS_SU_ELF_WOOD) ?
      STRING_COLOR_GREEN : STRING_COLOR_RED);
  }
  
  sList += _fbCHPrepareChatCommand("-train", STRING_COLOR_GREEN);

  sList += _fbCHPrepareChatCommand("-twohand",
      GetCreatureSize(oSpeaker) >= CREATURE_SIZE_MEDIUM ? STRING_COLOR_GREEN : STRING_COLOR_RED);

  sList += _fbCHPrepareChatCommand("-usefeat", STRING_COLOR_GREEN);
  sList += _fbCHPrepareChatCommand("-vampire", VampireIsVamp(oSpeaker) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  sList += _fbCHPrepareChatCommand("-walk", STRING_COLOR_GREEN);

  if (ALLOW_WARDING)
  {
    sList += _fbCHPrepareChatCommand("-ward",
      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oSpeaker) && !GetLocalInt(oHide, "SPELLSWORD")) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }

  if (ALLOW_YOINKING)
  {
    sList += _fbCHPrepareChatCommand("-yoink",
      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oSpeaker) && !GetLocalInt(oHide, "SPELLSWORD")) ? STRING_COLOR_GREEN : STRING_COLOR_RED);
  }


  if (GetIsDM(oSpeaker))
  {
    sList += "\nDM options:\n\n";
    sList += _fbCHPrepareChatCommand("-addgift", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-bombard", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-deities", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-filter_gold", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-filter_npc", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-filter_rpr", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-filter_shop", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-filter_text", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-forceactive", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-getgifts", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-gifts", STRING_COLOR_GREEN);
      sList += _fbCHPrepareChatCommand("-highlight", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-hoover_fixtures", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-jump", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-mark", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-names", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-removedrain", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-removegift", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-rp_ratings", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-setgift", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-setpvpcount", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-setsubrace", STRING_COLOR_GREEN);
    sList += _fbCHPrepareChatCommand("-uptime", STRING_COLOR_GREEN);
  }

  _clearTempArrays();

  return sList;
}
//----------------------------------------------------------------------------//
void fbCHMute(object oSpeaker)
{
  NWNX_Chat_SkipMessage();
}
//----------------------------------------------------------------------------//
void fbCHSwitchLanguage(int nLanguage, object oSpeaker)
{
  string sLanguageName = gsLAGetLanguageName(nLanguage);

  SetLocalInt(oSpeaker, "CHAT_LANGUAGE", nLanguage);
  SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777531, sLanguageName));
}
//----------------------------------------------------------------------------//
int fbCHGetIsInCharacter(int nChannel)
{
  return nChannel == NWNX_CHAT_CHANNEL_PLAYER_TALK ||
         nChannel == NWNX_CHAT_CHANNEL_PLAYER_WHISPER ||
         nChannel == NWNX_CHAT_CHANNEL_PLAYER_SHOUT;
}
//----------------------------------------------------------------------------//
float fbCHGetChannelRange(int nChannel)
{
  float fRange = 0.0;
  switch (nChannel)
  {
    case NWNX_CHAT_CHANNEL_PLAYER_WHISPER:
    case NWNX_CHAT_CHANNEL_DM_WHISPER:
      fRange = 3.0;
      break;
    case NWNX_CHAT_CHANNEL_PLAYER_TALK:
    case NWNX_CHAT_CHANNEL_DM_TALK:
      fRange = 20.0;
      break;
    case NWNX_CHAT_CHANNEL_PLAYER_SHOUT:
      fRange = 40.0;
      break;
  }

  return fRange;
}
int _CustomLoreCheck(object observer, int nRoll=TRUE)
{
    int loreRoll = GetSkillRank(SKILL_LORE, observer, TRUE) + GetAbilityModifier(ABILITY_INTELLIGENCE, observer);
    if(nRoll)
        loreRoll += d20();
    if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_LORE, observer))
        loreRoll += 10;
    if (GetHasFeat(FEAT_SKILL_FOCUS_LORE, observer))
        loreRoll += 3;
    if (GetHasFeat(FEAT_SKILL_AFFINITY_LORE, observer))
        loreRoll += 2;

    object oHide = gsPCGetCreatureHide(observer);
    // Add Bardic lore
    if (!GetLocalInt(oHide, VAR_WARLOCK))
        loreRoll += GetLevelByClass(CLASS_TYPE_BARD, observer);

    // Factor in backgrounds
    if (GetLocalInt(oHide, "MI_BACKGROUND") == 9 || GetLocalInt(oHide, "MI_BACKGROUND") == 15 || GetLocalInt(oHide, "MI_BACKGROUND") == 18 || GetLocalInt(oHide, "MI_BACKGROUND") == 23)
        loreRoll++;
    else if (GetLocalInt(oHide, "MI_BACKGROUND") == 10)
        loreRoll -= 2;

    // Raven Totem
    if (GetLocalInt(oHide, "MI_TOTEM") == 7)
        loreRoll += 10;

    return loreRoll;
}
//----------------------------------------------------------------------------//
void _fbCHOutputFinalText(object speaker, object observer, int channel, string untranslated, string translated, int languageId)
{
    // If colourMode == 0, we output untranslated and translated text with colour.
    // If colourMode == 1, we output untranslated text without colour, and translated text with colour.
    // If colourMode == 2, we output untranslated text with colour, and translated text without colour.
    // If colourMode == 3, we output untranslated and translated text without colour.
    int colourMode = GetLocalInt(gsPCGetCreatureHide(observer), "OUTPUT_COLOUR");

    if (colourMode == 1 || colourMode == 3)
    {
        untranslated = StripColourTokens(untranslated);
    }

    if (colourMode == 2 || colourMode == 3)
    {
        translated = StripColourTokens(translated);
    }

    // If we're listening to our own text, or we're a DM, we should always be able to read what's being said.
    // int loreRoll = gsCMGetBaseSkillRank(SKILL_LORE, IP_CONST_ABILITY_INT, observer) + d20();
    int loreRoll = _CustomLoreCheck(observer);


    int canSpeak = GetIsDM(observer) || observer == speaker;

    if (!canSpeak)
    {
        miREDoSpeech(observer, speaker);
        canSpeak = gsLAGetCanSpeakLanguage(languageId, observer, TRUE) || loreRoll > 40;
    }

    int languageIdForNamePrefix = languageId;

    // If we don't understand the language and it's Thieves Cant, pretend it's common.
    if (!canSpeak && languageIdForNamePrefix == GS_LA_LANGUAGE_THIEF)
    {
        languageIdForNamePrefix = GS_LA_LANGUAGE_COMMON;
    }

    int canSpeakForNamePrefix = gsLAGetCanSpeakLanguage(languageIdForNamePrefix, observer) || loreRoll > 21;
    string languageName = canSpeakForNamePrefix ? gsLAGetLanguageName(languageIdForNamePrefix) : "Unknown";

    // If prefixMode == 0, we always write the prefix.
    // If prefixMode == 1, we only write the prefix if it isn't common.
    // If prefixMode == 2, we do not write the prefix at all.
    string languageNamePrefix = "";
    int prefixMode = GetLocalInt(gsPCGetCreatureHide(observer), "OUTPUT_PREFIX");

    if (prefixMode == 0 || (prefixMode == 1 && languageIdForNamePrefix != GS_LA_LANGUAGE_COMMON))
    {
        languageNamePrefix = gsLAGetLanguageColor(languageIdForNamePrefix) + "[" + languageName + "]:</c> ";
    }

    // If consoleMode == 0, we output untranslated to the main window.
    // If consoleMode == 1, we output untranslated to the main window and translated to the combat window.
    // If consoleMode == 2, we output untranslated to the main window and translated to the combat window if it isn't common.
    // If consoleMode == 3, we output translated to the main window and untranslated to the combat window.
    // If consoleMode == 4, we output translated to the main window and untranslated to the combat window if it isn't common.
    string consoleOutput = chatGetChannelName(channel) + " " + txtWhite + svGetPCNameOverride(speaker) + "</c> " +
        languageNamePrefix;

    int consoleMode = GetLocalInt(gsPCGetCreatureHide(observer), "OUTPUT_TO_CONSOLE");

    if (consoleMode == 3 || consoleMode == 4)
    {
        chatSpeakString(speaker, channel, languageNamePrefix + translated, observer, FALSE);

        if (consoleMode != 4 || languageId != GS_LA_LANGUAGE_COMMON)
        {
            SendMessageToPC(observer, consoleOutput + (canSpeak ? untranslated : translated));
        }
    }
    else
    {
        chatSpeakString(speaker, channel, languageNamePrefix + (canSpeak ? untranslated : translated), observer, FALSE);

        if (consoleMode == 1 || consoleMode == 2)
        {
            if (consoleMode != 2 || languageId != GS_LA_LANGUAGE_COMMON)
            {
                SendMessageToPC(observer, consoleOutput + translated);
            }
        }
    }
}
void _insertIfValid(object speaker, object listener, float range, string arrayTag)
{
    int isPc = GetIsPC(listener);
    int sameArea = GetArea(listener) == GetArea(speaker);
    int inRange = GetDistanceBetween(speaker, listener) <= range;

    if (!isPc || !sameArea || !inRange)
    {
        return;
    }

    if (ObjectArray_Contains(speaker, arrayTag, listener))
    {
        // This code should help us track down why sometimes we're dispatching duplicate messages.
        Error("CHAT", "Tried to insert an object into the chat array that already existed." +
            "speaker: " + GetName(speaker) + "[" + ObjectToString(speaker) + "], " +
            "listener: " + GetName(listener) + "[" + ObjectToString(listener) + "]");
    }
    else
    {
        ObjectArray_PushBack(speaker, arrayTag, listener);
    }
}
//----------------------------------------------------------------------------//
// This function iterates over all creatures in the same area (with range varying based on channel)
// and dispatches the message to them directly.
// The text will come out translated for each PC who can understand it, and untranslated for those who cannot.
void _fbCHDispatchDirected(object speaker, string message, int channel, int languageId)
{
    string untranslated = gsLATranslate(message, languageId, GetEmoteStyle(speaker), FALSE);
    string translated = gsLATranslate(message, languageId, GetEmoteStyle(speaker), TRUE);

    // Repeat this message on a silent channel so NPCs and placeables can hear it
    AssignCommand(speaker, SpeakString(translated, TALKVOLUME_SILENT_TALK));
    // We make a temporary array here, and put ...
    string arrayName = "TALK_CANDIDATES";
    float range = fbCHGetChannelRange(channel);

    { // .. All DMs in range.
        object dm = GetFirstObjectElement(FB_CH_DM_LIST, GetModule());

        while (GetIsObjectValid(dm))
        {
            _insertIfValid(speaker, dm, range, arrayName);
            dm = GetNextObjectElement();
        }
    }

    { // ... All creatures in range in the area.
        object area = GetArea(speaker);
        object creature = GetFirstObjectInArea(area);

        while (GetIsObjectValid(creature))
        {
            _insertIfValid(speaker, creature, range, arrayName);
            creature = GetNextObjectInArea(area);
        }
    }

    { // ... Then iterate over every candidate, and send a message.
        int count = ObjectArray_Size(speaker, arrayName);

        int i;
        for (i = 0; i < count; ++i)
        {
            object obj = ObjectArray_At(speaker, arrayName, i);
            _fbCHOutputFinalText(speaker, obj, channel, untranslated, translated, languageId);
        }
    }

    ObjectArray_Clear(speaker, arrayName);
}
//----------------------------------------------------------------------------//
int fbCHSpeak(struct fbCHChat stChat)
{
  // Only process language code on IC channels, and for languages we can speak.
  if (fbCHGetIsInCharacter(stChat.nChannel))
  {
    fbCHMute(stChat.oSpeaker);

    if (stChat.sText != "")
    {
      string untranslated = stChat.sText;
      int languageId = GetLocalInt(stChat.oSpeaker, "CHAT_LANGUAGE");

      switch (languageId)
      {
        case GS_LA_LANGUAGE_SIGN:
        case GS_LA_LANGUAGE_THIEF:
          untranslated = GetStringLeft(untranslated, 25);
      }

      SetLocalString(stChat.oSpeaker, "CHAT_MESSAGE", untranslated);

      if (!gsLAGetCanSpeakLanguage(languageId, stChat.oSpeaker))
      {
        untranslated = "*(unintelligible gibberish)*";
        _fbCHDispatchDirected(stChat.oSpeaker, untranslated, stChat.nChannel, GS_LA_LANGUAGE_COMMON);
      }
      else
      {
        _fbCHDispatchDirected(stChat.oSpeaker, untranslated, stChat.nChannel, languageId);
      }
    }
  }
  else if (stChat.nChannel == NWNX_CHAT_CHANNEL_DM_TALK || stChat.nChannel == NWNX_CHAT_CHANNEL_DM_WHISPER)
  {
    // For DM chat channels, we just set the last message.
    SetLocalString(stChat.oSpeaker, "CHAT_MESSAGE", stChat.sText);
  }
  // Notells hook
  else if (chatGetIsTell(stChat.nChannel))
  {
    // Speaker has been banned from using Tells.
    if (!GetIsDM(stChat.oTarget) && !GetIsDMPossessed(stChat.oTarget) &&
     miTEGetTellsDisabled(stChat.oSpeaker) && stChat.oTarget != stChat.oSpeaker)
    {
      fbCHMute(stChat.oSpeaker);
      SendMessageToPC(stChat.oSpeaker, txtRed + "You are not permitted to send or " +
       "receive Tells except to/from DMs. Your message was not delivered.</c>");
    }
    // Target has blocked speaker, or has been banned from using Tells (if the
    // latter, let the target assume -notells was voluntary).
    // Septire - Players should be able to send tells to themselves, such as for descriptions/renaming of enchanted items
    // Similarly, players should be able to whitelist just themselves from a -notells state.
    else if (!GetIsDM(stChat.oSpeaker) &&
             !GetIsDMPossessed(stChat.oSpeaker) &&
             (miTEGetIsPlayerBlocked(stChat.oTarget, stChat.oSpeaker) || miTEGetTellsDisabled(stChat.oTarget)) &&
             (stChat.oSpeaker != stChat.oTarget)
            )
    {
        fbCHMute(stChat.oSpeaker);
        SendMessageToPC(stChat.oSpeaker, txtRed + svGetPCNameOverride(stChat.oTarget) +
        " has chosen not to receive Tells, by typing -notells. Your message was not delivered.</c>");
    }
    // Speaker has blocked target. Carry on, with a warning.
    else if (miTEGetIsPlayerBlocked(stChat.oSpeaker, stChat.oTarget) &&
             (stChat.oSpeaker != stChat.oTarget)
            )
    {
      // Warn the speaker that the recipient can't reply.
      SendMessageToPC(stChat.oSpeaker, txtRed + "You currently have this person blocked. " +
       "They won't be able to reply!  (Use -notells to configure)</c>");
      SetLocalString(stChat.oSpeaker, "CHAT_MESSAGE", stChat.sText);
      return TRUE;
    }
    else
    {
      SetLocalString(stChat.oSpeaker, "CHAT_MESSAGE", stChat.sText);
      return TRUE;
    }
  }

  return FALSE;
}
//----------------------------------------------------------------------------//

string fbCHRateValue(object second, string sStat, int bBluffed)
{

    // We are returning a string value for the stat.
    // Or, if bluffed, the mimicked value.
    string sDescriptor;

    // Return mimicked value
    if (bBluffed) {
        object oHide = gsPCGetCreatureHide(second);
        sDescriptor = GetLocalString(oHide, "MIMIC_" + sStat);
        if (sDescriptor == "HI")
            return txtLime + "High</c>";
        if (sDescriptor == "LO")
            return txtOrange + "Low</c>";
        if (sDescriptor == "AV")
            return txtYellow + "Average</c>";
        // No local string, go to actual values.
        // return "Unknown";
    }

    // Return actual value;
    int nStat;
    if (sStat == "DEX")
        nStat = ABILITY_DEXTERITY;
    else if (sStat == "STR")
        nStat = ABILITY_STRENGTH;
    else if (sStat == "CON")
        nStat = ABILITY_CONSTITUTION;
    else if (sStat == "CHA")
        nStat = ABILITY_CHARISMA;

    if (GetAbilityScore(second, nStat, TRUE) >= 16)
        return txtLime + "High</c>";
    if (GetAbilityScore(second, nStat, TRUE) <= 8)
        return txtOrange + "Low</c>";
    return txtYellow + "Average</c>";
}

/* string fbCHRateValue(int nValue, int nInaccuracy = 0)
if (nInaccuracy > 0) nValue += nInaccuracy / 2 - Random(nInaccuracy + 1);
    if (nValue <= -8) return GS_T_16777464;
    if (nValue <= -5) return GS_T_16777465;
    if (nValue <= -2) return GS_T_16777466;
    if (nValue <=  1) return GS_T_16777467;
    if (nValue <=  4) return GS_T_16777468;
    if (nValue <=  7) return GS_T_16777469;
    return GS_T_16777470;
*/

//----------------------------------------------------------------------------//
string fbDoLooksAndGetString(object first, object second)
{
    string sMessage         = "";
    string sString          = "";
    int nInsight, nBluff    = 0;
    int nTime = GetModuleTime();
    int nInRoll, nBlRoll;
    int bBluffed = FALSE;

    if (first != second && GetIsObjectValid(first) && GetIsObjectValid(second))
    {
        sString = GetTag(second);

        if (sString != "GS_BOSS" && sString != "GS_ENCOUNTER" && sString != "GS_LISTENER")
        {
            nBluff = GetSkillRank(SKILL_BLUFF, second);
            if (GetSkillRank(SKILL_PERFORM, second) > nBluff)
                nBluff = GetSkillRank(SKILL_PERFORM, second);

            nInsight = GetSkillRank(SKILL_SPOT, first);
            if (GetSkillRank(SKILL_SEARCH, first) > nInsight)
                nInsight = GetSkillRank(SKILL_SEARCH, first);

            // Insight roll.  The viewer only gets to roll this once per hour
            if (nTime - GetLocalInt(first, "EXAMINE_INTUITION_TIMESTAMP") < 3600) {
                nInRoll = GetLocalInt(first, "EXAMINE_INTUITION");
            } else {
                nInRoll = d20(1);
                SetLocalInt(first, "EXAMINE_INTUITION_TIMESTAMP", nTime);
                SetLocalInt(first, "EXAMINE_INTUITION", nInRoll);
            }

            // Ditto with the timing on the Bluff roll
            if (nTime - GetLocalInt(second, "EXAMINE_BLUFF_TIMESTAMP") < 3600) {
                nBlRoll = GetLocalInt(second, "EXAMINE_BLUFF");
            } else {
                nBlRoll = d20(1);
                SetLocalInt(second, "EXAMINE_BLUFF_TIMESTAMP", nTime);
                SetLocalInt(second, "EXAMINE_BLUFF", nBlRoll);
            }

            // Opposed roll between Bluff/Perform and Spot/Search.  +10 to the mimic.
            if (10 + nBluff + nBlRoll > nInsight + nInRoll)
                bBluffed = TRUE;

            int polymorphed = GetHasEffect(EFFECT_TYPE_POLYMORPH, second);
            int disguised = GetIsPCDisguised(second) || GetRacialType(first) == RACIAL_TYPE_SHAPECHANGER;
            int disguiseBroken = disguised && SeeThroughDisguise(second, first, FALSE);

            // if (polymorphed)
            // {
            //    sMessage += StringToRGBString("This character is polymorphed and you can " +
            //        "determine little meaningful information about them.", "599") + "\n";
            //    sMessage += GetPCDescriptionAttunement(first, second, TRUE);
            // }
            // We are now displaying stats regardless of disguise state
            // else if (disguised && !disguiseBroken)
            // {
            //  sMessage += StringToRGBString("This character is disguised and you can " +
            //   "determine little meaningful information about them.", "599") + "\n";
            //  sMessage += GetPCDescriptionAttunement(first, second, TRUE);
            //  DeleteLocalInt(first, "MI_LOOK_BROKE_" + ObjectToString(second));
            // }
            // else
            // {
            if (disguised && disguiseBroken)
            {
                SetLocalInt(first, "MI_LOOK_BROKE_" + ObjectToString(second), TRUE);
                if (polymorphed) {
                    sMessage += StringToRGBString("Something is off about this creature.  It may be a polymorphed individual!", "599");
                } else {
                sMessage += StringToRGBString("You have broken this character's disguise. They are ", "599") +
                            StringToRGBString(GetName(second, TRUE), "199") +
                            StringToRGBString("!", "599");
                }
            }

            sMessage += "\n";

            sMessage += GetPCDescriptionAttunement(first, second);

            //strength
            sMessage    += "\n" + txtBlue + "STRENGTH: </c>" + fbCHRateValue(second, "STR", bBluffed);

            //dexterity
            sMessage    += "\n" + txtBlue + "DEXTERITY: </c>" + fbCHRateValue(second, "DEX", bBluffed);

            //constitution
            sMessage    += "\n" + txtBlue + "CONSTITUTION: </c>" + fbCHRateValue(second, "CON", bBluffed);

            //charisma
            sMessage    += "\n" + txtBlue + "CHARISMA: </c>" + fbCHRateValue(second, "CHA", bBluffed);

            sMessage    += "\n";

            // Only show the following if undisguised or if the disguise was broken.
            if (!polymorphed && (!disguised || disguiseBroken)) 
			{
                //Add race
                string sRace;
                int nSubrace = gsSUGetSubRaceByName(GetSubRace(second));
                int nFirstRace = GetRacialType(first);
                int nFirstSubrace = gsSUGetSubRaceByName(GetSubRace(first));
                int nLore = _CustomLoreCheck(first, FALSE);
				
                if(nSubrace == GS_SU_NONE)
                    sRace = gvd_GetRacialTypeName(second);
                else if(nSubrace == GS_SU_FR_OROG ||
                    nSubrace == GS_SU_HALFORC_GNOLL ||
                    nSubrace == GS_SU_HALFORC_OROG ||
                    nSubrace == GS_SU_SPECIAL_FEY ||
                    nSubrace == GS_SU_SPECIAL_HOBGOBLIN ||
                    nSubrace == GS_SU_SPECIAL_GOBLIN ||
                    nSubrace == GS_SU_SPECIAL_IMP ||
                    nSubrace == GS_SU_SPECIAL_KOBOLD ||
                    nSubrace == GS_SU_SPECIAL_OGRE)
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(((nFirstRace == RACIAL_TYPE_ELF && nFirstSubrace != GS_SU_ELF_DROW) || GetHasFeat(FEAT_FAVORED_ENEMY_ELF, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20 ||
                   nLore >= 20) && (
                   nSubrace == GS_SU_ELF_MOON ||
                   nSubrace == GS_SU_ELF_SUN ||
                   nSubrace == GS_SU_ELF_WILD ||
                   nSubrace == GS_SU_ELF_WOOD
                   ))
                   sRace = gsSUGetNameBySubRace(nSubrace);
                else if((nFirstRace == RACIAL_TYPE_ELF && nLore >= 20 || (GetHasFeat(FEAT_FAVORED_ENEMY_ELF, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20)) &&
                  nSubrace == GS_SU_ELF_DROW)
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(nSubrace == GS_SU_ELF_DROW && nSubrace == nFirstSubrace)
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(((nFirstRace == RACIAL_TYPE_DWARF && nFirstSubrace != GS_SU_DWARF_GRAY) ||  GetHasFeat(FEAT_FAVORED_ENEMY_DWARF, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20 || nLore >= 20) &&
                    (nSubrace == GS_SU_DWARF_GOLD ||
                    nSubrace == GS_SU_DWARF_SHIELD ||
                    nSubrace == GS_SU_DWARF_WILD
                    ))
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if((nFirstRace == RACIAL_TYPE_DWARF && nLore >= 20 || (GetHasFeat(FEAT_FAVORED_ENEMY_DWARF, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20)) &&
                  nSubrace == GS_SU_DWARF_GRAY)
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(nSubrace == GS_SU_DWARF_GRAY && nSubrace == nFirstSubrace)
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if((nFirstRace == RACIAL_TYPE_GNOME || GetHasFeat(FEAT_FAVORED_ENEMY_GNOME, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20 || nLore >= 20) &&
                    (nSubrace == GS_SU_GNOME_DEEP ||
                    nSubrace == GS_SU_GNOME_FOREST ||
                    nSubrace == GS_SU_GNOME_ROCK))
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(((nFirstRace == RACIAL_TYPE_HALFLING && (nFirstSubrace == GS_SU_HALFLING_GHOSTWISE || nSubrace == GS_SU_HALFLING_LIGHTFOOT  || nSubrace == GS_SU_HALFLING_STRONGHEART))  || GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING, first) && nLore + GetLevelByClass(CLASS_TYPE_RANGER, first) >= 20 || nLore >= 20) &&
                    (nSubrace == GS_SU_HALFLING_GHOSTWISE ||
                    nSubrace == GS_SU_HALFLING_LIGHTFOOT ||
                    nSubrace == GS_SU_HALFLING_STRONGHEART))
                    sRace = gsSUGetNameBySubRace(nSubrace);
                else if(nSubrace == GS_SU_DEEP_IMASKARI)
                    sRace = gvd_GetRacialTypeName(second, RACIAL_TYPE_HUMAN);
                else //race for everyone else
                    sRace = gvd_GetRacialTypeName(second);

                sMessage +=  txtGreen + "\nRacial Type: " + sRace +  "</c>\n";
			}
        }
    }
	else if (first == second && GetIsObjectValid(first))
	{
		// Allow seers to see their own attunement.
        sMessage += GetPCDescriptionAttunement(first, second) + "\n";
	}
	
    if (sMessage != "")
    {
        sMessage = GetSubString(sMessage, 0, GetStringLength(sMessage) - 1);
    }

    return sMessage;
}

string GetPCDescriptionAttunement(object oExaminer, object oExaminee, int bDisguised = FALSE)
{
    string sAspectItem;
    string sMessage;

    if(GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oExaminer) && GetIsPC(oExaminee))
    {
        sAspectItem = miDVGetAspectDescription(miDVGetAspect(oExaminee));
        if(bDisguised) sMessage += StringToRGBString("\nThrough divination, you are able to determine that they are ", "599");
        sMessage += txtBlue;
        sMessage += (bDisguised) ? "a" : "\nA";
        sMessage += "ttuned to " + miDVGetAttunement(oExaminee) + (sAspectItem == "" ? "" : ", with an image of " + sAspectItem + " about their head!");
        if(bDisguised && sAspectItem == "") sMessage += ".";
        sMessage += "</c>";
    }

    return sMessage;
}

/*
fb_inc_chatutils

Chat library, contains all functions required for managing the chat, working
alongside the chat scipt.These methods are mostly for use in scripts such as
scripts for -commands (see comments in ar_chat for details on -commands).
*/

#include "inc_log"
#include "nwnx_chat"
#include "zzdlg_lists_inc"

const string FB_CH_DM_LIST = "FB_CH_DM";

const string CHATCMD = "CHAT COMMAND"; // for tracing

const string COLOR_CODE_CHAT_COMMAND_EXAMPLE = "<c‡Îë>"; // Sky Blue
const string COLOR_CODE_CHAT_COMMAND_PARAMETER = "<cÿ× >"; // Gold
const string COLOR_CODE_CHAT_COMMAND_TITLE = "<c þ >"; // Green
const string COLOR_CODE_TERMINATE = "</c>";

// Called when oPC logs in.
void chatEnter(object oPC);
// Called when oPC logs out.
void chatLeave(object oPC);
// Returns sString minus nFrom characters removed from the front of the string.
string chatGetStringFrom(string sString, int nFrom = 1);
// Send a chat message originating from oSender to oRecipient through nChannel.
// If oRecipient is OBJECT_INVALID, will send as appropriate for the channel.
// If bProcess is FALSE, will process the chat message as any other.
// nChannel - NWNX_CHAT_CHANNEL_*
void chatSpeakString(object oSender, int nChannel, string sMessage, object oRecipient = OBJECT_INVALID, int bProcess = TRUE);
// Returns the name of nChannel in square brackets, e.g. [Talk]. On error, will
// return Unknown(0) where 0 is replaced by the string representation of nID.
string chatGetChannelName(int nChannel);
// Converts CHAT_CHANNEL constants to TALKVOLUME_ constants. Returns -1 when
// there is no equivalent.
int chatGetVolume(int nChannel);
// Returns TRUE if nChannel is a Tell channel, FALSE otherwise.
int chatGetIsTell(int nChannel);
// Forgets the most recent message spoken by oSpeaker.
void chatClearLastMessage(object oSpeaker = OBJECT_SELF);
// Returns the most recent message spoken by oSpeaker.
string chatGetLastMessage(object oSpeaker = OBJECT_SELF);
// Returns the most recent channel of message spoke by oSpeaker.
int chatGetLastChannel(object oSpeaker = OBJECT_SELF);
// Returns the parameters of the current command being executed.
string chatGetParams(object oSpeaker);
// Returns the target of the current command being executed.
object chatGetTarget(object oSpeaker);
// Registers the command as having been processed (even if it was unsuccessful).
void chatVerifyCommand(object oSpeaker);
// Formats the string as a chat command example.
string chatCommandExample(string sString);
// Formats the string as a chat command parameter.
string chatCommandParameter(string sString);
// Formats the string as a chat command title.
string chatCommandTitle(string sString);

//----------------------------------------------------------------------------//
// Internal function: Adds a DM to the list of logged in DMs.
void _chatRegisterDM(object oDM)
{
  // Keep a list of currently logged in DMs.
  object oModule = GetModule();
  SetLocalString(oDM, "PLAYER_ID", GetPCPlayerName(oDM));
  AddObjectElement(oDM, FB_CH_DM_LIST, oModule);
}
//----------------------------------------------------------------------------//
// Internal function: Removes a DM from the list of logged in DMs.
void _chatUnRegisterDM(object oDM)
{
  object oModule   = GetModule();
  int nIndex       = 0;
  object oListItem = GetFirstObjectElement(FB_CH_DM_LIST, oModule);
  string sID       = GetLocalString(oDM, "PLAYER_ID");
  while (GetIsObjectValid(oListItem))
  {
    if (GetLocalString(oListItem, "PLAYER_ID") == sID)
    {
      break;
    }
    oListItem = GetNextObjectElement();
    nIndex++;
  }

  RemoveElement(nIndex, FB_CH_DM_LIST, oModule);
}
//----------------------------------------------------------------------------//
void chatEnter(object oPC)
{
  if (GetIsObjectValid(oPC) && GetIsDM(oPC))
  {
    _chatRegisterDM(oPC);
  }
}
//----------------------------------------------------------------------------//
void chatLeave(object oPC)
{
  if (GetIsObjectValid(oPC) && GetIsDM(oPC))
  {
    _chatUnRegisterDM(oPC);
  }
}
//----------------------------------------------------------------------------//
string chatGetStringFrom(string sString, int nFrom = 1)
{
    return GetStringRight(sString, GetStringLength(sString) - nFrom);
}
//----------------------------------------------------------------------------//
void _chatSpeakString(object oSender, int nChannel, string sMessage, object oRecipient)
{
    NWNX_Chat_SendMessage(nChannel, sMessage, oSender, oRecipient);
}
//----------------------------------------------------------------------------//
void chatSpeakString(object oSender, int nChannel, string sMessage, object oRecipient=OBJECT_INVALID, int bProcess = TRUE)
{
  if (!GetIsObjectValid(oSender))
  {
    return;
  }

  if (!GetIsObjectValid(oRecipient))
  {
    if (chatGetIsTell(nChannel)) return;
  }

  if (bProcess)
  {
    DelayCommand(0.0f, _chatSpeakString(oSender, nChannel, sMessage, oRecipient));
  }
  else
  {
    _chatSpeakString(oSender, nChannel, sMessage, oRecipient);
  }

}
//----------------------------------------------------------------------------//
string chatGetChannelName(int nChannel)
{
  switch (nChannel)
  {
    case NWNX_CHAT_CHANNEL_PLAYER_TALK:
    case NWNX_CHAT_CHANNEL_DM_TALK:
      return "[Talk]";
    case NWNX_CHAT_CHANNEL_PLAYER_SHOUT:
    case NWNX_CHAT_CHANNEL_DM_SHOUT:
      return "[Shout]";
    case NWNX_CHAT_CHANNEL_PLAYER_WHISPER:
    case NWNX_CHAT_CHANNEL_DM_WHISPER:
      return "[Whisper]";
    case NWNX_CHAT_CHANNEL_PLAYER_TELL:
    case NWNX_CHAT_CHANNEL_DM_TELL:
      return "[Tell]";
    case NWNX_CHAT_CHANNEL_SERVER_MSG:
      return "[Server]";
    case NWNX_CHAT_CHANNEL_PLAYER_PARTY:
    case NWNX_CHAT_CHANNEL_DM_PARTY:
      return "[Party]";
    case NWNX_CHAT_CHANNEL_PLAYER_DM:
    case NWNX_CHAT_CHANNEL_DM_DM:
      return "[DM]";
  }

  return "Channel (" + IntToString(nChannel) + ")";
}
//----------------------------------------------------------------------------//
int chatGetVolume(int nChannel)
{
  switch (nChannel)
  {
    case NWNX_CHAT_CHANNEL_PLAYER_TALK:
    case NWNX_CHAT_CHANNEL_PLAYER_SHOUT:
    case NWNX_CHAT_CHANNEL_DM_TALK:
      return TALKVOLUME_TALK;
    case NWNX_CHAT_CHANNEL_PLAYER_WHISPER:
    case NWNX_CHAT_CHANNEL_DM_WHISPER:
      return TALKVOLUME_WHISPER;
  }

  return -1;
}
//----------------------------------------------------------------------------//
int chatGetIsTell(int nChannel)
{
  return nChannel == NWNX_CHAT_CHANNEL_PLAYER_TELL || nChannel == NWNX_CHAT_CHANNEL_DM_TELL;
}
//----------------------------------------------------------------------------//
void chatClearLastMessage(object oSpeaker = OBJECT_SELF)
{
  DeleteLocalString(oSpeaker, "CHAT_MESSAGE");
}
//----------------------------------------------------------------------------//
string chatGetLastMessage(object oSpeaker = OBJECT_SELF)
{
  return GetLocalString(oSpeaker, "CHAT_MESSAGE");
}
//----------------------------------------------------------------------------//
int chatGetLastChannel(object oSpeaker = OBJECT_SELF)
{
  return GetLocalInt(oSpeaker, "CHAT_CHANNEL");
}
//----------------------------------------------------------------------------//
string chatGetParams(object oSpeaker)
{
  return GetLocalString(oSpeaker, "CHAT_PARAMS");
}
//----------------------------------------------------------------------------//
object chatGetTarget(object oSpeaker)
{
  return GetLocalObject(oSpeaker, "CHAT_TARGET");
}
//----------------------------------------------------------------------------//
void chatVerifyCommand(object oSpeaker)
{
  SetLocalInt(oSpeaker, "CHAT_RESULT", TRUE);
}
//----------------------------------------------------------------------------//
string chatCommandExample(string sString)
{
    return COLOR_CODE_CHAT_COMMAND_EXAMPLE + sString + COLOR_CODE_TERMINATE;
}
//----------------------------------------------------------------------------//
string chatCommandParameter(string sString)
{
    return COLOR_CODE_CHAT_COMMAND_PARAMETER + sString + COLOR_CODE_TERMINATE;
}
//----------------------------------------------------------------------------//
string chatCommandTitle(string sString)
{
    return COLOR_CODE_CHAT_COMMAND_TITLE + sString + COLOR_CODE_TERMINATE;
}
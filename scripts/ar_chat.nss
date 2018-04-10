/*
ar_chat
Chat script, written mostly by Mithreas and restructured by Fireboar

Name changed to ar_chat because this is an accumulation of work done by Mith,
Gigaschatten and Fireboar and possibly some other people as well. So giving it
any particular name prefix would be inaccurate.

This has four main sections:
- Grabs details of the text spoken, and decides whether or not to process
- Interprets -commands (see below) and language switches
- Interprets *emotes* and special commands
- Translates the text into whatever language the PC is speaking

The bulk of the work for all of these is handled by the fb_inc_chat library.

Creating -commands is simple. Simply make a script for it with the prefix chat_,
so for example to create the command -sample, you would use the script
chat_sample. The caller is the speaker, any parameters can be retrieved with
chatGetParams, and the target (in the case of a tell) can be retrieved with
chatGetTarget. It is expected that if the parameters are ?, the command itself
will not be executed, but more help will be provided. The script should end by
calling chatVerifyCommand, otherwise the system will assume that no such command
exists.

When creating a command, some extra code ought to be added to fbCHCommandList.
*/

#include "fb_inc_chat"
#include "inc_examine"

void _showHelp(object speaker)
{
    DisplayTextInExamineWindow("Arelith Virtual Console",
        "The console will recognize each of the following commands. " +
        "For details on how to use each one, simply speak a ? after the command, e.g. '-dispel ?'.\n\n" +
        "Commands inside square brackets represent aliases which provide a shortcut of functionality to their parent command.\n\n" +
        fbCHCommandList(speaker), speaker);
}

void main()
{
  struct fbCHChat stChat = fbCHGetChat();

  if (stChat.bIgnore)
  {
    return;
  }

  if (stChat.nChannel == NWNX_CHAT_CHANNEL_SERVER_MSG)
  {
    // Remove "You are now in a XYZ PVP Area." messages
    if (FindSubString(stChat.sText, "You are now in a") != -1)
    {
      fbCHMute(stChat.oSpeaker);
    }
    return;
  }

  string sSwitch = GetStringLeft(stChat.sText, 1);

  // Interpret -commands
  if (sSwitch == "-" || sSwitch == "/")
  {
    if (GetLocalInt(stChat.oSpeaker, "CONSOLE_COMMANDS_BLOCKED"))
    {
      FloatingTextStringOnCreature("You cannot use console commands right now.", stChat.oSpeaker, FALSE);
      fbCHMute(stChat.oSpeaker);
      return;
    }

    struct fbCHCommand stCommand = fbCHInterpretCommand(stChat);

    // Help
    if (stCommand.sText == "" || stCommand.sText == "help")
    {
      DelayCommand(0.0f, _showHelp(stChat.oSpeaker));
      fbCHMute(stChat.oSpeaker);
      return;
    }

    // Run a command
    if (!fbCHRunCommand(stCommand, stChat.oSpeaker, stChat.nChannel))
    {
      SendMessageToPC(stChat.oSpeaker, "Invalid or inaccesible command '-" + stCommand.sText + "'. Type -help for a list of commands.");
      fbCHMute(stChat.oSpeaker);
    }

    return;
  }

  // Hostile. We keep this hard-coded switch here for legacy reasons.
  if (stChat.sText == "!")
  {
    chatSpeakString(stChat.oSpeaker, stChat.nChannel, "-hostile", stChat.oTarget);
    fbCHMute(stChat.oSpeaker);
    return;
  }

  // Send DM messages back as a tell to the sender.
  // Batra: If this is their first DM message of the reset, give informative feedback text.
  if (stChat.nChannel == NWNX_CHAT_CHANNEL_PLAYER_DM)
  {
    chatSpeakString(stChat.oSpeaker, NWNX_CHAT_CHANNEL_PLAYER_TELL, "<c þþ>Sent to DM: " + stChat.sText+"</c>", stChat.oSpeaker, FALSE);
    if (GetLocalInt(stChat.oSpeaker, "DM_TIP"))
    {
      DeleteLocalInt(stChat.oSpeaker, "DM_TIP");
      SendMessageToPC(stChat.oSpeaker, 
                      "Thank you for pinging the DM Team. For a prompt response, please be upfront and clear with your question " + 
                      "or concern with one or two sentences. Sending us ‘Hello!’ or ‘Hey, is anyone around?’ does not help us " + 
                      "assist you, so please be clear with what you need from us! This allows us to sift through the requests we " +
                      "get as quickly and efficiently as possible. For more information, please see the ‘DM Etiquette’ thread on " +
                      "the Questions & Answers forum.");
    }
  }

  // Send DM shouts back as a tell to the DM.
  if (stChat.nChannel == NWNX_CHAT_CHANNEL_DM_SHOUT)
  {
    chatSpeakString(stChat.oSpeaker, NWNX_CHAT_CHANNEL_DM_TELL, "<cþîO>Broadcast to all players: " + stChat.sText + "</c>", stChat.oSpeaker, FALSE);
  }

  // Broadcast DM messages text to the other server.
  if (GetIsObjectValid(stChat.oSpeaker) && (stChat.nChannel == NWNX_CHAT_CHANNEL_PLAYER_DM || stChat.nChannel == NWNX_CHAT_CHANNEL_DM_DM))
  {
    string sServer = miXFGetCurrentServer();
    string sMessage = "[" + GetName(stChat.oSpeaker) + " on " + sServer + "]: " + stChat.sText;
    if (sServer != SERVER_ISLAND) miXFSendMessage("", SERVER_ISLAND, sMessage, MESSAGE_TYPE_DMC);
    if (sServer != SERVER_UNDERDARK) miXFSendMessage("", SERVER_UNDERDARK, sMessage, MESSAGE_TYPE_DMC);
    if (sServer != SERVER_DISTSHORES) miXFSendMessage("", SERVER_DISTSHORES, sMessage, MESSAGE_TYPE_DMC);
  }

  // Speak the string (perhaps in another language)
  fbCHSpeak(stChat);
}

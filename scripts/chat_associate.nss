#include "fb_inc_chat"
#include "inc_examine"
#include "inc_associates"

const string HELP_1 = "Use this command to make your familiar, animal companion, dominated associate, shadowdancer companion, or projected image speak <cÿ× >[Text]</c>. If /w is given, the associate will whisper. if /s is given, the associate will shout.\n\n";
const string HELP_2 = "If you have more than one valid associate for use with this command, then you must first specify one by selecting it with the Player Tool 1 feat.\n\nExample:\n<c‡Îë>-associate I am John Doe's associate.\n-associate /s This is a shout.</c>";

void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParams  = chatGetParams(oSpeaker);

  int nSpeakingAssociateCount = GetSpeakingAssociateCount(oSpeaker);

  chatVerifyCommand(oSpeaker);

  if (sParams == "?" || sParams == "")
  {
    DisplayTextInExamineWindow(chatCommandTitle("-associate") + " " + chatCommandParameter("[/w][/s][Text]") + "\n(Alias: -a)", HELP_1 + HELP_2);
  }
  else
  {
    if(!GetSpeakingAssociateCount(oSpeaker))
    {
        SendMessageToPC(oSpeaker, "You must have a familiar, animal companion, or projected image to use this command.");
        return;
    }
    else if(GetSpeakingAssociateCount(oSpeaker) > 1 && !GetCanMasterSpeakThroughAssociate(GetControlledAssociate(oSpeaker)))
    {
        SendMessageToPC(oSpeaker, "You currently have multiple associates that can speak for you. Please select one with Player Tool 1 before using this command.");
        return;
    }
    object oFamiliar = GetSpeakingAssociate(oSpeaker);

    if (GetIsObjectValid(oFamiliar))
    {
      int channel = NWNX_CHAT_CHANNEL_PLAYER_TALK;
      string text = sParams;

      string sFlag = GetStringLeft(text, 3);
      if (sFlag == "/w ")
      {
        channel = NWNX_CHAT_CHANNEL_PLAYER_WHISPER;
        text    = chatGetStringFrom(text, 3);
      }
      else if (sFlag == "/s ")
      {
        channel = NWNX_CHAT_CHANNEL_PLAYER_SHOUT;
        text    = chatGetStringFrom(text, 3);
      }

      chatSpeakString(oFamiliar, channel, text);
    }
  }
}

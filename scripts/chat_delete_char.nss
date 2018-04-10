#include "fb_inc_chatutils"
#include "fb_inc_external"
#include "mi_inc_xfer"
#include "inc_examine"
#include "gvd_inc_reward"

const string HELP = "Use -delete_character to delete your current character from the vault. Note: once you have deleted your character, you will NEVER be able to get it back.";

void main()
{
  // Command not valid
  if (!ALLOW_DELETE_CHARACTER) return;

  object oSpeaker = OBJECT_SELF;
  object oHide = gsPCGetCreatureHide(oSpeaker);
  if (chatGetParams(oSpeaker) == "?") {
    DisplayTextInExamineWindow("-delete_character", HELP);
  }
  else {
    int nConfirm = GetLocalInt(oHide, "CONFIRM_DELETE");
    if (nConfirm == 1) {

      // Dunshine, moved reward stuff to a seperate function/include file (gvd_inc_reward) so it can be used for MoDs as well:
      gvd_DoRewards(oSpeaker);

      // Hopefully this will prevent issues when remaking with the same name.
      miXFUnregisterPlayer(oSpeaker);
      fbEXDeletePC(oSpeaker);

      SetLocalInt(oHide, "CONFIRM_DELETE", 2);
    }
    else if(nConfirm == 2)
    {
      miXFUnregisterPlayer(oSpeaker);
      fbEXDeletePC(oSpeaker);
    }
    else if (!nConfirm) {
      SendMessageToPC(oSpeaker, "<c�  >!!! Are you really really sure that " +
       "you want to delete this character? If you type -delete_character again, " +
       "this character will be PERMANENTLY DELETED!!!\n");
      SetLocalInt(oHide, "CONFIRM_DELETE", 1);
    }
  }
  chatVerifyCommand(oSpeaker);
}

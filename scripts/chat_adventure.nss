#include "fb_inc_chat"
#include "inc_examine"
#include "inc_adv_xp"

const string HELP = "This command can be used to toggle Adventure Mode on/off. Adventure Mode Off is the default, 100% XP from killing creatures is gained directly. Adventure Mode On means 100% XP from killing creatures goes to your Adventure XP pool, and 50% is gained directly.";

void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParams = chatGetParams(oSpeaker);

    if (chatGetParams(oSpeaker) == "?")
    {
      DisplayTextInExamineWindow("-adventure", HELP);
    }
    else
    {
       gvd_ToggleAdventureMode(oSpeaker);
    }

  chatVerifyCommand(oSpeaker);

}

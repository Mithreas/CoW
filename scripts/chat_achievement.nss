#include "inc_achievements"
#include "inc_chatutils"
#include "inc_examine"

const string HELP = "Use -achievement(s) to list your achievements.  Your achievements are tied to your player account, shared across your characters.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?") 
  {
    DisplayTextInExamineWindow("-delete_character", HELP);
  }
  else 
  {
    acListAchievements(oSpeaker);
  }
  
  chatVerifyCommand(oSpeaker);
}

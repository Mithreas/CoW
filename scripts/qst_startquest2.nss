#include "inc_quest"
/*
  Name: mi_startquest2
  Author: Mithreas
  Date: 8 Sep 05
  Version: 1.0

  Usage: Give your NPC a string local variable "quest1name" with a unique
  value (unique across the mod) representing the name of this quest. Then
  include this script to check whether you should present the dialog option
  to start the quest.

  Note - this is generic and will work with all NPCs who have the above
  variable present.
*/
int StartingConditional()
{
  return ((GetQuestInt(2) == 0) ||
           ((GetQuestProgress(2) == 0) && (GetIsPCRecognised(2) == 0)));
}

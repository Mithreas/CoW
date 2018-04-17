#include "inc_quest"
/*
  Name: mi_contquest2
  Author: Mithreas
  Date: 8 Sep 05
  Version: 1.0

  Usage: Give your NPC a string local variable "quest1name" with a unique
  value (unique across the mod) representing the name of this quest. Then
  include this script to mark that the PC has been given the first/next stage
  of the quest.

  Note - this is generic and will work with all NPCs who have the above
  variable present.
*/
void main()
{
  DoneNextStageOfQuest(2);
}

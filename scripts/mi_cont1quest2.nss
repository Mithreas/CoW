#include "mi_questcomm"
/*
  Name: mi_cont1quest2
  Author: Mithreas
  Date: 8 Sep 05
  Version: 1.0

  Usage: Give your NPC a string local variable "quest1name" with a unique
  value (unique across the mod) representing the name of this quest. Then
  include this script to check that the PC has been given the first part
  of the quest (which means you should present the dialog option for
  finishing that part and starting the next).

  Note - this is generic and will work with all NPCs who have the above
  variable present.
*/
int StartingConditional()
{
  return (GetQuestProgress(2) == 1);
}

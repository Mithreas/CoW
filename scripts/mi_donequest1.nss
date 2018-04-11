#include "inc_quest"
#include "inc_reputation"
/*
  Name: mi_donequest1
  Author: Mithreas
  Date: 20 Apr 06
  Version: 1.1

  Usage: Give your NPC a string local variable "quest1name" with a unique
  value (unique across the mod) representing the name of this quest. Then
  include this script to mark that the PC has completed the quest.

  Note - this is generic and will work with all NPCs who have the above
  variable present.

  Apr 06 - updated to give PC's faction a boost for CoW.
*/
void main()
{
  DoneQuest(1);

  // Reward the PC's faction.
  GivePointsToFaction(1, GetPCFaction(GetPCSpeaker()));

  SendMessageToPC(GetPCSpeaker(), "Quest complete!");
}

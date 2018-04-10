/*
  OnUse script for the assassin's guild work board.
  When used, whispers a list of current targets.
*/
#include "mi_inc_azn"
void main()
{
  SpeakString(miAZListContracts(), TALKVOLUME_TALK);
}
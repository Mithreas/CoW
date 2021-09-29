/*
  Name: cow_xp
  Author: Mithreas
  Date: 18 June 06
  Revised: 1 May 06 (Delay giving XP for 5 seconds)

Script to give a fixed amount of XP to PCs when they trigger or complete an
encounter. The table of XP is shown below, where each call of this script will
give the amount of XP in the middle column for a PC of the level in the left
column. Most encounters will call this script when they fire and when they are
completed, so the usual amount of XP per encounter will be the amount in the
right column.

18 Apr 18 - completely revised this.

lvl xp  /encounter
1-5 50 
6-9 25
10+ 0

*/
#include "inc_xp"
// Gives a level-based amount of XP to the PC.
void GiveXPToPC(object oPC);
void GiveXPToPC(object oPC)
{
  int nLevel = GetHitDice(oPC);

  float fLevel = IntToFloat(nLevel);
  float fXP;

  if (nLevel < 6)
  {
    fXP = 50.0;
  }
  else if (nLevel < 10)
  {
    fXP = 25.0;
  }
  else
  {
    fXP = 0.0;
  }

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");

  if (fMultiplier == 0.0) fMultiplier = 1.0;

  fXP *= fMultiplier;

  if (fXP > 0.0f) SendMessageToPC(oPC, "You earned XP for encountering enemies.");
  gsXPGiveExperience(oPC, FloatToInt(fXP));
  
}

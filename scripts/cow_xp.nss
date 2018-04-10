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

lvl xp  /encounter
1   10   20
2   20   40
3   30   60
4   40   80
5   50   100
6   59   118
7   68   136
8   77   154
9   86   172
10  95   190
11  102  204
12  109  218
13  116  232
14  123  246
15  130  260
16  135  270
17  140  280
18  145  290
19  150  300
20  155  310

*/
// Gives a level-based amount of XP to the PC.
void GiveXPToPC(object oPC);
void GiveXPToPC(object oPC)
{
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
                    GetLevelByPosition(3, oPC);

  float fLevel = IntToFloat(nLevel);
  float fXP;

  if (nLevel < 6)
  {
    // 10xp per level.
    fXP = 10 * fLevel;
  }
  else if (nLevel < 11)
  {
    // 10xp per level for the first 5 levels, plus 9xp per level for the next 5.
    fXP = 50 + 9 * (fLevel - 5.0);
  }
  else if (nLevel < 16)
  {
    // 10xp for first 5, 9xp for next 5, 7xp for next 5...
    fXP = 50 + 45 + 7 * (fLevel - 10.0);
  }
  else
  {
    //... and 5xp for the last 5.
    fXP = 50 + 45 + 35 + 5 * (fLevel - 15.0);
  }

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");

  if (fMultiplier == 0.0) fMultiplier = 1.0;

  fXP *= fMultiplier;

  GiveXPToCreature(oPC, FloatToInt(fXP));
}

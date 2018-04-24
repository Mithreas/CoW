/*
  Name: encounter_xp
  Author: Mithreas
  Date: 15 Apr 06

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
#include "cow_xp"

void main()
{
  // Zeroing this out since creatures give XP now.
/*
  int nCount = 1;
  object oPC = GetNearestObject (OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount );
  float fDistance = GetDistanceBetween(oPC, OBJECT_SELF);

  while ((fDistance < 40.0) && GetIsObjectValid(oPC))
  {
     if (GetIsPC(oPC))
     {
       GiveXPToPC (oPC);
     }

     nCount ++;
     oPC = GetNearestObject (OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount );
     fDistance = GetDistanceBetween(oPC, OBJECT_SELF);
  }
*/
}

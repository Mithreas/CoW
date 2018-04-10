#include "mi_crimcommon"
void main()
{
  // Bounty system code to clear a player's bounty if they were killed by
  // a guard.
  object oPC = GetLastPlayerDied();
  object oKiller = GetLastHostileActor(oPC);
  int nNation = CheckFactionNation(oKiller);

  if ((nNation != NATION_INVALID) &&
       GetIsDefender(oKiller) &&
       CheckWantedToken(nNation, oPC))
  {
    RemoveBountyToken(nNation, oPC);
    AdjustReputation(oPC, oKiller, 50);

    //Remove all their gold, confiscated.
    TakeGoldFromCreature(GetGold(oPC), oPC);
  }

  // Check whether the killer was a PC, and if so, give them XP.
  if (GetIsPC(oKiller))
  {
    int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
                    GetLevelByPosition(3, oPC);

    int nXP = 10 * nLevel;

    GiveXPToCreature(oKiller, nXP);
  }

  // Execute the default death script.
  ExecuteScript("nw_o0_death", OBJECT_SELF);
}

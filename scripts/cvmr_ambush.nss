#include "inc_combat"

void main()
{
  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC);
  object oFactionExample = GetObjectByTag("factionexample26");
  
  object oInfiltrator = GetFirstFactionMember(oFactionExample, 0);
  
  while (GetIsObjectValid(oInfiltrator))
  {
    if (GetObjectSeen(oPC, oInfiltrator))
	{
	  SetIsTemporaryEnemy(oPC, oInfiltrator);
	  AssignCommand(oInfiltrator, gsCBDetermineCombatRound());
	}
	
    oInfiltrator = GetNextFactionMember(oFactionExample, 0);
  }
}
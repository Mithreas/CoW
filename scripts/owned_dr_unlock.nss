/*
  Name: owned_door_unlock
  Author: Mithreas
  Date: 15 Apr 18
  Description: This script belongs on the OnUnlock slot of a door or chest
  owned by an NPC. If an NPC is nearby when it is opened/destroyed and the
  NPC can see the PC who did the deed, then the PC gets their bounty increased
  for breaking in.
  
  The bounty defaults to the standard theft bounty (100) but you can override
  this by setting the BOUNTY var on the object in question. 
*/
#include "inc_crime"
#include "inc_combat"

void main()
{
  int nCount = 1;
  object oPC  = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
  
  // Check to see whether the PC owns the required key.  If so, take no action.
  if (GetIsObjectValid(GetItemPossessedBy(oPC, GetLockKeyTag(OBJECT_SELF))))
  {
    return;
  }
  
  // Check whether the PC is near the door.  If not, they probably didn't open it...
  if (GetDistanceBetween(OBJECT_SELF, oPC) > 5.0f) return;
  
  // The PC unlocked this door without using a key.  Spring into action, O forces
  // of law and order.  
  object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                   PLAYER_CHAR_NOT_PC,
                                   OBJECT_SELF,
                                   nCount);
  float fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);

  while (fDistance < 20.0 && GetIsObjectValid(oNPC))
  {
    int nNation = CheckFactionNation(oNPC);
    if (GetCanSeeParticularPC(oPC, oNPC) && (nNation != NATION_INVALID))
    {
	  AssignCommand(oNPC, ActionSpeakString("Stop, thief!"));
	  int nBounty = GetLocalInt(OBJECT_SELF, "BOUNTY");
      AddToBounty(nNation, nBounty ==0 ? FINE_THEFT : nBounty, oPC);
    }
	else if (GetCanSeeParticularPC(oPC, oNPC))
	{
	  SetIsTemporaryEnemy(oPC, oNPC);
	  AssignCommand(oNPC, gsCBDetermineCombatRound());
	}

    nCount++;
    oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                              PLAYER_CHAR_NOT_PC,
                              OBJECT_SELF,
                              nCount);
    fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);
  }
}

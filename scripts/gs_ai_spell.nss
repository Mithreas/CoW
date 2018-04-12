#include "inc_combat"
#include "inc_event"
#include "inc_divination"
#include "inc_crime"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_SPELL_CAST_AT));

    if (GetLastSpellHarmful())
    {
        object oCaster = GetLastSpellCaster();

        if (GetIsPC(oCaster)) miDVGivePoints(oCaster, ELEMENT_FIRE, 0.2);

        if (gsCBGetHasAttackTarget())
        {
            object oTarget = gsCBGetLastAttackTarget();

            if (oCaster != oTarget &&
                (gsCBGetIsFollowing() ||
                 GetDistanceToObject(oCaster) <=
                 GetDistanceToObject(oTarget) + 5.0))
            {
                gsCBDetermineCombatRound(oCaster);
            }
        }
        else
        {
            gsCBDetermineCombatRound(oCaster);
        }
    }
	
	
   /*
    OnSpellCastAt addition to check faction and increase a PC's bounty if
    necessary.
    Author: Mithreas
    Date: 4 Sep 05
    Version: 1.1

    Rev 1.1 - add to bounty of master for associate's actions.
  */
  Trace(BOUNTY, "Calling bounty script");
  int nNation = CheckFactionNation(OBJECT_SELF);
  if (nNation != NATION_INVALID)
  {
    Trace(BOUNTY, "NPC is from a nation that gives bounties.");
    // Only add to bounty if the spell is harmful :)
    if (GetIsPC(GetLastSpellCaster()) && GetLastSpellHarmful())
    {
      Trace(BOUNTY, "Offensive spell cast by PC - add to their bounty!");
      AddToBounty(nNation, FINE_ASSAULT, GetLastSpellCaster());
    }
    else if ((GetAssociateType(GetLastSpellCaster()) != ASSOCIATE_TYPE_NONE) &&
             GetIsPC(GetMaster(GetLastSpellCaster())))
    {
      Trace(BOUNTY, "Adding to master's bounty");
      AddToBounty(nNation, FINE_ASSAULT, GetMaster(GetLastSpellCaster()));
    }
  }
}

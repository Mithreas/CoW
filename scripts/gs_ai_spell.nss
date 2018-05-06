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
	
	
  // Crime system hook.
  if (GetLastSpellHarmful()) IWasAttacked(OBJECT_SELF, GetLastSpellCaster());

}

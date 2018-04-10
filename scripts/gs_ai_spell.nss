#include "gs_inc_combat"
#include "gs_inc_event"
#include "mi_inc_divinatio"

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
}

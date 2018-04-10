#include "__server_config"
#include "gs_inc_combat"
#include "gs_inc_event"
#include "mi_inc_weather"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_COMBAT_ROUND_END));

    gsCBDetermineCombatRound();

    if (ALLOW_WEATHER) miWHDoCombatChecks(OBJECT_SELF);
}

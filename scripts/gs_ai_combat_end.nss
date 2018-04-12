#include "__server_config"
#include "inc_combat"
#include "inc_event"
#include "inc_weather"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_COMBAT_ROUND_END));

    gsCBDetermineCombatRound();

    if (ALLOW_WEATHER) miWHDoCombatChecks(OBJECT_SELF);
}

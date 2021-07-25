#include "inc_bonuses"
#include "nwnx_events"

void main()
{
    int mode = StringToInt(NWNX_Events_GetEventData("COMBAT_MODE_ID"));
    if (mode == ACTION_MODE_PARRY)
    {
        RemoveParryBonus(OBJECT_SELF);
    }
}

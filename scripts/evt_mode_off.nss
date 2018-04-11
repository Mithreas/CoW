#include "inc_bonuses"
#include "nwnx_events"

void main()
{
    int mode = StringToInt(NWNX_Events_GetEventData("MODE"));
    if (mode == ACTION_MODE_PARRY)
    {
        RemoveParryBonus(OBJECT_SELF);
    }
}

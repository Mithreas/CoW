#include "inc_bonuses"
#include "nwnx_events"

void main()
{
    int mode = StringToInt(NWNX_Events_GetEventData("MODE"));
    if (mode == ACTION_MODE_PARRY)
    {
        AddParryBonus(OBJECT_SELF);
    }
	if (mode == 12)
	{
	    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE);
	}
}

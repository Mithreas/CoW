// On feat use, after

#include "nwnx_events"

void main()
{
	int nFeat = StringToInt(NWNX_Events_GetEventData("FEAT_ID"));

	// Restore Defensive Stance uses.
	if (nFeat == FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE)
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE);
}
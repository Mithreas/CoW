// Restores the use of a feat after it's been used.
// Called by NWNX, see m_load for config.
#include "nwnx_events"
void main()
{
  IncrementRemainingFeatUses(OBJECT_SELF, StringToInt(NWNX_Events_GetEventData("FEAT_ID")));
}
// Restores the use of a feat after it's been used for the cost of 5 stamina.
// Called by NWNX, see m_load for config.
#include "inc_state"
#include "nwnx_events"
void main()
{
  int FEAT_PRESTIGE_DEFENSIVE_STANCE = 947; // appears to be missing from constant list.

  // The whitelist is shared for before and after feat use, so filter on feats we want here.
  if (StringToInt(NWNX_Events_GetEventData("FEAT_ID")) != FEAT_PRESTIGE_DEFENSIVE_STANCE) return;
  
  IncrementRemainingFeatUses(OBJECT_SELF, StringToInt(NWNX_Events_GetEventData("FEAT_ID")));
  gsSTDoCasterDamage(OBJECT_SELF, 5);
}
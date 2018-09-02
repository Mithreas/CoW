#include "inc_state"
void main()
{
  location lCurrent = GetLocation(OBJECT_SELF);
  location lLast    = GetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION");

  if (lLast == lCurrent) return;

  # Note - Anemoi uses a custom CreatureSpeed.2da file, PC movement increased from 2.0 to 2.5.
  # So normal walking distance is 6x2.5=15m, but heartbeats don't fire precisely on time, so
  # allow another second's worth of distance.
  if (GetDistanceBetweenLocations(lCurrent, lLast) > 17.5f)
  {
    gsSTAdjustState(GS_ST_STAMINA, -0.5);
  }
  
  SetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION", lCurrent);

}

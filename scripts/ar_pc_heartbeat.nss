#include "inc_common"
#include "inc_state"
void main()
{
  if (GetIsDM(OBJECT_SELF)) return;
  
  if (GetLocalInt(OBJECT_SELF, "TRANSITION"))
  {
    // Set in nw_g0_transition to avoid stamina loss when 
	// moving between floors etc. on the same map. 
    DeleteLocalInt(OBJECT_SELF, "TRANSITION");
	return;
  }
  location lCurrent = GetLocation(OBJECT_SELF);
  location lLast    = GetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION");

  if (lLast == lCurrent) 
  {
    gsSTAdjustState(GS_ST_STAMINA, 0.1);
    return;
  }

  float fSpeedRate = 1.0f;
  
  // Note: Barbarian and Monk speeds do not stack.
  if (GetLevelByClass(CLASS_TYPE_MONK) >= 3)
    fSpeedRate += (GetLevelByClass(CLASS_TYPE_MONK) / 3 * 0.1);
  else if (GetLevelByClass(CLASS_TYPE_BARBARIAN)) fSpeedRate += 0.1;
  
  // Note - Anemoi uses a custom CreatureSpeed.2da file, PC movement increased from 2.0 to 2.5.
  // So normal walking distance is 6x2.5=15m, but heartbeats don't fire precisely on time, so
  // allow another second's worth of distance.
  if (GetDistanceBetweenLocations(lCurrent, lLast) > 18.0f * fSpeedRate)
  {
    int nAC = gsCMGetItemBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF));
	
	float fPenalty = 0.2f;
	if (nAC > 5) fPenalty = 0.6f;
	else if (nAC > 3) fPenalty = 0.4f;
	if (GetLocalInt(GetArea(OBJECT_SELF), "IS_UNDERWATER")) fPenalty *= 2.0f;
    gsSTAdjustState(GS_ST_STAMINA, -fPenalty);
  }
  
  SetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION", lCurrent);

}

#include "inc_combat2"
#include "inc_common"
#include "inc_state"
void main()
{
  if (GetIsDM(OBJECT_SELF)) return;
  
  location lCurrent = GetLocation(OBJECT_SELF);
  location lLast    = GetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION");
  
  if (GetLocalInt(OBJECT_SELF, "TRANSITION"))
  {
    // Set in nw_g0_transition to avoid stamina loss when 
	// moving between floors etc. on the same map. 
    DeleteLocalInt(OBJECT_SELF, "TRANSITION");
    SetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION", lCurrent);
	return;
  }
  
  int bDiseased = gsC2GetHasEffect(EFFECT_TYPE_DISEASE, OBJECT_SELF, TRUE);

  if (lLast == lCurrent) 
  { 
    if (bDiseased) 
	{
	  // Do not change stamina.  Diseased people can stop stamina drain by 
	  // resting, but cannot raise it. 
	  return;
	}
  
    // Recover more quickly when sitting.
    if (lCurrent == GetLocalLocation(OBJECT_SELF, "MI_SIT_LOCATION"))
    {
      gsSTAdjustState(GS_ST_STAMINA, 0.3);    
    }
	else
	{	
      gsSTAdjustState(GS_ST_STAMINA, 0.1);
	}  
    return;
  }
  
  float fSpeedRate = 1.0f;
  float fPenalty = bDiseased ? 0.5f : 0.0f;
  
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
	
	if (nAC > 5) fPenalty += 0.6f;
	else if (nAC > 3) fPenalty += 0.4f;
	else fPenalty += 0.2f;
	if (GetLocalInt(GetArea(OBJECT_SELF), "IS_UNDERWATER")) fPenalty *= 2.0f;
  }
  
  if (fPenalty > 0.0f) gsSTAdjustState(GS_ST_STAMINA, -fPenalty);
  
  SetLocalLocation(OBJECT_SELF, "CURRENT_LOCATION", lCurrent);

}

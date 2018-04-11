// inc_traps
// Trap-related utility functions, including prehook.
// 12/3/2017 - Adding in 1 second cooldown on PC traps to counteract Trap Stacking

#include "inc_log"
#include "gs_inc_time"
const string TRAPS = "TRAPS"; // For logging

int miTRPreHook();
int miTRPreHook2(object oCreator, object oVictim);
int miTRPreHook()
{
  object oVictim = GetEnteringObject();
  object oCreator = GetTrapCreator(OBJECT_SELF);
  int nStamp, nTime;

  // PC on PC trapping
  if (GetIsObjectValid(oCreator) && GetIsPC(oVictim)) {
      nTime = gsTIGetActualTimestamp();
      nStamp = GetLocalInt(oCreator, "TRAP_STACKING_TIMESTAMP");
      if (nTime - nStamp < 10) {
          SendMessageToPC(oCreator, "A trap failed to trigger due to the proximity of other traps.");
          Log(TRAPS, GetName(oVictim) + " stepped into a trap created by " + GetName(oCreator) + ", but the trap failed to trigger due to Trap Stacking.");
          return TRUE; // avoid the trap
      } else {
          SetLocalInt(oCreator, "TRAP_STACKING_TIMESTAMP", nTime);
      }
  }

  return miTRPreHook2(oCreator, oVictim);
}

int miTRPreHook2(object oCreator, object oVictim)
{
  if (GetIsObjectValid(oCreator))
  {
    Log(TRAPS, GetName(oVictim) + " stepped into a trap created by " + GetName(oCreator));
  }
  else
  {
    Log(TRAPS, GetName(oVictim) + " stepped into a trap set via the toolset.");
  }
  
  if (GetTrapDetectedBy(OBJECT_SELF, oVictim))
  {
    // Workaround to the "you triggered a trap" message you can't disable...
    SendMessageToPC(oVictim, "...but you saw it, so were able to avoid it.");
    return TRUE;
  }

  return FALSE; // proceed.
}


//-------------------------------------------------------------------------------------------

// Clear traps near an object
void trapClearTrapsNear(object oObject, float fDistance = 10.0f, int bPC_Only = TRUE);

//-------------------------------------------------------------------------------------------

void trapClearTrapsNear(object oObject, float fDistance = 10.0f, int bPC_Only = TRUE)
{
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);

    // Search trap-able objects in range.
    while(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) <= fDistance)
    {
        // Disable traps within that range.  Only do PC-made traps if bPC_Only is TRUE.
        if(GetIsTrapped(oTrap) && (!bPC_Only || GetTrapCreator(oTrap) != OBJECT_INVALID))
        {
            SetTrapDisabled(oTrap);
        }

        // Get next object.
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}

// Calculate XP for trap. (DC - 20) * 5 - so dc 22 is 10xp, dc 32 is 60.
#include "inc_xp"

void CreateTrapAtLocationVoid(int nType, location lLoc, int nDetectDC, int nDisarmDC, string sTriggerScript)
{
  object oTrap = CreateTrapAtLocation(nType, lLoc, 2.0f, "", STANDARD_FACTION_HOSTILE, "trap_xp", sTriggerScript);
  SetTrapDetectDC(oTrap, nDetectDC);
  SetTrapDisarmDC(oTrap, nDisarmDC);
}

void main()
{
  object oPC     = GetLastDisarmed();
  object oTrap   = OBJECT_SELF;
  location lLoc  = GetLocation(oTrap);
  int nDisarmDC  = GetTrapDisarmDC(oTrap);
  float fXP      = IntToFloat((nDisarmDC - 15));

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");
  int nXP = FloatToInt(fXP * fMultiplier);
  if (nXP > 40) nXP = 40;
  if (fXP > 0.0f) gsXPDistributeExperience(oPC, nXP);

  // Respawn trap.
  if (!GetLocalInt(oTrap, "DYNAMIC_TRAP"))
  {
    float fRespawn = 1800.0f + IntToFloat(Random(1800));
    if (GetObjectType(oTrap) == OBJECT_TYPE_TRIGGER)
	{
      string sTriggerScript = GetEventScript(oTrap, EVENT_SCRIPT_TRIGGER_ON_TRAPTRIGGERED);	  
      AssignCommand(GetModule(), DelayCommand(fRespawn, CreateTrapAtLocationVoid(GetTrapBaseType(oTrap), lLoc, GetTrapDetectDC(oTrap), nDisarmDC, sTriggerScript)));	
	}
	else if (GetObjectType(oTrap) == OBJECT_TYPE_PLACEABLE)
	{
	  string sTriggerScript = GetEventScript(oTrap, EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED);
      AssignCommand(GetModule(), DelayCommand(fRespawn, CreateTrapOnObject(GetTrapBaseType(oTrap), oTrap, STANDARD_FACTION_HOSTILE, "trap_xp", sTriggerScript)));	  
	}
	else if (GetObjectType(oTrap) == OBJECT_TYPE_DOOR)
	{
	  string sTriggerScript = GetEventScript(oTrap, EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED);
      AssignCommand(GetModule(), DelayCommand(fRespawn, CreateTrapOnObject(GetTrapBaseType(oTrap), oTrap, STANDARD_FACTION_HOSTILE, "trap_xp", sTriggerScript)));	  
	}
  }										  
}

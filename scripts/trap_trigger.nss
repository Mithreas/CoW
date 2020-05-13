// Trigger the trap then respawn it.
void CreateTrapAtLocationVoid(int nType, location lLoc, int nDetectDC, int nDisarmDC)
{
  object oTrap = CreateTrapAtLocation(nType, lLoc, 2.0f, "", STANDARD_FACTION_HOSTILE, "trap_xp", "trap_trigger");
  SetTrapDetectDC(oTrap, nDetectDC);
  SetTrapDisarmDC(oTrap, nDisarmDC);
}

void main()
{
  object oPC     = GetEnteringObject();
  object oTrap   = OBJECT_SELF;
  location lLoc  = GetLocation(oTrap);
  int nDisarmDC  = GetTrapDisarmDC(oTrap);
  int nType      = GetTrapBaseType(oTrap);

  // Trigger the trap.
  string sScript = Get2DAString("traps", "TrapScript", nType);
  ExecuteScript(sScript, OBJECT_SELF);

  // Respawn trap if this is a one shot.
  if (!GetLocalInt(oTrap, "DYNAMIC_TRAP") && GetTrapOneShot(oTrap))
  {
    float fRespawn = 1800.0f + IntToFloat(Random(1800));
    if (GetObjectType(oTrap) == OBJECT_TYPE_TRIGGER)
	{
      AssignCommand(GetModule(), DelayCommand(fRespawn, CreateTrapAtLocationVoid(nType, lLoc, GetTrapDetectDC(oTrap), nDisarmDC)));	
	}
	else if (GetObjectType(oTrap) == OBJECT_TYPE_PLACEABLE || GetObjectType(oTrap) == OBJECT_TYPE_DOOR)
	{
      AssignCommand(GetModule(), DelayCommand(fRespawn, CreateTrapOnObject(nType, oTrap, STANDARD_FACTION_HOSTILE, "trap_xp", "trap_trigger")));	  
	}
  }										  
}
// Calculate XP for trap. (DC - 20) * 5 - so dc 22 is 10xp, dc 32 is 60.
#include "cow_createobject"
void main()
{
  object oPC     = GetLastDisarmed();
  string sResRef = GetResRef(OBJECT_SELF);
  location lLoc  = GetLocation(OBJECT_SELF);
  int nDisarmDC  = GetTrapDisarmDC(OBJECT_SELF);
  float fXP      = IntToFloat((nDisarmDC - 20) * 5);

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");
  GiveXPToCreature(oPC, FloatToInt(fXP * fMultiplier));

  // Respawn trap.
  AssignCommand(GetModule(), DelayCommand(300.0, CreateObjectReturnsVoid(
                                          OBJECT_TYPE_TRIGGER, sResRef, lLoc)));
}

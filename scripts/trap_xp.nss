// Calculate XP for trap. (DC - 20) * 25 - so dc 22 is 50xp, dc 32 is 400.
#include "cow_createobject"
void main()
{
  object oPC     = GetLastDisarmed();
  string sResRef = GetResRef(OBJECT_SELF);
  location lLoc  = GetLocation(OBJECT_SELF);
  int nDisarmDC  = GetTrapDisarmDC(OBJECT_SELF);
  float fXP      = IntToFloat((nDisarmDC - 20) * 25);

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");
  GiveXPToCreature(oPC, FloatToInt(fXP * fMultiplier));

  // Respawn trap.
  AssignCommand(GetModule(), DelayCommand(300.0, CreateObjectReturnsVoid(
                                          OBJECT_TYPE_TRIGGER, sResRef, lLoc)));
}

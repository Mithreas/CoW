#include "cow_xp"

void main()
{
  // Encounters can fire the OnEntered event several times, which is bad. So
  // work around it by marking this encounter "used".
  if (GetLocalInt(OBJECT_SELF, "recently_fired"))
  {
    // Return and do nothing.
    return;
  }

  // Otherwise, mark that we've fired.
  SetLocalInt(OBJECT_SELF, "recently_fired", 1);

  // Not sure if encounters destroy themselves and respawn. In case they
  // don't, clear the variable later.
  AssignCommand(GetModule(), DelayCommand(300.0, DeleteLocalInt(OBJECT_SELF, "recently_fired")));

  int nCount = 1;
  object oPC = GetNearestObject (OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount );
  float fDistance = GetDistanceBetween(oPC, OBJECT_SELF);

  while ((fDistance < 40.0) && GetIsObjectValid(oPC))
  {
     if (GetIsPC(oPC))
     {
       // Delay XP award by 5 seconds to avoid having XP as the "warning" sign.
       // Assign to the mod as the encounter object blows up and hence can't
       // execute delayed commands.
       AssignCommand(GetModule(), DelayCommand(5.0, GiveXPToPC (oPC)));
     }

     nCount ++;
     oPC = GetNearestObject (OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount );
     fDistance = GetDistanceBetween(oPC, OBJECT_SELF);
  }

}

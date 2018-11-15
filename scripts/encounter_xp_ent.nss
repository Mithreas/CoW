#include "cow_xp"

void main()
{
  // Encounters can fire the OnEntered event several times, which is bad. So
  // work around it by marking this encounter "used".
  object oSelf = OBJECT_SELF;
  if (GetLocalInt(oSelf, "recently_fired"))
  {
    // Return and do nothing.
    return;
  }

  // Otherwise, mark that we've fired to avoid all members of a party triggering it.
  SetLocalInt(oSelf, "recently_fired", 1);
  DelayCommand(300.0, DeleteLocalInt(oSelf, "recently_fired"));

  int nCount = 1;
  object oPC = GetNearestObject (OBJECT_TYPE_CREATURE, oSelf, nCount );
  float fDistance = GetDistanceBetween(oPC, oSelf);

  while ((fDistance < 50.0) && GetIsObjectValid(oPC))
  {
     if (GetIsPC(oPC))
     {
       // Delay XP award by 5 seconds to avoid having XP as the "warning" sign.
       // Assign to the mod as the encounter object blows up and hence can't
       // execute delayed commands.
       AssignCommand(GetModule(), DelayCommand(5.0, GiveXPToPC (oPC)));
     }

     nCount ++;
     oPC = GetNearestObject (OBJECT_TYPE_CREATURE, oSelf, nCount );
     fDistance = GetDistanceBetween(oPC, oSelf);
  }
}

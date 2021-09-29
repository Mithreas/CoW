// Script triggers after removing a polymorph ability.
// Shapechanger race - re-apply scaling correction.
#include "inc_pc"
void main()
{
  // Putting code in here doesn't seem to fire visual effect changes reliably. 
  // Perhaps because it runs server side and there's no associated client trigger.
  // It also seems to fire twice.

  object oPC = OBJECT_SELF;
  gsPCRefreshCreatureScale(oPC);
}

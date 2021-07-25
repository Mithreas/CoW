// Script triggers after removing a polymorph ability.
// Shapechanger race - re-apply scaling correction.
// Moved to m_unequip.
#include "inc_pc"
#include "inc_shapechanger"
void main()
{
  // Putting code in here doesn't seem to fire visual effect changes reliably. 
  // Perhaps because it runs server side and there's no associated client trigger.
  // It also seems to fire twice.

  object oPC = OBJECT_SELF;
  object oHide = gsPCGetCreatureHide(oPC);

}

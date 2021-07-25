// Assassinate feat script.
#include "inc_assassin"

void main()
{
  object oPC = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  
  if (asCanAssassinate(oPC, oTarget))
  {
       asApplyDamage(oPC, oTarget);
  }
}
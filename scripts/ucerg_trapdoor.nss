#include "inc_teleport"
#include "inc_house_check"
void main()
{
  object oPC = GetLastUsedBy();
  if (!isShadow(oPC))
  {
    FloatingTextStringOnCreature("The trapdoor is locked.", oPC);
    return;
  }

  JumpAllToObject(oPC, GetObjectByTag("WP_ucerg_lower"));
}
#include "inc_climb"
void main()
{
  // PC tries to ford the river.  Strength test that applies armor check
  // penalties.
  object oPC = GetClickingObject();
  int bCheck = (d20() +
                GetAbilityModifier(ABILITY_STRENGTH, oPC) -
                miCBGetArmorCheckPenalty(oPC)) > 15;


  if (bCheck)
  {
    SendMessageToPC(oPC, "You successfully make your way across the ford.");
    ExecuteScript("nw_g0_transition", OBJECT_SELF);
  }
  else SendMessageToPC(oPC, "The water flows too swiftly and you are forced back to shore.");
}

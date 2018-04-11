#include "inc_adv_xp"

void main()
{

  object oPC = GetEnteringObject();

  // handle adventuring xp and message for this trigger
  if (GetIsPC(oPC) && !GetIsDM(oPC)) {
    gvd_AdventuringXP_ForObject(oPC, "TRIGGER", OBJECT_SELF);
  }
 
}

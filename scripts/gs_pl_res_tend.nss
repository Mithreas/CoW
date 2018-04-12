#include "inc_worship"
void main()
{
  object oPC = GetLastClosedBy();
  if (!GetIsPC(oPC)) return;

  // check for PC planted plants outside the designated areas
  if (GetLocalInt(OBJECT_SELF, "GVD_WITHERED") == 1) {
    FloatingTextStringOnCreature("This plant looks withered, you might save it by moving it to more fertile ground soon.", oPC);

  } else {

    if ((GetLocalInt(OBJECT_SELF, "TENDED_TO") == 0) &&
      ( GetLocalInt(gsPCGetCreatureHide(oPC), "GIFT_GREENFINGERS") || (
      gsWOGetDeityAspect(oPC) & ASPECT_NATURE &&
      (gsCMGetHasClass(CLASS_TYPE_RANGER, oPC) || gsCMGetHasClass(CLASS_TYPE_DRUID, oPC) ||
      gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC)))))
    {
      // Tend to the plant
      gsWOAdjustPiety(oPC, 1.0f);
      SetLocalInt(OBJECT_SELF, "TENDED_TO", 1);

      FloatingTextStringOnCreature("You tend to the plant, encouraging it to bloom once more.", oPC);
    }
  }
}

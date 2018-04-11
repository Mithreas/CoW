#include "inc_bar"

void main()
{
  // check if a BarKeeper leaves the bar area

  object oPC = GetExitingObject();
  string sBarID = GetBarID(OBJECT_SELF);

  if (GetIsBarkeeper(oPC, sBarID) == 1) {
    // log bar shift end
    BarkeeperShiftEnd(oPC, sBarID);
  }

}

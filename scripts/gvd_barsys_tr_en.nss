#include "inc_bar"

void main()
{

  object oPC = GetEnteringObject();
  string sBarID = GetBarID(OBJECT_SELF);

  // check if the PC is a barkeeper
  if (GetIsBarkeeper(oPC, sBarID) == 1) {
    // log starting time for shift
    BarkeeperShiftStart(oPC, sBarID);
  } else {
    // check for gvd_autohire variable, used in the Nomad, where quarter ownership ensures only barkeeper PCs are behind the bar
    if (GetLocalInt(OBJECT_SELF, "gvd_autohire") == 1) {
      HireBarkeeper(oPC, sBarID);
      BarkeeperShiftStart(oPC, sBarID);      
    }
  }

}


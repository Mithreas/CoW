#include "inc_bar";

void main()
{
  // create an item with resref gvd_bardrink1 on the placeable and set it's name to either the value of gvd_fixed_drink variable on the
  // gvd_barsys_res placeable, or the name of the placeable

  object oPC = GetLastUsedBy();

  if (GetIsPC(oPC) == TRUE) {

    // does the gvd_barid variable of the placeable match with that on the PC? Thus is the PC an employee of the bar?
    string sBarID = GetBarID(OBJECT_SELF);
    if (GetIsBarkeeper(oPC, sBarID) == 1) {

      string sDrinkName = GetLocalString(OBJECT_SELF,"gvd_fixed_drink");
      if (sDrinkName == "") {
        sDrinkName = GetName(OBJECT_SELF);
      }
      int iDraft = GetLocalInt(OBJECT_SELF,"gvd_draft");

      // when a PC barkeeper draws a drink from one of the Bars resources, that's signal for the NPC to disappear
      // RemoveBarkeeperNPC(sBarID);

      // depending on barkeeper level, determine the cost price of the drink, 3gc for starters, 2 for average, 1 for experts
      GetDrinkForBarkeeper(oPC, sBarID, sDrinkName, iDraft);

    } else {
      FloatingTextStringOnCreature("You don't work here!", oPC);
    }

  }

}

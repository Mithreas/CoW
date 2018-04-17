/*
  Name: chat_meditate
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the praying widget.
	Now reworked to be a console command: -meditate. 
*/
#include "inc_chatutils"
#include "inc_examine"
#include "inc_log"
#include "x2_inc_switches"
const string TRAINING = "TRAINING";

const string HELP = "Use this to meditate on spiritual mysteries.  Doing so in an appropriate location will be more effective.";

void main()
{
  object oPC = OBJECT_SELF;
  chatVerifyCommand(oPC);

  if (chatGetParams(oPC) == "?")
  {
    DisplayTextInExamineWindow("-meditate", HELP);
  }
  else
  {
    Trace(TRAINING, "Praying started");
    object oPC = GetItemActivator();

    // If already praying, ignore this use.
    location lPrayLoc = GetLocalLocation(oPC, "pray_location");
    if (GetIsObjectValid(GetAreaFromLocation(lPrayLoc)))
    {
      // PC is already meditating, so return.
      return;
    }

    Trace(TRAINING, "Calling ExecuteScript");
    DelayCommand(6.0, ExecuteScript("mi_prayhb", oPC));

    location lPCLocation = GetLocation(oPC);
    SetLocalLocation(oPC, "pray_location", lPCLocation);
	
    // Unequip weapons if holding them.
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if (GetIsObjectValid(oItem))
    {
      AssignCommand(oPC, ActionUnequipItem(oItem));
    }

    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (GetIsObjectValid(oItem))
    {
      AssignCommand(oPC, ActionUnequipItem(oItem));
    }

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 60.0));
  }	
}

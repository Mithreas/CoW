/*
  Name: obj_trainwidg
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the training widget.
*/
#include "mi_log"
#include "x2_inc_switches"
const string TRAINING = "TRAINING";
void main()
{
  // If this script was called in an acquire routine, run away.
  if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
  { Trace(TRAINING, "Training object not activated"); return; }

  Trace(TRAINING, "Training Widget Used");
  object oPC = GetItemActivator();
  // Next lines added to prevent multiple copies of the script being run at
  // once.
  if (GetLocalInt(oPC, "is_training"))
  { SendMessageToPC(oPC, "Please finish your current round of training!");return;}

  SetLocalInt(oPC, "is_training", 1);
  Trace(TRAINING, "Calling ExecuteScript");
  DelayCommand(12.0, ExecuteScript("mi_trainhb", oPC));
  object oDummy = CreateObject(OBJECT_TYPE_PLACEABLE,
                               "trainingdummy",
                               GetLocation(oPC));

  DelayCommand(1.0, AssignCommand(oPC, ActionAttack(oDummy)));

}

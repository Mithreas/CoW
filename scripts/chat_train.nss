/*
  Name: chat_train
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the training widget.
	Now reworked to be a console command: -train. 
*/
#include "inc_chatutils"
#include "inc_examine"
#include "inc_log"
#include "x2_inc_switches"
const string TRAINING = "TRAINING";

const string HELP = "Use this to practice your martial moves.  Doing so in an appropriate location will be more effective.";

void main()
{
  object oPC = OBJECT_SELF;
  chatVerifyCommand(oPC);

  if (chatGetParams(oPC) == "?")
  {
    DisplayTextInExamineWindow("-train", HELP);
  }
  else
  {
    Trace(TRAINING, "Training started.");
  
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
}

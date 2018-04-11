/*
  Name: mi_trainhb
  Author: Mithreas
  Date: 19/01/06
  Description:
  Pseudo-heartbeat that is fired while training. To use, ExecuteScript() on
  the training PC.
*/
#include "inc_activity"
void main()
{
  Trace(TRAINING, "Called training heartbeat script");
  object oPC = OBJECT_SELF;

  Trace(TRAINING, "Checking whether still training.");
  // Check if still training.
  if (GetIsInCombat(oPC))
  {
    // training_time counts the number of heartbeats, i.e. 6s intervals.
    int nTimeSoFar = GetLocalInt(oPC, "training_time");
    nTimeSoFar++;

    //Play description
    TrainingDescription(oPC);
    if (GetLocalInt(GetArea(oPC), IS_DOJO))
    {
      Trace(TRAINING, "In dojo.");
      GiveXP(oPC, TRUE);
    }
    else
    {
      Trace(TRAINING, "Not in dojo.");
      GiveXP(oPC);
    }

    if (nTimeSoFar == 20) // 120 s, check for a training benefit
    {
      Trace(TRAINING, "Checking whether to give training boost");
      int nDieRoll = d3();
      if (nDieRoll == 3)
      {
        Trace(TRAINING, "Giving training boost");
        GiveTrainingBoost(oPC);
      }
      else
      {
        Trace(TRAINING, "Not giving training bonus. Roll was: " + IntToString(nDieRoll));
      }

      ClearAllActions();
      DeleteLocalInt(oPC, "training_time");
      DeleteLocalInt(oPC, "is_training");
    }
    else
    {
      Trace(TRAINING, "Still training, kick off script again.");
      DelayCommand(6.0, ExecuteScript("mi_trainhb", oPC));
      SetLocalInt(oPC, "training_time", nTimeSoFar);
      return;
    }
  }

  Trace(TRAINING, "Stopped training");
  DeleteLocalInt(oPC, "training_time");
  DestroyObject(GetObjectByTag("trainingdummy"));
  DeleteLocalInt(oPC, "is_training");
}

/*
  Name: mi_reshb
  Author: Mithreas
  Date: 19/01/06
  Description:
  Pseudo-heartbeat that is fired while researching. To use, ExecuteScript() on
  the praying PC.
*/
#include "inc_activity"
void main()
{
  Trace(TRAINING, "Called research heartbeat script");
  object oPC = OBJECT_SELF;

  Trace(TRAINING, "Checking whether still praying.");
  // Check if still praying.
  location lPCLocation = GetLocation(oPC);
  location lResLoc = GetLocalLocation(oPC, "research_location");
  if (lPCLocation == lResLoc)
  {
    // research_time counts the number of heartbeats, i.e. 6s intervals.
    int nTimeSoFar = GetLocalInt(oPC, "research_time");
    nTimeSoFar++;

    // Play a description.
    ResearchDescription(oPC);

    if (GetLocalInt(GetArea(oPC), IS_LIB))
    {
      Trace(TRAINING, "In library.");
      GiveXP(oPC, TRUE);
    }
    else
    {
      Trace(TRAINING, "Not in library.");
      GiveXP(oPC);
    }

    if (nTimeSoFar == 20) // 120 s, check whether they learn something
    {
      // Kill the script to prevent people alt-tabbing.
      DeleteLocalLocation(oPC, "research_location");
      DeleteLocalInt(oPC, "research_time");
      Trace(TRAINING, "Checking whether to give training boost");
      if (d3() == 3)
      {
        Trace(TRAINING, "Giving information");
        GiveResearchInformation(oPC);
      }
    }
    else
    {
      Trace(TRAINING, "Still researching, kick off script again.");
      DelayCommand(6.0, ExecuteScript("mi_reshb", oPC));
      SetLocalInt(oPC, "research_time", nTimeSoFar);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
      // The read animation takes about 2s, so sit for the rest of the 6s.
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 4.0));
    }
  }
  else
  {
    Trace(TRAINING, "Stopped researching");
    DeleteLocalInt(oPC, "research_time");
    DeleteLocalLocation(oPC, "research_location");
  }
}

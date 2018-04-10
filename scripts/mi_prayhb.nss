/*
  Name: mi_prayhb
  Author: Mithreas
  Date: 19/01/06
  Description:
  Pseudo-heartbeat that is fired while praying. To use, ExecuteScript() on
  the praying PC.
*/
#include "mi_traininc"
void main()
{
  Trace(TRAINING, "Called praying heartbeat script");
  object oPC = OBJECT_SELF;

  Trace(TRAINING, "Checking whether still praying.");
  // Check if still praying.
  location lPCLocation = GetLocation(oPC);
  location lPrayLoc = GetLocalLocation(oPC, "pray_location");
  if (lPCLocation == lPrayLoc)
  {
    // praying_time counts the number of heartbeats, i.e. 6s intervals.
    int nTimeSoFar = GetLocalInt(oPC, "praying_time");
    nTimeSoFar++;

    // Play a description.
    PrayerDescription(oPC);

    if (GetLocalInt(GetArea(oPC), IS_TEMP))
    {
      Trace(TRAINING, "In temple.");
      GiveXP(oPC, TRUE);
    }
    else
    {
      Trace(TRAINING, "Not in temple.");
      GiveXP(oPC);
    }

    if (nTimeSoFar == 10) // 60 s, give prayer point
    {
      Trace(TRAINING, "Giving prayer point to god.");
      DeleteLocalLocation(oPC, "pray_location");
      DeleteLocalInt(oPC, "praying_time");
      GivePrayerPoint(oPC);
    }
    else
    {
      Trace(TRAINING, "Still praying, kick off script again.");
      DelayCommand(6.0, ExecuteScript("mi_prayhb", oPC));
      SetLocalInt(oPC, "praying_time", nTimeSoFar);
    }
  }
  else
  {
    Trace(TRAINING, "Stopped praying");
    DeleteLocalInt(oPC, "praying_time");
    DeleteLocalLocation(oPC, "pray_location");
  }
}

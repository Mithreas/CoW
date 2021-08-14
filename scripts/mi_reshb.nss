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

  Trace(TRAINING, "Checking whether still researching.");
  // Check if still researching.
  location lPCLocation = GetLocation(oPC);
  location lResLoc = GetLocalLocation(oPC, "research_location");
  if (lPCLocation == lResLoc)
  {
    // research_time counts the number of heartbeats, i.e. 6s intervals.
    int nTimeSoFar = GetLocalInt(oPC, "research_time");
    nTimeSoFar++;

    // Play a description.
    ResearchDescription(oPC);
	
    GiveXP(oPC, TRUE);

    if (nTimeSoFar == 10) // 60 s, check whether they learn something
    {
      // Kill the script to prevent people alt-tabbing.
      DeleteLocalLocation(oPC, "research_location");
      DeleteLocalInt(oPC, "research_time");
      Trace(TRAINING, "Checking whether to give training boost");
	  	  
      // Humans are quicker to put information together than other 
      // races.	  
	  int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC) + 
	     (GetRacialType(oPC) == RACIAL_TYPE_HUMAN ? 4 : 0);
		 
	  if (d20() + nInt > 15)	 
      {
        Trace(TRAINING, "Giving information");
        GiveResearchInformation(oPC);
		if (gsWOGetAspect(gsWOGetDeityByName(GetDeity(oPC))) & ASPECT_KNOWLEDGE_INVENTION) gsSTAdjustState(GS_ST_PIETY, 0.1);
      }
	  else
	  {
        Trace(TRAINING, "Not giving information");
		SendMessageToPC(oPC, "You don't find anything especially interesting this time.");
	  }
    }
    else
    {
      Trace(TRAINING, "Still researching, kick off script again.");
      DelayCommand(6.0, ExecuteScript("mi_reshb", oPC));
      SetLocalInt(oPC, "research_time", nTimeSoFar);
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
    }
  }
  else
  {
    Trace(TRAINING, "Stopped researching");
    DeleteLocalInt(oPC, "research_time");
    DeleteLocalLocation(oPC, "research_location");
  }
}

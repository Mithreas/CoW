/*
  Name: chat_research
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the research widget.
*/
#include "inc_chatutils"
#include "inc_examine"
#include "inc_log"
#include "x2_inc_switches"
const string TRAINING = "TRAINING";

const string HELP = "Use this to study.  Doing so in an appropriate location will be more effective.";

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
    Trace(TRAINING, "Research Widget Used");
    object oPC = GetItemActivator();

    // If already praying, ignore this use.
    location lResLoc = GetLocalLocation(oPC, "research_location");
    if (GetIsObjectValid(GetAreaFromLocation(lResLoc)))
    {
      // PC is already researching, so return.
      return;
    }  

    Trace(TRAINING, "Calling ExecuteScript");
    DelayCommand(6.0, ExecuteScript("mi_reshb", oPC));

    location lPCLocation = GetLocation(oPC);
    SetLocalLocation(oPC, "research_location", lPCLocation);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
    // The read animation takes about 2.5s, so sit for the rest of the 6s.
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3.5));
  }	
}

/*
  Name: chat_research
  Author: Mithreas
  Date: 19/01/06
  Description:
    OnUsed script for the research widget.
*/
#include "inc_activity"
#include "inc_chatutils"
#include "inc_examine"
#include "inc_log"
#include "x2_inc_switches"

const string HELP = "Use this to study.  You have to be in a suitable location, such as the University.";

void main()
{
  object oPC = OBJECT_SELF;
  chatVerifyCommand(oPC);

  if (chatGetParams(oPC) == "?")
  {
    DisplayTextInExamineWindow("-research", HELP);
  }
  else
  {
  
    if (!GetLocalInt(GetArea(oPC), IS_LIB))
    {
      Trace(TRAINING, "Not in library => cannot research");
	  FloatingTextStringOnCreature("You must be in a library to research.  Try the University?", oPC); 
    }
	
    Trace(TRAINING, "Research Widget Used");

    // If already researching, ignore this use.
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
  }	
}

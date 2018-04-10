#include "fb_inc_chatutils"
#include "gs_inc_combat2"
#include "inc_examine"
#include "ar_utils"

const string HELP = "-makesafe is available for OOC use only.  If you're physically stuck somewhere in the module with no way to escape, and you're not in a cell or something (!), you can use -makesafe to get out without needing a DM.";
void main()
{
  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-makesafe", HELP);
  }
  else
  {
    Log(CHATCMD, GetName(oSpeaker) + " used -makesafe in area " + GetName(GetArea(oSpeaker)));

    if (!GetIsInCombat(oSpeaker) &&
        !gsC2GetHasEffect(EFFECT_TYPE_PETRIFY, oSpeaker) &&
        !gsC2GetHasEffect(EFFECT_TYPE_PARALYZE, oSpeaker))
    {
      FloatingTextStringOnCreature("Please wait while we unstick you...", oSpeaker, FALSE);
      SetCutsceneMode(oSpeaker, TRUE, FALSE);

      //::  Get Waypoint tagged as 'makesafe' first as a priority, if it can't be found fallback to old behavior.
      object oWP = GetObjectByTagInAreaEx("makesafe", GetArea(oSpeaker));
      if ( !GetIsObjectValid(oWP) ) oWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, oSpeaker);

      AssignCommand(oSpeaker, ActionJumpToObject(oWP));

      DelayCommand(5.0, SetCutsceneMode(oSpeaker, FALSE, TRUE));
    }
  }

  chatVerifyCommand(oSpeaker);
}

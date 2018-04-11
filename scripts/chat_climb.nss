#include "__server_config"
#include "fb_inc_chatutils"
#include "gs_inc_flag"
#include "inc_climb"
#include "inc_examine"

const string HELP = "Use -climb to climb up or down normally impassable terrain. This only works in certain areas.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!ALLOW_CLIMBING || !miCBGetCanClimb(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-climb", HELP);
  }
  else
  {
    if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker))
    {
      FloatingTextStringOnCreature(GS_T_16777454, oSpeaker, FALSE);
    }
    else if (!GetLocalInt(oSpeaker, "MI_CLIMBING")) // Don't allow spam.
    {
      object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oSpeaker);
      if (GetDistanceBetween(oSpeaker, oDoor) > 0.0 &&
          GetDistanceBetween(oSpeaker, oDoor) < 3.0)
      {
        // PC is too close to a door.
        SendMessageToPC(oSpeaker, "<cþ  >No climbing through doors!");
      }
      else
      {
        location lTarget = miCBGetClimbTargetLocation(oSpeaker);

        SetLocalLocation(oSpeaker, "MI_STARTING_LOCATION", GetLocation(oSpeaker));
        AssignCommand(oSpeaker, ActionJumpToLocation(lTarget));
        SetLocalInt(oSpeaker, "MI_CLIMBING", 1);
        SetCutsceneMode(oSpeaker, TRUE); // No other movement allowed.
        DelayCommand(0.5, ExecuteScript("mi_climb_check", oSpeaker));
      }
    }
  }

  chatVerifyCommand(oSpeaker);
}

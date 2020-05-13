/**
  AI script for spirits
  Author: Mithreas
  Date: 30th April 2020
  
  Spirits vanish to all players on spawn, but when they perceive a player with a 
  relevant class, they appear for that player.  
  
  Spirits also don't move or engage in other AI behaviours.  
  
  Relevant classes are bard/druid/ranger/sorc/wizard.
*/
#include "inc_ai"
#include "inc_event"
#include "inc_behaviors"
#include "nwnx_visibility"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................
    {
	    object oPC   = GetLastPerceived();
	    if (!GetIsPC(oPC) || GetIsDM(oPC) || !GetLastPerceptionSeen()) return;
	    
		if (GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
		    GetLevelByClass(CLASS_TYPE_DRUID, oPC) ||
			GetLevelByClass(CLASS_TYPE_RANGER, oPC) ||
			GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
			GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
	    {
		  // Reset explicitly to try and make this more reliable.
		  NWNX_Visibility_SetVisibilityOverride(oPC, OBJECT_SELF, NWNX_VISIBILITY_DEFAULT);
		  NWNX_Visibility_SetVisibilityOverride(oPC, OBJECT_SELF, NWNX_VISIBILITY_VISIBLE);
		}

        break;
    }
    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
	    NWNX_Visibility_SetVisibilityOverride(OBJECT_INVALID, OBJECT_SELF, NWNX_VISIBILITY_DM_ONLY);
		DelayCommand (1.0f, gsAIClearActionMatrix());
//................................................................
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}

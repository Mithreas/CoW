#include "inc_achievements"
#include "inc_combat"
#include "inc_event"
#include "inc_behaviors"
#include "nw_i0_spells"
#include "X2_I0_SPELLS"

void DoDoom(object oTarget)
{  
	if (GetLocalInt(oTarget, "DOOMED") == TRUE)
	{
      // Go directly to Death.  Do not pass Go, do not collect $200.
	  ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
	}  
}

void DoCurse()
{
  object oSelf = OBJECT_SELF;
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES), oSelf);
  int nCount = 0;
  int nCnt = 0;
  
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oSelf), TRUE, OBJECT_TYPE_CREATURE);
  
  while (GetIsObjectValid(oTarget))
  {
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
	{
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, CreateDoomEffectsLink(), oTarget, 11.0f);
	
	  SetLocalInt(oTarget, "DOOMED", TRUE);
	  SetLocalObject(oTarget, "DOOMER", OBJECT_SELF);
	  DelayCommand(10.0f, DoDoom(oTarget));
	}
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oSelf), TRUE, OBJECT_TYPE_CREATURE);
  }  
}

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................
    {
	    // Possibly trigger a curse effect.
		if (d6() == 6)
		{
		  DoCurse();
		}
		else
		{
		  // Do nothing... for now.
		}

        break;
    }
    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................
    {
		int nNth = 1;
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		
		while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 35.0f)
		{
		    acAwardAchievement(oPC, "watcher");
			nNth++;
			oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		}

        break;
    }
    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................

        break;
		
    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}

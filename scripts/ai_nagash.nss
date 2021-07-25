#include "inc_achievements"
#include "inc_event"
#include "inc_behaviors"
#include "inc_state"
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
	    // Check whether our phylactories are in place.
		// PCK_GEM1 - regeneration
		if (GetIsObjectValid(GetObjectByTag("PCK_GEM1")))
		{
		  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(50), OBJECT_SELF);
		  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_GREATER), OBJECT_SELF);		  
		}
		
		// PCK_GEM2 - summon ghosts
		if (GetIsObjectValid(GetObjectByTag("PCK_GEM2")))
		{
		  int nCount = d3();
		  object oGhost; 
		  
		  switch (nCount)
		  {
		    case 3:
		      oGhost = CreateObject(OBJECT_TYPE_CREATURE, "ghost4", GetLocation(OBJECT_SELF));
			  AssignCommand(oGhost, SpeakString("*rises up from the stone floor*"));
			case 2:
		      oGhost = CreateObject(OBJECT_TYPE_CREATURE, "ghost4", GetLocation(OBJECT_SELF));
			  AssignCommand(oGhost, SpeakString("*rises up from the stone floor*"));
			case 1:
		      oGhost = CreateObject(OBJECT_TYPE_CREATURE, "ghost4", GetLocation(OBJECT_SELF));
			  AssignCommand(oGhost, SpeakString("*rises up from the stone floor*"));
			  break;
		  }			
		}		
		
		// PCK_GEM3 - drain stamina
		if (GetIsObjectValid(GetObjectByTag("PCK_GEM3")))
		{
		  int nStamina = 0;
		  int nNth = 1;
		  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		  while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 25.0f)
		  {
		    if (!GetIsDM(oPC))
			{
			  FloatingTextStringOnCreature("Stamina drained!", oPC, FALSE);
			  gsSTDoCasterDamage(oPC, 5);
		      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
			  nStamina += 5;
			}
			
			nNth++;
			oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		  }
		  
		  if (nStamina)
		  {
		    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(nStamina), OBJECT_SELF);
		    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), OBJECT_SELF);
		  }			  
		}
		
		// PCK_GEM4 - damage reduction effect
		if (GetIsObjectValid(GetObjectByTag("PCK_GEM4")))
		{
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 90), OBJECT_SELF, 6.0f);
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 90), OBJECT_SELF, 6.0f);
		  // Already immune to negative 
		  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY), OBJECT_SELF, 6.0f);
		}
				
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 200), OBJECT_SELF, 6.0f);

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
		    acAwardAchievement(oPC, "nagashi");
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

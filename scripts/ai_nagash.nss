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
		  
		  while (nCount > 0);
		  {
		    oGhost = CreateObject(OBJECT_TYPE_CREATURE, "ghost4", GetLocation(OBJECT_SELF));
			AssignCommand(oGhost, SpeakString("*rises up from the stone floor*"));
			
			nCount --;
		  }
		}		
		
		// PCK_GEM3 - drain stamina
		if (GetIsObjectValid(GetObjectByTag("PCK_GEM3")))
		{
		  int nStamina = 0;
		  
		  object oPC = GetFirstObjectInArea(OBJECT_SELF);
		  while (GetIsObjectValid(oPC))
		  {
		    if (GetIsPC(oPC) && !GetIsDM(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 25.0f)
			{
			  gsSTAdjustState(GS_ST_STAMINA, -5.0f, oPC);
		      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), OBJECT_SELF);
			  nStamina += 5;
			}
			
			oPC = GetNextObjectInArea(OBJECT_SELF);
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

#include "inc_achievements"
#include "inc_combat"
#include "inc_event"
#include "inc_behaviors"
#include "nw_i0_spells"
#include "X2_I0_SPELLS"

// Myconid boss
// Spawns 9 copies of itself.
// Each of the 10 copies gets immunity to everything except for one damage type and one effect type
// A coloured VFX indicates which vulnerability is which.

void ApplyImmunity(object oCreature, int nType)
{  
  effect eImmune = EffectVisualEffect(VFX_DUR_PIXIEDUST);
  if (nType != 1) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100));
  if (nType != 2) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
  if (nType != 3) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));
  if (nType != 4) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100));
  if (nType != 5) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
  if (nType != 6) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100));
  if (nType != 7) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100));
  if (nType != 8) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100));
  if (nType != 9) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100));
  if (nType != 10) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100));
  if (nType != 11) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100));
  if (nType != 12) eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100));
  
  if (nType != 1) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_POISON));
  if (nType != 2) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
  if (nType != 3) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
  if (nType != 4) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_STUN));
  if (nType != 5) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_DAZED));
  if (nType != 6) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_SLOW));
  if (nType != 7) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_SILENCE));
  if (nType != 8) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_DEATH));
  if (nType != 9) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
  if (nType != 10) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
  if (nType != 11) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
  if (nType != 12) eImmune = EffectLinkEffects(eImmune, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
  
  if (nType == 1) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_GREEN));
  if (nType == 2) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_ICESKIN));
  if (nType == 3) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_INFERNO));
  if (nType == 4) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_ORANGE));
  if (nType == 5) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_AURA_CYAN));
  if (nType == 6) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
  if (nType == 7) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_PURPLE));
  if (nType == 8) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_WHITE));
  if (nType == 9) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_PROT_STONESKIN));
  if (nType == 10) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_BROWN));
  if (nType == 11) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
  if (nType == 12) eImmune = EffectLinkEffects(eImmune, EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE));
  
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune, oCreature);
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
	    // TODO - Run a special ability.  Options:
		// Poison cloud - do physical stat and ASF effects to affected creatures
		// Stun spores - save or stun		
		// (for now, just throws spines at enemies)
		
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
	    if (GetLocalInt(OBJECT_SELF, "SPAWN") == 2)
	    {
			int nNth = 1;
			object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
		
			while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) <= 35.0f)
			{
				acAwardAchievement(oPC, "mushroom");
				nNth++;
				oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
			}
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
        if (!GetLocalInt(OBJECT_SELF, "SPAWN"))
	    {
		  // Create 9 more of ourselves.
		  int nCount = 0;
		  object oSpawn;
		  for (nCount; nCount < 9; nCount++)
		  {
		    oSpawn = CreateObject(OBJECT_TYPE_CREATURE, GetResRef(OBJECT_SELF), GetLocation(OBJECT_SELF));
			ApplyImmunity(oSpawn, d12(1));	
			SetLocalInt(oSpawn, "SPAWN", TRUE);
		  }
		  
		  ApplyImmunity(OBJECT_SELF, d12(1));
		  SetLocalInt(OBJECT_SELF, "SPAWN", 2);
		}
		
        break;
    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}

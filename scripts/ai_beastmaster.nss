#include "inc_combat"
#include "inc_event"
#include "inc_behaviors"
#include "nw_i0_spells"
#include "X2_I0_SPELLS"

void BreatheIn()
{
  object oSelf = OBJECT_SELF;
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSelf);
  int nCount = 0;
  int nCnt = 0;
  
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oSelf), TRUE, OBJECT_TYPE_CREATURE);
  
  while (GetIsObjectValid(oTarget))
  {
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
	{
	  if (GetIsObjectValid(GetMaster(oTarget)))
	  {
        //Search through and remove protections.
        while(nCnt <= NW_I0_SPELLS_MAX_BREACH)
        {
            int nBreachId = GetSpellBreachProtection(nCnt);
			if (RemoveProtections(nBreachId, oTarget, nCnt)) 
			{
			  nCount++;
			  break;
            }
			nCnt++;
        }
	  
	    continue;
	  }
	}
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oSelf), TRUE, OBJECT_TYPE_CREATURE);
  }
  
  if (nCount)
  {
    // Buff ourselves.
	effect eHeal = EffectHeal(20 * nCount);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HEAL);
    effect eAttack = EffectAttackIncrease(nCount);
    effect eDamage = EffectDamageIncrease(nCount, DAMAGE_TYPE_SLASHING);

    effect eInstant = EffectLinkEffects(eHeal, eVis);	
	effect eLink = EffectLinkEffects(eAttack, eDamage);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(eInstant), oSelf);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oSelf);
  }
}

void WarCry()
{
  object oSelf = OBJECT_SELF;
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), oSelf);
  effect eAttack = EffectAttackIncrease(2);
  effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
  effect eFear = EffectFrightened();
  effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
  effect eVisFear = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eLink = EffectLinkEffects(eAttack, eDamage);
  eLink = EffectLinkEffects(eLink, eDur2);

  effect eLink2 = EffectLinkEffects(eVisFear, eFear);
  eLink = EffectLinkEffects(eLink, eDur);
	
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oSelf));
  while (GetIsObjectValid(oTarget))
  {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oSelf) && oTarget != oSelf)
      {
	    if (GetIsObjectValid(GetMaster(oTarget)))
		{
		  // Switch sides!
		  if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
		  {
		    RemoveHenchman(GetMaster(oTarget), oTarget);
			ChangeFaction(oTarget, GetObjectByTag("factionexample0"));
		  }
		  else
		  {
		    object oCreature = CopyObject(oTarget, GetLocation(oTarget));
			ChangeFaction(oCreature, GetObjectByTag("factionexample0"));
			AssignCommand(oCreature, gsCBDetermineCombatRound(GetMaster(oTarget)));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));
			DestroyObject(oTarget);
		  }
		}
		else
		{
          //Make SR and Will saves
          if(!MyResistSpell(oSelf, oTarget)  && !MySavingThrow(SAVING_THROW_WILL, oTarget, 30, SAVING_THROW_TYPE_FEAR))
          {
              DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(1)));
          }
		}  
      }
	  else
	  {
	    // Buff allies.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
	  }
	  
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oSelf));
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
	    // Run a special ability.  Options:
		// Breathe in - breach one aura from each nearby enemy and buff based on number stolen
		// War cry - fear effect on PCs, causes summons and henchbeasts to switch sides
		if (d2() == 2)
		{
		  BreatheIn();
		}
		else
		{
		  WarCry();
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

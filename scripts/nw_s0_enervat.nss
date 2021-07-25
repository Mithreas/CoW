//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_spells"
#include "inc_customspells" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDrain = d4();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    	nDrain = 4;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }

    effect eDrain = EffectNegativeLevel(nDrain);	
    effect eLink = EffectLinkEffects(eDrain, eDur);
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, nDrain));
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, nDrain));

	if(!GetIsReactionTypeFriendly(oTarget))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
        //Resist magic check
        if(!MyResistSpell(OBJECT_SELF, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
        {
		    // Make non stacking (but removed save).
            RemoveEffectsFromSpell(oTarget, SPELL_ENERVATION);
			
			//Apply the VFX impact and effects
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			
			gsSTAdjustState(GS_ST_STAMINA, -IntToFloat(nDrain), oTarget);
        }
    }
}


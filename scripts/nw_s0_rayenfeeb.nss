//::///////////////////////////////////////////////
//:: Ray of EnFeeblement
//:: [NW_S0_rayEnfeeb.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
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
    object oTarget = GetSpellTargetObject();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nBonus = nDuration / 2;
    //Limit bonus ability damage
    if (nBonus > 5)
    {
        nBonus = 5;
    }
    if(nBonus == 0)
    {
        nBonus = 1;
    }
    int nLoss = d6() + nBonus;
    int nMetaMagic = AR_GetMetaMagicFeat();
    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);
        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE))
        {
		    // Make non stacking (but removed save).
            RemoveEffectsFromSpell(oTarget, SPELL_RAY_OF_ENFEEBLEMENT);
			
			//Enter Metamagic conditions
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nLoss = 6 + nBonus;
			}
			if (nMetaMagic == METAMAGIC_EMPOWER)
			{
				 nLoss = nLoss + (nLoss/2);
			}
			if (nMetaMagic == METAMAGIC_EXTEND)
			{
				nDuration = nDuration * 2;
			}
			//Set ability damage effect
			eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);
			effect eLink = EffectLinkEffects(eFeeb, eDur);
		   //Apply the ability damage effect and VFX impact
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
			if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) nLoss *= 2;
			gsSTAdjustState(GS_ST_STAMINA, -IntToFloat(nLoss), oTarget);

         }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}

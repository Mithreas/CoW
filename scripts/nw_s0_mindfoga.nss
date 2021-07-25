//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

//#include "X0_I0_SPELLS"
#include "inc_customspells"
#include "inc_warlock"
void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink  = AnemoiEffectBlindness(oTarget);
	effect eLink2 = EffectLinkEffects(EffectAbilityDecrease(ABILITY_INTELLIGENCE, 6), EffectAbilityDecrease(ABILITY_WISDOM, 6));
	eLink2        = EffectLinkEffects(eLink2, EffectAbilityDecrease(ABILITY_CHARISMA, 6));
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    object oCaster = GetAreaOfEffectCreator();
    int nWillDamage = d6(2);
    int nStunDur = 1;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster)) nStunDur = d6(1);

    if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));

        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && oCaster == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_BLINDNESS)
                    {
                        RemoveEffect(oTarget, eAOE);
					    gsSTDoStaminaTax(oTarget, -50, 0.0f);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then test SR again
        //If yes, apply without testing SR.
        }
		
        if(bValid == FALSE)
        {
            if(!(miWAGetIsWarlock(oCaster) ? miWAResistSpell(oCaster, oTarget) : MyResistSpell(oCaster, oTarget)))
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster))
                {
					if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
					{
					    // Add the ability score drain. 
						eLink = EffectLinkEffects(eLink, eLink2);
					}
					
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget));
                    eLink = EffectLinkEffects(eVis, eLink);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
					gsSTDoStaminaTax(oTarget, 50, 0.0f);
                }
            }
        }
        else
        {
            if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE )
            {
				if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
				{
					// Add the ability score drain. 
					eLink = EffectLinkEffects(eLink, eLink2);
				}
				
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DAZED_S), oTarget));
				eLink = EffectLinkEffects(eVis, eLink);
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
				gsSTDoStaminaTax(oTarget, 50, 0.0f);
            }
        }
    }
}

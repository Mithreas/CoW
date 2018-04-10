//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
#include "inc_spells"
#include "nw_i0_spells"
#include "mi_inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
	       // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF)/2;
    int nLoss = AR_GetCasterLevel(OBJECT_SELF)/4;
    int nDC = AR_GetSpellSaveDC();

    // DC goes up by +4 versus an Arcane spellcaster
    if (GetLevelByClass(CLASS_TYPE_BARD, oTarget) > 0 ||
        GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) > 0 ||
        GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) > 0) {
        nDC += 4;
    }

    //Check to make at least 1d4 damage is done
    if (nLoss < 1)
        nLoss = 1;

    //Check to make sure the duration is 1 or greater
    if (nDuration < 1)
        nDuration == 1;

    //Enter Metamagic conditions
    int nMetaMagic = AR_GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
        nLoss = nLoss * 4;
    else
        nLoss = d4(nLoss);

    if (nMetaMagic == METAMAGIC_EMPOWER)
        nLoss = nLoss + (nLoss/2);

    if (nMetaMagic == METAMAGIC_EXTEND)
        nDuration = nDuration * 2;

    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	   if(!GetIsReactionTypeFriendly(oTarget))
    	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEEBLEMIND));
        //Make SR check
    	   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	{
            //Make an will save
            int nWillResult =  WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS);
            if (nWillResult == 0)
            {
                //Set the ability damage.  Arelith Specific: Does CHA damage too.
                effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss), eDur);
                eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_CHARISMA, nLoss));

                //Apply the VFX impact and ability damage effect.
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                
                // Arelith Specific: If INT to be reduced to 3 or less, Stun.
                if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 4)
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(nDuration));

            }
            // else
            // * target was immune
            // if (nWillResult == 2)
            // {
            // SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
            // }
        }
    }
}



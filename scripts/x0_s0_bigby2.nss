//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for 1 round per level of caster

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "x0_i0_spells"
#include "inc_customspells"
#include "gs_inc_text"
#include "inc_spells"

//::  UPDATE Mars 12. 2017, ActionReplay:
//::  Creatures immune to Mind Spells or Daze will be Immobilized instead
//::  Properly deals damage again

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Apply the impact effect
        effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
//edited part.
if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, GetRandomDelay()))
{
            int nCasterRoll = d20(1) + 14;
            int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
            // * bullrush succesful, knockdown target for duration of spell
            if (nCasterRoll >= nTargetRoll)
            {
                effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                effect eKnockdown = EffectDazed();

                //:: Creatures immune to mind spell are still prevented from moving
                //:: Will not affect targets immune to movement speed decrease
                //:: E.g Freedom of Movement spell
                if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE) &&
                     (GetIsImmune(oTarget, IMMUNITY_TYPE_DAZED) ||
                      GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) )
                {
                    eKnockdown = EffectCutsceneImmobilize();
                }

                effect eKnockdown2 = EffectKnockdown();
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                //Link effects
                effect eLink = EffectLinkEffects(eKnockdown, eDur);
                eLink = EffectLinkEffects(eLink, eKnockdown2);
                //Apply the penalty
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration));
                // * Bull Rush succesful
                FloatingTextStrRefOnCreature(8966,OBJECT_SELF, FALSE);
            }
            else
            {
                FloatingTextStrRefOnCreature(8967,OBJECT_SELF, FALSE);
            }
}//
        }
    }
}



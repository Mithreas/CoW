//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//::  UPDATE Mars 12. 2017, ActionReplay:
//::  Creatures immune to Mind Spells or Paralyze will be Immobilized instead

#include "x0_i0_spells"
#include "inc_customspells"
#include "gs_inc_text"
#include "inc_spells"

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
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

        // Check spell resistance
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
//edited part.
if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, GetRandomDelay()))
{
            // Check caster ability vs. target's AC

            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + AR_GetCasterLevel(OBJECT_SELF) + 10 + -1;

            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier
                    + AR_GetCasterLevel(OBJECT_SELF) + 10 +4;

                nTargetRoll = GetSizeModifier(oTarget)
                    + GetAbilityModifier(ABILITY_STRENGTH);

                if (nCasterRoll >= nTargetRoll)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();

                    //:: Creatures immune to mind spell are still prevented from moving
                    //:: Will not affect targets immune to movement speed decrease
                    //:: E.g Freedom of Movement spell
                    if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE) &&
                         (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
                          GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) )
                    {
                        eKnockdown = EffectCutsceneImmobilize();
                    }

                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eHand, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, oTarget,
                                        RoundsToSeconds(nDuration));

//                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
//                                        eVis, oTarget,RoundsToSeconds(nDuration));
                }
            }
}//
        }
    }
}



//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent
     and do 2d6 + 12 points of damage EACH round
     for 1 round/level

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

//::  UPDATE Mars 12. 2017, ActionReplay:
//::  Creatures immune to Mind Spells or Paralyze will be Immobilized instead
//::  Properly deals damage again

#include "x0_i0_spells"
#include "inc_customspells"
#include "inc_text"
#include "inc_spells"

void RunHandImpact(int nSecondsRemaining, object oTarget)
{
    //::  Cancels out, no damage deal with this line below...
    //if (!GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND)) return;

    //::  Cancel out in Fudge Death Area
    if (GetTag(GetArea(oTarget)) == "gs_death") return;

    if (GetIsDead(oTarget) == FALSE)
    {
       if (nSecondsRemaining % 6 == 0)
       {
            int nDam = MaximizeOrEmpower(6,2,AR_GetMetaMagicFeat(), 12);
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       }
       nSecondsRemaining = nSecondsRemaining - 1;
       if (nSecondsRemaining > 0)
       {
          DelayCommand(1.0f,RunHandImpact(nSecondsRemaining,oTarget));
       }
   }
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.
}

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
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
//edited part.
if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, AR_GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, GetRandomDelay()))
{


            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + AR_GetCasterLevel(OBJECT_SELF) + 12 + -1;
            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check
                // * hold target for duration of spell

                nCasterRoll = d20(1) + nCasterModifier
                    + AR_GetCasterLevel(OBJECT_SELF) + 12 + 4;

                nTargetRoll = /*NEED GetBaseAttackBonus*/
                    GetBaseAttackBonus(oTarget) + GetSizeModifier(oTarget)
                    + GetAbilityModifier(ABILITY_STRENGTH);

                if (nCasterRoll >= nTargetRoll)
                {
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
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eLink, eHand);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, oTarget,
                                        RoundsToSeconds(nDuration));



                    // * now do damage each round
                    nDuration = nDuration * 6;
                    if (GetIsImmune(oTarget, EFFECT_TYPE_PARALYZE) == FALSE)
                    {
                        RunHandImpact(nDuration, oTarget);
                    }

                }
            }
}//
        }
    }
}



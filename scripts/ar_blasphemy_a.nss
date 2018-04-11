/*
    Blasphemy AoE Spell
    Will deal an effect based on difference between Caster hitdie and Target hitdie (Not Caster Level!)

    Effects: Daze, Weakened, Paralyzed, Death

    Applied OnEnter of the Blasphemy AoE
*/

#include "ar_spellmatrix"

void main()
{
    effect eDaze     = EffectDazed();
    effect eDazeVis  = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eLinkDaze = EffectLinkEffects(eDaze, eDazeVis);

    effect eWeak     = EffectAbilityDecrease(ABILITY_STRENGTH, d6(2));
    effect eWeakVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eLinkWeak = EffectLinkEffects(eWeak, eWeakVis);

    effect ePara     = EffectParalyze();
    effect eParaVis  = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLinkPara = EffectLinkEffects(eParaVis, ePara);
    eLinkPara        = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), eLinkPara);

    effect eDeath     = EffectDeath();
    effect eDeathVis  = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eLinkDeath = EffectLinkEffects(eDeath, eDeathVis);

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nDC        = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 7);

    int nCasterLevel = GetHitDice(oCaster);
    int nTargetLevel = GetHitDice(oTarget);

    //::  For higher end NPCs lower the HitDice
    if ( !GetIsPC(oTarget) ) {
        if      ( nTargetLevel > 30 ) nTargetLevel = 30;
        else if ( nTargetLevel > 25 ) nTargetLevel = 25;
        else if ( nTargetLevel > 15 ) nTargetLevel = 15;
    }

    if ( !GetIsObjectValid(oTarget) || oCaster == oTarget || !GetIsReactionTypeHostile(oTarget, oCaster) ) return;

    //::  Daze
    if (nTargetLevel <= nCasterLevel) {
        if ( ar_GetSpellImmune(oCaster, oTarget, SAVING_THROW_TYPE_MIND_SPELLS) == FALSE ) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkDaze, oTarget, RoundsToSeconds(1));
        }
    }

    //::  Weakened
    if (nTargetLevel <= (nCasterLevel-1) ) {
        if ( ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkWeak, oTarget, RoundsToSeconds(d4(2)));
        }
    }

    //::  Paralyzed
    if (nTargetLevel <= (nCasterLevel-5) ) {
        if ( ar_GetSpellImmune(oCaster, oTarget) == FALSE && GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) == FALSE ) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkPara, oTarget, RoundsToSeconds(3+d3()));
        }
    }

    //::  Kill
    if (nTargetLevel <= (nCasterLevel-10) ) {
        if ( ar_GetSpellImmune(oCaster, oTarget, SAVING_THROW_TYPE_DEATH) == FALSE && GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH) == FALSE ) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkDeath, oTarget);
        }
    }
}

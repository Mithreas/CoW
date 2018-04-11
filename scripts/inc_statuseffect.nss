//::///////////////////////////////////////////////
//:: Status Effects Library
//:: inc_statuseffect
//:://////////////////////////////////////////////
/*
    Contains functions for handling status
    effects unique to Arelith.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2017
//:://////////////////////////////////////////////

#include "inc_generic"

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Fear Aura Spell Ids
const int SPELL_AURA_OF_FEAR = 198;
const int SPELL_AURA_DRAGON_FEAR = 412;
const int SPELL_TURN_UNDEAD = 308;

// Fear effect type constants
const int FEAR_EFFECT_TYPE_STANDARD = 1;
const int FEAR_EFFECT_TYPE_SCALING = 2;
const int FEAR_EFFECT_TYPE_ANY = 3;

// Default intensity parameters.
const int INTENSITY_STANDARD = 10;
const int INTENSITY_STANDARD_SCALING = -1;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies a fear effect to the target (if not immune) with the given intensity. Targets
// suffer the following penalties:
//
// -nIntensity AB
// -nIntensity Saving Throws
// -nIntensity Skills
// -nIntensity AC
// nIntensity * 5% Spell Failure
//
// Two intensity constants are available:
//
//   - INTENSITY_STANDARD = 10
//   - INTENSITY_STANDARD_SCALING = (CasterHD - TargetHD), max 10, min 2.
// Note that new fear effects added to the module should be included in the GetIsFearEffect()
// function in inc_statuseffect.
void ApplyFear(object oCreature, int nIntensity = INTENSITY_STANDARD, float fDuration = 0.0);
// Returns TRUE if the effect is a fear effect of the given type.
//   * FEAR_EFFECT_TYPE_STANDARD - standard fear effect, per vanilla NwN
//   * FEAR_EFFECT_TYPE_SCALING - scaling fear effect, per updated fear auras
int GetIsFearEffect(effect eEffect, int nFearType = FEAR_EFFECT_TYPE_ANY);
// Removes fear effects of the given type.
//   * FEAR_EFFECT_TYPE_STANDARD - standard fear effect, per vanilla NwN
//   * FEAR_EFFECT_TYPE_SCALING - scaling fear effect, per updated fear auras
void RemoveFearEffects(object oCreature, int nFearType = FEAR_EFFECT_TYPE_ANY, int nVFX = VFX_NONE);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyFear
//:://////////////////////////////////////////////
/*
    Applies a fear effect to the target (if not
    immune) with the given intensity. Targets
    suffer the following penalties:

    -nIntensity AB
    -nIntensity Saving Throws
    -nIntensity Skills
    -nIntensity AC
    nIntensity * 5% Spell Failure

    Two intensity constants are available:

    - INTENSITY_STANDARD = 10
    - INTENSITY_STANDARD_SCALING = (CasterHD - TargetHD),
      max 10, min 2.

    Note that new fear effects added to the
    module should be included in the GetIsFearEffect()
    function in inc_statuseffect.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2017
//:://////////////////////////////////////////////
void ApplyFear(object oCreature, int nIntensity = INTENSITY_STANDARD, float fDuration = 0.0)
{
    object oCaster = OBJECT_SELF;

    if(GetObjectType(oCaster) != OBJECT_TYPE_CREATURE) oCaster = GetAreaOfEffectCreator();

    if(GetIsImmune(oCreature, IMMUNITY_TYPE_FEAR) || GetIsImmune(oCreature, IMMUNITY_TYPE_MIND_SPELLS)) return;

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDur, eDur2);

    if(nIntensity == INTENSITY_STANDARD_SCALING)
    {
        nIntensity = ClampInt(GetHitDice(oCaster) + GetBonusHitDice(oCaster) - GetHitDice(oCreature), 2, 10);
    }

    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, EffectAttackDecrease(nIntensity));
    eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nIntensity));
    eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nIntensity));
    eLink = EffectLinkEffects(eLink, EffectACDecrease(nIntensity));
    eLink = EffectLinkEffects(eLink, EffectSpellFailure(nIntensity * 5));

    RemoveFearEffects(oCreature, FEAR_EFFECT_TYPE_SCALING);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCreature, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature);
}

//::///////////////////////////////////////////////
//:: GetIsFearEffect
//:://////////////////////////////////////////////
/*
    Returns TRUE if the effect is a fear
    effect of the given type.
    * FEAR_EFFECT_TYPE_STANDARD - standard fear
      effect, per vanilla NwN
    * FEAR_EFFECT_TYPE_SCALING - scaling fear
      effect, per updated fear auras
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2017
//:://////////////////////////////////////////////
int GetIsFearEffect(effect eEffect, int nFearType = FEAR_EFFECT_TYPE_ANY)
{
    if(nFearType & FEAR_EFFECT_TYPE_STANDARD && GetEffectType(eEffect) == EFFECT_TYPE_FRIGHTENED) return TRUE;

    if(!(nFearType & FEAR_EFFECT_TYPE_SCALING)) return FALSE;

    int nEffectId = GetEffectSpellId(eEffect);

    switch(nEffectId)
    {
        case SPELL_AURA_OF_FEAR:
        case SPELL_AURA_DRAGON_FEAR:
        case SPELL_DISMISSAL:
        case 276: // Krenshar Scare
            return TRUE;
        case SPELL_TURN_UNDEAD:
            // Arbitrarily compare to one aspect of Arelith fear effects to
            // catch PC imps that have been turned.
            return (GetEffectType(eEffect) == EFFECT_TYPE_SPELL_FAILURE);
    }

    return FALSE;
}

//::///////////////////////////////////////////////
//:: RemoveFearEffects
//:://////////////////////////////////////////////
/*
    Removes fear effects of the given type.
    * FEAR_EFFECT_TYPE_STANDARD - standard fear
      effect, per vanilla NwN
    * FEAR_EFFECT_TYPE_SCALING - scaling fear
      effect, per updated fear auras
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 9, 2017
//:://////////////////////////////////////////////
void RemoveFearEffects(object oCreature, int nFearType = FEAR_EFFECT_TYPE_ANY, int nVFX = VFX_NONE)
{
    effect eEffect = GetFirstEffect(oCreature);

    while(GetIsEffectValid(eEffect))
    {
        if(GetIsFearEffect(eEffect, nFearType))
        {
            RemoveEffect(oCreature, eEffect);
            if(nVFX != VFX_NONE)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), oCreature);
            }
        }
        eEffect = GetNextEffect(oCreature);
    }
}

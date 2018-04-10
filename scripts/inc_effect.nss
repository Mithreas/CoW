//::///////////////////////////////////////////////
//:: Effect Library
//:: inc_effect
//:://////////////////////////////////////////////
/*
    Contains functions for use with effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 22, 2016
//:://////////////////////////////////////////////

#include "inc_effecttags"

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// An undefined effect tag.
const int EFFECT_TAG_UNDEFINED = -1;


/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies a tagged effect to an object. A tagged effect has a unique retrievable Id.
// Note that this should not be called from spell scripts, since tagged effects do
// not contain spell Id parameters and always apply as extraordinary effects.
void ApplyTaggedEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int nEffectTag = EFFECT_TAG_UNDEFINED);

// Returns TRUE if the creature has an effect with the specified tag.
int GetHasTaggedEffect(object oCreature, int nEffectTag);
// Returns TRUE if the creature has been flagged as being immune to crowd control.
// Note that this flag has no effect in itself. It exists just to carry information for other
// scripts.
int GetIsCrowdControlImmune(object oCreature);
// Returns TRUE if the effect is harmful.
int GetIsEffectHarmful(effect eEffect);
// Removes all effects from the creature with the specified effect tag.
void RemoveTaggedEffects(object oCreature, int nEffectTag, object oCreator = OBJECT_INVALID);

// Returns TRUE if the effect has been tagged with nEffectTag
int GetIsTaggedEffect(effect eEffect, int nEffectTag);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyTaggedEffectToObject
//:://////////////////////////////////////////////
/*
    Applies a tagged effect to the object.
    A tagged effect has a unique retrievable Id.
    Note that this should not be called from
    spell scripts, since tagged effects do not
    contain spell Id parameters and always apply
    as extraordinary effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 22, 2016
//:://////////////////////////////////////////////
void ApplyTaggedEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int nEffectTag = EFFECT_TAG_UNDEFINED)
{
    if(nEffectTag != EFFECT_TAG_UNDEFINED)
    {
      string sEffectTag = GetEffectTag(eEffect);
	  
	  // All effect tags are ints.  But stored as strings.
      // Use bitwise flags to allow us to apply multiple tags. 	  
	  int nCurrentTag = StringToInt(sEffectTag);

      // apply updated tag string
      eEffect = TagEffect(eEffect, IntToString(nCurrentTag | nEffectTag));
    }
	
    if(GetEffectSubType(eEffect) != SUBTYPE_SUPERNATURAL)
    {
        eEffect = ExtraordinaryEffect(eEffect);
    }
	
    ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}


//::///////////////////////////////////////////////
//:: GetIsCrowdControlImmune
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature has been
    flagged as being immune to crowd control.
    Note that this flag has no effect in itself.
    It exists just to carry information for other
    scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
int GetIsCrowdControlImmune(object oCreature)
{
    return GetHasTaggedEffect(oCreature, EFFECT_TAG_CROWD_CONTROL_IMMUNITY);
}

//::///////////////////////////////////////////////
//:: GetIsEffectHarmful
//:://////////////////////////////////////////////
/*
    Returns TRUE if the effect is harmful.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 22, 2016
//:://////////////////////////////////////////////
int GetIsEffectHarmful(effect eEffect)
{
    int nEffectType = GetEffectType(eEffect);

    return nEffectType == EFFECT_TYPE_ABILITY_DECREASE
        || nEffectType == EFFECT_TYPE_AC_DECREASE
        || nEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE
        || nEffectType == EFFECT_TYPE_ATTACK_DECREASE
        || nEffectType == EFFECT_TYPE_BLINDNESS
        || nEffectType == EFFECT_TYPE_CHARMED
        || nEffectType == EFFECT_TYPE_CONFUSED
        || nEffectType == EFFECT_TYPE_CURSE
        || nEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE
        || nEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE
        || nEffectType == EFFECT_TYPE_DAMAGE_DECREASE
        || nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
        || nEffectType == EFFECT_TYPE_DARKNESS
        || nEffectType == EFFECT_TYPE_DAZED
        || nEffectType == EFFECT_TYPE_DEAF
        || nEffectType == EFFECT_TYPE_DISEASE
        || nEffectType == EFFECT_TYPE_DOMINATED
        || nEffectType == EFFECT_TYPE_ENTANGLE
        || nEffectType == EFFECT_TYPE_FRIGHTENED
        || nEffectType == EFFECT_TYPE_MISS_CHANCE
        || nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
        || nEffectType == EFFECT_TYPE_NEGATIVELEVEL
        || nEffectType == EFFECT_TYPE_PARALYZE
        || nEffectType == EFFECT_TYPE_PETRIFY
        || nEffectType == EFFECT_TYPE_POISON
        || nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE
        || nEffectType == EFFECT_TYPE_SILENCE
        || nEffectType == EFFECT_TYPE_SKILL_DECREASE
        || nEffectType == EFFECT_TYPE_SLEEP
        || nEffectType == EFFECT_TYPE_SLOW
        || nEffectType == EFFECT_TYPE_SPELL_FAILURE
        || nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
        || nEffectType == EFFECT_TYPE_STUNNED
        || nEffectType == EFFECT_TYPE_TURN_RESISTANCE_DECREASE
        || nEffectType == EFFECT_TYPE_TURNED;
}

//::///////////////////////////////////////////////
//:: GetHasTaggedEffect
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature has an effect
    with the specified tag.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 18, 2016
//:://////////////////////////////////////////////
int GetHasTaggedEffect(object oCreature, int nEffectTag)
{
    effect eEffect = GetFirstEffect(oCreature);
    string sEffectTag;

    while(GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, nEffectTag)) {
          return TRUE;
        }
        eEffect = GetNextEffect(oCreature);
    }
	
    return FALSE;
}

//::///////////////////////////////////////////////
//:: RemoveTaggedEffects
//:://////////////////////////////////////////////
/*
    Removes all effects from the creature
    with the specified effect tag.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void RemoveTaggedEffects(object oCreature, int nEffectTag, object oCreator = OBJECT_INVALID)
{
    effect eEffect = GetFirstEffect(oCreature);
    string sEffectTag;

    while(GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, nEffectTag))
		{
            if ((oCreator == OBJECT_INVALID) || (oCreator == GetEffectCreator(eEffect))) 
			{
                RemoveEffect(oCreature, eEffect);
            }
        }

        eEffect = GetNextEffect(oCreature);
    }
}

//::///////////////////////////////////////////////
//:: GetIsTaggedEffect
//:://////////////////////////////////////////////
/*
    Returns TRUE if eEffect has the specified tag.
*/
//:://////////////////////////////////////////////
//:: Created By: Dunshine
//:: Created On: Nov 20, 2017
//:://////////////////////////////////////////////
int GetIsTaggedEffect(effect eEffect, int nEffectTag) {

  string sEffectTag = GetEffectTag(eEffect);
 
  if (sEffectTag != "") 
  {
    // sEffectTag will be a bitwise flag comprised of all the 
	// separate tags applied to this effect.  
    int nCurrentTag = StringToInt(sEffectTag);
            
    return nCurrentTag & nEffectTag;
  }

  return FALSE;
}


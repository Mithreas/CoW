//::///////////////////////////////////////////////
//:: Healer Library
//:: inc_healer
//:://////////////////////////////////////////////
/*
    Contains functions for handling the healer
    path class.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////

#include "inc_spells"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Prefix to separate healer variables from other libraries.
const string LIB_HEALER_PREFIX = "Lib_Healer_";

// Healer ability VFX.
const int VFX_OVERHEAL = VFX_DUR_GLOBE_MINOR;
const int VFX_LIFELINE = VFX_DUR_GLOW_GREY;

// Overheal config constants.
const float OVERHEAL_DURATION = 18.0;

// Lifeline config constants.
const int LIFELINE_DEFAULT_DURATION = 60;
const float LIFELINE_DELAY = 6.0;

// Feedback messages.
const string OVERHEALING_FEEDBACK = "%name : Overhealed %hp hit points.";
const string LIFELINE_APPLIED_RECIPIENT_FLOATING_FEEDBACK = "* Lifeline Applied: %sec Seconds *";
const string LIFELINE_APPLIED_RECIPIENT_FEEDBACK = "Lifelined applied for %sec seconds. If you would die during this period, you will instead be revived with %percenthp% of your hit points.";
const string LIFELINE_APPLIED_RECIPIENT_NO_HEALING_FEEDBACK = "Lifeline applied for %sec seconds. If you would die during this period, you will instead be revived with 1 hit point.";
const string LIFELINE_APPLIED_CASTER_FEEDBACK = "Lifeline applied to %name for %sec seconds.";
const string LIFELINE_TRIGGERED_RECIPIENT_FLOATING_FEEDBACK = "* Lifeline Activated *";
const string LIFELINE_TRIGGERED_RECIPIENT_FEEDBACK = "%name has revived you with a Lifeline.";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Index for EffectTemporaryHitPoints value in the effects struck.
const int EFFECT_INDEX_TEMP_HP_VALUE = 0;

// Lifeline constants:
// * Unavailable = None Applied
// * Failed = Applied, but once already used this rest
// * Successful = Applied
const int LIFELINE_UNAVAILABLE = 0;
const int LIFELINE_FAILED = 1;
const int LIFELINE_SUCCESSFUL = 2;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies a healing effect to the target. Should be used as a wrapper for all heal
// effects, as this also handles overhealing bonus (e.g. from the healer path).
//
// If an overheal limit is not specified, then it will be calculated automatically
// based on the cast class.
void ApplyHealToObject(int nDamageToHeal, object oTarget = SPELL_TARGET_OBJECT, object oCaster = OBJECT_SELF, int nOverhealLimit = -1);
// Applies a lifeline to the target, which causes them to be revived if killed while
// the lifeline is active. nPercentHP correlates to the amount of hit points they will be
// healed on revival.
void ApplyLifeline(object oPC, int nPercentHP = 0, int nDuration = LIFELINE_DEFAULT_DURATION, int nVFX = VFX_LIFELINE);
// Lifeline handler. Should be called on PC death. Will return one of three values:
//   * LIFELINE_UNAVAILABLE - no lifeline on the PC
//   * LIFELINE_SUCCESSFUL - lifeline on the PC
//   * LIFELINE_FAILED - lifeline on the PC, but one has already procced this rest
int CheckLifeline(object oPC);
// Returns the total amount of overhealing active on the target.
int GetCurrentOverheal(object oCreature);
// Returns TRUE if the effect is an overhealing effect.
int GetIsOverhealEffect(effect eEffect);
// Returns TRUE if a lifeline has been activted for the PC this rest.
int GetLifelineActivated(object oPC);
// Returns the caster of the most recent lifeline.
object GetLifelineCaster(object oPC);
// Returns the time, in seconds, at which the last applied lifeline has been scheduled
// to expire.
int GetLifelineExpirationTime(object oPC);
// Returns the percentage healing that the last applied lifeline will bestow on the PC
// upon revival.
int GetLifelineHealPercent(object oPC);
// Returns the maximum amount of overhealing that the creature can do. If a specific class
// is chosen, then overhealing will only apply to spells cast from that class.
int GetOverhealLimit(object oCreature, int nClass = CLASS_TYPE_ANY);
// Removes all overhealing effects from the creature.
void RemoveOverhealEffects(object oCreature);
// Sets lifeline activated state on the PC, which determines whether another lifeline
// can be applied during this rest.
void SetLifelineActivated(object oPC, int bIsActivated);
// Stores the caster of the most recent lifeline.
void _SetLifelineCaster(object oPC, object oCaster);
// Sets the time, in seconds, at which the currently active lifeline will expire.
void SetLifelineExpirationTime(object oPC, int nTime);
// Sets the amount of hit points that will be restored upon activation of the active
// lifeline.
void SetLifelineHealPercent(object oPC, int nPercent);
// Sets the amount of overhealing that can be applied by the creature. If a class is
// specified, then only spells cast from that class will trigger overhealing.
void SetOverhealLimit(object oCreature, int nLimit, int nClass = CLASS_TYPE_ANY);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Triggers the active lifeline's effect for the PC. */
void _ActivateLifeline(object oPC, int bLifelineSuccessful);
/* Applies the overhealing effect to the target. */
void _ApplyOverhealToObject(int nDamageToHeal, object oTarget, object oCaster, int nOverhealLimit);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyHealToObject
//:://////////////////////////////////////////////
/*
    Applies a healing effect to the target.
    Should be used as a wrapper for all heal
    effects, as this also handles overhealing
    bonus (e.g. from the healer path).

    If an overheal limit is not specified,
    then it will be calculated automatically
    based on the cast class.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
void ApplyHealToObject(int nDamageToHeal, object oTarget = SPELL_TARGET_OBJECT, object oCaster = OBJECT_SELF, int nOverhealLimit = -1)
{
    int nMissingHP;
    int nOverheal;
    int nCasterClass = GetIsLastSpellCastSpontaneous() ? GetSpontaneousSpellClass(oCaster, GetSpellId()) : GetLastSpellCastClass();

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT)
    {
        nCasterClass = GetAoECastClass();
        oCaster = GetAreaOfEffectCreator();
    }

    if(nOverhealLimit == -1) nOverhealLimit = GetIsObjectValid(GetSpellCastItem()) ? 0 : GetOverhealLimit(oCaster, nCasterClass);

    if(oTarget == SPELL_TARGET_OBJECT)
    {
        oTarget = GetSpellTargetObject();
    }
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && nOverhealLimit > 0)
    {
        nMissingHP = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        if(nMissingHP < 0)
        {
            nMissingHP = 0;
        }
        if(nMissingHP < nDamageToHeal)
        {
            nOverheal = nDamageToHeal - nMissingHP;
            nDamageToHeal = nMissingHP;
        }
    }

    if(nDamageToHeal)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamageToHeal), oTarget);
    }
    if(nOverheal)
    {
        _ApplyOverhealToObject(nOverheal, oTarget, oCaster, nOverhealLimit);
    }
}

//::///////////////////////////////////////////////
//:: ApplyLifeline
//:://////////////////////////////////////////////
/*
    Applies a lifeline to the target, which
    causes them to be revived if killed while
    the lifeline is active. nPercentHP correlates
    to the amount of hit points they will be
    healed on revival.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
void ApplyLifeline(object oPC, int nPercentHP = 0, int nDuration = LIFELINE_DEFAULT_DURATION, int nVFX = VFX_LIFELINE)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(nVFX)), oPC, IntToFloat(nDuration));
    SetLifelineHealPercent(oPC, nPercentHP);
    SetLifelineExpirationTime(oPC, GetModuleTime() + nDuration);
    _SetLifelineCaster(oPC, OBJECT_SELF);

    if(!GetLifelineActivated(oPC))
    {
        FloatingTextStringOnCreature(ParseFormatStrings(LIFELINE_APPLIED_RECIPIENT_FLOATING_FEEDBACK, "%sec", IntToString(nDuration)), oPC, FALSE);
        if(nPercentHP > 0)
        {
            SendMessageToPC(oPC, ParseFormatStrings(LIFELINE_APPLIED_RECIPIENT_FEEDBACK, "%sec", IntToString(nDuration), "%percenthp", IntToString(nPercentHP)));
        }
        else
        {
            SendMessageToPC(oPC, ParseFormatStrings(LIFELINE_APPLIED_RECIPIENT_NO_HEALING_FEEDBACK, "%sec", IntToString(nDuration)));
        }
    }
}

//::///////////////////////////////////////////////
//:: CheckLifeline
//:://////////////////////////////////////////////
/*
    Lifeline handler. Should be called on PC
    death. Will return one of three values:
      * LIFELINE_UNAVAILABLE - no lifeline on
        the PC
      * LIFELINE_SUCCESSFUL - lifeline on the
        PC
      * LIFELINE_FAILED - lifeline on the PC,
        but one has already procced this rest
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
int CheckLifeline(object oPC)
{
    if(GetModuleTime() > GetLifelineExpirationTime(oPC)) return LIFELINE_UNAVAILABLE;

    int bLifelineSuccessful = !GetLifelineActivated(oPC);

    DelayCommand(LIFELINE_DELAY, _ActivateLifeline(oPC, bLifelineSuccessful));

    if(bLifelineSuccessful) return LIFELINE_SUCCESSFUL;
    return LIFELINE_FAILED;
}

//::///////////////////////////////////////////////
//:: GetCurrentOverheal
//:://////////////////////////////////////////////
/*
    Returns the total amount of overhealing
    active on the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
int GetCurrentOverheal(object oCreature)
{
    effect eEffect = GetFirstEffect(oCreature);
    int nOverheal;
    int nMaxHp = GetMaxHitPoints(oCreature);
    int nCurrentHp = GetCurrentHitPoints(oCreature);
    while(GetIsEffectValid(eEffect))
    {
        if(GetIsOverhealEffect(eEffect))
        {
            return nCurrentHp > nMaxHp ? nCurrentHp - nMaxHp : 0;
        }
        eEffect = GetNextEffect(oCreature);
    }

    return 0;
}

//::///////////////////////////////////////////////
//:: GetIsOverhealEffect
//:://////////////////////////////////////////////
/*
    Returns TRUE if the effect is an overhealing
    effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
int GetIsOverhealEffect(effect eEffect)
{
    return GetEffectType(eEffect) == EFFECT_TYPE_TEMPORARY_HITPOINTS && GetIsTaggedEffect(eEffect, EFFECT_TAG_OVERHEAL);
}

//::///////////////////////////////////////////////
//:: GetLifelineActivated
//:://////////////////////////////////////////////
/*
    Returns TRUE if a lifeline has been activted
    for the PC this rest.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
int GetLifelineActivated(object oPC)
{
    return GetLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineActivated");
}

//::///////////////////////////////////////////////
//:: GetLifelineCaster
//:://////////////////////////////////////////////
/*
    Returns the caster of the most recent lifeline.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 18, 2016
//:://////////////////////////////////////////////
object GetLifelineCaster(object oPC)
{
    return GetLocalObject(oPC, LIB_HEALER_PREFIX + "LifelineCaster");
}

//::///////////////////////////////////////////////
//:: GetLifelineExpirationTime
//:://////////////////////////////////////////////
/*
    Returns the time, in seconds, at which
    the last applied lifeline has been scheduled
    to expire.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
int GetLifelineExpirationTime(object oPC)
{
    return GetLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineExpirationTime");
}

//::///////////////////////////////////////////////
//:: GetLifelineHealPercent
//:://////////////////////////////////////////////
/*
    Returns the percentage healing that the last
    applied lifeline will bestow on the PC
    upon revival.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
int GetLifelineHealPercent(object oPC)
{
    return GetLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineHealPercent");
}

//::///////////////////////////////////////////////
//:: GetOverhealLimit
//:://////////////////////////////////////////////
/*
    Returns the maximum amount of overhealing
    that the creature can do. If a specific class
    is chosen, then overhealing will only apply
    to spells cast from that class.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
int GetOverhealLimit(object oCreature, int nClass = CLASS_TYPE_ANY)
{
    int nClassLimit;
    int nLimit = GetLocalInt(oCreature, LIB_HEALER_PREFIX + "OverhealLimit_" + IntToString(CLASS_TYPE_ANY));

    if(nClass != CLASS_TYPE_ANY)
    {
        nClassLimit = GetLocalInt(oCreature, LIB_HEALER_PREFIX + "OverhealLimit_" + IntToString(nClass));
        if(nClassLimit > nLimit)
        {
            nLimit = nClassLimit;
        }
    }

    return nLimit;
}

//::///////////////////////////////////////////////
//:: RemoveOverhealEffects
//:://////////////////////////////////////////////
/*
    Removes all overhealing effects from the
    creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
void RemoveOverhealEffects(object oCreature)
{
    effect eEffect = GetFirstEffect(oCreature);

    while(GetIsEffectValid(eEffect))
    {
        if(GetIsOverhealEffect(eEffect))
        {
            RemoveEffect(oCreature, eEffect);
        }
        eEffect = GetNextEffect(oCreature);
    }
}

//::///////////////////////////////////////////////
//:: SetLifelineActivated
//:://////////////////////////////////////////////
/*
    Sets lifeline activated state on the PC,
    which determines whether another lifeline
    can be applied during this rest.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
void SetLifelineActivated(object oPC, int bIsActivated)
{
    SetTempInt(oPC, LIB_HEALER_PREFIX + "LifelineActivated", bIsActivated, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
}

//::///////////////////////////////////////////////
//:: SetLifelineExpirationTime
//:://////////////////////////////////////////////
/*
    Sets the time, in seconds, at which the
    currently active lifeline will expire.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
void SetLifelineExpirationTime(object oPC, int nTime)
{
    if(nTime <= 0)
    {
        DeleteLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineExpirationTime");
    }
    else
    {
        SetLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineExpirationTime", nTime);
    }
}

//::///////////////////////////////////////////////
//:: SetLifelineHealPercent
//:://////////////////////////////////////////////
/*
    Sets the amount of hit points that will be
    restored upon activation of the active
    lifeline.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
void SetLifelineHealPercent(object oPC, int nPercent)
{
    if(nPercent <= 0)
    {
        DeleteLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineHealPercent");
    }
    else
    {
        SetLocalInt(oPC, LIB_HEALER_PREFIX + "LifelineHealPercent", nPercent);
    }
}

//::///////////////////////////////////////////////
//:: SetOverhealLimit
//:://////////////////////////////////////////////
/*
    Sets the amount of overhealing that can
    be applied by the creature. If a class is
    specified, then only spells cast from that
    class will trigger overhealing.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
void SetOverhealLimit(object oCreature, int nLimit, int nClass = CLASS_TYPE_ANY)
{
    if(nLimit <= 0)
    {
        DeleteLocalInt(oCreature, LIB_HEALER_PREFIX + "OverhealLimit_" + IntToString(nClass));
    }
    else
    {
        SetLocalInt(oCreature, LIB_HEALER_PREFIX + "OverhealLimit_" + IntToString(nClass), nLimit);
    }
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

 //::///////////////////////////////////////////////
//:: _ActivateLifeline
//:://////////////////////////////////////////////
/*
    Triggers the active lifeline's effect for
    the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: Jun 13, 2016
//:://////////////////////////////////////////////
void _ActivateLifeline(object oPC, int bLifelineSuccessful)
{
    int nHeal = GetLifelineHealPercent(oPC) / 100 * GetMaxHitPoints(oPC);
    object oCaster = GetLifelineCaster(oPC);
    string sCaster = GetIsObjectValid(oCaster) ? GetName(oCaster) : "Someone";

    SetLifelineActivated(oPC, TRUE);
    SetLifelineExpirationTime(oPC, 0);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oPC);

    if(bLifelineSuccessful)
    {
        ApplyResurrection(oPC);
        if(nHeal)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oPC);
        }
        FloatingTextStringOnCreature(LIFELINE_TRIGGERED_RECIPIENT_FLOATING_FEEDBACK, oPC, FALSE);
        SendMessageToPC(oPC, ParseFormatStrings(LIFELINE_TRIGGERED_RECIPIENT_FEEDBACK, "%name", sCaster));
    }
    else
    {
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), oPC));
        DelayCommand(1.5, AssignCommand(oPC, PlaySound("sim_destruct")));
    }
}

//::///////////////////////////////////////////////
//:: _ApplyOverhealToObject
//:://////////////////////////////////////////////
/*
    Applies the overhealing effect to the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 14, 2016
//:://////////////////////////////////////////////
void _ApplyOverhealToObject(int nDamageToHeal, object oTarget, object oCaster, int nOverhealLimit)
{
    effect eEffect;
    effect eOverheal;
    effect eLink;
    effect eVFX;
    int nCurrentOverheal = GetCurrentOverheal(oTarget);
    int nNewOverhealValue = nCurrentOverheal + nDamageToHeal;

    if(nNewOverhealValue > nOverhealLimit)
    {
        nNewOverhealValue = nOverhealLimit;
    }

    eOverheal = EffectTemporaryHitpoints(nNewOverhealValue);
    eVFX = EffectVisualEffect(VFX_OVERHEAL);
    eLink = EffectLinkEffects(eOverheal, eVFX);

    RemoveOverhealEffects(oTarget);
    ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, OVERHEAL_DURATION, EFFECT_TAG_OVERHEAL);

    SendMessageToPC(oTarget, ParseFormatStrings(OVERHEALING_FEEDBACK, "%name", GetName(oTarget), "%hp", IntToString(GetCurrentOverheal(oTarget) - nCurrentOverheal)));
    if(oCaster != oTarget)
    {
        SendMessageToPC(oCaster, ParseFormatStrings(OVERHEALING_FEEDBACK, "%name", GetName(oTarget), "%hp", IntToString(GetCurrentOverheal(oTarget) - nCurrentOverheal)));
    }
}

//::///////////////////////////////////////////////
//:: _SetLifelineCaster
//:://////////////////////////////////////////////
/*
    Stores the caster of the most recent lifeline.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 18, 2016
//:://////////////////////////////////////////////
void _SetLifelineCaster(object oPC, object oCaster)
{
    if(oCaster == OBJECT_INVALID)
    {
        DeleteLocalObject(oPC, LIB_HEALER_PREFIX + "LifelineCaster");
    }
    else
    {
        SetLocalObject(oPC, LIB_HEALER_PREFIX + "LifelineCaster", oCaster);
    }
}

//::///////////////////////////////////////////////
//:: NPC Cooldowns Library
//:: inc_npccooldowns
//:://////////////////////////////////////////////
/*
    Contains functions for handling NPC ability
    cooldowns. Namely, this allows the user
    to flag special abilities (e.g. dragon's
    breath, magic missile) as being available
    every X seconds to the NPC.

    To flag ability cooldowns, NPCs must have
    integers tagged sequentially to the NPC:

    NPC_ABILILITY_X - the ID of the spell/ability
        to be used. For Acid Fog (id 0), use the
        id -1 instead.
    NPC_ABILITY_COOLDOWN_X - the cooldown for the
        ability, in seconds. Note that some
        leniency in precision is given for the
        sake of efficiency, erring toward
        re-enabling abilities later than flagged.
    NPC_ABILITY_COOLDOWN_MAX_X - the maximum
        cooldown value for the ability. If set,
        the ability will come off cooldown at a
        random interval between the base cooldown
        value and the maximum cooldown value.
    NPC_ABILITY_LEVEL_X - the level at which the
        ability will be cast at. Values will be
        clamped between 1 and 15 (the highest
        special ability level that can be
        handled natively by the engine).

    Where X refers to the number in sequence,
    starting at 1.

    Do not add these special abilities to
    creatures manually via the creature abilities
    menu. These will conflict with npc cooldowns
    behavior.

    InitializeNPCCooldownAbilities must be called
    once for this behavior to work. It is
    recommended to call it on spawn.

    UpdateNPCCooldownAbilities must be called
    periodically. For the sake of minimizing
    overhead, it is recommended to call this on
    combat round end. However, it can also be
    called on heartbeat or via pseudo-heartbeat
    if greater precision is desired.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////

#include "inc_math"
#include "inc_spells"
#include "inc_time"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Prefix used for cooldown-based ability flags.
const string VAR_NPC_ABILITY = "NPC_ABILITY_";
const string VAR_NPC_ABILITY_COOLDOWN = "NPC_ABILITY_COOLDOWN_";
const string VAR_NPC_ABILITY_MAX_COOLDOWN = "NPC_ABILITY_COOLDOWN_MAX_";
const string VAR_NPC_ABILITY_LEVEL = "NPC_ABILITY_LEVEL_";

// Variable used to flag an NPC to use default NwN DC values.
const string VAR_NPC_ABILITY_USE_DEFAULT_DC_VALUES = "NPC_ABILITY_USE_DEFAULT_DC_VALUES";

// Default cooldown profiles.
const int NPC_ABILITY_COOLDOWN_DEFAULT = 0;
const int NPC_ABILITY_COOLDOWN_ZERO = -1;
const int NPC_ABILITY_COOLDOWN_SHORT = -2;
const int NPC_ABILITY_COOLDOWN_MEDIUM = -3;
const int NPC_ABILITY_COOLDOWN_LONG = -4;

// Default profile values.
const int NPC_ABILITY_COOLDOWN_DEFAULT_MIN = 90;
const int NPC_ABILITY_COOLDOWN_DEFAULT_MAX = 120;
const int NPC_ABILITY_COOLDOWN_ZERO_MIN = 0;
const int NPC_ABILITY_COOLDOWN_ZERO_MAX = 0;
const int NPC_ABILITY_COOLDOWN_SHORT_MIN = 60;
const int NPC_ABILITY_COOLDOWN_SHORT_MAX = 90;
const int NPC_ABILITY_COOLDOWN_MEDIUM_MIN = 90;
const int NPC_ABILITY_COOLDOWN_MEDIUM_MAX = 120;
const int NPC_ABILITY_COOLDOWN_LONG_MIN = 120;
const int NPC_ABILITY_COOLDOWN_LONG_MAX = 150;

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate NPC cooldowns variables from other libraries.
const string LIB_NPC_COOLDOWNS_PREFIX = "Lib_NPC_Cooldowns";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Generates a cooldown for the given spell Id, evenly distributed between the minimum
// and maximum value designated for the ability.
int GenerateNPCAbilityCooldown(int nSpellId, object oNPC = OBJECT_SELF);
// Returns TRUE if the given NPC has abilities flagged as cooldown-based.
int GetHasNPCCooldownAbilities(object oNPC = OBJECT_SELF);
// Returns TRUE if the given NPC has an ability flagged as cooldown-based matching nSpellId.
int GetIsNPCCooldownAbility(int nSpellId, object oNPC = OBJECT_SELF);
// Returns the cooldown, in seconds, of the cooldown-based ability for the NPC matching
// nSpellId.
int GetNPCAbilityCooldown(int nSpellId, object oNPC = OBJECT_SELF);
// Returns the maximum cooldown, in seconds, of the cooldown-based ability for the NPC
// matching nSpellId.
int GetNPCAbilityMaximumCooldown(int nSpellId, object oNPC = OBJECT_SELF);
// Returns the time at which the cooldown-based ability will be available for the given
// NPC.
int GetNPCAbilityTimeAvailable(int nSpellId, object oNPC = OBJECT_SELF);
// Initializes all NPC cooldown abilities for the NPC, adding them as special abilities.
void InitializeNPCCooldownAbilities(object oNPC = OBJECT_SELF);
// Sets default DC values for NPC cooldown-based abilities based on the following
// formula: DC = 14 + Spell Level + HD / 2.
void SetDefaultNPCCooldownAbilityDCs(object oNPC = OBJECT_SELF);
// Sets the time at which the cooldown-based ability will be available for the given
// NPC.
void SetNPCAbilityTimeAvailable(int nSpellId, int nTime, object oNPC = OBJECT_SELF);
// Updates cooldown-based abilities for the NPC, flagged used ones as being on cooldown,
// and restoring ones for which the cooldown has expired.
void UpdateNPCCooldownAbilities(object oNPC = OBJECT_SELF);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GenerateNPCAbilityCooldown
//:://////////////////////////////////////////////
/*
    Generates a cooldown for the given spell
    Id, evenly distributed between the minimum
    and maximum value designated for the
    ability.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 31, 2016
//:://////////////////////////////////////////////
int GenerateNPCAbilityCooldown(int nSpellId, object oNPC = OBJECT_SELF)
{
    int nMin = GetNPCAbilityCooldown(nSpellId, oNPC);
    int nMax = GetNPCAbilityMaximumCooldown(nSpellId, oNPC);

    if(!nMax) nMax = nMin;

    return nMin + Random(nMax - nMin + 1);
}

//::///////////////////////////////////////////////
//:: GetHasNPCCooldownAbilities
//:://////////////////////////////////////////////
/*
    Returns TRUE if the given NPC has abilities
    flagged as cooldown-based.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
int GetHasNPCCooldownAbilities(object oNPC = OBJECT_SELF)
{
    return GetLocalInt(oNPC, VAR_NPC_ABILITY + "1");
}

//::///////////////////////////////////////////////
//:: GetIsNPCCooldownAbility
//:://////////////////////////////////////////////
/*
    Returns TRUE if the given NPC has an ability
    flagged as cooldown-based matching nSpellId.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
int GetIsNPCCooldownAbility(int nSpellId, object oNPC = OBJECT_SELF)
{
    int i;
    int nAbility;

    if(!nSpellId) nSpellId = -1; // Special case for Acid Fog

    do
    {
        i++;
        nAbility = GetLocalInt(oNPC, VAR_NPC_ABILITY + IntToString(i));
        if(nAbility == nSpellId) return TRUE;
    } while(nAbility);

    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetNPCAbilityCooldown
//:://////////////////////////////////////////////
/*
    Returns the cooldown, in seconds, of the
    cooldown-based ability for the NPC matching
    nSpellId.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
int GetNPCAbilityCooldown(int nSpellId, object oNPC = OBJECT_SELF)
{
    int i;
    int nCooldown;
    int nAbility;

    if(!nSpellId) nSpellId = -1; // Special Case for Acid Fog

    do
    {
        i++;
        nAbility = GetLocalInt(oNPC, VAR_NPC_ABILITY + IntToString(i));
        if(nAbility == nSpellId)
        {
            nCooldown = GetLocalInt(oNPC, VAR_NPC_ABILITY_COOLDOWN + IntToString(i));
            switch(nCooldown)
            {
                case NPC_ABILITY_COOLDOWN_DEFAULT: return NPC_ABILITY_COOLDOWN_DEFAULT_MIN;
                case NPC_ABILITY_COOLDOWN_ZERO:    return NPC_ABILITY_COOLDOWN_ZERO_MIN;
                case NPC_ABILITY_COOLDOWN_SHORT:   return NPC_ABILITY_COOLDOWN_SHORT_MIN;
                case NPC_ABILITY_COOLDOWN_MEDIUM:  return NPC_ABILITY_COOLDOWN_MEDIUM_MIN;
                case NPC_ABILITY_COOLDOWN_LONG:    return NPC_ABILITY_COOLDOWN_LONG_MIN;
                default:                           return nCooldown;
            }
        }
    } while(nAbility);

    return 0;
}

//::///////////////////////////////////////////////
//:: GetNPCAbilityMaximumCooldown
//:://////////////////////////////////////////////
/*
    Returns the maximum cooldown, in seconds,
    of the cooldown-based ability for the NPC
    matching nSpellId.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 31, 2016
//:://////////////////////////////////////////////
int GetNPCAbilityMaximumCooldown(int nSpellId, object oNPC = OBJECT_SELF)
{
    int i;
    int nAbility;
    int nCooldownMin;

    if(!nSpellId) nSpellId = -1; // Special Case for Acid Fog

    do
    {
        i++;
        nAbility = GetLocalInt(oNPC, VAR_NPC_ABILITY + IntToString(i));
        if(nAbility == nSpellId)
        {
            nCooldownMin = GetLocalInt(oNPC, VAR_NPC_ABILITY_COOLDOWN + IntToString(i));
            switch(nCooldownMin)
            {
                case NPC_ABILITY_COOLDOWN_DEFAULT: return NPC_ABILITY_COOLDOWN_DEFAULT_MAX;
                case NPC_ABILITY_COOLDOWN_ZERO:    return NPC_ABILITY_COOLDOWN_ZERO_MAX;
                case NPC_ABILITY_COOLDOWN_SHORT:   return NPC_ABILITY_COOLDOWN_SHORT_MAX;
                case NPC_ABILITY_COOLDOWN_MEDIUM:  return NPC_ABILITY_COOLDOWN_MEDIUM_MAX;
                case NPC_ABILITY_COOLDOWN_LONG:    return NPC_ABILITY_COOLDOWN_LONG_MAX;
                default:                           return GetLocalInt(oNPC, VAR_NPC_ABILITY_MAX_COOLDOWN + IntToString(i));
            }
        }
    } while(nAbility);

    return 0;
}

//::///////////////////////////////////////////////
//:: GetNPCAbilityTimeAvailable
//:://////////////////////////////////////////////
/*
    Returns the time at which the cooldown-based
    ability will be available for the given
    NPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
int GetNPCAbilityTimeAvailable(int nSpellId, object oNPC = OBJECT_SELF)
{
    if(!nSpellId) nSpellId = -1; // Special case for Acid Fog

    return GetLocalInt(oNPC, LIB_NPC_COOLDOWNS_PREFIX + "NPCCooldownTimeAvailable_" + IntToString(nSpellId));
}

//::///////////////////////////////////////////////
//:: InitializeNPCCooldownAbilities
//:://////////////////////////////////////////////
/*
    Initializes all NPC cooldown abilities for
    the NPC, adding them as special abilities.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
void InitializeNPCCooldownAbilities(object oNPC = OBJECT_SELF)
{
    if(GetLocalInt(oNPC, LIB_NPC_COOLDOWNS_PREFIX + "NPCCooldownAbilitiesInitialized")) return;

    int i;
    int nAbilityId;
    int nLevel;
    struct NWNX_Creature_SpecialAbility ability;

    do
    {
        i++;
        nAbilityId = GetLocalInt(oNPC, VAR_NPC_ABILITY + IntToString(i));
        if(nAbilityId)
        {
            if(nAbilityId == -1) // Special case for Acid Fog
            {
                ability.id = 0;
            }
            else
            {
                ability.id = nAbilityId;
            }
            nLevel = GetLocalInt(oNPC, VAR_NPC_ABILITY_LEVEL + IntToString(i));
            if(!nLevel) nLevel = GetHitDice(oNPC);
            if(nLevel > 15) SetCasterLevelOverride(oNPC, ability.id, nLevel);
            ability.level = ClampInt(nLevel, 1, 15);
            ability.ready = TRUE;
            NWNX_Creature_AddSpecialAbility(oNPC, ability);
        }
    } while(nAbilityId);

    SetDefaultNPCCooldownAbilityDCs(oNPC);

    SetLocalInt(oNPC, LIB_NPC_COOLDOWNS_PREFIX + "NPCCooldownAbilitiesInitialized", TRUE);
}

//::///////////////////////////////////////////////
//:: SetDefaultNPCCooldownAbilityDCs
//:://////////////////////////////////////////////
/*
    Sets default DC values for NPC cooldown-
    based abilities based on the following
    formula: DC = 14 + Spell Level + HD / 2.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
void SetDefaultNPCCooldownAbilityDCs(object oNPC = OBJECT_SELF)
{
    if(GetLocalInt(oNPC, VAR_NPC_ABILITY_USE_DEFAULT_DC_VALUES)) return;

    int i;
    int nAbilityCount = NWNX_Creature_GetSpecialAbilityCount(oNPC);
    int nBaseDC = 14 + (GetHitDice(oNPC) + GetBonusHitDice(oNPC)) / 2;
    struct NWNX_Creature_SpecialAbility ability;

    for(i = 0; i < nAbilityCount; i++)
    {
        ability = NWNX_Creature_GetSpecialAbility(oNPC, i);
        if(!GetLocalInt(oNPC, "DC_OVERRIDE_" + IntToString(ability.id)))
        {
            SetLocalInt(oNPC, "DC_OVERRIDE_" + IntToString(ability.id), nBaseDC + GetSpellInnateLevel(ability.id));
        }
    }
}

//::///////////////////////////////////////////////
//:: SetNPCAbilityTimeAvailable
//:://////////////////////////////////////////////
/*
    Sets the time at which the cooldown-based
    ability will be available for the given
    NPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
void SetNPCAbilityTimeAvailable(int nSpellId, int nTime, object oNPC = OBJECT_SELF)
{
    if(!nSpellId) nSpellId = -1; // Special case for Acid Fog

    if(!nTime)
    {
        DeleteLocalInt(oNPC, LIB_NPC_COOLDOWNS_PREFIX + "NPCCooldownTimeAvailable_" + IntToString(nSpellId));
    }
    else
    {
        SetLocalInt(oNPC, LIB_NPC_COOLDOWNS_PREFIX + "NPCCooldownTimeAvailable_" + IntToString(nSpellId), nTime);
    }
}

//::///////////////////////////////////////////////
//:: UpdateNPCCooldownAbilities
//:://////////////////////////////////////////////
/*
    Updates cooldown-based abilities for the
    NPC, flagged used ones as being on cooldown,
    and restoring ones for which the cooldown
    has expired.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 30, 2016
//:://////////////////////////////////////////////
void UpdateNPCCooldownAbilities(object oNPC = OBJECT_SELF)
{
    int i;
    int nAbilityCount = NWNX_Creature_GetSpecialAbilityCount(oNPC);
    int nCooldown;
    int nTimeAvailable;
    struct NWNX_Creature_SpecialAbility ability;

    for(i = 0; i < nAbilityCount; i++)
    {
        ability = NWNX_Creature_GetSpecialAbility(oNPC, i);

        if(!ability.ready && GetIsNPCCooldownAbility(ability.id, oNPC))
        {
            nTimeAvailable = GetNPCAbilityTimeAvailable(ability.id, oNPC);
            if(!nTimeAvailable)
            {
                // No cooldown flagged. Flag it now.
                nCooldown = GenerateNPCAbilityCooldown(ability.id, oNPC);
                if(nCooldown > 3)
                {
                    SetNPCAbilityTimeAvailable(ability.id, GetModuleTime() + nCooldown);
                }
                else
                {
                    // If the cooldown is less than three seconds, than the ability will be ready by the time we check
                    // again. Just restore it now.
                    ability.ready = TRUE;
                    NWNX_Creature_SetSpecialAbility(oNPC, i, ability);
                    SetNPCAbilityTimeAvailable(ability.id, 0, oNPC);
                }

            }
            else if(GetModuleTime() > nTimeAvailable)
            {
                // Cooldown flagged. Restore the ability if applicable.
                ability.ready = TRUE;
                NWNX_Creature_SetSpecialAbility(oNPC, i, ability);
                SetNPCAbilityTimeAvailable(ability.id, 0, oNPC);
            }
        }
    }
}

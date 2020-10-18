//::///////////////////////////////////////////////
//:: Spells Library
//:: inc_spells
//:://////////////////////////////////////////////
/*
    Contains functions for handling spells
    and spell-like effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 30, 2016
//:://////////////////////////////////////////////

#include "inc_associates"
#include "inc_chatrelay"
#include "inc_database"
#include "inc_data_arr"
#include "inc_divination"
#include "inc_effect"
#include "inc_favsoul"
#include "inc_generic"
#include "inc_math"
#include "inc_rename"
#include "inc_pc"
#include "inc_string"
#include "inc_tempvars"
#include "inc_timelock"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x0_i0_position"
#include "x2_inc_switches"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Controls the amount of overlap allowed for persistent AOEs. Effective values range
// from 0.0 (no overlap) to 100.0 (complete overlap).
const float AOE_OVERLAP_PERCENTAGE = 50.0;

// Allows NPCs to overlap persistent AoEs when set to TRUE.
const int ALLOW_NPC_AOE_OVERLAP = FALSE;

// Error given to a PC when attempting to cast a spontaneous spell with insufficient
// spell slots.
const string ERROR_INSUFFICIENT_SPELLSLOTS = "You do not have enough %s spell slots remaining to cast that spontaneous spell.";

// Scripts for the project image summon.
const string PROJECT_IMAGE_AI_ON_BLOCKED =           "NW_CH_AC1";
const string PROJECT_IMAGE_AI_ON_COMBAT_ROUND_END =  "NW_CH_AC3";
const string PROJECT_IMAGE_AI_ON_CONVERSATION =      "NW_CH_AC4";
const string PROJECT_IMAGE_AI_ON_DAMAGED =           "NW_CH_AC6";
const string PROJECT_IMAGE_AI_ON_DEATH =             "";
const string PROJECT_IMAGE_AI_ON_DISTURBED =         "NW_C2_AC8";
const string PROJECT_IMAGE_AI_ON_HEARTBEAT =         "hrt_unsummon";
const string PROJECT_IMAGE_AI_ON_PERCEPTION =        "NW_CH_AC2";
const string PROJECT_IMAGE_AI_ON_PHYSICAL_ATTACKED = "NW_CH_AC5";
const string PROJECT_IMAGE_AI_ON_RESTED =            "rst_unsummon";
const string PROJECT_IMAGE_AI_ON_SPAWN =             "NW_CH_AC9";
const string PROJECT_IMAGE_AI_ON_SPELL_CAST_AT =     "NW_CH_ACB";
const string PROJECT_IMAGE_AI_ON_USER_DEFINED =      "NW_CH_ACD";

// Blueprint created as a source for static VFX (e.g. vfx on glyph of warding).
const string BLUEPRINT_STATIC_VFX = "gs_null";
// Heartbeat script for static VFX. Responsible for destroying the object when
// the source AoE is removed (e.g. by dispels).
const string STATIC_VFX_ON_HEARTBEAT = "hrt_staticvfx";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate spells variables from other libraries.
const string LIB_SPELLS_PREFIX = "Lib_Spells_";

// Generic spell focus feat references.
const int FEAT_SPELL_FOCUS = 0;
const int FEAT_GREATER_SPELL_FOCUS = 1;
const int FEAT_EPIC_SPELL_FOCUS = 2;

// Undefined ID values.
const int ABILITY_INVALID = -1;
const int FEAT_INVALID = -1;
const int SPELL_ID_UNDEFINED = 0;
const int SHAPE_UNDEFINED = -1;
const int SPELL_INVALID = -1;
const int SPELL_SLOT_INDEX_INVALID = -1;
const int SPECIAL_ABILITY_INDEX_UNDEFINED = -1;
const int SPONTANEOUS_SPELL_LEVEL_INVALID = -1;

// Function default parameters.
const int CLASS_TYPE_ANY = -1;
const int DETERMINE_SPELL_LEVEL_BY_CLASS = -1;
const int DETERMINE_CASTER_LEVEL_BY_CLASS = -1;
const int GET_LAST_SPELL_CAST_CLASS = -1;
const int LAST_SPELL_CAST_CLASS = -2;
const object SPELL_TARGET_OBJECT = OBJECT_INVALID;

struct SummonGroup
{
    string summon1;
    string summon2;
    string summon3;
    string summon4;
    int numSummons;
};

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Adds an innate spell to the PC with infinite uses. If nClass is set to CLASS_TYPE_INVALID,
// then the default caster level will equal the hit dice of the PC. The nClass parameter
// has no function if nCasterLevel is set manually.
void AddInnateSpell(object oPC, int nSpellId, int nClass = CLASS_TYPE_INVALID, int nCasterLevel = DETERMINE_CASTER_LEVEL_BY_CLASS);
// Adds a spontaneous spell to the PC. Consumes spell slots of the specified
// class and spell level when used. If the default value is used for nSpellLevel, then
// it will consume slots equal to the level of the spell added.
void AddSpontaneousSpell(object oPC, int nSpellId, int nClass, int nSpellLevel = DETERMINE_SPELL_LEVEL_BY_CLASS);
// Adjusts the DC of a spell as if its spell school was that of nSpellSchool.
int AdjustSpellDCForSpellSchool(int nDC, int nSpellSchool, int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF);
// * Wrapper for GetSpellSaveDC(). Under default conditions, returns the value of the above function.
// * If an int, DC_OVERRIDE_X, is flagged on the creature (where X corresponds to a spell id),
// then the DC will be overriden to the given value.
// * If a default value is given, then that value will be used instead of GetSpellSaveDC()
// when no override is provided. This can be useful for assigning DCs to spell-like
// abilities.
int AR_GetSpellSaveDC(int nDefaultValue = -1);
// Handler for spontaneous casting. Depletes spell slots as appropriate and blocks
// casting if the PC has insufficient spell slots. Should be called whenever a spell
// is cast.
int CheckSpontaneousCasting();
// Creates a persistent AoE at the target location. AoEs of the same type will not stack if cast by the same caster.
// If scripts for the AoE are not specified, default ones will be used.
// If nSpellId is not set, then the value of GetSpellId() will be used.
void CreateNonStackingPersistentAoE(int nDurationType, int nAreaEffectId, location lLocation, float fDuration = 0.0,
    string sOnEnterScript = "", string sHeartbeatScript = "", string sOnExitScript = "", int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF,
    int nCasterClass = GET_LAST_SPELL_CAST_CLASS, string sStaticVFXTemplate = BLUEPRINT_STATIC_VFX, string sSpellName = "", int nStaticVFX1 = VFX_NONE, int nStaticVFX2 = VFX_NONE);
// Creates a SummonGroup struct for use with the SummonSwarm function.
struct SummonGroup CreateSummonGroup(int nNumSummons, string sSummon1, string sSummon2 = "", string sSummon3 = "", string sSummon4 = "");
// Decrements spell slots for the creature of the given class and spell level. Affects
// only spontaneous casting classes.
void DecrementRemainingSpellSlots(object oCreature, int nClass, int nSpellLevel);
// Dismisses old swarm summons belonging to the creature. Call whenever an associate
// is added to the creature's party.
void DismissOldSwarmSummons(object oCreature);
// Multiples nAmount by 3/2 if the last spell cast was empowered or the caster possesses
// the designated feat.
int EmpowerSpell(int nAmount, int nEmpowerFeat = FEAT_INVALID);
// Returns the AoE's casting class override variable, if it exists.
int GetAoECastClass();
// Returns the AoE's caster level override. If no caster level override exists, then the
// creator's caster level will be used instead.
int GetAoECasterLevel(object oAoE = OBJECT_SELF);
// Returns an estimate of the AoE's remaining duration. Will be accurate to about 10
// milliseconds.
float GetAoEDurationRemaining(object oAoE = OBJECT_SELF);
// Returns the Id of the nonstacking AoE. The Id corresponds to the spell or ability
// used to create it.
int GetAoEId(object oAoE);
// Returns the MetaMagic feat used to cast the AoE.
int GetAoEMetaMagic(object oAoE = OBJECT_SELF);
// Returns the static VFX partner for the AoE, if one exists.
object GetAoEPartner(object oAoE);
// Returns the radius of the AoE associated with nAreaEffectId.
float GetAoERadius(int nAreaEffectId);
// Returns the shape of the AoE associated with nAreaEffectId. Rectangular AoEs
// will return SHAPE_CUBE.
int GetAoEShape(int nAreaEffectId);
// Returns TRUE if the creature can cast a spell of the specified class type
// and spell level.
int GetCanCastSpellOfLevel(object oCreature, int nClass, int nLevel);
// Returns the ability used by nClass to cast spells.
int GetCasterAbility(int nClass);
// Returns the overriden caster level value for the given spell id on the creature.
int GetCasterLevelOverride(object oCreature, int nSpellId);
// Returns the spell cast class for the spell last cast by the creature.
int GetCreatureLastSpellCastClass(object oCreature);
// Returns the caster level for the spell last cast by the creature.
int GetCreatureLastSpellCasterLevel(object oCreature);
// Returns the cast ability used by the last spell cast for the creature (e.g. intelligence
// for wizards). If the last spell cast was an epic spell, will instead return the
// cast stat of the creature's primary class. If an item was used to cast the spell,
// or the creature has no spell cast levels, will return ABILITY_INVALID.
int GetCreatureLastSpellCastAbility(object oCreature);
// Returns the id of the spell last cast by the creature.
int GetCreatureLastSpellId(object oCreature);
// Returns the index of the first available spell slot for the class and spell level.
// Does not work for spontaneous spell casting classes.
int GetFirstAvailableSpellSlot(object oCreature, int nClass, int nSpellLevel);
// Returns the creature's highest spellcaster level out of all of its classes.
int GetGreatestSpellCasterLevel(object oCreature);
// Returns TRUE if the creature has at least one summon that was not created via the
// SummonSwarm function.
int GetHasNonSwarmSummon(object oCreature);
// Returns TRUE if the creature has spells remaining of the specified class and level.
int GetHasSpellsRemaining(object oPC, int nClass, int nSpellLevel);
// Returns TRUE if the AoE is about to expire.
int GetIsAoEExpiring(object oAoE = OBJECT_SELF);
// Returns TRUE if nClass is an arcane spellcaster.
int GetIsArcaneSpellCastClass(int nClass);
// Returns TRUE if the given spell is a caster spell (i.e. one castable by one of the
// game's base classes).
int GetIsCasterSpell(int nSpellId);
// Returns TRUE if the last spell the creature cast was from an item.
int GetIsCreatureLastSpellCastItemValid(object oCreature);
// Returns TRUE if the spell cast is an epic spell.
int GetIsEpicSpell(int nSpellId);
// Returns TRUE if the last spell was cast as an innate ability.
int GetIsLastSpellCastInnate();
// Returns TRUE if the last spell was cast as an innate ability by a PC.
int GetIsLastSpellCastSpontaneous();
// Returns TRUE if nClass can cast spells.
int GetIsSpellCastClass(int nClass);
// Returns TRUE if the specified class casts spells spontaneously (i.e. is a bard
// or sorcerer).
int GetIsSpontaneousSpellCastClass(int nClass);
// Returns TRUE if the creature was summoned via a swarm effect.
int GetIsSwarmSummon(object oCreature);
// Returns the spell cast class in which the given creature has the most levels. If two
// classes are tied, then the first will be returned.
int GetPrimarySpellCastClass(object oCreature);
// Returns the special ability at the specified index for the creature.
int GetSpecialAbilityIdByIndex(object oPC, int nIndex);
// Returns the special ability index of the ability matching the spell id on the creature.
int GetSpecialAbilityIndex(object oPC, int nSpellId);
// Returns the degree to which the creature is focused in the given spell school (i.e.
// 0 for no focus, 1 for spell focus, 2 for greater spell focus, 3 for epic spell focus).
int GetSpellFocusLevel(object oCreature, int nSchool);
// Returns the appropriate spells 2DA column for the specified class (e.g. CLASS_TYPE_WIZARD
// and CLASS_TYPE_SORCERER would both return "Wiz_Sorc").
string GetSpells2DAColumnFromClass(int nClass);
// Returns the innate level of the given spell.
int GetSpellInnateLevel(int nSpellId);
// Checks the SPELL_OVERRIDE_X flag for the spellcaster and runs the override script
// if one has been flagged. Returns TRUE on a successful override.
int GetSpellOverride();
// Returns the school of the spell of nSpellId.
int GetSpellSchool(int nSpellId);
// Returns the class used for the spontaneous spell assigned to the PC.
int GetSpontaneousSpellClass(object oPC, int nSpellId);
// Returns the caster level of the spontaneous spell assigned to the PC.
int GetSpontaneousSpellLevel(object oPC, int nSpellId);
// Returns the ready state of the spontaneous spell with the specified id.
int GetSpontaneousSpellReadyState(object oPC, int nSpellId);
// Returns the static VFX partner for the AoE, if one exists.
object GetStaticVFXPartner(object oVFX);
// Returns the number of swarm summons belonging to the creature.
int GetSwarmSummonCount(object oCreature);
// Returns the caster level bonus for the creatures, which translates to additional
// caster levels for all spells.
int GetTemporaryasterLevelBonus(object oCreature);
// Increments spell slots for the creature of the given class and spell level. Affects
// only spontaneous casting classes.
void IncrementRemainingSpellSlots(object oCreature, int nClass, int nSpellLevel);
// Handles the project image spell, which creates a non-spellcasting clone of the caster
// that lasts for 1 hour / level.
void ProjectImage();
// Removes all effects from the designated object.
void RemoveAllEffects(object oObject);
// Removes all special abilities from the creature.
void RemoveAllSpontaneousSpells(object oPC);
// Removes the special ability with the designated spell id on the creature.
void RemoveSpontaneousSpell(object oPC, int nSpellId);
// Overrides the cast class used for the existing AoE.
void SetAoECastClass(object oAoE, int nClass);
// Overrides the caster level used for the existing AoE.
void SetAoECasterLevel(object oAoE, int nCasterLevel);
// Sets an Id variable on the nonstacking AoE.
void SetAoEId(object oAoE, int nId);
// Overrides the metamagic feat used for the existing AoE.
void SetAoEMetaMagic(object oAoE, int nMetaMagic);
// Overrides the caster level for the given spell id on the creature to the given level.
void SetCasterLevelOverride(object oCreature, int nSpellId, int nCasterLevel);
// Sets the designated spell slot's ready state. Does nothing for spontaneous spell
// cast classes.
void SetSpellSlotReadyState(object oCreature, int nClass, int nSpellLevel, int nIndex, int bIsReady);
// Sets the class used for the designated spontaneous spell.
void SetSpontaneousSpellClass(object oPC, int nSpellId, int nClass);
// Sets the caster level for the designated spontaneous spell.
void SetSpontaneousSpellLevel(object oPC, int nSpellId, int nLevel);
// Sets the ready state of the special ability matching the designated spell id.
void SetSpontaneousSpellReadyState(object oPC, int nSpellId, int bIsReady);
// Sets the caster level bonus for the creature, which translates to additional caster levels
// for all spells.
void SetTemporaryCasterLevelBonus(object oCreature, int nBonus);
// Returns the spell focus feat for the specified school.
int SpellSchoolToSpellFocusFeat(int nSpellSchool, int nFocusLevel = FEAT_SPELL_FOCUS);
// Summons multiple creatures at once to fight at the caster's side.
void SummonSwarm(object oCaster, struct SummonGroup swarm, float fDuration, int nVFX = VFX_NONE);
// Unsummons a creature. Uses the specified VFX.
void UnsummonCreature(object oCreature, int nVFX = VFX_IMP_UNSUMMON);
// Unsummons all summons created via the SummonSwarm function belonging to the
// given creature.
void UnsummonSwarmSummons(object oCreature);
// Updates spell variables for the creature, which allows information on the spell being
// cast to be recalled after the spell has been cast.
void UpdateCreatureSpellVariables(object oCreature);
// Updates ready states for all spontaneous spells on the PC. Should be called whenever
// a spell is cast. Note that this is called by default from the spontaneous spell
// handler.
void UpdateSpontaneousSpellReadyStates(object oPC);
// Alternative for EffectPolymorph, using this wrapper will also store all Spellbook
// data from oPC to be used to restore later after polymorph has ended.
effect EffectPolymorphEx(int nPolymorphSelection, int nLocked = FALSE, object oPC = OBJECT_SELF);
// Used in 'gs_m_unequip' to restore Spellbook data for oPC after
// unpolymorphing.
void RestoreSpellsAfterPolymorph(object oPC);
// Removes NEP related effects and reapplies them after a short duration
// with the duration remaining.
// Good to use for certain features we want to force penalties NEP otherwise
// make the user immune to.
void RemoveAndReapplyNEP(object oTarget);
// Returns a random arcane SPELL_ id for the specified level.
int GetRandomArcaneSpell(int nSpellLevel);
// Retrieve any caster level bonus oCaster has; if nSpellID is -1 will use GetSpellId() to generate
int AR_GetCasterLevelBonus(object oCaster=OBJECT_SELF, int nSpellId = -1);
// Set a caster level bonus for oCaster.
void AR_SetCasterLevelBonus(int nBonus, object oCaster=OBJECT_SELF);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Creates a static VFX object, coupled with an AoE. This allows an AoE to appear to hold
   VFX that it naturally could not (e.g. glyph of warding). */
object _CreateStaticVFX(string sName, int nId, location lLocation, float fDuration, string sStaticSourceTemplate, int nVFX1, int nVFX2);
/* Unsummons deprecated swarm summons. Called internally on a delay to resolve timing
   issues. */
void _DismissOldSwarmSummons(object oCreature);
/* Flags the AoE as having expired. Prevents he AoE from running expiration scripts more
   than once in rare cases. */
void _FlagAoEExpired(object oAoE);
/* Flags all summons owned by the caster as having been summoned by a swarm effect.
   Called automatically by the SummonSwarm function. */
void _FlagSwarmSummons(object oCaster);
/* Stores references on the AoE and static VFX to one another. */
void _LinkAoEToStaticVFX(object oAoE, object oVFX);
/* Stores a reference to the coupled static VFX on the AoE. */
void _SetAoEPartner(object oAoE, object oPartner);
/* Updates the project image object to use AI scripts as defined by
   PROJECT_IMAGE_AI_ constants. */
void _SetProjectImageAI(object oImage);
/* Sets the spell cast class for the creature's last spell, to be recalled with the
   GetCreatureLastSpellCastClass function. */
void _SetCreatureLastSpellCastClass(object oCreature, int nCastClass);
/* Sets the caster level for the creature's last spell, to be recalled with the
   GetCreatureLastSpellCasterLevel function. */
void _SetCreatureLastSpellCasterLevel(object oCreature, int nCasterLevel);
/* Sets the creature's last spell Id, to be recalled with the GetCreatureLastSpellId
   function. */
void _SetCreatureLastSpellId(object oCreature, int nId);
/* Sets whether the creature's last spell used a spell cast item, to be recalled with the
   GetIsCreatureLastSpellCastItemValid function. */
void _SetIsCreatureLastSpellCastItemValid(object oCreature, int bIsValid);
/* Sets the despawn timer for the projected image so that it will despawn
   when the timer expires. */
void _SetProjectImageDespawnTimer(object oImage, int nTime);
/* Stores a reference to the coupled AoE on the static VFX. */
void _SetStaticVFXPartner(object oVFX, object oPartner);
/* Wrapper for AR_GetCasterLevel. Included in the spells library to avoid dependency
   issues. */
int _Spells_GetCasterLevel(object oCreature);
/* Sets a unique Id on the AoE at the specified location. */
void _UpdateAoEDataAtLocation(location lLocation, int nId, object oStaticVFX, int nCasterLevel, int nCastClass, float fDuration, int nMetaMagic);
/* Returns TRUE if nClass has a Spellbook. */
int _getIsSpellBookClass(int nClass);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AddInnateSpell
//:://////////////////////////////////////////////
/*
    Adds an innate spell to the PC with infinite
    uses. If nClass is set to CLASS_TYPE_INVALID,
    then the default caster level will equal
    the hit dice of the PC. The nClass parameter
    has no function if nCasterLevel is set
    manually.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////
void AddInnateSpell(object oPC, int nSpellId, int nClass = CLASS_TYPE_INVALID, int nCasterLevel = DETERMINE_CASTER_LEVEL_BY_CLASS)
{
    struct NWNX_Creature_SpecialAbility spell;

    if(nCasterLevel == DETERMINE_CASTER_LEVEL_BY_CLASS)
    {
        if(nClass == CLASS_TYPE_INVALID)
        {
            nCasterLevel = GetHitDice(oPC);
        }
        else
        {
            nCasterLevel = GetLevelByClass(nClass, oPC);
        }
        if(!nCasterLevel) nCasterLevel = 1;
    }

    spell.id = nSpellId;
    spell.level = nCasterLevel;
    spell.ready = TRUE;

    NWNX_Creature_AddSpecialAbility(oPC, spell);
    SetSpontaneousSpellLevel(oPC, nSpellId, SPONTANEOUS_SPELL_LEVEL_INVALID);
    SetSpontaneousSpellClass(oPC, nSpellId, nClass);
}

//::///////////////////////////////////////////////
//:: AddSpontaneousSpell
//:://////////////////////////////////////////////
/*
    Adds a spontaneous spell to the PC.
    Consumes spell slots of the specified
    class and spell level when used. If the
    default value is used for nSpellLevel, then
    it will consume slots equal to the level of
    the spell added.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void AddSpontaneousSpell(object oPC, int nSpellId, int nClass, int nSpellLevel = DETERMINE_SPELL_LEVEL_BY_CLASS)
{
    if(!nClass) return;

    struct NWNX_Creature_SpecialAbility spell;

    if(nSpellLevel == DETERMINE_SPELL_LEVEL_BY_CLASS)
    {
        nSpellLevel = StringToInt(Get2DAString("spells", GetSpells2DAColumnFromClass(nClass), nSpellId));
        if(!nSpellLevel)
        {
            nSpellLevel = StringToInt(Get2DAString("spells", "Innate", nSpellId));
        }
    }

    if(!GetCanCastSpellOfLevel(oPC, nClass, nSpellLevel)) return;

    spell.id = nSpellId;
    spell.level = GetLevelByClass(nClass, oPC);
    spell.ready = TRUE;

    NWNX_Creature_AddSpecialAbility(oPC, spell);
    SetSpontaneousSpellLevel(oPC, nSpellId, nSpellLevel);
    SetSpontaneousSpellClass(oPC, nSpellId, nClass);
    UpdateSpontaneousSpellReadyStates(oPC);
}

//::///////////////////////////////////////////////
//:: AdjustSpellDCForSpellSchool
//:://////////////////////////////////////////////
/*
    Adjusts the DC of a spell as if its spell
    school was that of nSpellSchool.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
int AdjustSpellDCForSpellSchool(int nDC, int nSpellSchool, int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF)
{
    int nOriginalSpellSchool = (nSpellId == SPELL_ID_UNDEFINED) ? GetSpellSchool(GetSpellId()) : GetSpellSchool(nSpellId);

    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nOriginalSpellSchool, FEAT_SPELL_FOCUS), oCreator))
        nDC -= 2;
    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nOriginalSpellSchool, FEAT_GREATER_SPELL_FOCUS), oCreator))
        nDC -= 2;
    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nOriginalSpellSchool, FEAT_EPIC_SPELL_FOCUS), oCreator))
        nDC -= 2;
    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nSpellSchool, FEAT_SPELL_FOCUS), oCreator))
        nDC += 2;
    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nSpellSchool, FEAT_GREATER_SPELL_FOCUS), oCreator))
        nDC += 2;
    if(GetHasFeat(SpellSchoolToSpellFocusFeat(nSpellSchool, FEAT_EPIC_SPELL_FOCUS), oCreator))
        nDC += 2;

    return nDC;
}

//::///////////////////////////////////////////////
//:: AR_GetSpellSaveDC
//:://////////////////////////////////////////////
/*
    Wrapper for GetSpellSaveDC(). Under default
    conditions, returns the value of the above
    function.

    If an int, DC_OVERRIDE_X, is flagged on the
    creature (where X corresponds to a spell id),
    then the DC will be overriden to the given
    value.

    If a default value is given, then that value
    will be used instead of GetSpellSaveDC()
    when no override is provided. This can be
    useful for assigning DCs to spell-like
    abilities.

    Grants Shadow Mages +2 DC to Illusion,
    Enchantment and Necromancy spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 1, 2016
//:://////////////////////////////////////////////
int AR_GetSpellSaveDC(int nDefaultValue = -1)
{
    int nAbilityModifier;
    int nFocusBonuses;
    int nMiscBonuses = 0;
    int nSpellId = GetSpellId();
    int nSpellLevel;
    int nClass = GetSpontaneousSpellClass(OBJECT_SELF, nSpellId);
    int nDCOverride = GetLocalInt(OBJECT_SELF, "DC_OVERRIDE_" + IntToString(nSpellId));
    string sSchool  = Get2DAString("spells","School",GetSpellId());

    if(nDCOverride) return nDCOverride;
    if(nDefaultValue != -1) return nDefaultValue;

    // We can't include inc_class here without creating dependency loops.
    // So rather than call GetIsShadowMage, check the hide variable directly.
    if (GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "SHADOW_MAGE") &&
        (
         (GetIsLastSpellCastSpontaneous() &&
          (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER))
          ||
         (!GetIsLastSpellCastSpontaneous() &&
          (GetLastSpellCastClass() == CLASS_TYPE_WIZARD ||
           GetLastSpellCastClass() == CLASS_TYPE_SORCERER))
        ) &&
        (sSchool == "I" || sSchool == "N" || sSchool == "E")
       )
    {
      nMiscBonuses += 2;
    }

    if(GetIsLastSpellCastSpontaneous() && nClass != CLASS_TYPE_INVALID)
    {
        // Override to calculate proper spell DCs for spontaneous spells.
        nAbilityModifier = GetAbilityModifier(GetCasterAbility(nClass), OBJECT_SELF);
        nFocusBonuses = GetSpellFocusLevel(OBJECT_SELF, GetSpellSchool(nSpellId)) * 2;
        nSpellLevel = StringToInt(Get2DAString("spells", GetSpells2DAColumnFromClass(nClass), nSpellId));

        return 10 + nAbilityModifier + nFocusBonuses + nSpellLevel + nMiscBonuses;
    }
    return GetSpellSaveDC() + nMiscBonuses;
}

//::///////////////////////////////////////////////
//:: CheckSpontaneousCasting
//:://////////////////////////////////////////////
/*
    Handler for spontaneous casting. Depletes
    spell slots as appropriate and blocks
    casting if the PC has insufficient spell
    slots. Should be called whenever a spell
    is cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int CheckSpontaneousCasting()
{
    if(!GetIsLastSpellCastSpontaneous())
        return TRUE;

    object oCaster = OBJECT_SELF;

    int nSpellId = GetSpellId();
    int nSpellLevel = GetSpontaneousSpellLevel(oCaster, nSpellId);
    int nSpellCastClass = GetSpontaneousSpellClass(oCaster, nSpellId);

    if(nSpellLevel != SPONTANEOUS_SPELL_LEVEL_INVALID)
    {
        if(!GetHasSpellsRemaining(oCaster, nSpellCastClass, nSpellLevel))
        {
            SendMessageToPC(oCaster, ParseFormatStrings(ERROR_INSUFFICIENT_SPELLSLOTS, "%s", IntToString(nSpellLevel) + OrdinalSuffix(nSpellLevel)));
            UpdateSpontaneousSpellReadyStates(oCaster);
            return FALSE;
        }
        if(GetIsSpontaneousSpellCastClass(nSpellCastClass))
        {
            DecrementRemainingSpellSlots(oCaster, nSpellCastClass, nSpellLevel);
        }
        else
        {
            SetSpellSlotReadyState(oCaster, nSpellCastClass, nSpellLevel, GetFirstAvailableSpellSlot(oCaster, nSpellCastClass, nSpellLevel), FALSE);
        }
    }

    UpdateSpontaneousSpellReadyStates(oCaster);
    return TRUE;
}

//::///////////////////////////////////////////////
//:: CreateNonStackingPersistentAoE
//:://////////////////////////////////////////////
/*
    Creates a persistent AoE at the target
    location. AoEs of the same type will not
    stack if cast by the same caster.

    If scripts for the AoE are not specified,
    default ones will be used.

    If nSpellId is not set, then the value of
    GetSpellId() will be used.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 30, 2016
//:://////////////////////////////////////////////
void CreateNonStackingPersistentAoE(int nDurationType, int nAreaEffectId, location lLocation, float fDuration = 0.0,
    string sOnEnterScript = "", string sHeartbeatScript = "", string sOnExitScript = "", int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF,
    int nCasterClass = GET_LAST_SPELL_CAST_CLASS, string sStaticVFXTemplate = BLUEPRINT_STATIC_VFX, string sSpellName = "", int nStaticVFX1 = VFX_NONE, int nStaticVFX2 = VFX_NONE)
{
    float fAoERadius = GetAoERadius(nAreaEffectId) * (1 - AOE_OVERLAP_PERCENTAGE / 100.0) * 2.0;
    object oStaticVFX;
    object oNearestAoE;
    int nCasterLevel = _Spells_GetCasterLevel(oCreator);
    int nMetaMagic = GetMetaMagicFeat();
    int i = 1;

    nSpellId = (nSpellId == SPELL_ID_UNDEFINED) ? GetSpellId() : nSpellId;
    if(nCasterClass == GET_LAST_SPELL_CAST_CLASS)
    {
        nCasterClass = GetIsLastSpellCastSpontaneous() ? GetSpontaneousSpellClass(oCreator, GetSpellId()) : GetLastSpellCastClass();
    }

    switch(GetAoEShape(nAreaEffectId))
    {
        case SHAPE_SPHERE:
            if(GetObjectType(oCreator) == OBJECT_TYPE_CREATURE && (GetIsPC(oCreator) || !ALLOW_NPC_AOE_OVERLAP))
            {
                oNearestAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation, 1);
                while(GetIsObjectValid(oNearestAoE) && GetDistanceBetweenLocations(lLocation, GetLocation(oNearestAoE)) <= fAoERadius)
                {
                    if(GetAreaOfEffectCreator(oNearestAoE) == oCreator && GetAoEId(oNearestAoE) == nSpellId)
                    {
                        DestroyObject(oNearestAoE);
                        DestroyObject(GetAoEPartner(oNearestAoE));
                    }
                    i++;
                    oNearestAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation, i);
                }
            }
            break;
        case SHAPE_CUBE:
            // Logic for blade barrier and wall of fire would go here.
            break;
    }

    ApplyEffectAtLocation(nDurationType, EffectAreaOfEffect(nAreaEffectId, sOnEnterScript, sHeartbeatScript, sOnExitScript), lLocation, fDuration);
    if(!(nStaticVFX1 == VFX_NONE && nStaticVFX2 == VFX_NONE) || sStaticVFXTemplate != BLUEPRINT_STATIC_VFX)
    {
        oStaticVFX = _CreateStaticVFX(sSpellName, nSpellId, lLocation, fDuration, sStaticVFXTemplate, nStaticVFX1, nStaticVFX2);
    }
    DelayCommand(0.01, _UpdateAoEDataAtLocation(lLocation, nSpellId, oStaticVFX, nCasterLevel, nCasterClass, fDuration - 0.01, nMetaMagic));
}

//::///////////////////////////////////////////////
//:: CreateSummonGroup
//:://////////////////////////////////////////////
/*
    Creates a SummonGroup struct for use with
    the SummonSwarm function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
struct SummonGroup CreateSummonGroup(int nNumSummons, string sSummon1, string sSummon2 = "", string sSummon3 = "", string sSummon4 = "")
{
    struct SummonGroup swarm;

    swarm.summon1 = sSummon1;
    swarm.summon2 = sSummon2;
    swarm.summon3 = sSummon3;
    swarm.summon4 = sSummon4;
    swarm.numSummons = nNumSummons;

    return swarm;
}

//::///////////////////////////////////////////////
//:: DecrementRemainingSpellSlots
//:://////////////////////////////////////////////
/*
    Decrements spell slots for the creature
    of the given class and spell level. Affects
    only spontaneous casting classes.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void DecrementRemainingSpellSlots(object oCreature, int nClass, int nSpellLevel)
{
    NWNX_Creature_SetRemainingSpellSlots(oCreature, nClass, nSpellLevel, NWNX_Creature_GetRemainingSpellSlots(oCreature, nClass, nSpellLevel) - 1);
}

//::///////////////////////////////////////////////
//:: DismissOldSwarmSummons
//:://////////////////////////////////////////////
/*
    Dismisses old swarm summons belonging to
    the creature. Call whenever an associate
    is added to the creature's party.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void DismissOldSwarmSummons(object oCreature)
{
    DelayCommand(0.01, _DismissOldSwarmSummons(oCreature));
}

//::///////////////////////////////////////////////
//:: EmpowerSpell
//:://////////////////////////////////////////////
/*
    Multiples nAmount by 3/2 if the last spell
    cast was empowered or the caster possesses
    the designated feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 12, 2016
//:://////////////////////////////////////////////
int EmpowerSpell(int nAmount, int nEmpowerFeat = FEAT_INVALID)
{
    object oCaster = OBJECT_SELF;
    int bEmpower;
    int nMetaMagic = GetMetaMagicFeat();

    if(GetIsObjectValid(GetSpellCastItem()))
        return nAmount;

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT)
    {
        oCaster = GetAreaOfEffectCreator();
        nMetaMagic = GetAoEMetaMagic();
    }

    if(nEmpowerFeat > FEAT_INVALID && GetHasFeat(nEmpowerFeat, oCaster))
    {
        bEmpower = TRUE;
    }
    else if(nMetaMagic & METAMAGIC_EMPOWER)
    {
        bEmpower = TRUE;
    }
    if(bEmpower)
    {
        nAmount = nAmount + nAmount / 2;
    }

    return nAmount;
}

//::///////////////////////////////////////////////
//:: GetAoECastClass
//:://////////////////////////////////////////////
/*
    Returns the AoE's casting class override
    variable, if it exists.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
int GetAoECastClass()
{
    return GetLocalInt(OBJECT_SELF, LIB_SPELLS_PREFIX + "AoECastClass");
}

//::///////////////////////////////////////////////
//:: GetAoECasterLevel
//:://////////////////////////////////////////////
/*
    Returns the AoE's caster level override. If
    no caster level override exists, then the
    creator's caster level will be used instead.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
int GetAoECasterLevel(object oAoE = OBJECT_SELF)
{
    int nCasterLevel = GetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoECasterLevel");

    if(!nCasterLevel)
    {
        nCasterLevel = _Spells_GetCasterLevel(GetAreaOfEffectCreator());
    }

    return nCasterLevel;
}

//::///////////////////////////////////////////////
//:: GetAoEDurationRemaining
//:://////////////////////////////////////////////
/*
    Returns an estimate of the AoE's remaining
    duration. Will be accurate to seconds
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
float GetAoEDurationRemaining(object oAoE = OBJECT_SELF)
{
    effect eEffect = GetFirstEffect(OBJECT_SELF);

    while(GetIsEffectValid(eEffect))
    {
        if(GetIsTaggedEffect(eEffect, EFFECT_TAG_DURATION_MARKER))
        {
            return IntToFloat(GetEffectDurationRemaining(eEffect));
        }
        eEffect = GetNextEffect(OBJECT_SELF);
    }
    return -1.0;
}

//::///////////////////////////////////////////////
//:: GetAoEId
//:://////////////////////////////////////////////
/*
    Returns the AoE of the nonstacking AoE. The
    Id corresponds to the spell or ability
    used to create it.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
int GetAoEId(object oAoE)
{
    int nAoEId = GetLocalInt(oAoE, LIB_SPELLS_PREFIX + "NonStackingAoEId");

    // Value shift of one because we're moving the whole index upward, so as not to confuse
    // unassigned Ids with the Id of the 0th entry of spells.2da (i.e. acid fog).
    // If no Id is found, then the AoE was just created (i.e. this is being called from an
    // on enter script). Returning the value of GetEffectSpellId(EffectDazed()) tricks the
    // engine into assigning the AoE an Id we can use.
    return (nAoEId > 0) ? nAoEId - 1 : GetEffectSpellId(EffectDazed());
}

//::///////////////////////////////////////////////
//:: GetAoEMetaMagic
//:://////////////////////////////////////////////
/*
    Returns the MetaMagic feat used to cast the
    AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 21, 2016
//:://////////////////////////////////////////////
int GetAoEMetaMagic(object oAoE = OBJECT_SELF)
{
    return GetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoEMetaMagic");
}

//::///////////////////////////////////////////////
//:: GetAoEPartner
//:://////////////////////////////////////////////
/*
    Returns the static VFX partner for the
    AoE, if one exists.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
object GetAoEPartner(object oAoE)
{
    return GetLocalObject(oAoE, LIB_SPELLS_PREFIX + "AoEPartner");
}

//::///////////////////////////////////////////////
//:: GetAoERadius
//:://////////////////////////////////////////////
/*
    Returns the radius of the AoE associated
    with nAreaEffectId.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 30, 2016
//:://////////////////////////////////////////////
float GetAoERadius(int nAreaEffectId)
{
    return StringToFloat(Get2DAString("vfx_persistent", "RADIUS", nAreaEffectId));
}

//::///////////////////////////////////////////////
//:: GetAoEShape
//:://////////////////////////////////////////////
/*
    Returns the shape of the AoE associated with
    nAreaEffectId. Rectangular AoEs will return
    SHAPE_CUBE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
int GetAoEShape(int nAreaEffectId)
{
    string sShape = Get2DAString("vfx_persistent", "SHAPE", nAreaEffectId);

    if(sShape == "C")
        return SHAPE_SPHERE;
    else if(sShape == "R")
        return SHAPE_CUBE;
    return SHAPE_UNDEFINED;
}

//::///////////////////////////////////////////////
//:: GetCanCastSpellOfLevel
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature can cast
    a spell of the specified class type
    and spell level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 17, 2017
//:://////////////////////////////////////////////
int GetCanCastSpellOfLevel(object oCreature, int nClass, int nLevel)
{
    string sClass;
    string sSpells;

    if((GetAbilityScore(oCreature, GetCasterAbility(nClass), TRUE) - 10) < nLevel)
        return FALSE;

    switch(nClass)
    {
        case CLASS_TYPE_BARD:
            sClass = "bard";
            break;
        case CLASS_TYPE_CLERIC:
            sClass = "cler";
            break;
        case CLASS_TYPE_DRUID:
            sClass = "dru";
            break;
        case CLASS_TYPE_PALADIN:
            sClass = "pal";
            break;
        case CLASS_TYPE_RANGER:
            sClass = "rang";
            break;
        case CLASS_TYPE_SORCERER:
            sClass = "sorc";
            break;
        case CLASS_TYPE_WIZARD:
            sClass = "wiz";
            break;
    }
    sSpells = Get2DAString("cls_spgn_" + sClass, "SpellLevel" + IntToString(nLevel), GetLevelByClass(nClass, oCreature) - 1);

    return (sSpells == "0") || (StringToInt(sSpells) > 0);
}

//::///////////////////////////////////////////////
//:: GetCasterAbility
//:://////////////////////////////////////////////
/*
    Returns the ability used by nClass to
    cast spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 17, 2016
//:://////////////////////////////////////////////
int GetCasterAbility(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARD:     return ABILITY_CHARISMA;
        case CLASS_TYPE_CLERIC:   return ABILITY_WISDOM;
        case CLASS_TYPE_DRUID:    return ABILITY_WISDOM;
        case CLASS_TYPE_PALADIN:  return ABILITY_WISDOM;
        case CLASS_TYPE_RANGER:   return ABILITY_WISDOM;
        case CLASS_TYPE_SORCERER: return ABILITY_CHARISMA;
        case CLASS_TYPE_WIZARD:   return ABILITY_INTELLIGENCE;
    }
    return ABILITY_INVALID;
}

//::///////////////////////////////////////////////
//:: GetCasterLevelOverride
//:://////////////////////////////////////////////
/*
    Returns the overriden caster level value
    for the given spell id on the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
int GetCasterLevelOverride(object oCreature, int nSpellId)
{
    return GetLocalInt(oCreature, "CASTER_LEVEL_OVERRIDE_" + IntToString(nSpellId));
}

//::///////////////////////////////////////////////
//:: GetCreatureLastSpellCastClass
//:://////////////////////////////////////////////
/*
    Returns the spell cast class for the spell
    last cast by the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetCreatureLastSpellCastClass(object oCreature)
{
    if(GetIsCreatureLastSpellCastItemValid(oCreature))
        return CLASS_TYPE_INVALID;
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCastClass");
}

//::///////////////////////////////////////////////
//:: GetCreatureLastSpellCasterLevel
//:://////////////////////////////////////////////
/*
    Returns the caster level for the spell
    last cast by the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetCreatureLastSpellCasterLevel(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCasterLevel");
}

//::///////////////////////////////////////////////
//:: GetCreatureLastSpellCastAbility
//:://////////////////////////////////////////////
/*
    Returns the cast ability used by the last
    spell cast for the creature (e.g. intelligence
    for wizards). If the last spell cast was an
    epic spell, will instead return the cast stat
    for the creature's primary class. If an item
    was used to cast the spell, or the creature
    has no spell cast levels, will return
    ABILITY_INVALID.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
int GetCreatureLastSpellCastAbility(object oCreature)
{
    if(GetIsEpicSpell(GetCreatureLastSpellId(oCreature)))
        return GetCasterAbility(GetPrimarySpellCastClass(oCreature));
    return GetCasterAbility(GetCreatureLastSpellCastClass(oCreature));
}

//::///////////////////////////////////////////////
//:: GetCreatureLastSpellId
//:://////////////////////////////////////////////
/*
    Returns the id of the spell last cast
    by the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetCreatureLastSpellId(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellId");
}

//::///////////////////////////////////////////////
//:: GetFirstAvailableSpellSlot
//:://////////////////////////////////////////////
/*
    Returns the index of the first available
    spell slot for the class and spell level.
    Does not work for spontaneous spell casting
    classes.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetFirstAvailableSpellSlot(object oCreature, int nClass, int nSpellLevel)
{
    int i;
    int nNumSlots = NWNX_Creature_GetMaxSpellSlots(oCreature, nClass, nSpellLevel);
    struct NWNX_Creature_MemorisedSpell spellSlot;

    for(i = 0; i < nNumSlots; i++)
    {
        spellSlot = NWNX_Creature_GetMemorisedSpell(oCreature, nClass, nSpellLevel, i);
        if(spellSlot.ready)
            return i;
    }
    return SPELL_SLOT_INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetCreatestSpellCasterLevel
//:://////////////////////////////////////////////
/*
    Returns the creature's highest spellcaster
    level out of all of its classes.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 29, 2016
//:://////////////////////////////////////////////
int GetGreatestSpellCasterLevel(object oCreature)
{
    int i;
    int nCasterLevel;
    int nClass;
    int nLevel;

    for(i = 1; i <= 3; i++)
    {
        nClass = GetClassByPosition(i, oCreature);
        nLevel = GetLevelByClass(nClass, oCreature);
        if(GetIsArcaneSpellCastClass(nClass))
        {
            nLevel += GetLevelByClass(CLASS_TYPE_PALEMASTER, oCreature) / 2;
        }
        if(GetIsSpellCastClass(nClass) && nLevel > nCasterLevel)
        {
            nCasterLevel = nLevel;
        }
    }
    return nCasterLevel;
}

//::///////////////////////////////////////////////
//:: GetHasNonSwarmSummon
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature has at least
    one summon that was not created via the
    SummonSwarm function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetHasNonSwarmSummon(object oCreature)
{
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature);

    while(GetIsObjectValid(oSummon))
    {
        if(!GetIsSwarmSummon(oSummon))
            return TRUE;
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature, i);
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetHasSpellsRemaining
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature has spells
    remaining of the specified class and level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetHasSpellsRemaining(object oPC, int nClass, int nSpellLevel)
{
    return GetIsSpontaneousSpellCastClass(nClass) ? NWNX_Creature_GetRemainingSpellSlots(oPC, nClass, nSpellLevel) :
        (GetFirstAvailableSpellSlot(oPC, nClass, nSpellLevel) >= 0);
}

//::///////////////////////////////////////////////
//:: GetIsAoEExpiring
//:://////////////////////////////////////////////
/*
    Returns TRUE if the AoE is about to expire.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 17, 2016
//:://////////////////////////////////////////////
int GetIsAoEExpiring(object oAoE = OBJECT_SELF)
{
    float fDurationRemaining = GetAoEDurationRemaining(oAoE);
    int bIsExpiring = (fDurationRemaining <= 0.05 && fDurationRemaining != -1.0) && !GetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoEExpired");

    if(bIsExpiring)
    {
        _FlagAoEExpired(oAoE);
    }
    return bIsExpiring;
}

//::///////////////////////////////////////////////
//:: GetIsArcaneSpellCastClass
//:://////////////////////////////////////////////
/*
    Returns TRUE if nClass is an arcane
    spellcaster.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 29, 2016
//:://////////////////////////////////////////////
int GetIsArcaneSpellCastClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
            return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetIsCasterSpell
//:://////////////////////////////////////////////
/*
    Returns TRUE if the given spell is a caster
    spell (i.e. one castable by one of the
    game's base classes).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2017
//:://////////////////////////////////////////////
int GetIsCasterSpell(int nSpellId)
{
    return (Get2DAString("spells", "Bard", nSpellId) != "****"
        || Get2DAString("spells", "Cleric", nSpellId) != "****"
        || Get2DAString("spells", "Druid", nSpellId) != "****"
        || Get2DAString("spells", "Paladin", nSpellId) != "****"
        || Get2DAString("spells", "Ranger", nSpellId) != "****"
        || Get2DAString("spells", "Wiz_Sorc", nSpellId) != "****");
}

//::///////////////////////////////////////////////
//:: GetIsCreatureLastSpellCastItemValid
//:://////////////////////////////////////////////
/*
    Returns TRUE if the last spell the creature
    cast was from an item.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetIsCreatureLastSpellCastItemValid(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCastItemIsValid");
}

//::///////////////////////////////////////////////
//:: GetIsEpicSpell
//:://////////////////////////////////////////////
/*
    Returns TRUE if the spell cast is an epic
    spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetIsEpicSpell(int nSpellId)
{
    return nSpellId == SPELL_EPIC_DRAGON_KNIGHT
        || nSpellId == SPELL_EPIC_HELLBALL
        || nSpellId == SPELL_EPIC_MAGE_ARMOR
        || nSpellId == SPELL_EPIC_MUMMY_DUST
        || nSpellId == SPELL_EPIC_RUIN;
}

//::///////////////////////////////////////////////
//:: GetIsLastSpellCastInnate
//:://////////////////////////////////////////////
/*
    Returns TRUE if the last spell was cast
    as an innate ability.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetIsLastSpellCastInnate()
{
    return !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID;
}

//::///////////////////////////////////////////////
//:: GetIsLastSpellCastSpontaneous
//:://////////////////////////////////////////////
/*
    Returns TRUE if the last spell was cast
    as an innate ability by a PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
int GetIsLastSpellCastSpontaneous()
{
    return GetIsLastSpellCastInnate() && GetIsPC(OBJECT_SELF) && !GetIsPossessedFamiliar(OBJECT_SELF)
        && GetSpecialAbilityIndex(OBJECT_SELF, GetSpellId()) != SPECIAL_ABILITY_INDEX_UNDEFINED;
}

//::///////////////////////////////////////////////
//:: GetIsSpellCastClass
//:://////////////////////////////////////////////
/*
    Returns TRUE if nClass can cast spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 29, 2016
//:://////////////////////////////////////////////
int GetIsSpellCastClass(int nClass)
{
    return StringToInt(Get2DAString("classes", "SpellCaster", nClass));
}

//::///////////////////////////////////////////////
//:: GetIsSpontaneousSpellCastClass
//:://////////////////////////////////////////////
/*
    Returns TRUE if the specified class casts
    spells spontaneously (i.e. is a bard
    or sorcerer).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetIsSpontaneousSpellCastClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
            return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetIsSwarmSummon
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature was summoned
    via a swarm effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetIsSwarmSummon(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "IsSwarmSummon");
}

//::///////////////////////////////////////////////
//:: GetPrimarySpellCastClass
//:://////////////////////////////////////////////
/*
    Returns the spell cast class in which the
    given creature has the most levels. If two
    classes are tied, then the first will be
    returned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
int GetPrimarySpellCastClass(object oCreature)
{
    int nClass;
    int nClass1 = GetClassByPosition(1, oCreature);
    int nClass2 = GetClassByPosition(2, oCreature);
    int nClass3 = GetClassByPosition(3, oCreature);

    if(GetIsSpellCastClass(nClass1))
        nClass = nClass1;
    if(GetIsSpellCastClass(nClass2) && GetLevelByClass(nClass2, oCreature) > GetLevelByClass(nClass, oCreature))
        nClass = nClass2;
    if(GetIsSpellCastClass(nClass3) && GetLevelByClass(nClass3, oCreature) > GetLevelByClass(nClass, oCreature))
        nClass = nClass3;
    if(!nClass)
        nClass = CLASS_TYPE_INVALID;

    return nClass;
}

//::///////////////////////////////////////////////
//:: GetSpecialAbilityIdByIndex
//:://////////////////////////////////////////////
/*
    Returns the special ability at the
    specified index for the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetSpecialAbilityIdByIndex(object oPC, int nIndex)
{
    struct NWNX_Creature_SpecialAbility ability = NWNX_Creature_GetSpecialAbility(oPC, nIndex);

    return ability.id;
}

//::///////////////////////////////////////////////
//:: GetSpecialAbilityIndex
//:://////////////////////////////////////////////
/*
    Returns the special ability index of the
    ability matching the spell id on the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetSpecialAbilityIndex(object oPC, int nSpellId)
{
    int i;
    int nSpecialAbilityCount = NWNX_Creature_GetSpecialAbilityCount(oPC);
    struct NWNX_Creature_SpecialAbility ability;

    for(i = 0; i < nSpecialAbilityCount; i++)
    {
        ability = NWNX_Creature_GetSpecialAbility(oPC, i);
        if(ability.id == nSpellId)
            return i;
    }
    return SPECIAL_ABILITY_INDEX_UNDEFINED;
}

//::///////////////////////////////////////////////
//:: GetSpellFocusLevel
//:://////////////////////////////////////////////
/*
    Returns the degree to which the creature is
    focused in the given spell school (i.e.
    0 for no focus, 1 for spell focus, 2 for
    greater spell focus, 3 for epic spell focus).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 16, 2016
//:://////////////////////////////////////////////
int GetSpellFocusLevel(object oCreature, int nSchool)
{
    switch(nSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_CONJURATION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_DIVINATION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_ENCHANTMENT:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_EVOCATION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_ILLUSION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_NECROMANCY:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCreature))
                return 1;
            break;
        case SPELL_SCHOOL_TRANSMUTATION:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCreature))
                return 3;
            if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCreature))
                return 2;
            if(GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCreature))
                return 1;
            break;
    }
    return 0;
}

//::///////////////////////////////////////////////
//:: GetSpells2DAColumnFromClass
//:://////////////////////////////////////////////
/*
    Returns the appropriate spells 2DA column
    for the specified class (e.g. CLASS_TYPE_WIZARD
    and CLASS_TYPE_SORCERER would both return
    "Wiz_Sorc").
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
string GetSpells2DAColumnFromClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARD:
            return "Bard";
        case CLASS_TYPE_CLERIC:
            return "Cleric";
        case CLASS_TYPE_DRUID:
            return "Druid";
        case CLASS_TYPE_PALADIN:
            return "Paladin";
        case CLASS_TYPE_RANGER:
            return "Ranger";
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SORCERER:
            return "Wiz_Sorc";
    }
    return "";
}

//::///////////////////////////////////////////////
//:: GetSpellInnateLevel
//:://////////////////////////////////////////////
/*
    Returns the innate level of the given spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 11, 2016
//:://////////////////////////////////////////////
int GetSpellInnateLevel(int nSpellId)
{
    return StringToInt(Get2DAString("spells", "Innate", nSpellId));
}

//::///////////////////////////////////////////////
//:: GetSpellOverride
//:://////////////////////////////////////////////
/*
    Checks the SPELL_OVERRIDE_X flag for the
    spellcaster and runs the override script
    if one has been flagged. Returns TRUE
    on a successful override.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 17, 2016
//:://////////////////////////////////////////////
int GetSpellOverride()
{
    string sOverride = GetLocalString(OBJECT_SELF, "SPELL_OVERRIDE_" + IntToString(GetSpellId()));

    if(sOverride == "")
    {
        sOverride = GetLocalString(GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF), "SPELL_OVERRIDE_" + IntToString(GetSpellId()));
    }

    if(sOverride != "")
    {
        ExecuteScript(sOverride, OBJECT_SELF);
        return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetSpellSchool
//:://////////////////////////////////////////////
/*
    Returns the spell school associated with
    the specified spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 4, 2016
//:://////////////////////////////////////////////
int GetSpellSchool(int nSpellId)
{
    string sSchool = Get2DAString("spells", "School", nSpellId);

    return ((sSchool == "A") ? SPELL_SCHOOL_ABJURATION :
        (sSchool == "C") ? SPELL_SCHOOL_CONJURATION :
        (sSchool == "D") ? SPELL_SCHOOL_DIVINATION :
        (sSchool == "E") ? SPELL_SCHOOL_ENCHANTMENT :
        (sSchool == "V") ? SPELL_SCHOOL_EVOCATION :
        (sSchool == "I") ? SPELL_SCHOOL_ILLUSION :
        (sSchool == "N") ? SPELL_SCHOOL_NECROMANCY :
        (sSchool == "T") ? SPELL_SCHOOL_TRANSMUTATION :
            SPELL_SCHOOL_GENERAL);
}

//::///////////////////////////////////////////////
//:: GetSpontaneousSpellClass
//:://////////////////////////////////////////////
/*
    Returns the class used for the spontaneous
    spell assigned to the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetSpontaneousSpellClass(object oPC, int nSpellId)
{
    return GetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpell" + IntToString(nSpellId) + "Class");
}

//::///////////////////////////////////////////////
//:: GetSpontaneousSpellLevel
//:://////////////////////////////////////////////
/*
    Returns the caster level of the spontaneous
    spell assigned to the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetSpontaneousSpellLevel(object oPC, int nSpellId)
{
    return GetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpell" + IntToString(nSpellId) + "Level");
}

//::///////////////////////////////////////////////
//:: GetSpontaneousSpellReadyState
//:://////////////////////////////////////////////
/*
    Returns the ready state of the spontaneous
    spell with the specified id.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
int GetSpontaneousSpellReadyState(object oPC, int nSpellId)
{
    int nIndex = GetSpecialAbilityIndex(oPC, nSpellId);
    struct NWNX_Creature_SpecialAbility spell = NWNX_Creature_GetSpecialAbility(oPC, nIndex);

    return spell.ready;
}

//::///////////////////////////////////////////////
//:: GetStaticVFXPartner
//:://////////////////////////////////////////////
/*
    Returns the static VFX partner for the
    AoE, if one exists.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
object GetStaticVFXPartner(object oVFX)
{
    return GetLocalObject(oVFX, LIB_SPELLS_PREFIX + "VFXPartner");
}

//::///////////////////////////////////////////////
//:: GetTemporaryCasterLevelBonus
//:://////////////////////////////////////////////
/*
    Returns the caster level bonus for the
    creatures, which translates to additional
    caster levels for all spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
int GetTemporaryCasterLevelBonus(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SPELLS_PREFIX + "CasterLevelBonus");
}

//::///////////////////////////////////////////////
//:: GetSwarmSummonCount
//:://////////////////////////////////////////////
/*
    Returns the number of swarm summons belonging
    to the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 13, 2016
//:://////////////////////////////////////////////
int GetSwarmSummonCount(object oCreature)
{
    int nCount;
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature);

    while(GetIsObjectValid(oSummon))
    {
        if(GetIsSwarmSummon(oSummon))
        {
            nCount++;
        }
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature, i);
    }
    return nCount;
}

//::///////////////////////////////////////////////
//:: IncrementRemainingSpellSlots
//:://////////////////////////////////////////////
/*
    Increments spell slots for the creature
    of the given class and spell level. Affects
    only spontaneous casting classes.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void IncrementRemainingSpellSlots(object oCreature, int nClass, int nSpellLevel)
{
    NWNX_Creature_SetRemainingSpellSlots(oCreature, nClass, nSpellLevel, NWNX_Creature_GetRemainingSpellSlots(oCreature, nClass, nSpellLevel) + 1);
}

//::///////////////////////////////////////////////
//:: ProjectImage
//:://////////////////////////////////////////////
/*
    Handles the project image spell, which
    creates a non-spellcasting clone of the caster
    that lasts for 1 hour / level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 2, 2016
//:: Modified By: Miesny_Jez
//:: Modified On: November 18, 2017
//:://////////////////////////////////////////////
void ProjectImage()
{
	location lSpawn = Location(GetArea(OBJECT_SELF), GetPosition(OBJECT_SELF) + GenerateCircleCoordinate(3), IntToFloat(Random(360)));
    object oImage = CopyObject(OBJECT_SELF, lSpawn, OBJECT_INVALID, "Sum_Project_Image");
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF)
        + GetLevelByClass(CLASS_TYPE_SORCERER, OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_WIZARD, OBJECT_SELF) + 
			GetLevelByClass(CLASS_TYPE_PALEMASTER, OBJECT_SELF)  + GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, OBJECT_SELF) +
			    GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF)  + GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF);
	
	int nHarperLevel = GetLevelByClass(CLASS_TYPE_HARPER, OBJECT_SELF); // Check for Harper
	int nSDLevel 	 = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, OBJECT_SELF); //Check for SD
	string sName;
	string sPortrait;
	
	int nHarperBonus = 0;
	int nSMBonus	 = 0;
    
	if(nHarperLevel)
    {		
    	int nHarperPath = GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "MI_CL_HARPER_PATH");
    	
	    switch (nHarperPath)
	    {
	      case 0:
	        // SCOUT - Bonus at levels 1/3/5
	        nHarperBonus = (nHarperLevel + 1) / 2;
	        break;
	      case 1: // MAGE - Full bonus.	        
	      case 2: // PRIEST - Full bonus.
	      case 3: // PARAGON - Full bonus.	        
	        nHarperBonus = nHarperLevel;
	        break;
	      case 4: // MASTER - no bonus	        
	        break;
	    }	
	}	
	if (nSDLevel && GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "SHADOW_MAGE"))
	{
		nSMBonus = nSDLevel;
	}
	
	nCasterLevel = nCasterLevel + nHarperBonus + nSMBonus; // Modify the CL by HS or SM

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), GetLocation(oImage));
    
    if(GetLocalInt(OBJECT_SELF, "disguised")) 
	{
		SetLocalInt(oImage, "disguised", 1);
		sName = svGetPCNameOverride(OBJECT_SELF); // Get the Disguised name
		SetName(oImage, sName); //Set Name of the Image, fbNASetDynamicNameForAll will not work here
		if (GetGender(OBJECT_SELF) == GENDER_MALE) //Hide portrait
		{ // Male
			sPortrait = "po_hu_m_99_";	
		}
		else
		{ // Female
			sPortrait = "po_hu_f_99_";	
		}
		SetPortraitResRef(oImage, sPortrait);	
	}

    _SetProjectImageAI(oImage);
    _SetProjectImageDespawnTimer(oImage, FloatToInt(HoursToSeconds(nCasterLevel)));
    SetLocalInt(oImage, "X2_JUST_A_DISABLEEQUIP", TRUE);
    SetLocalInt(oImage, "X2_L_BEH_OFFENSE", 100);
    SetLocalInt(oImage, "X2_L_BEH_MAGIC", -100);
    SetLocalInt(oImage, "PROJECT_IMAGE_CASTER_CL", nCasterLevel);
    SetChatRelayTarget(oImage, OBJECT_SELF);
    SetChatRelayName(oImage, "Your image");
    SetCanMasterSpeakThroughAssociate(oImage);
    AssignCommand(oImage, SetIsDestroyable(TRUE, FALSE, FALSE));
    ClearInventory(oImage, TRUE, FALSE);
    SetInventoryDroppable(oImage, FALSE);
    RemoveAllEffects(oImage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellFailure(100)), oImage);
    AddHenchman(OBJECT_SELF, oImage);
}

//::///////////////////////////////////////////////
//:: RemoveAllEffects
//:://////////////////////////////////////////////
/*
    Removes all effects from the designated
    object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 12, 2016
//:://////////////////////////////////////////////
void RemoveAllEffects(object oObject)
{
    effect eEffect = GetFirstEffect(oObject);

    while(GetIsEffectValid(eEffect))
    {
        RemoveEffect(oObject, eEffect);
        eEffect = GetNextEffect(oObject);
    }
}

//::///////////////////////////////////////////////
//:: RemoveAllSpecialAbilities
//:://////////////////////////////////////////////
/*
    Removes all special abilities from the
    creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 12, 2016
//:://////////////////////////////////////////////
void RemoveAllSpecialAbilities(object oPC)
{
    int i;

    for(i = 0; i < NWNX_Creature_GetSpecialAbilityCount(oPC); i++)
    {
        NWNX_Creature_RemoveSpecialAbility(oPC, i);
    }
}

//::///////////////////////////////////////////////
//:: RemoveSpecialAbilityById
//:://////////////////////////////////////////////
/*
    Removes the special ability with the
    designated spell id on the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void RemoveSpecialAbilityById(object oPC, int nSpellId)
{
    int nIndex = GetSpecialAbilityIndex(oPC, nSpellId);
    if(nIndex > -1)
        NWNX_Creature_RemoveSpecialAbility(oPC, nIndex);
}

//::///////////////////////////////////////////////
//:: SetAoECastClass
//:://////////////////////////////////////////////
/*
    Overrides the cast class used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void SetAoECastClass(object oAoE, int nClass)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoECastClass", nClass);
}

//::///////////////////////////////////////////////
//:: SetAoECasterLevel
//:://////////////////////////////////////////////
/*
    Overrides the caster level used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void SetAoECasterLevel(object oAoE, int nCasterLevel)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoECasterLevel", nCasterLevel);
}

//::///////////////////////////////////////////////
//:: SetAoEId
//:://////////////////////////////////////////////
/*
    Sets an Id variable on the nonstacking AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
void SetAoEId(object oAoE, int nId)
{
    // Value shift of one because we're moving the whole index upward, so as not to confuse
    // unassigned Ids with the Id of the 0th entry of spells.2da (i.e. acid fog).
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "NonStackingAoEId", nId + 1);
}

//::///////////////////////////////////////////////
//:: SetAoEMetaMagic
//:://////////////////////////////////////////////
/*
    Overrides the metamagic feat used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 21, 2016
//:://////////////////////////////////////////////
void SetAoEMetaMagic(object oAoE, int nMetaMagic)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoEMetaMagic", nMetaMagic);
}
//::///////////////////////////////////////////////
//:: SetCasterLevelOverride
//:://////////////////////////////////////////////
/*
    Overrides the caster level for the given
    spell id on the creature to the given level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
void SetCasterLevelOverride(object oCreature, int nSpellId, int nCasterLevel)
{
    if(!nCasterLevel)
    {
        DeleteLocalInt(oCreature, "CASTER_LEVEL_OVERRIDE_" + IntToString(nSpellId));
    }
    else
    {
        SetLocalInt(oCreature, "CASTER_LEVEL_OVERRIDE_" + IntToString(nSpellId), nCasterLevel);
    }
}

//::///////////////////////////////////////////////
//:: SetSpellSlotReadyState
//:://////////////////////////////////////////////
/*
    Sets the designated spell slot's ready
    state. Does nothing for spontaneous spell
    cast classes.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void SetSpellSlotReadyState(object oCreature, int nClass, int nSpellLevel, int nIndex, int bIsReady)
{
    struct NWNX_Creature_MemorisedSpell spellSlot = NWNX_Creature_GetMemorisedSpell(oCreature, nClass, nSpellLevel, nIndex);

    spellSlot.ready = bIsReady;
    NWNX_Creature_SetMemorisedSpell(oCreature, nClass, nSpellLevel, nIndex, spellSlot);
}

//::///////////////////////////////////////////////
//:: SetSpontaneousSpellClass
//:://////////////////////////////////////////////
/*
    Sets the class used for the designated
    spontaneous spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void SetSpontaneousSpellClass(object oPC, int nSpellId, int nClass)
{
    SetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpell" + IntToString(nSpellId) + "Class", nClass);
}

//::///////////////////////////////////////////////
//:: SetSpontaneousSpellLevel
//:://////////////////////////////////////////////
/*
    Sets the caster level for the designated
    spontaneous spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void SetSpontaneousSpellLevel(object oPC, int nSpellId, int nLevel)
{
    SetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpell" + IntToString(nSpellId) + "Level", nLevel);
}

//::///////////////////////////////////////////////
//:: SetSpontaneousSpellReadyState
//:://////////////////////////////////////////////
/*
    Sets the ready state of the special ability
    matching the designated spell id.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void SetSpontaneousSpellReadyState(object oPC, int nSpellId, int bIsReady)
{
    int nIndex = GetSpecialAbilityIndex(oPC, nSpellId);
    struct NWNX_Creature_SpecialAbility spell = NWNX_Creature_GetSpecialAbility(oPC, nIndex);

    spell.ready = bIsReady;

    NWNX_Creature_SetSpecialAbility(oPC, nIndex, spell);
}

//::///////////////////////////////////////////////
//:: SetTemporaryCasterLevelBonus
//:://////////////////////////////////////////////
/*
    Sets the caster level bonus for the creature,
    which translates to additional caster levels
    for all spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////
void SetTemporaryCasterLevelBonus(object oCreature, int nBonus)
{
    if(!nBonus)
    {
        DeleteLocalInt(oCreature, LIB_SPELLS_PREFIX + "CasterLevelBonus");
    }
    else
    {
        SetLocalInt(oCreature, LIB_SPELLS_PREFIX + "CasterLevelBonus", nBonus);
    }
}

//::///////////////////////////////////////////////
//:: SpellSchoolToSpellFocusFeat
//:://////////////////////////////////////////////
/*
    Returns the spell focus feat for the specified
    school.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 4, 2016
//:://////////////////////////////////////////////
int SpellSchoolToSpellFocusFeat(int nSpellSchool, int nFocusLevel = FEAT_SPELL_FOCUS)
{
    switch(nSpellSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_ABJURATION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_ABJURATION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_ABJURATION;
            }
        case SPELL_SCHOOL_CONJURATION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_CONJURATION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_CONJURATION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_CONJURATION;
            }
        case SPELL_SCHOOL_DIVINATION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_DIVINATION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_DIVINATION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_DIVINATION;
            }
        case SPELL_SCHOOL_ENCHANTMENT:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_ENCHANTMENT;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT;
            }
        case SPELL_SCHOOL_EVOCATION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_EVOCATION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_EVOCATION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_EVOCATION;
            }
        case SPELL_SCHOOL_ILLUSION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_ILLUSION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_ILLUSION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_ILLUSION;
            }
        case SPELL_SCHOOL_NECROMANCY:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_NECROMANCY;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_NECROMANCY;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
            }
        case SPELL_SCHOOL_TRANSMUTATION:
            switch(nFocusLevel)
            {
                case FEAT_SPELL_FOCUS:
                    return FEAT_SPELL_FOCUS_TRANSMUTATION;
                case FEAT_GREATER_SPELL_FOCUS:
                    return FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION;
                case FEAT_EPIC_SPELL_FOCUS:
                    return FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
            }
    }
    return -1;
}

//::///////////////////////////////////////////////
//:: SummonSwarm
//:://////////////////////////////////////////////
/*
    Summons multiple creatures at once to fight
    at the caster's side.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void SummonSwarm(object oCaster, struct SummonGroup swarm, float fDuration, int nVFX = VFX_NONE)
{
    float fVector = 0.0;
    int i = 1;
    int nSummonIndex;
    location lSpawn;
    location lTarget = GetSpellTargetLocation();
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    string sSummonBlueprint;

    while(GetIsObjectValid(oSummon))
    {
        UnsummonCreature(oSummon);
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }

    for(nSummonIndex = 1; nSummonIndex <= 4; nSummonIndex++)
    {
        switch(nSummonIndex)
        {
            case 1:
                sSummonBlueprint = swarm.summon1;
                break;
            case 2:
                sSummonBlueprint = swarm.summon2;
                break;
            case 3:
                sSummonBlueprint = swarm.summon3;
                break;
            case 4:
                sSummonBlueprint = swarm.summon4;
                break;
        }
        if(sSummonBlueprint == "") continue;
        if(nSummonIndex == 1)
        {
            // The game will unsummon the first spawn of a new batch. So create one dummy.
            lSpawn = GenerateNewLocationFromLocation(lTarget, 1.5, fVector, fVector);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummonBlueprint, nVFX), lSpawn, fDuration);
        }
        for(i = 0; i < swarm.numSummons; i++)
        {
            lSpawn = GenerateNewLocationFromLocation(lTarget, 1.5, fVector, fVector);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummonBlueprint, nVFX), lSpawn, fDuration);
            fVector += 40;
        }
    }
    DelayCommand(0.0, _FlagSwarmSummons(oCaster));
}

//::///////////////////////////////////////////////
//:: UnsummonCreature
//:://////////////////////////////////////////////
/*
    Unsummons a creature. Uses the specified
    VFX.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
void UnsummonCreature(object oCreature, int nVFX = VFX_IMP_UNSUMMON)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), GetLocation(oCreature));
    AssignCommand(oCreature, SetIsDestroyable(TRUE, FALSE, FALSE));
    DestroyObject(oCreature);
}

//::///////////////////////////////////////////////
//:: UnsummonSwarmSummons
//:://////////////////////////////////////////////
/*
    Unsummons all summons created via the
    SummonSwarm function belonging to the
    given creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void UnsummonSwarmSummons(object oCreature)
{
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature);

    while(GetIsObjectValid(oSummon))
    {
        if(GetIsSwarmSummon(oSummon))
        {
            UnsummonCreature(oSummon);
        }
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCreature, i);
    }
}

//::///////////////////////////////////////////////
//:: UpdateCreatureSpellVariables
//:://////////////////////////////////////////////
/*
    Updates spell variables for the creature,
    which allows information on the spell being
    cast to be recalled after the spell has been
    cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 20, 2016
//:://////////////////////////////////////////////
void UpdateCreatureSpellVariables(object oCreature)
{
    _SetCreatureLastSpellCastClass(oCreature, GetLastSpellCastClass());
    _SetCreatureLastSpellCasterLevel(oCreature, GetIsEpicSpell(GetSpellId()) ? GetGreatestSpellCasterLevel(oCreature) : _Spells_GetCasterLevel(oCreature));
    _SetCreatureLastSpellId(oCreature, GetSpellId());
    _SetIsCreatureLastSpellCastItemValid(oCreature, GetIsObjectValid(GetSpellCastItem()));
}

//::///////////////////////////////////////////////
//:: UpdateSpontaneousSpellReadyStates
//:://////////////////////////////////////////////
/*
    Updates ready states for all spontaneous
    spells on the PC. Should be called whenever
    a spell is cast. Note that this is called
    by default from the spontaneous spell
    handler.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
void UpdateSpontaneousSpellReadyStates(object oPC)
{
    if(!GetIsPC(oPC) || GetIsPossessedFamiliar(oPC) || GetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpellStatesUpdated")) return;

    // Avoid multiple unnecessary checks on subsequent calls.
    SetLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpellStatesUpdated", TRUE);
    DelayCommand(0.0, DeleteLocalInt(oPC, LIB_SPELLS_PREFIX + "SpontaneousSpellStatesUpdated"));

    int i;
    int bIsReady;
    struct NWNX_Creature_SpecialAbility spell;

    for(i = 0; i < NWNX_Creature_GetSpecialAbilityCount(oPC); i++)
    {
        spell = NWNX_Creature_GetSpecialAbility(oPC, i);
        bIsReady = !GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) &&
            (GetSpontaneousSpellLevel(oPC, spell.id) == SPONTANEOUS_SPELL_LEVEL_INVALID ||
            GetHasSpellsRemaining(oPC, GetSpontaneousSpellClass(oPC, spell.id), GetSpontaneousSpellLevel(oPC, spell.id)));
        SetSpontaneousSpellReadyState(oPC, spell.id, bIsReady);
    }
}

//::///////////////////////////////////////////////
//:: EffectPolymorphEx
//:://////////////////////////////////////////////
/*
    Alternative for EffectPolymorph, using this
    wrapper will also store all Spellbook
    data from oPC to be used to restore later
    after polymorph has ended.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: July 8, 2017
//:://////////////////////////////////////////////
effect EffectPolymorphEx(int nPolymorphSelection, int nLocked = FALSE, object oPC = OBJECT_SELF) {
    effect ePoly = EffectPolymorph(nPolymorphSelection, nLocked);

    if ( !GetIsObjectValid(oPC) || !GetIsPC(oPC) || GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) ) return ePoly;

    struct NWNX_Creature_MemorisedSpell mss;
    string sSpellData;
    int nMaxSlots;
    string sArrayTag;
    int nClass;
    int nSpellLevel;
    int x;

    //::  Loop classes to check their spellbooks
    int c;
    for ( c = 1; c <= 3; c++ ) {
        nClass = GetClassByPosition(c, oPC);

        if ( nClass == CLASS_TYPE_INVALID || !_getIsSpellBookClass(nClass) ) continue;

        //::  Loop Spellbook for this class and store spelldata
        for ( nSpellLevel = 1; nSpellLevel <= 9; nSpellLevel++ ) {
            nMaxSlots = NWNX_Creature_GetMaxSpellSlots(oPC, nClass, nSpellLevel);
            sArrayTag  = "mss" + IntToString(c) + IntToString(nSpellLevel);

            //::  Just clear if its not cleared already, to be safe
            //::  before we populate it anew.
            StringArray_Clear(oPC, sArrayTag);

            for( x = 0; x < nMaxSlots; x++ )
            {
                mss = NWNX_Creature_GetMemorisedSpell(oPC, nClass, nSpellLevel, x);

                //::  Spell Data stored as a string to be parsed later when restoring as:
                //::
                //::  SPELL_* ! 0/1 (TRUE/FALSE) # METAMAGIC_*
                //::  E.g a string could look like: "442!1#2"     Meaning: Amplify, Ready (Not spent), Extended
                sSpellData = IntToString(mss.id) + "!" + IntToString(mss.ready) + "#" + IntToString(mss.meta);
                StringArray_PushBack(oPC, sArrayTag, sSpellData);

                //WriteTimestampedLogEntry("INC_SPELLS -- Stored spell data (" + sArrayTag + ")  " + sSpellData + "  on  " + GetName(oPC));
            }
        }
    }

    return ePoly;
}

//::///////////////////////////////////////////////
//:: RestoreSpellsAfterPolymorph
//:://////////////////////////////////////////////
/*
    Used from 'gs_m_unequip' to restore Spellbook
    data for oPC after unpolymorphing.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: July 8, 2017
//:://////////////////////////////////////////////
void RestoreSpellsAfterPolymorph(object oPC) {
    if ( !GetIsObjectValid(oPC) || !GetIsPC(oPC) || GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) )    return;

    struct NWNX_Creature_MemorisedSpell mss;
    string sSpellData;
    int pos1;
    int pos2;
    int len;
    int nMaxSlots;
    string sArrayTag;
    int nClass;
    int nSpellLevel;
    int x;

    //::  Loop classes to check their spellbooks
    int c;
    for ( c = 1; c <= 3; c++ ) {
        nClass = GetClassByPosition(c, oPC);

        if ( nClass == CLASS_TYPE_INVALID || !_getIsSpellBookClass(nClass) ) continue;

        //::  Loop Spellbook and restore spelldata for this class
        for ( nSpellLevel = 1; nSpellLevel <= 9; nSpellLevel++ ) {
            sArrayTag  = "mss" + IntToString(c) + IntToString(nSpellLevel);
            nMaxSlots = StringArray_Size(oPC, sArrayTag);

            for( x = 0; x < nMaxSlots; x++ )
            {
                sSpellData = StringArray_At(oPC, sArrayTag, x);
                pos1 = FindSubString(sSpellData, "!");
                pos2 = FindSubString(sSpellData, "#");
                len  = GetStringLength(sSpellData);

                //WriteTimestampedLogEntry("INC_SPELLS -- Restored spell data (" + sArrayTag + ")  " + sSpellData + "  on  " + GetName(oPC));
                if (pos1 != -1 && pos2 != -1) {
                    int nSpellId    = StringToInt(GetSubString(sSpellData, 0, pos1));
                    int nSpellReady = StringToInt(GetSubString(sSpellData, pos1+1, pos2));
                    int nSpellMeta  = StringToInt(GetSubString(sSpellData, pos2+1, len-pos2));

                    if ( nSpellId == -1 ) {
                        continue;
                    }

                    mss.id      = nSpellId;
                    mss.ready   = nSpellReady;
                    mss.meta    = nSpellMeta;
                    //mss.domain  = 0;  //::  Needed?

                    //WriteTimestampedLogEntry("INC_SPELLS -- SetMemorizedSpell on " + GetName(oPC) + " | Spell ID: " + IntToString(nSpellId) + " | Ready: " + IntToString(nSpellReady) + " | Meta: " + IntToString(nSpellMeta));
                    NWNX_Creature_SetMemorisedSpell(oPC, nClass, nSpellLevel, x, mss);
                }

            }
            StringArray_Clear(oPC, sArrayTag);
        }
    }
}

//::///////////////////////////////////////////////
//:: RemoveAndReapplyNEP
//:://////////////////////////////////////////////
/*
    Removes NEP related effects and reapplies them
    after a short duration with the duration remaining.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: Sep 13, 2017
//:://////////////////////////////////////////////
void RemoveAndReapplyNEP(object oTarget) {

    if ( !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget) ) {
        return;
    }

    int bFound = FALSE;
    float fDuration = 0.0;
    effect eEffect = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eEffect)) {
        if( GetEffectSpellId(eEffect) == SPELL_NEGATIVE_ENERGY_PROTECTION &&
            GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY) {
            bFound = TRUE;
            fDuration = IntToFloat(GetEffectDurationRemaining(eEffect));
            RemoveEffect(oTarget, eEffect);
        }
        eEffect = GetNextEffect(oTarget);
    }

    //::  Found effects from NEP, reapply them.
    if ( bFound ) {
        //::  Just a precaution, but mainly for testing.
        if ( fDuration < 6.0) fDuration = 6.0;

        //::  Reapply NEP
        effect eNeg     = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
        effect eLevel   = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
        effect eAbil    = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
        effect eLink    = EffectLinkEffects(eNeg, eLevel);

        string nCurrentServer = GetLocalString(GetModule(), "SERVER_NAME");
        object oSave = gsPCGetCreatureHide(oTarget);
        if (    GetHasTaggedEffect(oTarget, EFFECT_TAG_DEATH) ||
                GetHasTaggedEffect(oTarget, EFFECT_TAG_SUBDUAL) ||
                (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SURFACE") == 1 && nCurrentServer == "1") ||
                (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_CANDP") == 1 && nCurrentServer == "3")) {
            FloatingTextStringOnCreature("You are too weak to receive the full potential of this spell", oTarget, FALSE);
        } else {
            eLink = EffectLinkEffects(eLink, eAbil);
        }

        //::  Apply it again after a short delay
        DelayCommand(1.0, AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration)));
    }
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _CreateStaticVFX
//:://////////////////////////////////////////////
/*
    Creates a static VFX object, coupled with
    an AoE. This allows an AoE to appear to hold
    VFX that it naturally could not (e.g.
    glyph of warding).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
object _CreateStaticVFX(string sName, int nId, location lLocation, float fDuration, string sStaticSourceTemplate, int nVFX1, int nVFX2)
{
    object oVFX = CreateObject(OBJECT_TYPE_PLACEABLE, sStaticSourceTemplate, lLocation, FALSE, "StaticVFX" + IntToString(nId));

    SetName(oVFX, sName);
    SetEventScript(oVFX, EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT, STATIC_VFX_ON_HEARTBEAT);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX1), oVFX, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX2), oVFX, fDuration);
    AssignCommand(oVFX, DestroyObject(oVFX, fDuration));

    return oVFX;
}

//::///////////////////////////////////////////////
//:: _DismissOldSwarmSummons
//:://////////////////////////////////////////////
/*
    Unsummons deprecated swarm summons. Called
    internally on a delay to resolve timing
    issues.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _DismissOldSwarmSummons(object oCreature)
{
    if(GetHasNonSwarmSummon(oCreature))
    {
        UnsummonSwarmSummons(oCreature);
    }
}

//::///////////////////////////////////////////////
//:: _FlagAoEExpired
//:://////////////////////////////////////////////
/*
    Flags the AoE as having expired. Prevents
    the AoE from running expiration scripts more
    than once in rare cases.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 17, 2016
//:://////////////////////////////////////////////
void _FlagAoEExpired(object oAoE)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoEExpired", TRUE);
}

//::///////////////////////////////////////////////
//:: _FlagSwarmSummons
//:://////////////////////////////////////////////
/*
    Flags all summons owned by the caster as
    having been summoned by a swarm effect.
    Called automatically by the SummonSwarm
    function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _FlagSwarmSummons(object oCaster)
{
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);

    while(GetIsObjectValid(oSummon))
    {
        SetLocalInt(oSummon, LIB_SPELLS_PREFIX + "IsSwarmSummon", TRUE);
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }
}

//::///////////////////////////////////////////////
//:: _LinkAoEToStaticVFX
//:://////////////////////////////////////////////
/*
    Stores references on the AoE and static
    VFX to one another.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _LinkAoEToStaticVFX(object oAoE, object oVFX)
{
    _SetStaticVFXPartner(oVFX, oAoE);
    _SetAoEPartner(oAoE, oVFX);
}

//::///////////////////////////////////////////////
//:: _SetAoEPartner
//:://////////////////////////////////////////////
/*
    Stores a reference to the coupled static VFX
    on the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _SetAoEPartner(object oAoE, object oPartner)
{
    SetLocalObject(oAoE, LIB_SPELLS_PREFIX + "AoEPartner", oPartner);
}

//::///////////////////////////////////////////////
//:: _SetCreatureLastSpellCastClass
//:://////////////////////////////////////////////
/*
    Sets the spell cast class for the creature's
    last spell, to be recalled with the
    GetCreatureLastSpellCastClass function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _SetCreatureLastSpellCastClass(object oCreature, int nCastClass)
{
    SetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCastClass", nCastClass);
}

//::///////////////////////////////////////////////
//:: _SetCreatureLastSpellCasterLevel
//:://////////////////////////////////////////////
/*
    Sets the caster level for the creature's
    last spell, to be recalled with the
    GetCreatureLastSpellCasterLevel function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _SetCreatureLastSpellCasterLevel(object oCreature, int nCasterLevel)
{
    SetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCasterLevel", nCasterLevel);
}

//::///////////////////////////////////////////////
//:: _SetCreatureLastSpellId
//:://////////////////////////////////////////////
/*
    Sets the creature's last spell Id, to be
    recalled with the GetCreatureLastSpellId
    function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _SetCreatureLastSpellId(object oCreature, int nId)
{
    SetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellId", nId);
}

//::///////////////////////////////////////////////
//:: _SetIsCreatureLastSpellCastItemValid
//:://////////////////////////////////////////////
/*
    Sets whether the creature's last spell used
    a spell cast item, to be recalled with the
    GetIsCreatureLastSpellCastItemValid function.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _SetIsCreatureLastSpellCastItemValid(object oCreature, int bIsValid)
{
    SetLocalInt(oCreature, LIB_SPELLS_PREFIX + "LastSpellCastItemIsValid", bIsValid);
}

//::///////////////////////////////////////////////
//:: _SetProjectImageAI
//:://////////////////////////////////////////////
/*
    Updates the project image object to use AI
    scripts as defined by PROJECT_IMAGE_AI_
    constants.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
void _SetProjectImageAI(object oImage)
{
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, PROJECT_IMAGE_AI_ON_BLOCKED);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, PROJECT_IMAGE_AI_ON_COMBAT_ROUND_END);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, PROJECT_IMAGE_AI_ON_CONVERSATION);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DAMAGED, PROJECT_IMAGE_AI_ON_DAMAGED);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DEATH, PROJECT_IMAGE_AI_ON_DEATH);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_DISTURBED, PROJECT_IMAGE_AI_ON_DISTURBED);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, PROJECT_IMAGE_AI_ON_HEARTBEAT);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_NOTICE, PROJECT_IMAGE_AI_ON_PERCEPTION);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, PROJECT_IMAGE_AI_ON_PHYSICAL_ATTACKED);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_RESTED, PROJECT_IMAGE_AI_ON_RESTED);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, PROJECT_IMAGE_AI_ON_SPELL_CAST_AT);
    SetEventScript(oImage, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, PROJECT_IMAGE_AI_ON_USER_DEFINED);
    ExecuteScript(PROJECT_IMAGE_AI_ON_SPAWN, oImage);
}

//::///////////////////////////////////////////////
//:: _SetProjectImageDespawnTimer
//:://////////////////////////////////////////////
/*
    Sets the spawn timer for the projected image
    so that it will despawn when the timer
    expires.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////
void _SetProjectImageDespawnTimer(object oImage, int nTime)
{
    SetLocalInt(oImage, "Despawn_Time", GetModuleTime() + nTime);
}

//::///////////////////////////////////////////////
//:: _SetStaticVFXPartner
//:://////////////////////////////////////////////
/*
    Stores a reference to the coupled AoE on
    the static VFX.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _SetStaticVFXPartner(object oVFX, object oPartner)
{
    SetLocalObject(oVFX, LIB_SPELLS_PREFIX + "VFXPartner", oPartner);
}

//::///////////////////////////////////////////////
//:: _Spells_GetCasterLevel
//:://////////////////////////////////////////////
/*
    Wrapper for AR_GetCasterLevel. Included
    in the spells library to avoid dependency
    issues.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
int _Spells_GetCasterLevel(object oCreature)
{
    return ExecuteScriptAndReturnInt("exe_casterlevel", oCreature);
}

//::///////////////////////////////////////////////
//:: _UpdateAoEDataAtLocation
//:://////////////////////////////////////////////
/*
    Sets the Id for the nonstacking AoE
    within 0.1m of the location.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
void _UpdateAoEDataAtLocation(location lLocation, int nId, object oStaticVFX, int nCasterLevel, int nCasterClass, float fDuration, int nMetaMagic)
{
    object oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation);
    object oStaticVFX = GetNearestObjectByTag("StaticVFX" + IntToString(nId));

    if(GetDistanceBetweenLocations(lLocation, GetLocation(oAoE)) > 0.1)
        return;

    SetAoEId(oAoE, nId);
    SetAoECasterLevel(oAoE, nCasterLevel);
    SetAoECastClass(oAoE, nCasterClass);
    SetAoEMetaMagic(oAoE, nMetaMagic);
    ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oAoE, fDuration, EFFECT_TAG_DURATION_MARKER);
    if(oStaticVFX != OBJECT_INVALID)
    {
        _LinkAoEToStaticVFX(oAoE, oStaticVFX);
    }
}

//::///////////////////////////////////////////////
//:: _getIsSpellBookClass
//:://////////////////////////////////////////////
/*
    Returns TRUE if nClass has a Spellbook.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: July 8, 2017
//:://////////////////////////////////////////////
int _getIsSpellBookClass(int nClass)  {
    return nClass == CLASS_TYPE_SORCERER ||
           nClass == CLASS_TYPE_WIZARD ||
           nClass == CLASS_TYPE_CLERIC ||
           nClass == CLASS_TYPE_BARD ||
           nClass == CLASS_TYPE_PALADIN ||
           nClass == CLASS_TYPE_DRUID;
}

// 
// Returns a random arcane SPELL_ id for the specified level.
//
int GetRandomArcaneSpell(int nSpellLevel)
{
  int nRandom;
  switch (nSpellLevel)
  {
    case 0:
	{
	  nRandom = Random(7);
	  switch (nRandom)
	  {
	    case 0: return SPELL_ACID_SPLASH;
		case 1: return SPELL_DAZE;
		case 2: return SPELL_ELECTRIC_JOLT;
		case 3: return SPELL_FLARE;
		case 4: return SPELL_LIGHT;
		case 5: return SPELL_RAY_OF_FROST;
		case 6: return SPELL_RESISTANCE;
	  }
	}
	case 1:
	{
	  nRandom = Random(23);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BURNING_HANDS;
		case 1: return SPELL_CHARM_PERSON;
		case 2: return SPELL_COLOR_SPRAY;
		case 3: return SPELL_ENDURE_ELEMENTS;
		case 4: return SPELL_EXPEDITIOUS_RETREAT;
		case 5: return SPELL_GREASE;
		case 6: return SPELL_HORIZIKAULS_BOOM;
		case 7: return SPELL_ICE_DAGGER;
		case 8: return SPELL_IDENTIFY;
		case 9: return SPELL_IRONGUTS;
		case 10: return SPELL_MAGE_ARMOR;
		case 11: return SPELL_MAGIC_MISSILE;
		case 12: return SPELL_MAGIC_WEAPON;
		case 13: return SPELL_NEGATIVE_ENERGY_RAY;
		case 14: return SPELL_PROTECTION_FROM_GOOD;
		case 15: return SPELL_PROTECTION_FROM_EVIL;
		case 16: return SPELL_RAY_OF_ENFEEBLEMENT;
		case 17: return SPELL_SCARE;
		case 18: return SPELL_SHELGARNS_PERSISTENT_BLADE;
		case 19: return SPELL_SHIELD;
		case 20: return SPELL_SLEEP;
		case 21: return SPELL_SUMMON_CREATURE_I;
		case 22: return SPELL_TRUE_STRIKE;
	  }
	}
	case 2:
	{
	  nRandom = Random(28);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BALAGARNSIRONHORN;
		case 1: return SPELL_BLINDNESS_AND_DEAFNESS;
		case 2: return SPELL_BULLS_STRENGTH;
		case 3: return SPELL_CATS_GRACE;
		case 4: return SPELL_CLOUD_OF_BEWILDERMENT;
		case 5: return SPELL_COMBUST;
		case 6: return SPELL_CONTINUAL_FLAME;
		case 7: return SPELL_DARKNESS;
		case 8: return SPELL_DEATH_ARMOR;
		case 9: return SPELL_EAGLE_SPLEDOR;
		case 10: return SPELL_ENDURANCE;
		case 11: return SPELL_FLAME_WEAPON;
		case 12: return SPELL_FOXS_CUNNING;
		case 13: return SPELL_GEDLEES_ELECTRIC_LOOP;
		case 14: return SPELL_GHOSTLY_VISAGE;
		case 15: return SPELL_GHOUL_TOUCH;
		case 16: return SPELL_INVISIBILITY;
		case 17: return SPELL_KNOCK;
		case 18: return SPELL_LESSER_DISPEL;
		case 19: return SPELL_MELFS_ACID_ARROW;
		case 20: return SPELL_OWLS_WISDOM;
		case 21: return SPELL_RESIST_ELEMENTS;
		case 22: return SPELL_SEE_INVISIBILITY;
		case 23: return SPELL_STONE_BONES;
		case 24: return SPELL_SUMMON_CREATURE_II;
		case 25: return SPELL_TASHAS_HIDEOUS_LAUGHTER;
		case 26: return SPELL_DARKVISION;
		case 27: return SPELL_WEB;
	  }
	}
	case 3:
	{
	  nRandom = Random(24);
	  switch (nRandom)
	  {
	    case 0: return SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
		case 1: return SPELL_CLARITY;
		case 2: return SPELL_DISPEL_MAGIC;
		case 3: return SPELL_DISPLACEMENT;
		case 4: return SPELL_FIND_TRAPS;
		case 5: return SPELL_FIREBALL;
		case 6: return SPELL_FLAME_ARROW;
		case 7: return SPELL_GREATER_MAGIC_WEAPON;
		case 8: return SPELL_GUST_OF_WIND;
		case 9: return SPELL_HASTE;
		case 10: return SPELL_HOLD_PERSON;
		case 11: return SPELL_INVISIBILITY_SPHERE;
		case 12: return SPELL_KEEN_EDGE;
		case 13: return SPELL_LIGHTNING_BOLT;
		case 14: return SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
		case 15: return SPELL_MAGIC_CIRCLE_AGAINST_GOOD;
		case 16: return SPELL_MESTILS_ACID_BREATH;
		case 17: return SPELL_NEGATIVE_ENERGY_BURST;
		case 18: return SPELL_PROTECTION_FROM_ELEMENTS;
		case 19: return SPELL_SCINTILLATING_SPHERE;
		case 20: return SPELL_SLOW;
		case 21: return SPELL_STINKING_CLOUD;
		case 22: return SPELL_SUMMON_CREATURE_III;
		case 23: return SPELL_VAMPIRIC_TOUCH;
	  }
	}
	case 4:
	{
	  nRandom = Random(21);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BESTOW_CURSE;
		case 1: return SPELL_CHARM_MONSTER;
		case 2: return SPELL_CONFUSION;
		case 3: return SPELL_CONTAGION;
		case 4: return SPELL_ELEMENTAL_SHIELD;
		case 5: return SPELL_ENERVATION;
		case 6: return SPELL_EVARDS_BLACK_TENTACLES;
		case 7: return SPELL_FEAR;
		case 8: return SPELL_ICE_STORM;
		case 9: return SPELL_IMPROVED_INVISIBILITY;
		case 10: return SPELL_ISAACS_LESSER_MISSILE_STORM;
		case 11: return SPELL_LESSER_SPELL_BREACH;
		case 12: return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
		case 13: return SPELL_PHANTASMAL_KILLER;
		case 14: return SPELL_POLYMORPH_SELF;
		case 15: return SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
		case 16: return SPELL_REMOVE_CURSE;
		case 17: return SPELL_SHADOW_CONJURATION_SUMMON_SHADOW;
		case 18: return SPELL_STONESKIN;
		case 19: return SPELL_SUMMON_CREATURE_IV;
		case 20: return SPELL_WALL_OF_FIRE;
	  }	
	}
	case 5:
	{
	  nRandom = Random(18);
	  switch (nRandom)
	  {
	    case 0: return SPELL_ANIMATE_DEAD;
		case 1: return SPELL_BALL_LIGHTNING;
		case 2: return SPELL_BIGBYS_INTERPOSING_HAND;
		case 3: return SPELL_CLOUDKILL;
		case 4: return SPELL_CONE_OF_COLD;
		case 5: return SPELL_DISMISSAL;
		case 6: return SPELL_DOMINATE_PERSON;
		case 7: return SPELL_ENERGY_BUFFER;
		case 8: return SPELL_FEEBLEMIND;
		case 9: return SPELL_FIREBRAND;
		case 10: return SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW;
		case 11: return SPELL_HOLD_MONSTER;
		case 12: return SPELL_LESSER_MIND_BLANK;
		case 13: return SPELL_LESSER_PLANAR_BINDING;
		case 14: return SPELL_LESSER_SPELL_MANTLE;
		case 15: return SPELL_MESTILS_ACID_SHEATH;
		case 16: return SPELL_MIND_FOG;
		case 17: return SPELL_SUMMON_CREATURE_V;
	  }		  
	}
	case 6:
	{
	  nRandom = Random(20);
	  switch (nRandom)
	  {
	    case 0: return SPELL_ACID_FOG;
		case 1: return SPELL_BIGBYS_FORCEFUL_HAND;
		case 2: return SPELL_CHAIN_LIGHTNING;
		case 3: return SPELL_CIRCLE_OF_DEATH;
		case 4: return SPELL_ETHEREAL_VISAGE;
		case 5: return SPELL_FLESH_TO_STONE;
		case 6: return SPELL_GLOBE_OF_INVULNERABILITY;
		case 7: return SPELL_GREATER_DISPELLING;
		case 8: return SPELL_GREATER_SPELL_BREACH;
		case 9: return SPELL_GREATER_STONESKIN;
		case 10: return SPELL_ISAACS_GREATER_MISSILE_STORM;
		case 11: return SPELL_LEGEND_LORE;
		case 12: return SPELL_MASS_HASTE;
		case 13: return SPELL_PLANAR_BINDING;
		case 14: return SPELL_SHADES_SUMMON_SHADOW;
		case 15: return SPELL_STONE_TO_FLESH;
		case 16: return SPELL_SUMMON_CREATURE_VI;
		case 17: return SPELL_TENSERS_TRANSFORMATION;
		case 18: return SPELL_TRUE_SEEING;
		case 19: return SPELL_UNDEATH_TO_DEATH;
	  }		
	}
    case 7:
    {
	  nRandom = Random(13);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BANISHMENT;
		case 1: return SPELL_BIGBYS_GRASPING_HAND;
		case 2: return SPELL_CONTROL_UNDEAD;
		case 3: return SPELL_DELAYED_BLAST_FIREBALL;
		case 4: return SPELL_FINGER_OF_DEATH;
		case 5: return SPELL_GREAT_THUNDERCLAP;
		case 6: return SPELL_MORDENKAINENS_SWORD;
		case 7: return SPELL_POWER_WORD_STUN;
		case 8: return SPELL_PRISMATIC_SPRAY;
		case 9: return SPELL_PROTECTION_FROM_SPELLS;
		case 10: return SPELL_SHADOW_SHIELD;
		case 11: return SPELL_SPELL_MANTLE;
		case 12: return SPELL_SUMMON_CREATURE_VII;
	  }	
    }	
	case 8:
    {
	  nRandom = Random(13);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BIGBYS_CLENCHED_FIST;
		case 1: return SPELL_BLACKSTAFF;
		case 2: return SPELL_CREATE_UNDEAD;
		case 3: return SPELL_GREATER_PLANAR_BINDING;
		case 4: return SPELL_ETHEREALNESS;
		case 5: return SPELL_HORRID_WILTING;
		case 6: return SPELL_INCENDIARY_CLOUD;
		case 7: return SPELL_MASS_BLINDNESS_AND_DEAFNESS;
		case 8: return SPELL_MASS_CHARM;
		case 9: return SPELL_MIND_BLANK;
		case 10: return SPELL_PREMONITION;
		case 11: return SPELL_SUMMON_CREATURE_VIII;
		case 12: return SPELL_SUNBURST;
	  }	
    }
	case 9:
    {
	  nRandom = Random(14);
	  switch (nRandom)
	  {
	    case 0: return SPELL_BIGBYS_CRUSHING_HAND;
		case 1: return SPELL_BLACK_BLADE_OF_DISASTER;
		case 2: return SPELL_DOMINATE_MONSTER;
		case 3: return SPELL_ENERGY_DRAIN;
		case 4: return SPELL_GATE;
		case 5: return SPELL_GREATER_SPELL_MANTLE;
		case 6: return SPELL_METEOR_SWARM;
		case 7: return SPELL_MORDENKAINENS_DISJUNCTION;
		case 8: return SPELL_POWER_WORD_KILL;
		case 9: return SPELL_SHAPECHANGE;
		case 10: return SPELL_SUMMON_CREATURE_IX;
		case 11: return SPELL_TIME_STOP;
		case 12: return SPELL_WEIRD;
	  }	
    }
  }
  
  return 0;
}
//------------------------------------------------------------------------------
int _GetOpposingSchool(int nSpellSchool)
{
  int nSchool = SPELL_SCHOOL_GENERAL;
  
  switch (nSpellSchool)
  {
    case SPELL_SCHOOL_CONJURATION:
	  return SPELL_SCHOOL_NECROMANCY;
	case SPELL_SCHOOL_NECROMANCY:
	  return SPELL_SCHOOL_CONJURATION;
	case SPELL_SCHOOL_ILLUSION:
	  return SPELL_SCHOOL_ENCHANTMENT;
	case SPELL_SCHOOL_ENCHANTMENT:
	  return SPELL_SCHOOL_ILLUSION;
	case SPELL_SCHOOL_EVOCATION:
	  return SPELL_SCHOOL_TRANSMUTATION;
	case SPELL_SCHOOL_TRANSMUTATION:
	  return SPELL_SCHOOL_EVOCATION;
  }
  
  // Note - in this setup, Abjuration and Divination have no opposed schools.
  return nSchool;  
}
//------------------------------------------------------------------------------
int _GetRelativeAttunement(object oCaster, int nSpellSchool)
{
  switch (nSpellSchool)
  {
	case SPELL_SCHOOL_CONJURATION:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_LIFE);
	case SPELL_SCHOOL_ENCHANTMENT:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_EARTH);
	case SPELL_SCHOOL_EVOCATION:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_FIRE);
	case SPELL_SCHOOL_ILLUSION:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_AIR);
	case SPELL_SCHOOL_NECROMANCY:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_DEATH);
	case SPELL_SCHOOL_TRANSMUTATION:
	  return miDVGetRelativeAttunement(oCaster, ELEMENT_WATER);
  }

  // Other schools are unaligned. 
  return 0;
}
//------------------------------------------------------------------------------
int AR_GetCasterLevelBonus(object oCaster=OBJECT_SELF, int nSpellId = -1)
{
  if (nSpellId == -1) nSpellId = GetSpellId();
  int nBonus = 0;
  object oHide = gsPCGetCreatureHide(oCaster);
  
  //-------------------------------------------------------------
  // Anemoi edit - add 1/10 Piety for clerics, Favoured Souls and 
  // paladins, pacts for others.  Mummy Dust needs some special 
  // handling as it's not cast naturally (ditto PM abilities).
  //-------------------------------------------------------------  
  int nPietyBonus = 0;
  int bDivine = (GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) + GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oCaster) + GetLevelByClass(CLASS_TYPE_PALADIN, oCaster)) >
    (GetLevelByClass(CLASS_TYPE_SORCERER, oCaster) + GetLevelByClass(CLASS_TYPE_WIZARD, oCaster));
	  
  int bSpecialNecro = (nSpellId == 637 || nSpellId == 623 || nSpellId == 624 || nSpellId == 627); // Mummy Dust, PM animate dead spells	
  if (GetLastSpellCastClass() == CLASS_TYPE_PALADIN || GetLastSpellCastClass() == CLASS_TYPE_FAVOURED_SOUL || GetLastSpellCastClass() == CLASS_TYPE_CLERIC || (bSpecialNecro && bDivine))
  {
    // Note - cannot include inc_state from here due to circular dependencies.
    return FloatToInt(GetLocalFloat(oHide, "GS_ST_PIETY")) / 10;
  }
  
  //-------------------------------------------------------------
  // Check for attunement (formed via a pact with a spirit). 
  //-------------------------------------------------------------
  int nAttunement = 0;
  int nStrength = 0;
  if (GetIsObjectValid(oHide)) 
  {
    nAttunement = GetLocalInt(oHide, "ATTUNEMENT");
	nStrength = GetLocalInt(oHide, "ATTUNEMENT_STRENGTH");
  }
  else
  {
    nAttunement = GetLocalInt(oCaster, "ATTUNEMENT");
	nStrength = GetLocalInt(oCaster, "ATTUNEMENT_STRENGTH");
  }
  
  if (!nAttunement)
  {
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oCaster);
	int nAssassin = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
	
	if (nMonk > nAssassin)
	{
	  nAttunement = SPELL_SCHOOL_ENCHANTMENT;
	  nStrength   = nMonk;
	}
	else
	{
	  nAttunement = SPELL_SCHOOL_ILLUSION;
	  nStrength   = nAssassin;
	}
  }
  
  // Check whether to continue.  
  if (!nAttunement || !nStrength) return nBonus;
  
  int nSchool = GetSpellSchool(nSpellId);
  
  //---------------------------------------------------------------
  // Boost the strength of the attunement if the PC does things
  // aligned with their patron.  Cap this bonus at spirit strength.
  //---------------------------------------------------------------
  int nMyAttunement = _GetRelativeAttunement(oCaster, nAttunement);
  if (nMyAttunement > nStrength) nMyAttunement = nStrength;
  nStrength += nMyAttunement;
  
  //---------------------------------------------------------------
  // Apply the bonus based on how closely the school of the spell
  // used matches our attunement.  If opposed it becomes a 
  // penalty!
  //---------------------------------------------------------------
  if (nSchool == nAttunement)
  {
    nBonus = nStrength;
  }
  else if (nSchool == _GetOpposingSchool(nAttunement))
  {
    nBonus = -1 * nStrength;
  }
  else
  {
    nBonus = nStrength / 2;
  }

  return nBonus;
}
//------------------------------------------------------------------------------
void AR_SetCasterLevelBonus(int nBonus, object oCaster=OBJECT_SELF)
{
  // No longer used.
  SetLocalInt(gsPCGetCreatureHide(oCaster), "AR_BONUS_CASTER_LEVELS", nBonus);
}
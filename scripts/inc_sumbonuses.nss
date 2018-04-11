//::///////////////////////////////////////////////
//:: Summon Bonuses Library
//::    inc_bonuses
//:://////////////////////////////////////////////
/*
    Contains functions for the application of
    Arelitic-centric associate bonuses.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////

#include "inc_behaviors"
#include "inc_generic"
#include "inc_item"
#include "inc_spells"
#include "inc_sumstream"
#include "inc_totem"
#include "inc_warlock"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Summon buff type constants, used to determine which spell focus feat
// should provide buffs to a summon.
const int SUMMON_BUFF_TYPE_NONE = 0;
const int SUMMON_BUFF_TYPE_CONJURATION = 1;
const int SUMMON_BUFF_TYPE_EVOCATION = 2;
const int SUMMON_BUFF_TYPE_ILLUSION = 3;
const int SUMMON_BUFF_TYPE_NECROMANCY = 4;
const int SUMMON_BUFF_TYPE_TRANSMUTATION = 5;

// Constants for use with override epic summon scaling, allowing a spell that
// would not ordinarily grant epic scaling to receive it.
const int EPIC_SUMMON_SCALING_OVERRIDE_NONE = 0;
const int EPIC_SUMMON_SCALING_OVERRIDE_ENABLE = 1;

// Prefix to separate summon bonus variables from other libraries.
const string LIB_SUMMON_BONUSES_PREFIX = "Lib_Summon_Bonuses_";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies all Arelith-specific buffs to creatures summoned by the PC.
void ApplyAssociateBuffs(object oPC = OBJECT_SELF);
// Applies animal companion buffs to the creature, maximizing hit points, skill ranks,
// and granting additional AB/AC/damage.
void ApplyAnimalCompanionBuffs(object oCreature);
// Applies scaling epic summon buffs to the creature, granting additional progression
// similar to that if they had gained epic levels.
void ApplyEpicSummonBuffs(object oCreature);
// Applies spell focus buffs to the summons (e.g. buffs to conjured creatures for
// conjurers, undead creatures for necromancers), granting bonuses similar to that if they
// had gained one level per focus.
void ApplySpellFocusSummonBuffs(object oCreature);
// Returns the current epic summon scaling override value, which determines whether the next
// spell's usual behavior with respect to adding epic scaling will be respected.
//
// Constants:
//   * EPIC_SUMMON_SCALING_OVERRIDE_NONE
//   * EPIC_SUMMON_SCALING_OVERRIDE_ENABLE
int GetEpicSummonScalingOverride(object oCreature);
// Returns TRUE if the spell is meant to gain epic scaling bonuses for the caster.
int GetIsScalingSummonSpell(int nSpellId, object oCaster);
// Returns the caster level that will be used for determining epic summon scaling
// by the caster for the last spell cast.
int GetScalingSummonSpellEpicCasterLevel(object oCaster);
// Returns the "summon buff level" of a caster for focus bonsues (i.e. 1 for focus,
// 2 for greater focus, 3 for epic focus).
int GetSummonBuffLevel(int nSpellId, object oCaster);
// Returns the type of summon buff needed for a summon of the chosen spell ID to
// gain bonuses (e.g. SUMMON_BUFF_TYPE_CONJURATION for summon creature spells).
int GetSummonBuffType(int nSpellId, object oCaster);
// Sets the current epic summon scaling override value, which determines whether the next
// spell's usual behavior with respect to adding epic scaling will be respected.
//
// Constants:
//   * EPIC_SUMMON_SCALING_OVERRIDE_NONE
//   * EPIC_SUMMON_SCALING_OVERRIDE_ENABLE
void SetEpicSummonScalingOverride(object oCreature, int nOverride = EPIC_SUMMON_SCALING_OVERRIDE_ENABLE);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Internal function used to apply associate buffs following a delay, bypassing timing
   issues. */
void _ApplyAssociateBuffs(object oPC);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyAssociateBuffs
//:://////////////////////////////////////////////
/*
    Applies all Arelith-specific buffs to
    creatures summoned by the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void ApplyAssociateBuffs(object oAssociate)
{
    DelayCommand(0.0, _ApplyAssociateBuffs(oAssociate));
}

//::///////////////////////////////////////////////
//:: ApplyAnimalCompanionBuffs
//:://////////////////////////////////////////////
/*
    Applies animal companion buffs to the
    creature, maximizing hit points, skill ranks,
    and granting additional AB/AC/damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void ApplyAnimalCompanionBuffs(object oCreature)
{
    int nHitDice;

    if(GetAssociateType(oCreature) != ASSOCIATE_TYPE_ANIMALCOMPANION)
        return;

    nHitDice = GetHitDice(oCreature);

    MaximizeHitPoints(oCreature);
    MaximizeKnownSkillRanks(oCreature);
    NWNX_Creature_SetSkillRank(oCreature, SKILL_DISCIPLINE, nHitDice + 3);
    if(nHitDice >= 21) AddKnownFeat(oCreature, FEAT_EPIC_SKILL_FOCUS_DISCIPLINE);

    if(GetHasFeat(FEAT_WEAPON_FINESSE, oCreature))
    {
        ModifyAbilityScore(oCreature, ABILITY_DEXTERITY, nHitDice / 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(DamageBonusConstant(nHitDice / 6))), oCreature);
    }
    else
    {
        ModifyAbilityScore(oCreature, ABILITY_STRENGTH, nHitDice / 3);
        NWNX_Creature_SetBaseAC(oCreature, GetACNaturalBase(oCreature) + nHitDice / 6);
    }
}

//::///////////////////////////////////////////////
//:: ApplyEpicSummonBuffs
//:://////////////////////////////////////////////
/*
    Applies scaling epic summon buffs to the
    creature, granting additional progression
    similar to that if they had gained epic
    levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void ApplyEpicSummonBuffs(object oCreature)
{
    effect eBuff;
    int nAbility;
    int nEpicCasterLevel;
    object oMaster = GetMaster(oCreature);

    if(GetAssociateType(oCreature) != ASSOCIATE_TYPE_SUMMONED || !GetIsObjectValid(oMaster))
        return;

    nEpicCasterLevel = GetScalingSummonSpellEpicCasterLevel(oMaster);

    if(nEpicCasterLevel <= 0) return;

    nAbility = GetAbilityScore(oCreature, ABILITY_STRENGTH, TRUE) >
        GetAbilityScore(oCreature, ABILITY_DEXTERITY, TRUE) ? ABILITY_STRENGTH : ABILITY_DEXTERITY;

    eBuff = EffectAttackIncrease((nEpicCasterLevel + 1) / 2);
    eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEpicCasterLevel / 2));
    eBuff = SupernaturalEffect(eBuff);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oCreature);
    ModifyAbilityScore(oCreature, nAbility, (nEpicCasterLevel + 1) / 2);
    IncreaseKnownSkillRanks(oCreature, nEpicCasterLevel);
    IncreaseMaximumHitPoints(oCreature, GetClassHitDie(GetPrimaryClass(oCreature)) * nEpicCasterLevel + GetBaseAbilityModifier(oCreature, ABILITY_CONSTITUTION) * nEpicCasterLevel);
    NWNX_Creature_SetBaseAC(oCreature, GetACNaturalBase(oCreature) + nEpicCasterLevel / 2);
    SetBonusHitDice(oCreature, nEpicCasterLevel);
    SetTemporaryCasterLevelBonus(oCreature, nEpicCasterLevel);
}

//::///////////////////////////////////////////////
//:: ApplySpellFocusSummonBuffs
//:://////////////////////////////////////////////
/*
    Applies spell focus buffs to the summons
    (e.g. buffs to conjured creatures for
    conjurers, undead creatures for necromancers),
    granting bonuses similar to that if they
    had gained one level per focus.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void ApplySpellFocusSummonBuffs(object oCreature)
{
    effect eBuff;
    int nAmount;
    object oMaster = GetMaster(oCreature);

    if(GetAssociateType(oCreature) != ASSOCIATE_TYPE_SUMMONED || !GetIsObjectValid(oMaster)) return;

    nAmount = GetSummonBuffLevel(GetCreatureLastSpellId(oMaster), oMaster);

    if(nAmount <= 0) return;

    eBuff = EffectAttackIncrease(nAmount);
    eBuff = EffectLinkEffects(eBuff, EffectDamageIncrease(DamageBonusConstant(nAmount), DAMAGE_TYPE_BLUDGEONING));
    eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAmount));
    eBuff = SupernaturalEffect(eBuff);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oCreature);
    IncreaseKnownSkillRanks(oCreature, nAmount);
    IncreaseMaximumHitPoints(oCreature, GetClassHitDie(GetPrimaryClass(oCreature)) * nAmount + GetBaseAbilityModifier(oCreature, ABILITY_CONSTITUTION) * nAmount);
    NWNX_Creature_SetBaseAC(oCreature, GetACNaturalBase(oCreature) + nAmount);
}

//::///////////////////////////////////////////////
//:: GetEpicSummonScalingOverride
//:://////////////////////////////////////////////
/*
    Returns the current epic summon scaling override
    value, which determines whether the next
    spell's usual behavior with respect to
    adding epic scaling will be respected.

    Constants:
      * EPIC_SUMMON_SCALING_OVERRIDE_NONE
      * EPIC_SUMMON_SCALING_OVERRIDE_ENABLE
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////
int GetEpicSummonScalingOverride(object oCreature)
{
    return GetLocalInt(oCreature, LIB_SUMMON_BONUSES_PREFIX + "EpicSummonScalingOverride");
}

//::///////////////////////////////////////////////
//:: GetIsScalingSummonSpell
//:://////////////////////////////////////////////
/*
    Returns TRUE if the spell is meant to
    gain epic scaling bonuses for the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetIsScalingSummonSpell(int nSpellId, object oCaster)
{
    return nSpellId == SPELL_BLACK_BLADE_OF_DISASTER
        || nSpellId == SPELL_ELEMENTAL_SWARM
        || nSpellId == SPELL_EPIC_DRAGON_KNIGHT
        || nSpellId == SPELL_GATE
        || (nSpellId == SPELL_SUMMON_CREATURE_VI
            && GetCreatureLastSpellCastClass(oCaster) == CLASS_TYPE_BARD && !GetIsCreatureLastSpellCastItemValid(oCaster) && miWAGetIsWarlock(oCaster))
        || nSpellId == SPELL_SUMMON_CREATURE_IX
        || nSpellId == 609  // BG Create Undead
        || nSpellId == 610; // BG Summon Fiend
}

//::///////////////////////////////////////////////
//:: GetScalingSummonSpellEpicCasterLevel
//:://////////////////////////////////////////////
/*
    Returns the caster level that will be
    used for determining epic summon scaling
    by the caster for the last spell cast.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetScalingSummonSpellEpicCasterLevel(object oCaster)
{
    int nOverride = GetEpicSummonScalingOverride(oCaster);

    SetEpicSummonScalingOverride(oCaster, EPIC_SUMMON_SCALING_OVERRIDE_NONE);

    if(!GetIsScalingSummonSpell(GetCreatureLastSpellId(oCaster), oCaster) && nOverride != EPIC_SUMMON_SCALING_OVERRIDE_ENABLE) return 0;

    switch(GetCreatureLastSpellId(oCaster))
    {
        case SPELL_EPIC_DRAGON_KNIGHT:
            if(GetActiveSummonStream(oCaster, STREAM_TYPE_DRAGON) == STREAM_DRAGON_UNDEAD)
                return GetCreatureLastSpellCasterLevel(oCaster) + GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) - (GetLevelByClass(CLASS_TYPE_PALEMASTER, oCaster) / 2) - 20;
            break;
        case 609: // BG Create Undead
        case 610: // BG Summon Fiend
            return GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster) - 10;
    }
    return GetCreatureLastSpellCasterLevel(oCaster) - 20;
}

//::///////////////////////////////////////////////
//:: GetSummonBuffLevel
//:://////////////////////////////////////////////
/*
    Returns the "summon buff level" of a caster
    for focus bonsues (i.e. 1 for focus,
    2 for greater focus, 3 for epic focus).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetSummonBuffLevel(int nSpellId, object oCaster)
{
    switch(GetSummonBuffType(nSpellId, oCaster))
    {
        case SUMMON_BUFF_TYPE_CONJURATION:
            return GetSpellFocusLevel(oCaster, SPELL_SCHOOL_CONJURATION);
        case SUMMON_BUFF_TYPE_EVOCATION:
            return GetSpellFocusLevel(oCaster, SPELL_SCHOOL_EVOCATION);
        case SUMMON_BUFF_TYPE_ILLUSION:
            return GetSpellFocusLevel(oCaster, SPELL_SCHOOL_ILLUSION);
        case SUMMON_BUFF_TYPE_NECROMANCY:
            return GetSpellFocusLevel(oCaster, SPELL_SCHOOL_NECROMANCY);
        case SUMMON_BUFF_TYPE_TRANSMUTATION:
            return GetSpellFocusLevel(oCaster, SPELL_SCHOOL_TRANSMUTATION);
    }
    return 0;
}

//::///////////////////////////////////////////////
//:: GetSummonBuffType
//:://////////////////////////////////////////////
/*
    Returns the type of summon buff needed
    for a summon of the chosen spell ID to
    gain bonuses (e.g. SUMMON_BUFF_TYPE_CONJURATION
    for summon creature spells).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int GetSummonBuffType(int nSpellId, object oCaster)
{
    switch(nSpellId)
    {
        case SPELL_BLACK_BLADE_OF_DISASTER:
        case SPELL_GATE:
        case SPELL_GREATER_PLANAR_BINDING:
        case SPELL_LESSER_PLANAR_BINDING:
        case SPELL_PLANAR_ALLY:
        case SPELL_PLANAR_BINDING:
        case 610: // BG Fiendish Servant
            return SUMMON_BUFF_TYPE_CONJURATION;
        case SPELL_SUMMON_CREATURE_I:
        case SPELL_SUMMON_CREATURE_II:
        case SPELL_SUMMON_CREATURE_III:
        case SPELL_SUMMON_CREATURE_IV:
        case SPELL_SUMMON_CREATURE_V:
        case SPELL_SUMMON_CREATURE_VI:
            return (GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster)
                || (GetCreatureLastSpellCastClass(oCaster) == CLASS_TYPE_BARD && !GetIsCreatureLastSpellCastItemValid(oCaster) && miWAGetIsWarlock(oCaster)))
                    ? SUMMON_BUFF_TYPE_CONJURATION : SUMMON_BUFF_TYPE_NONE;
        case SPELL_SUMMON_CREATURE_VII:
        case SPELL_SUMMON_CREATURE_VIII:
        case SPELL_SUMMON_CREATURE_IX:
        case SPELL_ELEMENTAL_SWARM:
            return GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster) ? SUMMON_BUFF_TYPE_CONJURATION : SUMMON_BUFF_TYPE_NONE;
        case SPELL_SHELGARNS_PERSISTENT_BLADE:
            return SUMMON_BUFF_TYPE_EVOCATION;
        case 344: // Shadow Conjuration Shadow
        case 349: // Greater Shadow Conjuration Shadow
        case 324: // Shades Shadow
            return SUMMON_BUFF_TYPE_ILLUSION;
        case SPELL_ANIMATE_DEAD:
        case SPELL_CREATE_UNDEAD:
        case SPELL_CREATE_GREATER_UNDEAD:
        case SPELL_EPIC_MUMMY_DUST:
        case 609: // BG Create Dead
        case 623: // PM Animate Dead
        case 624: // PM Summon Undead
        case 627: // PM Summon Greater Undead
            return SUMMON_BUFF_TYPE_NECROMANCY;
        case SPELL_MORDENKAINENS_SWORD:
            return SUMMON_BUFF_TYPE_TRANSMUTATION;
        case SPELL_EPIC_DRAGON_KNIGHT:
            return (GetActiveSummonStream(oCaster, STREAM_TYPE_DRAGON) == STREAM_DRAGON_UNDEAD) ? SUMMON_BUFF_TYPE_NECROMANCY : SUMMON_BUFF_TYPE_CONJURATION;
    }
    return SUMMON_BUFF_TYPE_NONE;
}

//::///////////////////////////////////////////////
//:: SetEpicSummonScalingOverride
//:://////////////////////////////////////////////
/*
    Sets the current epic summon scaling override
    value, which determines whether the next
    spell's usual behavior with respect to
    adding epic scaling will be respected.

    Constants:
      * EPIC_SUMMON_SCALING_OVERRIDE_NONE
      * EPIC_SUMMON_SCALING_OVERRIDE_ENABLE
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////
void SetEpicSummonScalingOverride(object oCreature, int nOverride = EPIC_SUMMON_SCALING_OVERRIDE_ENABLE)
{
    if(!nOverride)
        DeleteLocalInt(oCreature, LIB_SUMMON_BONUSES_PREFIX + "EpicSummonScalingOverride");
    else
        SetLocalInt(oCreature, LIB_SUMMON_BONUSES_PREFIX + "EpicSummonScalingOverride", nOverride);
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _ApplyAssociateBuffs
//:://////////////////////////////////////////////
/*
    Internal function used to apply associate
    buffs following a delay, bypassing timing
    issues.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
void _ApplyAssociateBuffs(object oAssociate)
{
    SignalEvent(oAssociate, EventUserDefined(GS_EV_ON_SPAWN));
    ApplyAnimalCompanionBuffs(oAssociate);
    ApplyEpicSummonBuffs(oAssociate);
    ApplySpellFocusSummonBuffs(oAssociate);
    ApplyTotemPropertiesToSummon(oAssociate);
    ApplyTotemPropertiesToAnimalCompanion(oAssociate);
}

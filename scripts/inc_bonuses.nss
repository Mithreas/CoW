//::///////////////////////////////////////////////
//:: inc_bonuses
//:: Library: Bonuses
//:://////////////////////////////////////////////
/*
    Centralized library for applying unique
    bonuses pertaining to class, race, path, etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////

#include "inc_language"
#include "inc_pc"
#include "inc_subrace"
#include "inc_effect"
#include "inc_item"
#include "inc_levelbonuses"
#include "inc_spells"
#include "inc_sumstream"
#include "inc_timelock"
#include "inc_backgrounds"
#include "inc_class"
#include "inc_favsoul"
#include "inc_customspells"
#include "inc_totem"
#include "inc_warlock"
#include "nw_i0_spells"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x0_i0_match"
#include "inc_spellsword"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Message sent to a PC when he is unpolymorphed so that character updates can be applied.
// Occurs when deleveling.
const string MESSAGE_POLYMORPH_REMOVED = "You have been depolymorphed so that your character could be updated.";

// Message sent to a PC when a two-handed weapon is equipped (and bonuses applied).
const string MESSAGE_TWO_HANDED_WEAPON_BONUS = "Two-Handed Weapon Bonus Granted: +2 Attack Bonus";

// 'Indefinite' duration for temp properties that are meant never to expire.
const float DURATION_INDEFINITE = 72000.0f; // 30 hours

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate bonuses variables from other libraries.
const string LIB_BONUSES_PREFIX = "Lib_Bonuses_";

// Training system bonuses - used in the FL training system.
const string BARD_BONUS_SLOT   = "BARD_BONUS_SLOT";
const string CLERIC_BONUS_SLOT = "CLERIC_BONUS_SLOT";
const string DRUID_BONUS_SLOT  = "DRUID_BONUS_SLOT";
const string PALLY_BONUS_SLOT  = "PALLY_BONUS_SLOT";
const string RANGER_BONUS_SLOT = "RANGER_BONUS_SLOT";
const string SORC_BONUS_SLOT   = "SORC_BONUS_SLOT";
const string WIZZY_BONUS_SLOT  = "WIZZY_BONUS_SLOT";

const string FL_BONUS_RGR_LEVELS  = "FL_BONUS_RGR_LEVELS";
const string FL_BONUS_BARD_LEVELS = "FL_BONUS_BARD_LEVELS";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Applies ASF Reduction for the Automatic Still Spell feats (i.e. 5% for AutoStill I,
// 10% for AutoStill II).
void ApplyAutoStillASFReduction(object oPC);
// Applies all character bonuses pertaining to race, class, path, etc. to a PC.
void ApplyCharacterBonuses(object oPC, int bReapplySpecialAbilities = FALSE, int bForceRemovePolymorph = TRUE, int bUpdateNaturalAC = FALSE);
// Reapplies arcane spell failure reductions (i.e. from warlock and favored soul paths) to
// the PC's equipment.
void ReapplyASFReductions(object oPC);
// Remove effects with the character bonus tag from the PC.
void RemoveCharacterBonusEffects(object oPC);
// Reapplies all temporary bonuses to a PC (e.g. fighter enhancement bonuses on items).
void ReapplyTemporaryCharacterBonuses(object oPC);
// Removes all temporary item properties from all equipped items from the PC.
void RemoveTemporaryEquipmentBonuses(object oPC);
// Updates innate languages for the PC, causing them to appear in the languages menu.
void UpdateKnownLanguages(object oPC);
// Updates weapon bonuses for the PC (e.g. grants +2 AB for two-handed weapons).
void UpdateWeaponBonuses(object oPC);
// Updates bonus spell slots (used in the FL training system).
void UpdateBonusSpellSlots(object oPC);
// Updates skill bonuses (used in the FL training system).
void UpdateSkillBonuses(object oPC);
// Adds a bonus to hit and damage for parrying PCs.
void AddParryBonus(object oPC);
// Removes the parry bonus.
void RemoveParryBonus(object oPC);
// Adds bonus damage from two-handed mode.
int ApplyTwoHandedBonus(object oItem);
// Returns TRUE if oItem is a valid Large-sized weapon
int arIsValidLargeSizedWeapon(object oItem);
// Removes bonus damage from two-handed mode.
int RemoveTwoHandedBonus(object oItem);
// Checks if two hand is applicable
void DoTwoHandedBonusCheck(object oPC, object oUnequipped=OBJECT_INVALID);

// remove most tagged effects on login (to prevent exploit with -save making them permanent)
void RemoveTaggedEffectsOnLogin(object oPC);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ApplyAutoStillASFReduction
//:://////////////////////////////////////////////
/*
    Applies ASF Reduction for the Automatic
    Still Spell feats (i.e. 5% for AutoStill I,
    10% for AutoStill II).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: March 14, 2017
//:://////////////////////////////////////////////
void ApplyAutoStillASFReduction(object oPC)
{
    if(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oPC))
    {
        // This block left intentionally empty. No need to apply ASF reduction
        // for characters with AutoStill III, since the feat renders them immune
        // to ASF by default.
    }
    else if(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, oPC))
    {
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT),
            GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), DURATION_INDEFINITE);
    }
    else if(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oPC))
    {
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT),
            GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), DURATION_INDEFINITE);
    }
}

//::///////////////////////////////////////////////
//:: ApplyCharacterBonuses
//:://////////////////////////////////////////////
/*
    Applies all character bonuses pertaining
    to race, class, path, etc. to a PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
void ApplyCharacterBonuses(object oPC, int bReapplySpecialAbilities = FALSE, int bForceRemovePolymorph = TRUE, int bUpdateNaturalAC = FALSE)
{
    if(!GetIsPC(oPC) || GetIsDM(oPC)) return;

    int bIsPlot = GetPlotFlag(oPC);

    // Disable the plot flag for now so that negative bonuses can also be applied.
    if(bIsPlot) SetPlotFlag(oPC, FALSE);

    if(!GetLocalInt(oPC, LIB_BONUSES_PREFIX + "FirstLogin"))
    {
        bReapplySpecialAbilities = TRUE;
        RemoveTemporaryEquipmentBonuses(oPC);
    }

    if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {
        if(bForceRemovePolymorph)
        {
            RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oPC);
            SendMessageToPC(oPC, MESSAGE_POLYMORPH_REMOVED);
        }
        else
        {
            return;
        }
    }

    //apply the parry script
    if(GetSkillRank(SKILL_PARRY, oPC) >= 10)
    {
        SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "evt_ply_hb");
    }
    object oHide = gsPCGetCreatureHide(oPC);
    object oSubraceToken = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    RemoveAllItemProperties(oHide);
    if(bReapplySpecialAbilities) RemoveAllItemProperties(oSubraceToken);
    RemoveAllSpecialAbilities(oPC);
    RemoveCharacterBonusEffects(oPC);
    
    // Dunshine: added this one to remove any other tagged effects that have been made permanent by using the -save exploit while under a tagged effect
    RemoveTaggedEffectsOnLogin(oPC);

    Trace(CLASSES, "Checking whether PC uses old or new subrace system.");
    if(GetLocalInt(oHide, "GIFT_SUBRACE") || GetLocalFloat(oHide, "ECL") == 0.0f)
    {
        Trace(CLASSES, "Character gets subrace bonuses.");
        gsSUApplyProperty(oHide, gsSUGetSubRaceByName(GetSubRace(oPC)), GetHitDice(oPC), bUpdateNaturalAC);
        if(bReapplySpecialAbilities) gsSUApplyAbility(oSubraceToken, gsSUGetSubRaceByName(GetSubRace(oPC)), GetHitDice(oPC));
    }

    //::  Add Racial Bonuses here, GetHitDice(oPC) > 3 really neccissary?
    if( GetHitDice(oPC) > 3 )
        md_AddRacialBonuses(oPC, gsSUGetSubRaceByName(GetSubRace(oPC)));

    ReapplyTemporaryCharacterBonuses(oPC);
    miTOApplyTotemAbilities(oHide);
    miBAReapplyGifts(oPC, bReapplySpecialAbilities);
    miCLApplyClassChanges(oPC);
    miCLApplyPathChanges(oPC, bReapplySpecialAbilities, bUpdateNaturalAC);
    miBAApplyBackground(oPC, -1, FALSE); // Moved to after class adjustments so that Dauntless HP stacks with Spellsword/Warlock
    UpdateWeaponBonuses(oPC);
    UpdateLevelBonuses(oPC);
    UpdateKnownLanguages(oPC);
    UpdateBonusSpellSlots(oPC);
    UpdateSkillBonuses(oPC);
    MigrateStreamData(oPC);
    ApplyAutoStillASFReduction(oPC);
    
    SetLocalInt(oPC, LIB_BONUSES_PREFIX + "FirstLogin", TRUE);

    // Fix for non-standard subrace movement.
    if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SPECIAL_FEY)
    {
        NWNX_Creature_SetMovementRate(oPC, MOVEMENT_RATE_VERY_FAST);
    }
    else
    {
        NWNX_Creature_SetMovementRate(oPC, MOVEMENT_RATE_PC);
    }

    if(bIsPlot) SetPlotFlag(oPC, TRUE);

    // Force move speed recalculation on login/server transition. This is an attempted fix for
    // reported move speed bugs.
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(1), oPC, 0.1));

    Trace(CLASSES, "Subrace and class changes reapplied.");
}

//::///////////////////////////////////////////////
//:: ReapplyASFReductions
//:://////////////////////////////////////////////
/*
    Reapplies arcane spell failure reductions
    (i.e. from warlock and favored soul paths) to
    the PC's equipment.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void ReapplyASFReductions(object oPC)
{
    int nMulti = 0;
    int nClass2 = GetClassByPosition(2, oPC);
    if (nClass2 != CLASS_TYPE_INVALID) nMulti = 1;

    miFSRemoveASFReduction(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
    miFSRemoveASFReduction(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));

    if(miFSGetIsFavoredSoul(oPC))
    {
      miFSApplyASFReduction(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
      miFSApplyASFReduction(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
      return;
    }
    else if(miWAGetIsWarlock(oPC))
    {
      if(miWAGetCasterLevel(oPC) < 6 && nMulti == 1) return;

      miFSApplyASFReduction(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
      miFSApplyASFReduction(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
    }
}

//::///////////////////////////////////////////////
//:: ReapplyTemporaryCharacterBonuses
//:://////////////////////////////////////////////
/*
    Reapplies all temporary bonuses to a PC (e.g.
    fighter enhancement bonuses on items).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
void ReapplyTemporaryCharacterBonuses(object oPC)
{
    ReapplyFighterBonuses(oPC);
    ReapplyASFReductions(oPC);

    RemoveTaggedEffects(oPC, EFFECT_TAG_TWOHAND);
    if ( GetLocalInt(oPC, "AR_TWO_HAND") ) {
        ApplyTwoHandedBonus( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) );
    }
}

//::///////////////////////////////////////////////
//: RemoveCharacterBonusEffects
//:://////////////////////////////////////////////
/*
    Remove effects with the character bonus
    tag from the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
void RemoveCharacterBonusEffects(object oPC)
{
    RemoveTaggedEffects(oPC, EFFECT_TAG_CHARACTER_BONUS);
}

//::///////////////////////////////////////////////
//:: RemoveTemporaryEquipmentBonuses
//:://////////////////////////////////////////////
/*
    Removes all temporary item properties from
    all equipped items from the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 7, 2016
//:://////////////////////////////////////////////
void RemoveTemporaryEquipmentBonuses(object oPC)
{
    int nSlot;

    for(nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++ nSlot)
    {
        RemoveAllItemProperties(GetItemInSlot(nSlot, oPC), DURATION_TYPE_TEMPORARY);
    }
}

//::///////////////////////////////////////////////
//:: UpdateKnownLanguages
//:://////////////////////////////////////////////
/*
    Updates innate languages for the PC, causing
    them to appear in the languages menu.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 3, 2016
//:://////////////////////////////////////////////
void UpdateKnownLanguages(object oPC)
{
    int i;
    object oHide = gsPCGetCreatureHide(oPC);

    for(i = GS_LA_LANGUAGE_FIRST; i <= GS_LA_LANGUAGE_LAST; i++)
    {
        _gsLAGetCanSpeakLanguage(i, oPC, oHide, "GS_LA_LANGUAGE_" + IntToString(i));
    }
}

//::///////////////////////////////////////////////
//:: UpdateWeaponBonuses
//:://////////////////////////////////////////////
/*
    Updates weapon bonuses for the PC (e.g.
    grants +2 AB for two-handed weapons).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
void UpdateWeaponBonuses(object oPC)
{
    if(!GetIsPC(oPC) || GetIsDM(oPC)) return;

    // Cooldown on feedback to prevent spam with multiple successive updates.
    int bFeedback = GetModuleTime() >= GetLocalInt(oPC, LIB_BONUSES_PREFIX + "WeaponBonusUpdate") ? TRUE : FALSE;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    SetLocalInt(oPC, LIB_BONUSES_PREFIX + "WeaponBonusUpdate", GetModuleTime() + 1);

    RemoveTaggedEffects(oPC, EFFECT_TAG_WEAPON_BONUS);
    ApplyRangerWeaponBonuses(oPC, bFeedback);
    if(GetIsObjectValid(oWeapon) && GetWeaponSize(oWeapon, oPC) == WEAPON_SIZE_TWO_HANDED && !GetWeaponRanged(oWeapon))
    {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(2)), oPC, 0.0, EFFECT_TAG_WEAPON_BONUS);
        if(bFeedback) SendMessageToPC(oPC, MESSAGE_TWO_HANDED_WEAPON_BONUS);
    }
}

//:://////////////////////////////////////////////
//:: Updates bonus spell slots (used in the FL training system).
//:: Created By: Mithreas
//:: Created On: Jan 6, 2017
//:://////////////////////////////////////////////
void _UpdateBonusSpellSlots(object oHide, int nSlots, int nClass, int nMaxSlotLevel)
{
  int nSpellSlot  = 1;
  int nTotalSlots = 1;

  while (nTotalSlots <= nSlots)
  {
    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyBonusLevelSpell(nClass, nSpellSlot),
                    oHide);

    nSpellSlot ++;
    nTotalSlots ++;

    if (nSpellSlot > nMaxSlotLevel)
    {
      nSpellSlot = 1;
    }
  }
}

//:://////////////////////////////////////////////
//:: Created By: Mithreas
//:: Created On: Jan 6, 2017
//:://////////////////////////////////////////////
void UpdateBonusSpellSlots(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);

  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, BARD_BONUS_SLOT), CLASS_TYPE_BARD, 3);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, CLERIC_BONUS_SLOT), CLASS_TYPE_CLERIC, 5);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, DRUID_BONUS_SLOT), CLASS_TYPE_DRUID, 5);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, PALLY_BONUS_SLOT), CLASS_TYPE_PALADIN, 2);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, RANGER_BONUS_SLOT), CLASS_TYPE_RANGER, 2);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, SORC_BONUS_SLOT), CLASS_TYPE_SORCERER, 5);
  _UpdateBonusSpellSlots(oHide, GetLocalInt(oHide, WIZZY_BONUS_SLOT), CLASS_TYPE_WIZARD, 5);
}

//:://////////////////////////////////////////////
//:: Created By: Mithreas
//:: Created On: Jan 6, 2017
//:: Updates skill bonuses (used in the FL training system).
//:://////////////////////////////////////////////
void UpdateSkillBonuses(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);

  int nEmpathy = GetLocalInt(oHide, FL_BONUS_RGR_LEVELS);
  AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, nEmpathy), oHide);

  int nPerform = GetLocalInt(oHide, FL_BONUS_BARD_LEVELS);
  AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_PERFORM, nPerform), oHide);
}

//::///////////////////////////////////////////////
//:: AddParryBonus
//:://////////////////////////////////////////////
/*
    Add Parry mode bonuses to hit and damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Mithreas
//:: Created On: Jan 13, 2017
//:://////////////////////////////////////////////
void _AddParryBonus(object oPC)
{
  //---------------------------------------------------------------------
  // Delayed to ensure bonuses aren't gained in the same round.  First,
  // check that we are still in Parry mode.
  //---------------------------------------------------------------------
  if (!GetActionMode(oPC, ACTION_MODE_PARRY)) return;

  //---------------------------------------------------------------------
  // Damage bonus adjusted to 1 every 2 ranks for the first 20 ranks, and
  // 1 every 4 ranks thereafter.
  //---------------------------------------------------------------------
  int nDamageBonus1 = GetSkillRank(SKILL_PARRY, oPC) / 2;
  int nDamageBonus2 = 0;
  int nDamageBonus3 = 0;

  if (nDamageBonus1 > 10) nDamageBonus1 = 5 + GetSkillRank(SKILL_PARRY, oPC) / 4;

  //---------------------------------------------------------------------
  // The damage 2da index maps 6->16 and 20->30 (6-15 are variable
  // bonuses).  20 damage (row 30) is the highest.  Roll over to multiple
  // damage types if needed.
  //---------------------------------------------------------------------
  if (nDamageBonus1 > 20)
  {
    nDamageBonus2 = nDamageBonus1 - 20;
    nDamageBonus1 = 20;
  }

  if (nDamageBonus2 > 20)
  {
    nDamageBonus3 = nDamageBonus2 - 20;
    nDamageBonus2 = 20;
  }

  if (nDamageBonus3 > 20)
  {
    nDamageBonus3 = 20;
  }

  if (nDamageBonus1 > 5) nDamageBonus1 += 10;
  if (nDamageBonus2 > 5) nDamageBonus2 += 10;
  if (nDamageBonus3 > 5) nDamageBonus3 += 10;

  effect eAttack = EffectAttackIncrease(5);
  effect eDamage1 = EffectDamageIncrease(nDamageBonus1, DAMAGE_TYPE_PIERCING);
  effect eDamage2 = EffectDamageIncrease(nDamageBonus2, DAMAGE_TYPE_SLASHING);
  effect eDamage3 = EffectDamageIncrease(nDamageBonus3, DAMAGE_TYPE_BLUDGEONING);
  effect eParry = EffectLinkEffects(eAttack, eDamage1);
  if (nDamageBonus2) eParry = EffectLinkEffects(eParry, eDamage2);
  if (nDamageBonus3) eParry = EffectLinkEffects(eParry, eDamage3);

  ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eParry, oPC, 0.0f, EFFECT_TAG_PARRY);
  //SendMessageToPC(oPC, "Ready to riposte!"); removed as this msg will get old quick every 6 seconds
}

void AddParryBonus(object oPC)
{
  // Delay for most of a round, in case someone toggles after their
  // first flurry.
  DelayCommand(4.0, _AddParryBonus(oPC));
}

//::///////////////////////////////////////////////
//:: RemoveParryBonus
//:://////////////////////////////////////////////
/*
    Removes the parry mode hit/damage bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Mithreas
//:: Created On: Jan 13, 2017
//:://////////////////////////////////////////////
void RemoveParryBonus(object oPC)
{
  //---------------------------------------------------------------------
  // Remove Parry bonuses.
  //---------------------------------------------------------------------
  effect eEffect = GetFirstEffect(oPC);

  while (GetIsEffectValid(eEffect))
  {
    if (GetIsTaggedEffect(eEffect, EFFECT_TAG_PARRY))
    {
      RemoveEffect(oPC, eEffect);
      // It's possible to have multiple parry bonuses, so remove them all.
      // (The bonuses don't stack).
    }

    eEffect = GetNextEffect(oPC);
  }
}

//::///////////////////////////////////////////////
//:: ApplyTwoHandedBonus
//:://////////////////////////////////////////////
/*
    Applies two-handed bonus damage to the main
    hand weapon.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: April 05, 2017
//:://////////////////////////////////////////////
void _arUnEquipItem(object oItem) {
    if (GetHasSpellEffect(SPELL_CHARM_MONSTER) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL) ||
        GetHasSpellEffect(SPELL_MASS_CHARM) )
    {
      return;
    }

    gsCMCopyItem(oItem, OBJECT_SELF, TRUE);
    DestroyObject(oItem);
}

int ApplyTwoHandedBonus(object oItem) {
    object oPC = GetItemPossessor(oItem);
    if ( !GetIsPC(oPC) || GetIsDM(oPC) ) return FALSE;

    //::  Unequip Offhand
    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if (oItem == oOffHand) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 0.75);
        DelayCommand(0.5, AssignCommand(oPC, _arUnEquipItem(oOffHand)));
        return FALSE;
    }

    //::  Two-handed bonus
    int bIsMedium           = GetCreatureSize(oPC) == CREATURE_SIZE_MEDIUM;
    int bIsMediumBastard    = bIsMedium && GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER;
    int bIsMediumDwarfAxe   = GetRacialType(oPC) == RACIAL_TYPE_DWARF && GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE;
    object oMainHand        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if ( oMainHand == oItem && ( arIsValidLargeSizedWeapon(oMainHand) || bIsMediumBastard || bIsMediumDwarfAxe ) ) {
        int nStrBonus = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        if (nStrBonus < 0) nStrBonus = 0;
        int nBonusDmg = nStrBonus / 2;
        nBonusDmg = IPGetDamageBonusConstantFromNumber(nBonusDmg);

        RemoveTaggedEffects(oPC, EFFECT_TAG_TWOHAND);
        if (nBonusDmg > 0) {
            effect eLink = SupernaturalEffect( EffectDamageIncrease(nBonusDmg, GetMatchingDamageType(oMainHand)) );

            //::  Only Large creatures get the extra +2 AB
            if ( !bIsMedium ) {
                int bFeedback = GetModuleTime() >= GetLocalInt(oPC, LIB_BONUSES_PREFIX + "WeaponBonusUpdate") ? TRUE : FALSE;
                SetLocalInt(oPC, LIB_BONUSES_PREFIX + "WeaponBonusUpdate", GetModuleTime() + 1);
                if(bFeedback) SendMessageToPC(oPC, MESSAGE_TWO_HANDED_WEAPON_BONUS);
                eLink = EffectLinkEffects( eLink, SupernaturalEffect(EffectAttackIncrease(2)));
            }

            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, 0.0, EFFECT_TAG_TWOHAND);
        }

        //::Kirito-Spellsword path
        if (miSSGetIsSpellsword(oPC))
        {
          //Re-Applies All Spellsword Bonuses
          miSSReApplyBonuses(oPC, TRUE);
        }

        return TRUE;
    }

    return FALSE;
}

int arIsValidLargeSizedWeapon(object oItem) {

    if ( !GetIsObjectValid(oItem) || GetWeaponRanged(oItem) || GetCreatureSize(GetItemPossessor(oItem)) <= CREATURE_SIZE_MEDIUM ) return FALSE;

    switch( GetBaseItemType(oItem) ) {
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_TWOBLADEDSWORD:
            return TRUE;
    }

    return FALSE;
}

//::///////////////////////////////////////////////
//:: RemoveTwoHandedBonus
//:://////////////////////////////////////////////
/*
    Removes two-handed bonus damage to the main
    hand weapon.
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: April 05, 2017
//:://////////////////////////////////////////////
int RemoveTwoHandedBonus(object oItem) {
    object oPC = GetItemPossessor(oItem);
    if( !GetIsObjectValid(oItem) || !GetIsPC(oPC) || GetIsDM(oPC) ) return FALSE;

    int bIsMediumBastard    = GetCreatureSize(oPC) == CREATURE_SIZE_MEDIUM && GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD;
    int bIsMediumDwarfAxe   = GetRacialType(oPC) == RACIAL_TYPE_DWARF && GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE;

    if ( arIsValidLargeSizedWeapon(oItem) || bIsMediumBastard || bIsMediumDwarfAxe )
    {
        RemoveTaggedEffects(oPC, EFFECT_TAG_TWOHAND);

        //::Kirito-Spellsword path
        if (miSSGetIsSpellsword(oPC))
        {
          //Re-Applies All Spellsword Bonuses
          miSSReApplyBonuses(oPC, TRUE);
        }
        return TRUE;
    }

    return FALSE;
}

//::///////////////////////////////////////////////
//:: DoTwoHandedBonusCheck
//:://////////////////////////////////////////////
/*
    Decides to apply or remove
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: March 23, 2018
//:://////////////////////////////////////////////
void DoTwoHandedBonusCheck(object oPC, object oUnequipped=OBJECT_INVALID)
{
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int nTwoHandMode = GetLocalInt(oPC, "AR_TWO_HAND");
    if(nTwoHandMode) { //two hand mode engaged

        if(GetIsObjectValid(oLeft)) //has a shild equipped
        {
            RemoveTaggedEffects(oPC, EFFECT_TAG_TWOHAND);

            //::Kirito-Spellsword path
            if (miSSGetIsSpellsword(oPC))
            {
                //Re-Applies All Spellsword Bonuses
                miSSReApplyBonuses(oPC, TRUE);
            }
            DeleteLocalInt(oPC, "AR_TWO_HAND");
            SendMessageToPC(oPC, " <c€€€>Two-Handed Mode Disabled.");
        }
        else if(RemoveTwoHandedBonus(oUnequipped)) //removed the correct weapon, remove the boon
        {
            DeleteLocalInt(oPC, "AR_TWO_HAND");
            SendMessageToPC(oPC, " <c€€€>Two-Handed Mode Disabled.");
        }
        else if(!GetIsObjectValid(oUnequipped) && GetIsObjectValid(oRight)) //just in case it's equipped and twohand mode didn't get set off
            ApplyTwoHandedBonus(oRight);

    }
    else if(!GetIsObjectValid(oLeft) && GetIsObjectValid(oRight) && ApplyTwoHandedBonus(oRight)) {
        SetLocalInt(oPC, "AR_TWO_HAND", TRUE);
        SendMessageToPC(oPC, " <c € >Two-Handed Mode Activated.");
    }


}

void RemoveTaggedEffectsOnLogin(object oPC) {

  // remove most tagged effects not alreayd covered by other functions in this script
  RemoveTaggedEffects(oPC, EFFECT_TAG_RESPITE);
  RemoveTaggedEffects(oPC, EFFECT_TAG_DURATION_MARKER);
  RemoveTaggedEffects(oPC, EFFECT_TAG_OVERHEAL);
  RemoveTaggedEffects(oPC, EFFECT_TAG_CROWD_CONTROL_IMMUNITY);
  RemoveTaggedEffects(oPC, EFFECT_TAG_PARRY);
  RemoveTaggedEffects(oPC, EFFECT_TAG_TWOHAND);
  RemoveTaggedEffects(oPC, EFFECT_TAG_AURA);
  RemoveTaggedEffects(oPC, EFFECT_TAG_SCRY);
  RemoveTaggedEffects(oPC, EFFECT_TAG_DISGUISE);
  RemoveTaggedEffects(oPC, EFFECT_TAG_TRIBAL_GOBLIN);
  RemoveTaggedEffects(oPC, EFFECT_TAG_SPELLSWORD);

}



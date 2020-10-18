//::///////////////////////////////////////////////
//:: inc_barbarian
//:: Library: Barbarian
//:://////////////////////////////////////////////
/*
    Library with functions for Barbarian mechanics

    Current Rage Scaling:
    Level 1:  +1 to 1H,  +3 to 2H
    Level 4:  +2 to 1H,  +4 to 2H
    Level 8:  +3 to 1H,  +6 to 2H,  Up to +1 damage from positive CON modifier.
    Level 12: +4 to 1H,  +7 to 2H
    Level 16: +6 to 1H,  +9 to 2H,  Up to +2 damage from positive CON modifier.
    Level 20: +7 to 1H,  +11 to 2H
    Level 24: +9 to 1H,  +13 to 2H
    Level 28: +12 to 1H, +16 to 2H
    CON modifier bonus to damage: +1 to cap with every odd epic barbarian level

    Special:  Tribal path summons tribesmen in lieu of rage effects.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_associates"
#include "inc_pc"
#include "inc_iprop"
#include "inc_generic"
#include "inc_item"
#include "inc_spells"
#include "inc_effecttags"
#include "inc_timelock"
#include "inc_spellmatrix"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_itemprop"


/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Default Barbarian Functions

// CC cleansing effect of Mighty Rage
void barbMightyRageCleanse(object oPC = OBJECT_SELF);
// Check if the Barbarian is wearing Heavy Armor
int barbIsWearingHeavyArmor(object oPC = OBJECT_SELF);
// Returns the base damage type of a weapon.  Use only for barbarian weapons.
int barbWeapDamType(object oWeapon);
// Application of Rage Effects on the Barbarian
void barbSelfRageEffects(int nDuration, object oPC = OBJECT_SELF);
// Application of Rage Effects on Weapon Damage
void barbWeaponRageEffects(int nDuration, object oPC = OBJECT_SELF);
// Application of passive CON-based boost to barb damage
void barbReApplyBonuses(object oEquip, object oPC = OBJECT_SELF);
// Override to set rage level based on number of rage feats.
int _AnemoiRageLvl(object oPC = OBJECT_SELF);
// TRIBAL PATH FUNCTIONS

// Equip tribal armor
void btribeEquipTribesmanArmor(object oArmor);
// Set tribesmen appearance
void btribeSetTribesmanAppearance(object oTribesman, object oPC);
// Tribesmen creation upon rage use
void btribeCreateTribesmen(object oPC);

// CUSTOM RAGE SCRIPTS

// Check Epic Rage Feats
void barbEpicRageFeats(int nRounds, object oPC = OBJECT_SELF);
// Thundering Rage
void barbThunderingRage(int nRounds, object oPC = OBJECT_SELF);
// Terrifying Rage
void barbTerrifyingRage(int nRounds, object oPC = OBJECT_SELF);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/


//------------------------------------------------------------------------------

void barbMightyRageCleanse(object oPC = OBJECT_SELF)
{
    // Mighty Rage now cleanses CCs and other negative effects
    effect eBad = GetFirstEffect(oPC);

    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
            GetEffectType(eBad) == EFFECT_TYPE_SLEEP ||
            GetEffectType(eBad) == EFFECT_TYPE_ENTANGLE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_PETRIFY ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE)
        {
            RemoveEffect(oPC, eBad);
        }
        eBad = GetNextEffect(oPC);
    }
}

//------------------------------------------------------------------------------

int barbIsWearingHeavyArmor(object oPC = OBJECT_SELF)
{
    // Check to see if the barbarian is wearing heavy armor

    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    // Not Wearing Anything!
    if (!GetIsObjectValid(oItem))
        return 0;

    // Silly workaround to test armor type
    // Unidentify then check item base value

    int bID = GetIdentified(oItem);

    SetIdentified(oItem, FALSE);

    int nBaseAC = 0;

    switch (GetGoldPieceValue(oItem)) {
        case 5:    nBaseAC = 1; break;  // Padded
        case 10:   nBaseAC = 2; break;  // Leather
        case 15:   nBaseAC = 3; break;  // Studded Leather / Hide
        case 100:  nBaseAC = 4; break;  // Chain Shirt / Scale Mail
        case 150:  nBaseAC = 5; break;  // Chainmail / Breastplate
        case 200:  nBaseAC = 6; break;  // Splint Mail / Banded Mail
        case 600:  nBaseAC = 7; break;  // Half Plate
        case 1500: nBaseAC = 8; break;  // Full Plate
    }

    SetIdentified(oItem, bID);

    if (nBaseAC > 5)
        return 1;

    return 0;
}

//------------------------------------------------------------------------------

void barbSelfRageEffects(int nDuration, object oPC = OBJECT_SELF)
{

    // Create and link all temporary effects to be applied to the Barbarian

    // Duration is 0 or less, abort
    if (nDuration < 1)
        return;

    // Scaling of rage effects now depends solely on Barbarian class levels
    int nBarbLevels = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);

    // 50% Movement speed while enraged
    effect eSpeed = EffectMovementSpeedIncrease(50);

    // Visual effect on cessation of rage.
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Create the temp HP effect.
    // OLD Formula: effect eHP = EffectTemporaryHitpoints((GetMaxHitPoints(oPC) *  nBarbLevels) / (2 * GetHitDice(oPC)));
    // New formula: (12 + Constitution modifier + 1 if Toughness) * Barbarian Levels / 2
    // Apply this effect separately.
    effect eHP = EffectTemporaryHitpoints((12 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + GetHasFeat(FEAT_TOUGHNESS, oPC)) * nBarbLevels / 2);
       eHP = ExtraordinaryEffect(eHP);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds(nDuration));

	//Sawaki: Keeping TempHP linked to lvl, other effects to rage feats. Testwise reduced Con-requirements (BALANCING?)
	nBarbLevels = _AnemoiRageLvl(oPC);
	
	// Will Bonus is (Class levels / 4) + 1
    effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 1 + (nBarbLevels / 4));

    // AB Increase
    int nAB = 0;
    if (nBarbLevels >= 12)
        nAB = 2;
    else if (nBarbLevels >= 1)
        nAB = 1;

    // Drop AB increase if CON <= 13
    if (nAB > 0 && GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) <= 13)
        nAB = nAB - 1;

    // Link all effects (except HP)
    effect eLink = EffectLinkEffects(eSpeed, eWill);
    eLink = EffectLinkEffects(eLink, eDur);
    // eLink = EffectLinkEffects(eLink, eHP);

    if (nAB > 0)
        eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAB, ATTACK_BONUS_MISC));

    // 5% Physical Immunity
    if (nBarbLevels >= 4) {
        int nImmunity = 5;
              if (nBarbLevels >= 16)
                     nImmunity += 5;
        if (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) < 14)
            nImmunity -= 5;

              if (nImmunity > 0) {
                     eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nImmunity));
                     eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nImmunity));
                     eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nImmunity));
                }
    }

    // Add Extra Attack if PC has Thundering Rage
    if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oPC))
        eLink = EffectLinkEffects(eLink, EffectModifyAttacks(1));

    //Make linked effects extraordinary
    eLink = ExtraordinaryEffect(eLink);

    // Apply the effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));

    // Instant visual effect
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    // Change instant visual effect for Terrifying Rage
    if (GetHasFeat(FEAT_MIGHTY_RAGE)) {
        if (GetGender(oPC) == GENDER_FEMALE)
            eVis = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY_FEMALE);
        else
            eVis = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    }

    // Apply the VFX impact
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    // Because Cortex wants bling on the other epic rage feats too.
    if (GetHasFeat(FEAT_EPIC_TERRIFYING_RAGE)) {
        effect eTVis = EffectVisualEffect(VFX_FNF_HOWL_MIND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eTVis, oPC);
    }

    if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE)) {
        effect eThVis = EffectVisualEffect(460);;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eThVis, oPC);
    }
}


//------------------------------------------------------------------------------
// Returns the base damage type of a weapon.  Use only for barbarian weapons.
int barbWeapDamType(object oWeapon)
{
    int nBaseType = GetBaseItemType(oWeapon);
    int nDamType = IP_CONST_DAMAGETYPE_SLASHING;

    switch (nBaseType) {
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_TRIDENT:
            nDamType = IP_CONST_DAMAGETYPE_PIERCING;
            break;
        case BASE_ITEM_CLUB:
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_WARHAMMER:
            nDamType = IP_CONST_DAMAGETYPE_BLUDGEONING;
            break;
    }
    return nDamType;
}

//------------------------------------------------------------------------------
// Sawaki: Setting BarbarianLVL via Rage-Feats. Balancing under review.
int _AnemoiRageLvl(object oPC = OBJECT_SELF)
{
	int nLevel;
	nLevel = 0;
	
	if (GetHasFeat(330, oPC)) // barb rage 6
	{  
	  nLevel = 20;
	}
	else if (GetHasFeat(329, oPC)) // barb rage 5
	{  
	  nLevel = 16;
	}
	else if (GetHasFeat(328, oPC)) // barb rage 4
	{  
	  nLevel = 12;
	}
	else if (GetHasFeat(327, oPC))  // barb rage 3
	{  
	  nLevel = 8;
	}
	else if (GetHasFeat(326, oPC)) // barb rage 2
	{  
	  nLevel = 4;
	}
	else
	{ 
	  nLevel = 1; // barb rage 1 
	}  
		
	// Temporaray solution: Any epic Rage feat sets ragelvl to 24, then 28.
	
	if (GetHasFeat(869, oPC)) // Mighty Rage
	{ 
		if (nLevel == 24)
		{	
			nLevel = 28;
		} 
		else 
		{
			nLevel = 24;
		}	
	}
	if (GetHasFeat(988, oPC)) // Thundering Rage
	{ 
	  if (nLevel == 24)
		{	
			nLevel = 28;
		} 
		else 
		{
			nLevel = 24;
		}
	}	
	if (GetHasFeat(989, oPC)) // Terrifying Rage
	{ 
	  if (nLevel == 24)
		{	
			nLevel = 28;
		} 
		else 
		{
			nLevel = 24;
		}
	}	
	return nLevel;
}	

//------------------------------------------------------------------------------

void barbWeaponRageEffects(int nDuration, object oPC = OBJECT_SELF)
{

    // Applying bonus damage to weapon for the duration of Rage

    // Duration is 0 or less, abort
    if (nDuration < 1)
        return;


    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    // Not Wielding Anything!
    if (!GetIsObjectValid(oWeapon))
        return;

    // Don't apply bonus damage to bundle items.
    if (GetBaseItemType(oWeapon) == BASE_ITEM_CLUB && FindSubString(GetTag(oWeapon), "ca_gen") > -1)
        return;

    // Bonus damage only applies to melee weapons and throwing axes.
    if (GetWeaponRanged(oWeapon) && GetBaseItemType(oWeapon) != BASE_ITEM_THROWINGAXE)
        return;

    // Determine the bonus damage types based on the weapon type.
    int nWeapType = barbWeapDamType(oWeapon);
    int nFirstType, nSecondType;

    if (nWeapType == IP_CONST_DAMAGETYPE_PIERCING) {
        nFirstType = IP_CONST_DAMAGETYPE_SLASHING;
        nSecondType = IP_CONST_DAMAGETYPE_BLUDGEONING;
    } else if (nWeapType == IP_CONST_DAMAGETYPE_BLUDGEONING) {
        nFirstType = IP_CONST_DAMAGETYPE_SLASHING;
        nSecondType = IP_CONST_DAMAGETYPE_PIERCING;
    } else {
        nFirstType = IP_CONST_DAMAGETYPE_PIERCING;
        nSecondType = IP_CONST_DAMAGETYPE_BLUDGEONING;
    }

    // Scale damage based on class level
    int nBarbLevels = _AnemoiRageLvl(oPC);
    int nBonusLevel = 1 + (nBarbLevels / 4);
    int nDamageBonus = IP_CONST_DAMAGEBONUS_1;
    int nSecondBonus = 0;
	

    // Separate scaling basedon 1H or 2H weapons 
    if (GetWeaponSize(oWeapon, oPC) >= WEAPON_SIZE_TWO_HANDED || GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE) {
        switch (nBonusLevel)
        {
            case 1:
                nDamageBonus = IP_CONST_DAMAGEBONUS_3;
                break;
            case 2:
                nDamageBonus = IP_CONST_DAMAGEBONUS_4;
                break;
            case 3:
                nDamageBonus = IP_CONST_DAMAGEBONUS_6;
                break;
            case 4:
                nDamageBonus = IP_CONST_DAMAGEBONUS_7;
                break;
            case 5:
                nDamageBonus = IP_CONST_DAMAGEBONUS_9;
                break;
            case 6:
                nDamageBonus = IP_CONST_DAMAGEBONUS_10;
                nSecondBonus = IP_CONST_DAMAGEBONUS_1;
                break;
            case 7:
                nDamageBonus = IP_CONST_DAMAGEBONUS_10;
                nSecondBonus = IP_CONST_DAMAGEBONUS_3;
                break;
            case 8:
                nDamageBonus = IP_CONST_DAMAGEBONUS_10;
                nSecondBonus = IP_CONST_DAMAGEBONUS_6;
                break;
            default:
                nDamageBonus = IP_CONST_DAMAGEBONUS_1;
                break;
        }
    } else {
        switch (nBonusLevel)
        {
            case 1:
                nDamageBonus = IP_CONST_DAMAGEBONUS_1;
                break;
            case 2:
                nDamageBonus = IP_CONST_DAMAGEBONUS_2;
                break;
            case 3:
                nDamageBonus = IP_CONST_DAMAGEBONUS_3;
                break;
            case 4:
                nDamageBonus = IP_CONST_DAMAGEBONUS_4;
                break;
            case 5:
                nDamageBonus = IP_CONST_DAMAGEBONUS_6;
                break;
            case 6:
                nDamageBonus = IP_CONST_DAMAGEBONUS_7;
                break;
            case 7:
                nDamageBonus = IP_CONST_DAMAGEBONUS_9;
                break;
            case 8:
                nDamageBonus = IP_CONST_DAMAGEBONUS_10;
                nSecondBonus = IP_CONST_DAMAGEBONUS_2;
                break;
            default:
                nDamageBonus = IP_CONST_DAMAGEBONUS_1;
                break;
        }
    }

    // Increase scaling for 2h weapon, and for large creatures.
    // if (GetWeaponSize(oWeapon, oPC) >= WEAPON_SIZE_TWO_HANDED || GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE)
    //    nBonusLevel = nBonusLevel + 3;

    // Create the item property
    itemproperty ipDamage = ItemPropertyDamageBonus(nFirstType, nDamageBonus);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipDamage, oWeapon, RoundsToSeconds(nDuration));

    if (nSecondBonus > 0) {
        ipDamage = ItemPropertyDamageBonus(nSecondType, nSecondBonus);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDamage, oWeapon, RoundsToSeconds(nDuration));
    }

    // We have bonus damage exceeding the max scaling of the constant.
    // if (nBonusLevel > 7) {
    //     int nBonusDamage = IPGetDamageBonusConstantFromNumber(nBonusLevel -7);
    //    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDamageIncrease(nBonusDamage, DAMAGE_TYPE_SLASHING)), oPC, RoundsToSeconds(nDuration));
    // }
}


//------------------------------------------------------------------------------

void barbReApplyBonuses(object oEquip, object oPC = OBJECT_SELF)
{
    // Anemoi - this method is no longer called.  (Was referenced in m_equip)
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int nValidWeapon = FALSE;
    if ((oWeapon != OBJECT_INVALID) && (!GetWeaponRanged(oWeapon) || GetBaseItemType(oWeapon) == BASE_ITEM_THROWINGAXE))
        nValidWeapon = TRUE;

    // Houseclean present Barbarian effects
    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        // Remove passive CON-based damage so it can be re-applied.
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_BARBARIAN)) {
            // First remove any existing Barbarian damage effects
            if (GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_INCREASE)
                RemoveEffect(oPC, eEffect);

            // Remove Dodge AC so it can be reapplied.
            if ((GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE))
                RemoveEffect(oPC, eEffect);
        }

        // While we're here, check to see if Rage bonuses are still applicable
        if (GetEffectSpellId(eEffect) == SPELLABILITY_BARBARIAN_RAGE) {

            // If the Barbarian is no longer carrying the right weapon type, remove bonus rage damage
            if ((GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_INCREASE) && !nValidWeapon)
                RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }

    // AC Increase
    int nBarbLevels = _AnemoiRageLvl(oPC);
    int nACBonus = 0;
    if (nBarbLevels >= 20)
        nACBonus = 4;
    else if (nBarbLevels >= 12)
        nACBonus = 2;

    // AC only applies if not wearing heavy armor
    if (!barbIsWearingHeavyArmor(oPC) && nACBonus > 0) {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACBonus, AC_DODGE_BONUS)), oPC, 0.0, EFFECT_TAG_BARBARIAN);
        SendMessageToPC(oPC, "Gaining " + IntToString(nACBonus) + " dodge AC from wearing medium or lighter armor.");
    }

    // No passive damage if the equipped item is a ranged weapon
    if (!nValidWeapon)
        return;

    // Apply passive base CON bonus to damage.  Limited to +1 at level 8, +2 at level 16, and then an additional +1 every odd epic level
    int nDamage = (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) - 10) / 2;
    if (nBarbLevels < 8) {
        nDamage = 0;
    } else if (nBarbLevels >= 8 && nBarbLevels < 16) {
        if (nDamage > 1) nDamage = 1;
    } else if (nBarbLevels >= 16 && nBarbLevels < 21 && nDamage > 2) {
        if (nDamage > 2) nDamage = 2;
    } else if (nBarbLevels >= 21) {
        if (nDamage > 2 + ((nBarbLevels - 19) / 2)) nDamage = 2 + ((nBarbLevels - 19) / 2);
    }

    nDamage = IPGetDamageBonusConstantFromNumber(nDamage);

    if (nDamage > 0) {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING)), oPC, 0.0, EFFECT_TAG_BARBARIAN);
        SendMessageToPC(oPC, "Added " + IntToString(nDamage) + " bonus damage from base constitution.");
    }
}


//------------------------------------------------------------------------------
//----- TRIBAL PATH BARBARIAN FUNCTIONS ----------------------------------------
//------------------------------------------------------------------------------

void btribeEquipTribesmanArmor(object oArmor)
{
    // Have the tribesmen equip their armor.
    ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST);
    ActionDoCommand(SetCommandable(TRUE, OBJECT_SELF));
    SetCommandable(FALSE, OBJECT_SELF);
    SetDroppableFlag(oArmor, FALSE);
}

//------------------------------------------------------------------------------

void btribeSetTribesmanAppearance(object oTribesman, object oPC)
{
    // Copy the summoner's appearance (tattoos etc) but randomise the head.
    // This method fires but doesn't seem to do anything to the summon.
    int nPart = 0;
    for (nPart; nPart < 18; nPart++)
    {
        //SpeakString("Part: " + IntToString(nPart) +
        //            ", value: " + IntToString(GetCreatureBodyPart(nPart, oPC)));
        SetCreatureBodyPart(nPart, GetCreatureBodyPart(nPart, oPC), oTribesman);
    }

    SetCreatureBodyPart(CREATURE_PART_HEAD, Random(6) + 1, oTribesman);

    // SpeakString("Colours: " + IntToString(GetColor(oPC, COLOR_CHANNEL_SKIN)) +
    //             ", " + IntToString(GetColor(oPC, COLOR_CHANNEL_HAIR)) +
    //             ", " +IntToString(GetColor(oPC, COLOR_CHANNEL_TATTOO_1)) +
    //             ", " +IntToString(GetColor(oPC, COLOR_CHANNEL_TATTOO_2)));
    SetColor(oTribesman, COLOR_CHANNEL_SKIN, GetColor(oPC, COLOR_CHANNEL_SKIN));
    SetColor(oTribesman, COLOR_CHANNEL_HAIR, GetColor(oPC, COLOR_CHANNEL_HAIR));
    SetColor(oTribesman, COLOR_CHANNEL_TATTOO_1, GetColor(oPC, COLOR_CHANNEL_TATTOO_1));
    SetColor(oTribesman, COLOR_CHANNEL_TATTOO_2, GetColor(oPC, COLOR_CHANNEL_TATTOO_2));
}

//------------------------------------------------------------------------------

void btribeCreateTribesmen(object oPC)
{
    // Rage Override for tribesman path.
    // Create a tribesman of the appropriate gender.
    // string sGender = GetGender(oPC) == GENDER_MALE ? "m" : "f";
    string sGender = (d2() == 1) ? "m" : "f";
    // SpeakString(sGender);

    object oTribesman = CreateObject(OBJECT_TYPE_CREATURE,
                                     "tribesman_" + sGender,
                                     GetLocation(oPC));

    // Flag that the master can RP the tribesmen.
	SetCanMasterSpeakThroughAssociate(oTribesman, TRUE);

    // Set the subrace ,appearance etc
    SetSubRace(oTribesman, GetSubRace(oPC));
    // SpeakString("Appearance: " + IntToString(GetAppearanceType(oPC)));
    SetCreatureAppearanceType(oTribesman, GetAppearanceType(oPC));

    DelayCommand(1.0, btribeSetTribesmanAppearance(oTribesman, oPC));

    // Copy the appearance of the summoner's clothing.
    object oGarb = CopyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC),
                              GetLocation(oTribesman),
                              oTribesman);
    IPRemoveAllItemProperties(oGarb, DURATION_TYPE_PERMANENT);
    IPRemoveAllItemProperties(oGarb, DURATION_TYPE_TEMPORARY);

    // dunshine: changed the armor property to a permanent effect, since they were somehow still dropping on death
    //gsIPAddItemProperty(oGarb, ItemPropertyRegeneration(3), 0.0);

    effect eTribalRegen = EffectRegenerate(3, 6.0);
    eTribalRegen = SupernaturalEffect(eTribalRegen);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTribalRegen, oTribesman, 0.0);

    SetPlotFlag(oGarb, TRUE);

    // Peppermint, 1-18-2016; Fix to ensure tribesmen cannot be interrupted while equipping armor.
    AssignCommand(oTribesman, ClearAllActions());
    AssignCommand(oTribesman, btribeEquipTribesmanArmor(oGarb));

	// Sawaki, 7-27-2018; TribalLVL determined via RageFeat
	int nLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) + (GetHitDice(oPC) / 2);
	
	if (GetHasFeat(331, oPC)) // barb rage 7
	{  
	  nLevel += 7;
	}
	else if (GetHasFeat(330, oPC)) // barb rage 6
	{  
	  nLevel += 6;
	}
	else if (GetHasFeat(329, oPC)) // barb rage 5
	{  
	  nLevel += 5;
	}
	else if (GetHasFeat(328, oPC)) // barb rage 4
	{  
	  nLevel += 4;
	}
	else if (GetHasFeat(327, oPC))  // barb rage 3
	{  
	  nLevel += 3;
	}
	else if (GetHasFeat(326, oPC)) // barb rage 2
	{  
	  nLevel += 2;
	}
	else
	{ 
	  nLevel += 1; // barb rage 1 
	}  
		
	// +2 per epic rage feat.
	if (GetHasFeat(869, oPC)) // Mighty Rage
	{ 
	  nLevel += 2;
	}
	
	if (GetHasFeat(988, oPC)) // Thundering Rage
	{ 
	  nLevel += 2;
	}
	
	if (GetHasFeat(989, oPC)) // Terrifying Rage
	{ 
	  nLevel += 2;
	}
		
    // adds Class-lvls on to the Tribal levels - Sawaki
    int nCounter;
	for (nCounter = 0; nCounter < nLevel; nCounter++)
	{
	  LevelUpHenchman(oTribesman, CLASS_TYPE_BARBARIAN);
	}
	
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        SupernaturalEffect(EffectACIncrease(nLevel / 2)),
                        oTribesman);

    // Buff weapon.
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTribesman);

    gsIPAddItemProperty(oWeapon, ItemPropertyEnhancementBonus(nLevel / 6), 0.0);

	if (!GetIsPC(oPC)) ChangeFaction(oTribesman, oPC);
	
    AddHenchman(oPC, oTribesman);
}


//------------------------------------------------------------------------------
//----- CUSTOM RAGE FEATS ------------------------------------------------------
//------------------------------------------------------------------------------

void barbEpicRageFeats(int nRounds, object oPC = OBJECT_SELF)
{

    // We're substituting our own custom scripts for the default rage feats
    // Vanilla code found in x2_i0_spells

    barbThunderingRage(nRounds, oPC);
    barbTerrifyingRage(nRounds, oPC);
}

//------------------------------------------------------------------------------

void barbThunderingRage(int nRounds, object oPC = OBJECT_SELF)
{

    // Essentially a copy of CheckAndApplyThunderingRage

    if (GetHasFeat(988, oPC))
    {
        object oWeapon =  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        if (GetIsObjectValid(oWeapon))
        {
           IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
           IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
           IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        }

        oWeapon =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        if (GetIsObjectValid(oWeapon) )
        {
           IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
           IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        }


    }
}

//------------------------------------------------------------------------------

void barbTerrifyingRage(int nRounds, object oPC = OBJECT_SELF)
{

    // We're using a custom script for terrifying rage, found in mi.inc.terrirage.nss
    if (GetHasFeat(989, oPC))
    {
        effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR,"ent_terrirage", "","");
        eAOE = ExtraordinaryEffect(eAOE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAOE, oPC, RoundsToSeconds(nRounds));
    }
}
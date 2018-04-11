//::///////////////////////////////////////////////
//:: inc_item
//:: Library: Items
//:://////////////////////////////////////////////
/*
    Contains functions for handling items
    and item properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////

#include "inc_math"
#include "nwnx_alts"
#include "x2_inc_itemprop"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Flags an item as uncopyable (e.g. by the printing press).
const string ITEM_FLAG_NO_COPY = "NO_COPY";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate spells variables from other libraries.
const string LIB_ITEM_PREFIX = "Lib_Item_";

// Item property constants.
const int ITEM_PROPERTY_INVALID = -1;
const int ITEM_PROPERTY_SUBTYPE_UNDEFINED = -1;
const int ITEM_PROPERTY_VALUE_ANY = -1;
const int ITEM_PROPERTY_VALUE_UNDEFINED = -1;

// Corresponds to the internal index for an item property's value.
const int ITEM_PROPERTY_INDEX_VALUE = 3;

// Any duration type (i.e. permanent or temporary).
const int DURATION_TYPE_ANY = 3;

// Damage type constants.
const int DAMAGE_TYPE_NONE = -1;
const int IP_CONST_DAMAGETYPE_NONE = -1;

// Equipment type constants. More generalized than item types.
const int EQUIPMENT_TYPE_INVALID = -1;
const int EQUIPMENT_TYPE_HELMET = 0;
const int EQUIPMENT_TYPE_ARMOR = 1;
const int EQUIPMENT_TYPE_BOOTS = 2;
const int EQUIPMENT_TYPE_GLOVES = 3;
const int EQUIPMENT_TYPE_WEAPON = 4;
const int EQUIPMENT_TYPE_SHIELD = 5;
const int EQUIPMENT_TYPE_CLOAK = 6;
const int EQUIPMENT_TYPE_RING = 7;
const int EQUIPMENT_TYPE_AMULET = 9;
const int EQUIPMENT_TYPE_BELT = 10;
const int EQUIPMENT_TYPE_AMMUNITION = 11;
const int EQUIPMENT_TYPE_CREATURE_WEAPON = 14;
const int EQUIPMENT_TYPE_TORCH = 15;
const int EQUIPMENT_TYPE_CREATURE_HIDE = 17;

// Weapon size constants returned via GetWeaponWeight() function. Corresponds
// to the size of a weapon in a specified creature's hands.
const int WEAPON_SIZE_INVALID = -1;
const int WEAPON_SIZE_LIGHT = 0;
const int WEAPON_SIZE_ONE_HANDED = 1;
const int WEAPON_SIZE_TWO_HANDED = 2;
const int WEAPON_SIZE_UNEQUIPPABLE = 3;

// Armor weight constants. Corresponds to proficiency required to wear the
// armor.
const int ARMOR_WEIGHT_INVALID = -1;
const int ARMOR_WEIGHT_CLOTH = 0;
const int ARMOR_WEIGHT_LIGHT = 1;
const int ARMOR_WEIGHT_MEDIUM = 2;
const int ARMOR_WEIGHT_HEAVY = 3;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Adds the values of two item properties (e.g. a +1 enhancement and +3 enhancement
// would return 4).
//
// Supports the following properties:
//   * Ability Bonus
//   * AC Bonus
//   * Attack Bonus
//   * Enhancement Bonus
//   * Damage Bonus
//   * Skill Bonus
//   * Regeneration
//
// Other property types may return unexpected values.
int AddItemPropertyValues(int nValue1, int nValue2, int nItemPropertyType = ITEM_PROPERTY_INVALID);
// Adds a stacking item property to an item. A stacking property differs in that if the
// item already has a bonus of the specified property type, then the applied bonus
// will be additive (e.g. if a weapon has +1 enhancement, and a +2 enhancement bonus
// is passed in, then a +3 bonus will actually be applied to the item).
void AddStackingItemProperty(int nDurationType, itemproperty ipProperty, object oItem, float fDuration=0.0f);
// Returns the damage bonus constant for the given damage bonus amount.
int DamageBonusConstant(int nDamageBonus, int bUseDice = FALSE);
// Converts a damage bonus cosntant into a float representing the constant's average damage value.
float DamageBonusConstantToFloat(int nDamageBonusConstant);
// Converts a damage type constant into an item property damage type constant of
// the same damage type.
int DamageTypeToIPDamageType(int nDamageType);
// Converts a float to a damage bonus constant; the damage bonus constant with the closest
// average damage value to the float will be returned. If bUseDice is TRUE, then random
// rolls will be prioritized over flat damage values (e.g. 2d4 would be returned instead
// of 5).
int FloatToDamageBonusConstant(float fFloat, int bUseDice);
// Returns the base AC value of the armor (e.g. 4 for a chain shirt). Returns -1
// on error.
int GetArmorBaseACValue(object oArmor);
// Returns one of the following armor weight constants, based on the base AC value of
// the armor:
//   0:   ARMOR_WEIGHT_CLOTH
//   1-3: ARMOR_WEIGHT_LIGHT
//   4-5: ARMOR_WEIGHT_MEDIUM
//   6-8: ARMOR_WEIGHT_HEAVY
// Returns ARMOR_WEIGHT_INVALID on error.
int GetArmorWeight(object oArmor);
// Returns the default description assigned to the designated base item type.
string GetBaseItemDefaultDescription(int nItemType);
// Returns the equipment type of an item, which is more general than item type. See constants
// in inc_item for details. Returns EQUIPMENT_TYPE_INVALID if the item cannot
// be equipped.
int GetEquipmentType(object oItem);
// Returns TRUE if the creature has the specified feat granted via an item.
int GetHasFeatOnItem(object oCreature, int nIPFeat);
// Returns the damage type constant for the type of damage dealth by the item property.
int GetIPDamageType(itemproperty ip);
// Returns TRUE if the item property grants an attack bonus of any type.
int GetIsAttackBonusItemProperty(itemproperty ip);
// Returns TRUE if the item property grants a damage bonus of any type.
int GetIsDamageBonusItemProperty(itemproperty ip);
// Returns TRUE if the item property grants an enhancement bonus of any type.
int GetIsDiceDamageBonusConstant(int nDamageBonusConstant);
// Returns TRUE if the item is a double weapon.
int GetIsDoubleWeapon(object oItem);
// Returns TRUE if the creature is dual wielding.
int GetIsDualWielding(object oCreature);
// Returns TRUE if the damage constant is a randomized value (i.e. uses dice).
int GetIsEnhancementBonusItemProperty(itemproperty ip);
// Returns TRUE if an item can be copied (e.g. via the printing press).
int GetIsItemCopyable(object oItem);
// Returns TRUE if the item can be equipped into an inventory slot.
int GetIsItemEquippable(object oItem);
// Returns TRUE if the item has been flagged as mundane (i.e. can be used by classes
// ordinarily barred from using magic and in non-magic areas).
int GetIsItemMundane(object oItem);
// Returns the "stacked" value of the item property for oItem (e.g. if +1 enhancement
// is passed in, and the item has a +2 enhancement currently, then 2 will be returned).
int GetItemPropertyStackedValue(object oItem, itemproperty ipProperty);
// Returns a number corresponding to the "value" of the specified property on the item
// (e.g. an item with a +3 strength bonus would return 3 if a strength ability
// bonus parameter is given).
int GetItemPropertyValue(object oItem, int nItemPropertyType, int nDurationType = DURATION_TYPE_PERMANENT, int nParam1Value = ITEM_PROPERTY_VALUE_UNDEFINED, int nSubtype = ITEM_PROPERTY_SUBTYPE_UNDEFINED);
// Returns the last item the creature used as flagged via the item activated event.
object GetLastItemUsed(object oCreature);
// Returns a weapon's damage type. If a weapon deals more than one damage type, then
// only one of them will be returned.
int GetMatchingDamageType(object oItem);
// Returns a weapon's damage type as an itembproperty constant. If a weapon deals more than
// one damage type, then only one of them will be returned.
int GetMatchingIPDamageType(object oItem);
// Returns a weapon damage type.
int GetWeaponDamageType(object oItem);
// Returns the size of a weapon in the wielder's hands. Possible return values:
//   * WEAPON_SIZE_INVALID (not a weapon or oWielder not a creature)
//   * WEAPON_SIZE_LIGHT
//   * WEAPON_SIZE_ONE_HANDED
//   * WEAPON_SIZE_TWO_HANDED
//   * WEAPON_SIZE_UNEQUIPPABLE
int GetWeaponSize(object oWeapon, object oWielder = OBJECT_SELF);
// Converts an item property attack bonus constant into an enhancement bonus constant.
int IPAttackBonusToIPEnhancementBonus(int nIPAttackBonus);
// Converts an item property damage bonus constant into an enhancement bonus constant.
int IPDamageBonusToIPEnhancementBonus(int nIPDamageBonus);
// Converts an item property damage type constant into a standard damage type constant.
int IPDamageTypeToDamageType(int nIPDamageType);
// Removes all item properties matching the specified parameters from the item. Use
// this function with care. Results are permanent.
void RemoveAllItemProperties(object oItem, int nDurationType = DURATION_TYPE_ANY);
// Removes all item properties of the specified type from the item.
void RemoveMatchingItemProperties(object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY,
    int nItemPropertySubType = ITEM_PROPERTY_SUBTYPE_UNDEFINED, int nItemPropertyValue = ITEM_PROPERTY_VALUE_ANY);
// Flags whether an item can be copied (e.g. by the printing press).
void SetIsItemCopyable(object oItem, int bCopyable);
// Sets the item's mundane flag, which allows it to be used by classes ordinarily barred
// from using magic and in non-magic areas.
void SetIsItemMundane(object oItem, int bIsMundane);
// Call from the item activated script to store the last item used for future reference.
void StoreLastItemUsed();
// Checks whether the item's ILR has been set, and if not, sets it.
void SetItemILR(object oItem);
// return value of oItem (disregarding plot flag etc.) - moved from gs_inc_common 
int gsCMGetItemValue(object oItem);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: gsCMGetItemValue
//:://////////////////////////////////////////////
/*
    Gets the value of an item, resetting the plot
	and identified flags as needed.
	
	Note: this function has been moved from 
	gs_inc_common, as it is needed here (and belongs
	here as an item-related function).  However, it's
	called in about 20 places so hasn't been renamed 
	yet.
*/
//:://////////////////////////////////////////////
//:: Created By: Gigaschatten
//:: Created On: c.2004
//:://////////////////////////////////////////////
//----------------------------------------------------------------
int gsCMGetItemValue(object oItem)
{
    int nPlot    = GetPlotFlag(oItem);
    int nUnknown = ! GetIdentified(oItem);
    int nValue   = 0;

    if (nPlot)    SetPlotFlag(oItem, FALSE);
    if (nUnknown) SetIdentified(oItem, TRUE);

    nValue       = GetGoldPieceValue(oItem);

    if (nPlot)    SetPlotFlag(oItem, TRUE);
    if (nUnknown) SetIdentified(oItem, FALSE);

    return nValue;
}
//::///////////////////////////////////////////////
//:: AddItemPropertyValues
//:://////////////////////////////////////////////
/*
    Adds the values of two item properties
    (e.g. a +1 enhancement and +3 enhancement
    would return 4).

    Supports the following properties:
        * Ability Bonus
        * AC Bonus
        * Attack Bonus
        * Enhancement Bonus
        * Damage Bonus
        * Skill Bonus
        * Regeneration

    Other property types may return unexpected
    values.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int AddItemPropertyValues(int nValue1, int nValue2, int nItemPropertyType = ITEM_PROPERTY_INVALID)
{
    switch(nItemPropertyType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 12);
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            return ClampInt(nValue1 + nValue2, 1, 12);
        case ITEM_PROPERTY_AC_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ATTACK_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_SKILL_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 50);
        case ITEM_PROPERTY_DAMAGE_BONUS:
            return ClampInt(FloatToDamageBonusConstant(DamageBonusConstantToFloat(nValue1) + DamageBonusConstantToFloat(nValue2),
                GetIsDiceDamageBonusConstant(nValue1) || GetIsDiceDamageBonusConstant(nValue2)), IP_CONST_DAMAGEBONUS_1, IP_CONST_DAMAGEBONUS_10);
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
            return ClampInt(FloatToDamageBonusConstant(DamageBonusConstantToFloat(nValue1) + DamageBonusConstantToFloat(nValue2),
                GetIsDiceDamageBonusConstant(nValue1) || GetIsDiceDamageBonusConstant(nValue2)), IP_CONST_DAMAGEBONUS_1, IP_CONST_DAMAGEBONUS_10);
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
            return ClampInt(FloatToDamageBonusConstant(DamageBonusConstantToFloat(nValue1) + DamageBonusConstantToFloat(nValue2),
                GetIsDiceDamageBonusConstant(nValue1) || GetIsDiceDamageBonusConstant(nValue2)), IP_CONST_DAMAGEBONUS_1, IP_CONST_DAMAGEBONUS_10);
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ClampInt(FloatToDamageBonusConstant(DamageBonusConstantToFloat(nValue1) + DamageBonusConstantToFloat(nValue2),
                GetIsDiceDamageBonusConstant(nValue1) || GetIsDiceDamageBonusConstant(nValue2)), IP_CONST_DAMAGEBONUS_1, IP_CONST_DAMAGEBONUS_10);
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            return ClampInt(nValue1 + nValue2, 1, 20);
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
            return ClampInt(nValue1 + nValue2, 1, 5);
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
            return ClampInt(nValue1 + nValue2, 1, 5);
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
            return ClampInt(nValue1 + nValue2, 1, 50);
        case ITEM_PROPERTY_REGENERATION:
            return ClampInt(nValue1 + nValue2, 1, 20);
    }
    return nValue1 + nValue2;
}

//::///////////////////////////////////////////////
//:: AddStackingItemProperty
//:://////////////////////////////////////////////
/*
    Adds a stacking item property to an item.
    A stacking property differs in that if the
    item already has a bonus of the specified
    property type, then the applied bonus
    will be additive (e.g. if a weapon has
    +1 enhancement, and a +2 enhancement bonus
    is passed in, then a +3 bonus will
    actually be applied to the item).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
void AddStackingItemProperty(int nDurationType, itemproperty ipProperty, object oItem, float fDuration=0.0f)
{
    int nValue = nDurationType == DURATION_TYPE_TEMPORARY ? GetItemPropertyCostTableValue(ipProperty) : ITEM_PROPERTY_VALUE_ANY;

    ipProperty = SetItemPropertyInteger(ipProperty, ITEM_PROPERTY_INDEX_VALUE, GetItemPropertyStackedValue(oItem, ipProperty));
    RemoveMatchingItemProperties(oItem, GetItemPropertyType(ipProperty), nDurationType, GetItemPropertySubType(ipProperty), nValue);
    AddItemProperty(nDurationType, ipProperty, oItem, fDuration);
}

//::///////////////////////////////////////////////
//:: DamageBonusConstant
//:://////////////////////////////////////////////
/*
    Returns the damage bonus constant for
    the given damage bonus amount.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 10, 2016
//:://////////////////////////////////////////////
int DamageBonusConstant(int nDamageBonus, int bUseDice = FALSE)
{
    return FloatToDamageBonusConstant(IntToFloat(nDamageBonus), bUseDice);
}

//::///////////////////////////////////////////////
//:: DamageBonusConstantToFloat
//:://////////////////////////////////////////////
/*
    Converts a damage bonus constant into a float
    representing the constant's average damage
    value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
float DamageBonusConstantToFloat(int nDamageBonusConstant)
{
    switch(nDamageBonusConstant)
    {
        case DAMAGE_BONUS_1: return 1.0;
        case DAMAGE_BONUS_10: return 10.0;
        case DAMAGE_BONUS_11: return 11.0;
        case DAMAGE_BONUS_12: return 12.0;
        case DAMAGE_BONUS_13: return 13.0;
        case DAMAGE_BONUS_14: return 14.0;
        case DAMAGE_BONUS_15: return 15.0;
        case DAMAGE_BONUS_16: return 16.0;
        case DAMAGE_BONUS_17: return 17.0;
        case DAMAGE_BONUS_18: return 18.0;
        case DAMAGE_BONUS_19: return 19.0;
        case DAMAGE_BONUS_1d10: return 5.5;
        case DAMAGE_BONUS_1d12: return 6.5;
        case DAMAGE_BONUS_1d4: return 2.5;
        case DAMAGE_BONUS_1d6: return 3.5;
        case DAMAGE_BONUS_1d8: return 4.5;
        case DAMAGE_BONUS_2: return 2.0;
        case DAMAGE_BONUS_20: return 20.0;
        case DAMAGE_BONUS_2d10: return 11.0;
        case DAMAGE_BONUS_2d12: return 13.0;
        case DAMAGE_BONUS_2d4: return 5.0;
        case DAMAGE_BONUS_2d6: return 7.0;
        case DAMAGE_BONUS_2d8: return 9.0;
        case DAMAGE_BONUS_3: return 3.0;
        case DAMAGE_BONUS_4: return 4.0;
        case DAMAGE_BONUS_5: return 5.0;
        case DAMAGE_BONUS_6: return 6.0;
        case DAMAGE_BONUS_7: return 7.0;
        case DAMAGE_BONUS_8: return 8.0;
        case DAMAGE_BONUS_9: return 9.0;
    }
    return 0.0;
}

//::///////////////////////////////////////////////
//:: DamageTypeToIPDamageType
//:://////////////////////////////////////////////
/*
    Converts a damage type constant into
    an item property damage type constant of
    the same damage type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int DamageTypeToIPDamageType(int nDamageType)
{
    switch(nDamageType)
    {
        case DAMAGE_TYPE_BLUDGEONING: return IP_CONST_DAMAGETYPE_BLUDGEONING;
        case DAMAGE_TYPE_PIERCING: return IP_CONST_DAMAGETYPE_PIERCING;
        case DAMAGE_TYPE_SLASHING: return IP_CONST_DAMAGETYPE_SLASHING;
        case DAMAGE_TYPE_MAGICAL: return IP_CONST_DAMAGETYPE_MAGICAL;
        case DAMAGE_TYPE_ACID: return IP_CONST_DAMAGETYPE_ACID;
        case DAMAGE_TYPE_COLD: return IP_CONST_DAMAGETYPE_COLD;
        case DAMAGE_TYPE_DIVINE: return IP_CONST_DAMAGETYPE_DIVINE;
        case DAMAGE_TYPE_ELECTRICAL: return IP_CONST_DAMAGETYPE_ELECTRICAL;
        case DAMAGE_TYPE_FIRE: return IP_CONST_DAMAGETYPE_FIRE;
        case DAMAGE_TYPE_NEGATIVE: return IP_CONST_DAMAGETYPE_NEGATIVE;
        case DAMAGE_TYPE_POSITIVE: return IP_CONST_DAMAGETYPE_POSITIVE;
        case DAMAGE_TYPE_SONIC: return IP_CONST_DAMAGETYPE_SONIC;
    }
    return IP_CONST_DAMAGETYPE_NONE;
}

//::///////////////////////////////////////////////
//:: FloatToDamageBonusConstant
//:://////////////////////////////////////////////
/*
    Converts a float to a damage bonus constant;
    the damage bonus constant with the closest
    average damage value to the float will be
    returned. If bUseDice is TRUE, then random
    rolls will be prioritized over flat damage
    values (e.g. 2d4 would be returned instead
    of 5).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int FloatToDamageBonusConstant(float fFloat, int bUseDice)
{
    if(fFloat >= 20.0) return DAMAGE_BONUS_20;
    if(fFloat >= 19.0) return DAMAGE_BONUS_19;
    if(fFloat >= 18.0) return DAMAGE_BONUS_18;
    if(fFloat >= 17.0) return DAMAGE_BONUS_17;
    if(fFloat >= 16.0) return DAMAGE_BONUS_16;
    if(fFloat >= 15.0) return DAMAGE_BONUS_15;
    if(fFloat >= 14.0) return DAMAGE_BONUS_14;
    if(fFloat >= 13.0) return bUseDice ? DAMAGE_BONUS_2d12 : DAMAGE_BONUS_13;
    if(fFloat >= 12.0) return DAMAGE_BONUS_12;
    if(fFloat >= 11.0) return bUseDice ? DAMAGE_BONUS_2d10 : DAMAGE_BONUS_11;
    if(fFloat >= 10.0) return DAMAGE_BONUS_10;
    if(fFloat >= 9.0) return bUseDice ? DAMAGE_BONUS_2d8 : DAMAGE_BONUS_9;
    if(fFloat >= 8.0) return DAMAGE_BONUS_8;
    if(fFloat >= 7.0) return bUseDice ? DAMAGE_BONUS_2d6 : DAMAGE_BONUS_7;
    if(fFloat >= 6.5) return DAMAGE_BONUS_1d12;
    if(fFloat >= 6.0) return DAMAGE_BONUS_6;
    if(fFloat >= 5.5) return DAMAGE_BONUS_1d10;
    if(fFloat >= 5.0) return bUseDice ? DAMAGE_BONUS_2d4 : DAMAGE_BONUS_5;
    if(fFloat >= 4.5) return DAMAGE_BONUS_1d8;
    if(fFloat >= 4.0) return DAMAGE_BONUS_4;
    if(fFloat >= 3.5) return DAMAGE_BONUS_1d6;
    if(fFloat >= 3.0) return DAMAGE_BONUS_3;
    if(fFloat >= 2.5) return DAMAGE_BONUS_1d4;
    if(fFloat >= 2.0) return DAMAGE_BONUS_2;
    return DAMAGE_BONUS_1;
}

//::///////////////////////////////////////////////
//:: GetArmorBaseACValue
//:://////////////////////////////////////////////
/*
    Returns the base AC value of the armor
    (e.g. 4 for a chain shirt). Returns -1
    on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 13, 2016
//:://////////////////////////////////////////////
int GetArmorBaseACValue(object oArmor)
{
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR) return -1;

    int nAC = -1;
    int bIdentified = GetIdentified(oArmor);

    SetIdentified(oArmor, FALSE);
    switch(GetGoldPieceValue(oArmor))
    {
        case 1:    nAC = 0; break;
        case 5:    nAC = 1; break;
        case 10:   nAC = 2; break;
        case 15:   nAC = 3; break;
        case 100:  nAC = 4; break;
        case 150:  nAC = 5; break;
        case 200:  nAC = 6; break;
        case 600:  nAC = 7; break;
        case 1500: nAC = 8; break;
    }
    SetIdentified(oArmor, bIdentified);

    return nAC;
}

//::///////////////////////////////////////////////
//:: GetArmorWeight
//:://////////////////////////////////////////////
/*
    Returns one of the following armor weight
    constants, based on the base AC value of
    the armor:
        0:   ARMOR_WEIGHT_CLOTH
        1-3: ARMOR_WEIGHT_LIGHT
        4-5: ARMOR_WEIGHT_MEDIUM
        6-8: ARMOR_WEIGHT_HEAVY
    Returns ARMOR_WEIGHT_INVALID on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 13, 2015
//:://////////////////////////////////////////////
int GetArmorWeight(object oArmor)
{
    switch(GetArmorBaseACValue(oArmor))
    {
        case 0: return ARMOR_WEIGHT_CLOTH;
        case 1:
        case 2:
        case 3: return ARMOR_WEIGHT_LIGHT;
        case 4:
        case 5: return ARMOR_WEIGHT_MEDIUM;
        case 6:
        case 7:
        case 8: return ARMOR_WEIGHT_HEAVY;
    }
    return ARMOR_WEIGHT_INVALID;
}

//::///////////////////////////////////////////////
//:: GetBaseItemDefaultDescription
//:://////////////////////////////////////////////
/*
    Returns the default description assigned
    to the designated base item type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
string GetBaseItemDefaultDescription(int nItemType)
{
    return GetStringByStrRef(StringToInt(Get2DAString("baseitems", "Description", nItemType)));
}

//::///////////////////////////////////////////////
//:: GetEquipmentType
//:://////////////////////////////////////////////
/*
    Returns the equipment type of an item, which
    is more general than item type. See constants
    in inc_item for details. Returns
    EQUIPMENT_TYPE_INVALID if the item cannot
    be equipped.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: April 14, 2016
//:://////////////////////////////////////////////
int GetEquipmentType(object oItem)
{
    switch(GetBaseItemType(oItem))
    {
        case BASE_ITEM_HELMET:
            return EQUIPMENT_TYPE_HELMET;
        case BASE_ITEM_ARMOR:
            return EQUIPMENT_TYPE_ARMOR;
        case BASE_ITEM_BOOTS:
            return EQUIPMENT_TYPE_BOOTS;
        case BASE_ITEM_BRACER:
        case BASE_ITEM_GLOVES:
            return EQUIPMENT_TYPE_GLOVES;
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DART:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_SLING:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
            return EQUIPMENT_TYPE_WEAPON;
        case BASE_ITEM_TOWERSHIELD:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
            return EQUIPMENT_TYPE_SHIELD;
        case BASE_ITEM_CLOAK:
            return EQUIPMENT_TYPE_CLOAK;
        case BASE_ITEM_RING:
            return EQUIPMENT_TYPE_RING;
        case BASE_ITEM_AMULET:
            return EQUIPMENT_TYPE_AMULET;
        case BASE_ITEM_BELT:
            return EQUIPMENT_TYPE_BELT;
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
            return EQUIPMENT_TYPE_AMMUNITION;
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            return EQUIPMENT_TYPE_CREATURE_WEAPON;
        case BASE_ITEM_TORCH:
            return EQUIPMENT_TYPE_TORCH;
        case BASE_ITEM_CREATUREITEM:
            return EQUIPMENT_TYPE_CREATURE_HIDE;
    }
    return EQUIPMENT_TYPE_INVALID;
}

//::///////////////////////////////////////////////
//:: GetHasFeatOnItem
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature has the
    specified feat granted via an item.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetHasFeatOnItem(object oCreature, int nIPFeat)
{
    itemproperty ip;
    int nSlot;
    object oItem;

    for(nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; ++nSlot)
    {
        oItem = GetItemInSlot(nSlot, oCreature);
        ip = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT && GetItemPropertySubType(ip) == nIPFeat)
            {
                return TRUE;
            }
            ip = GetNextItemProperty(oItem);
        }
    }

    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetIsAttackBonusItemProperty
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item property grants
    an attack bonus of any type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetIsAttackBonusItemProperty(itemproperty ip)
{
    return GetItemPropertyType(ip) >= ITEM_PROPERTY_ATTACK_BONUS && GetItemPropertyType(ip) <= ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT;
}

//::///////////////////////////////////////////////
//:: GetIsDamageBonusItemProperty
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item property grants
    a damage bonus of any type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetIsDamageBonusItemProperty(itemproperty ip)
{
    return GetItemPropertyType(ip) >= ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertyType(ip) <= ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT;
}

//::///////////////////////////////////////////////
//:: GetIsDoubleWeapon
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item is a double weapon.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetIsDoubleWeapon(object oItem)
{
    return (StringToInt(Get2DAString("baseitems", "WeaponWield", GetBaseItemType(oItem))) == 8);
}

//::///////////////////////////////////////////////
//:: GetIsDualWielding
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature is dual wielding.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
int GetIsDualWielding(object oCreature)
{
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);

    return ((GetIsObjectValid(oRight) && GetIsObjectValid(oLeft) && oRight != oLeft && GetEquipmentType(oLeft) == EQUIPMENT_TYPE_WEAPON)
                || GetIsDoubleWeapon(oRight));
}

//::///////////////////////////////////////////////
//:: GetIPDamageType
//:://////////////////////////////////////////////
/*
    Returns the damage type constant for the
    type of damage dealt by the item property.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: April 25, 2016
//:://////////////////////////////////////////////
int GetIPDamageType(itemproperty ip)
{
    return IPDamageTypeToDamageType(GetItemPropertySubType(ip));
}

//::///////////////////////////////////////////////
//:: GetIsEnhancementBonusItemProperty
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item property grants
    an enhancement bonus of any type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetIsEnhancementBonusItemProperty(itemproperty ip)
{
    return GetItemPropertyType(ip) >= ITEM_PROPERTY_ENHANCEMENT_BONUS && GetItemPropertyType(ip) <= ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT;
}

//::///////////////////////////////////////////////
//:: GetIsDiceDamageBonusConstant
//:://////////////////////////////////////////////
/*
    Returns TRUE if the damage constant is
    a randomized value (i.e. uses dice).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetIsDiceDamageBonusConstant(int nDamageBonusConstant)
{
    switch(nDamageBonusConstant)
    {
        case DAMAGE_BONUS_1d10:
        case DAMAGE_BONUS_1d12:
        case DAMAGE_BONUS_1d4:
        case DAMAGE_BONUS_1d6:
        case DAMAGE_BONUS_1d8:
        case DAMAGE_BONUS_2d10:
        case DAMAGE_BONUS_2d12:
        case DAMAGE_BONUS_2d4:
        case DAMAGE_BONUS_2d6:
        case DAMAGE_BONUS_2d8:
            return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetIsItemCopyable
//:://////////////////////////////////////////////
/*
    Returns TRUE if an item can be copied
    (e.g. via the printing press).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
int GetIsItemCopyable(object oItem)
{
    // dunshine, extra exception here for ir_bookofsouls and slave, old versions shouldn't be copyable as well
    if ((GetTag(oItem) == "ir_bookofsouls") || (GetTag(oItem) == "DrowSlaversHandbook")) return 0;

    return !GetLocalInt(oItem, ITEM_FLAG_NO_COPY);
}

//::///////////////////////////////////////////////
//:: GetIsItemEquippable
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item can be equipped
    into an inventory slot.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 21, 2016
//:://////////////////////////////////////////////
int GetIsItemEquippable(object oItem)
{
    return Get2DAString("baseitems", "EquipableSlots", GetBaseItemType(oItem)) != "0x00000";
}

//::///////////////////////////////////////////////
//:: GetIsItemMundane
//:://////////////////////////////////////////////
/*
    Returns TRUE if the item has been mundane
    (i.e. can be used by classes ordinarily
    barred from using magic and in non-magic
    areas).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 21, 2016
//:://////////////////////////////////////////////
int GetIsItemMundane(object oItem)
{
    return GetLocalInt(oItem, "IS_MUNDANE");
}

//::///////////////////////////////////////////////
//:: GetItemPropertyValue
//:://////////////////////////////////////////////
/*
    Returns a number corresponding to the "value"
    of the specified property on the item
    (e.g. an item with a +3 strength bonus
    would return 3 if a strength ability
    bonus parameter is given).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetItemPropertyValue(object oItem, int nItemPropertyType, int nDurationType = DURATION_TYPE_PERMANENT, int nParam1Value = ITEM_PROPERTY_VALUE_UNDEFINED, int nSubtype = ITEM_PROPERTY_SUBTYPE_UNDEFINED)
{
    int nBonus;
    itemproperty ip = GetFirstItemProperty(oItem);

    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == nDurationType
            && GetItemPropertyType(ip) == nItemPropertyType
            && (nParam1Value == ITEM_PROPERTY_VALUE_UNDEFINED || GetItemPropertyParam1Value(ip) == nParam1Value)
            && (nSubtype == ITEM_PROPERTY_SUBTYPE_UNDEFINED || GetItemPropertySubType(ip) == nSubtype)
            && GetItemPropertyCostTableValue(ip) > nBonus)
        {
            nBonus = GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oItem);
    }

    return nBonus;
}

//::///////////////////////////////////////////////
//:: GetItemPropertyStackedValue
//:://////////////////////////////////////////////
/*
    Returns the "stacked" value of the item
    property for oItem (e.g. if +1 enhancement
    is passed in, and the item has a +2 enhancement
    currently, then 2 will be returned).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: April 11, 2016
//:://////////////////////////////////////////////
int GetItemPropertyStackedValue(object oItem, itemproperty ipProperty)
{
    int nCurrentValue;

    if(GetIsAttackBonusItemProperty(ipProperty) || (GetIsDamageBonusItemProperty(ipProperty) && GetWeaponDamageType(oItem) & IPDamageTypeToDamageType(GetItemPropertySubType(ipProperty))))
    {
        if(GetItemPropertyValue(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_PERMANENT)
            > GetItemPropertyValue(oItem, GetItemPropertyType(ipProperty), DURATION_TYPE_PERMANENT, GetItemPropertyParam1Value(ipProperty), GetItemPropertySubType(ipProperty)))
        {
            // Special handling required for attack and damage bonus properties to ensure the bonus stacks with enhancement on the
            // item. If the weapon has a greater enhancement bonus than its current attack/damage bonus, then we use the
            // enhancement bonus as a floor.
            nCurrentValue = GetItemPropertyValue(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_PERMANENT);
        }
    }
    if(!nCurrentValue)
    {
        nCurrentValue = GetItemPropertyValue(oItem, GetItemPropertyType(ipProperty), DURATION_TYPE_PERMANENT, GetItemPropertyParam1Value(ipProperty), GetItemPropertySubType(ipProperty));
    }
    return AddItemPropertyValues(nCurrentValue, GetItemPropertyCostTableValue(ipProperty), GetItemPropertyType(ipProperty));
}

//::///////////////////////////////////////////////
//:: GetLastItemUsed
//:://////////////////////////////////////////////
/*
    Returns the last item the creature used
    as flagged via the item activated event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////
object GetLastItemUsed(object oCreature)
{
    return GetLocalObject(oCreature, LIB_ITEM_PREFIX + "LAST_ITEM_USED");
}

//::///////////////////////////////////////////////
//:: GetMatchingDamageType
//:://////////////////////////////////////////////
/*
    Returns a weapon's damage type. If a weapon
    deals more than one damage type, then only
    one of them will be returned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetMatchingDamageType(object oItem)
{
    int nWeaponDamageType = GetWeaponDamageType(oItem);

    if(nWeaponDamageType & DAMAGE_TYPE_BLUDGEONING)
        return DAMAGE_TYPE_BLUDGEONING;
    if(nWeaponDamageType & DAMAGE_TYPE_SLASHING)
        return DAMAGE_TYPE_SLASHING;
    if(nWeaponDamageType & DAMAGE_TYPE_PIERCING)
        return DAMAGE_TYPE_PIERCING;
    return DAMAGE_TYPE_NONE;
}

//::///////////////////////////////////////////////
//:: GetMatchingIPDamageType
//:://////////////////////////////////////////////
/*
    Returns a weapon's damage type as an item
    property constant. If a weapon deals more than
    one damage type, then only one of them will
    be returned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: April 25, 2016
//:://////////////////////////////////////////////
int GetMatchingIPDamageType(object oItem)
{
    return DamageTypeToIPDamageType(GetMatchingDamageType(oItem));
}

//::///////////////////////////////////////////////
//:: GetWeaponDamageType
//:://////////////////////////////////////////////
/*
    Returns a weapon damage type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int GetWeaponDamageType(object oItem)
{
    int nItemType = GetBaseItemType(oItem);

    switch(nItemType)
    {
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BOLT:
            return DAMAGE_TYPE_PIERCING;
        case BASE_ITEM_BULLET:
            return DAMAGE_TYPE_BLUDGEONING;
        default:
        {
            switch(StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)))
            {
                case 1: return DAMAGE_TYPE_PIERCING;
                case 2: return DAMAGE_TYPE_BLUDGEONING;
                case 3: return DAMAGE_TYPE_SLASHING;
                case 4: return DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING;
                case 5: return DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING;
            }
        }
    }

    return DAMAGE_TYPE_NONE;
}

//::///////////////////////////////////////////////
//:: GetWeaponSize
//:://////////////////////////////////////////////
/*
    Returns the size of a weapon in the
    wielder's hands. Possible return values:
        * WEAPON_SIZE_INVALID
            (not a weapon or oWielder not a creature)
        * WEAPON_SIZE_LIGHT
        * WEAPON_SIZE_ONE_HANDED
        * WEAPON_SIZE_TWO_HANDED
        * WEAPON_SIZE_UNEQUIPPABLE
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 8, 2016
//:://////////////////////////////////////////////
int GetWeaponSize(object oWeapon, object oWielder = OBJECT_SELF)
{
    int nWeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oWeapon)));

    return (GetObjectType(oWielder) == OBJECT_TYPE_CREATURE && nWeaponSize) ?
        ClampInt(nWeaponSize - GetCreatureSize(oWielder) + 1, WEAPON_SIZE_LIGHT, WEAPON_SIZE_UNEQUIPPABLE) :
        WEAPON_SIZE_INVALID;
}

//::///////////////////////////////////////////////
//:: IPAttackBonusToIPEnhancementBonus
//:://////////////////////////////////////////////
/*
    Converts an item property attack bonus
    constant into an enhancement bonus constant.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int IPAttackBonusToIPEnhancementBonus(int nIPAttackBonus)
{
    return nIPAttackBonus - 50;
}

//::///////////////////////////////////////////////
//:: IPDamageBonusToIPEnhancementBonus
//:://////////////////////////////////////////////
/*
    Converts an item property damage bonus
    constant into an enhancement bonus constant.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int IPDamageBonusToIPEnhancementBonus(int nIPDamageBonus)
{
    return nIPDamageBonus - 10;
}

//::///////////////////////////////////////////////
//:: IPDamageTypeToDamageType
//:://////////////////////////////////////////////
/*
    Converts an item property damage type constant
    into a standard damage type constant.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
int IPDamageTypeToDamageType(int nIPDamageType)
{
    switch(nIPDamageType)
    {
        case IP_CONST_DAMAGETYPE_BLUDGEONING: return DAMAGE_TYPE_BLUDGEONING;
        case IP_CONST_DAMAGETYPE_PIERCING: return DAMAGE_TYPE_PIERCING;
        case IP_CONST_DAMAGETYPE_SLASHING: return DAMAGE_TYPE_SLASHING;
        case IP_CONST_DAMAGETYPE_MAGICAL: return DAMAGE_TYPE_MAGICAL;
        case IP_CONST_DAMAGETYPE_ACID: return DAMAGE_TYPE_ACID;
        case IP_CONST_DAMAGETYPE_COLD: return DAMAGE_TYPE_COLD;
        case IP_CONST_DAMAGETYPE_DIVINE: return DAMAGE_TYPE_DIVINE;
        case IP_CONST_DAMAGETYPE_ELECTRICAL: return DAMAGE_TYPE_ELECTRICAL;
        case IP_CONST_DAMAGETYPE_FIRE: return DAMAGE_TYPE_FIRE;
        case IP_CONST_DAMAGETYPE_NEGATIVE: return DAMAGE_TYPE_NEGATIVE;
        case IP_CONST_DAMAGETYPE_POSITIVE: return DAMAGE_TYPE_POSITIVE;
        case IP_CONST_DAMAGETYPE_SONIC: return DAMAGE_TYPE_SONIC;
    }
    return DAMAGE_TYPE_NONE;
}

//::///////////////////////////////////////////////
//:: RemoveAllItemProperties
//:://////////////////////////////////////////////
/*
    Removes all item properties matching the
    specified parameters from the item. Use
    this function with care. Results are permanent.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
void RemoveAllItemProperties(object oItem, int nDurationType = DURATION_TYPE_ANY)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) & nDurationType)
        {
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
}

//::///////////////////////////////////////////////
//:: RemoveMatchingItemProperties
//:://////////////////////////////////////////////
/*
    Removes all item properties of the specified
    type from the item.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 28, 2016
//:://////////////////////////////////////////////
void RemoveMatchingItemProperties(object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY,
    int nItemPropertySubType = ITEM_PROPERTY_SUBTYPE_UNDEFINED, int nItemPropertyValue = ITEM_PROPERTY_VALUE_ANY)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == nItemPropertyType
            && GetItemPropertyDurationType(ip) == nItemPropertyDuration
            && (nItemPropertySubType == ITEM_PROPERTY_SUBTYPE_UNDEFINED || GetItemPropertySubType(ip) == nItemPropertySubType)
            && (nItemPropertyValue == ITEM_PROPERTY_VALUE_ANY || GetItemPropertyCostTableValue(ip) == nItemPropertyValue))
        {
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
}

//::///////////////////////////////////////////////
//:: SetIsItemCopyable
//:://////////////////////////////////////////////
/*
    Flags whether an item can be copied (e.g.
    by the printing press).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
void SetIsItemCopyable(object oItem, int bCopyable)
{
    SetLocalInt(oItem, ITEM_FLAG_NO_COPY, !bCopyable);
}

//::///////////////////////////////////////////////
//:: SetIsItemMundane
//:://////////////////////////////////////////////
/*
    Sets the item's mundane flag, which allows
    it to be used by classes ordinarily barred
    from using magic and in non-magic areas.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 21, 2016
//:://////////////////////////////////////////////
void SetIsItemMundane(object oItem, int bIsMundane)
{
    SetLocalInt(oItem, "IS_MUNDANE", bIsMundane);
}

//::///////////////////////////////////////////////
//:: StoreLastItemUsed
//:://////////////////////////////////////////////
/*
    Call from the item activated script to store
    the last item used for future reference.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////
void StoreLastItemUsed()
{
    SetLocalObject(GetItemActivator(), LIB_ITEM_PREFIX + "LAST_ITEM_USED", GetItemActivated());
}
//::///////////////////////////////////////////////
//:: SetItemILR
//:://////////////////////////////////////////////
/*
    Checks whether the item's ILR variable has
	been set, and if not, sets it.
*/
//:://////////////////////////////////////////////
//:: Created By: Mithreas
//:: Created On: April 8, 2017
//:://////////////////////////////////////////////
void SetItemILR(object oItem)
{
  if (GetLocalInt(oItem, "ILR")) return;
  
  // For now, apply ILR to weapons only.
  if (GetEquipmentType(oItem) != EQUIPMENT_TYPE_WEAPON) return;
  
  int nValue = gsCMGetItemValue(oItem);
  int nILR = 0;
  
  if (nValue < 2000) nILR = 1;
  else if (nValue < 4000) nILR = 4;
  else if (nValue < 7000) nILR = 7;
  else if (nValue < 15000) nILR = 10;
  else if (nValue < 30000) nILR = 13;
  else nILR = 16;

  SetLocalInt(oItem, "ILR", nILR);  
}
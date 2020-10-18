// This file governs loot generation.
// To use this, you need to do a few things ...
//
// First of all, each the loot system works based on "loot scripts".
//
// Each loot script "tag" needs a number of corresponding scripts:
//
// [mandatory] [called once]
// - lgen_tag_1: The first phase of loot generation is simple. The lgen script must call two functions:
//
//                   1. LGEN_SetMinPropertyCount(int min)
//                   1. LGEN_SetMaxPropertyCount(int max)
//
// [optional] [called once per property]
// - lgen_tag_2: The second phase of loot generation is OPTIONAL.
//               If the lgen script desires, it can set up a subset of properties that can be chosen by
//               using the API exposed in inc_data_arr, as such ...
//
//                   1. IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, 1)
//
//               If a set is not provided, the loot generation system will use all available properties.
//
// [mandatory] [called once per property]
// - lgen_tag_3: The third phase of loot generation requires the lgen script to do two things.
//
//               First, the loot lgen script should call LGEN_GetChosenProperty().
//               This will return the PROPERTY_* constant which the loot generation system has chosen based
//               on the provided random set from the previous phase, or containing all properties if none.
//
//               Second, the lgen script should call four functions --
//
//                   1. LGEN_SetMinProperty1Value(int min)
//                   2. LGEN_SetMaxProperty1Value(int max)
//                   3. LGEN_SetMinProperty2Value(int min)
//                   4. LGEN_SetMaxProperty2Value(int max)
//
//               These functions will set the minimum and maximum extents for mod1 and mod2.
//               See the below comments which outline mod1 and mo2 for each property.
//
//               TODO: Set property cost in terms of 'slots' (see phase 1), so we can make one property occupy
//               more than one slot.
//
//               ALTERNATIVELY, the lgen script may instead set up a random set using the functionality
//               exposed by inc_data_arr (as in stage 2) for one or both of the mods, as such ...
//
//                   1. IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, 1)
//                   2. IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 1)
//
//               If one or more values are present in the sets named above, the min and max property values
//               will be ignored for the respective category.
//
//               Note that this script may be called more than the property count times. This is because
//               the loot generation algorithm may fail during the population of mod1 and mod2, e.g. due
//               to the useless property protection.
//
// [optional] [called once]
// - lgen_tag_4: This is an optional script which is called once lot generation has finished but before the
//               object has been cleaned up -- e.g., all variables are still available for inspection.
//               It can be used to add any additional properties that need more fine-grained control outside
//               of the generic loot generation system.
//
// [optional] [called once]
// - lgen_tag_5: This is an optional script which is called once loot generation has finished completely.
//               All variables have been purged, and the generic name and description have been applied to the item.
//               This script can be used to name and describe items.
//
// The mod-map is as follows:
//
//     [id: PROPERTY_AC_BONUS] [mod1: bonus]
//     [id: PROPERTY_AC_BONUS_VS_RACE] [mod1: race] [mod2: bonus]
//     [id: PROPERTY_SAVE_BONUS] [mod1: bonus]
//     [id: PROPERTY_SPECIFIC_SAVE_BONUS] [mod1: type] [mod2: bonus]
//     [id: PROPERTY_ELEMENTAL_DR] [mod1: type] [mod2: bonus]
//     [id: PROPERTY_ABILITY_BONUS] [mod1: ability] [mod2: bonus]
//     [id: PROPERTY_SKILL_BONUS] [mod1: skill] [mod2: bonus]
//     [id: PROPERTY_USAGE_RESTRICTION_CLASS] [mod1: class]
//     [id: PROPERTY_USAGE_RESTRICTION_RACE] [mod1: race]
//     [id: PROPERTY_WEAPON_ENH_BONUS] [mod1: bonus]
//     [id: PROPERTY_WEAPON_AB_BONUS] [mod1: bonus]
//     [id: PROPERTY_WEAPON_ENH_BONUS_VS_RACE] [mod1: race] [mod2: bonus]
//     [id: PROPERTY_WEAPON_ELEMENTAL_DAMAGE] [mod1: element] [mod2: damage]
//     [id: PROPERTY_WEAPON_MASSIVE_CRITICALS] [mod1: damage]
//     [id: PROPERTY_WEAPON_VISUAL] [mod1: effect]
//     [id: PROPERTY_WEAPON_FREEDOM]
//     [id: PROPERTY_WEAPON_FEAR]
//     [id: PROPERTY_WEAPON_LIGHT] [mod1: brightness] [mod2: colour]
//     [id: PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN] [mod1: ammo type/vamp regen]
//


#include "inc_data_arr"
#include "inc_random"

// ----- PUBLIC API ------

const int PROPERTY_INVALID                    = 0;

const int PROPERTY_AC_BONUS                   = 1;
const int PROPERTY_AC_BONUS_VS_RACE           = 2;
const int PROPERTY_SAVE_BONUS                 = 3;
const int PROPERTY_SPECIFIC_SAVE_BONUS        = 4;
const int PROPERTY_ELEMENTAL_DR               = 5;
const int PROPERTY_ABILITY_BONUS              = 6;
const int PROPERTY_SKILL_BONUS                = 7;
const int PROPERTY_USAGE_RESTRICTION_CLASS    = 8;
const int PROPERTY_USAGE_RESTRICTION_RACE     = 9;

const int PROPERTY_WEAPON_ENH_BONUS           = 10;
const int PROPERTY_WEAPON_AB_BONUS            = 11;
const int PROPERTY_WEAPON_ENH_BONUS_VS_RACE   = 12;
const int PROPERTY_WEAPON_ELEMENTAL_DAMAGE    = 13;
const int PROPERTY_WEAPON_MASSIVE_CRITICALS   = 14;
const int PROPERTY_WEAPON_VISUAL              = 15;
const int PROPERTY_WEAPON_FREEDOM             = 16;
const int PROPERTY_WEAPON_FEAR                = 17;
const int PROPERTY_WEAPON_LIGHT               = 18;
const int PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN  = 19;

const int PROPERTY_COUNT = PROPERTY_USAGE_RESTRICTION_RACE;
const int PROPERTY_WEAPON_COUNT = PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN;

const int ITEM_TYPE_GEAR = 0;
const int ITEM_TYPE_ARMOUR = 1;
const int ITEM_TYPE_WEAPON = 2;

// Generates a random item of the provided template inside the provided container.
// Type should be one of the ITEM_TYPE_* constants.
object GenerateLootInContainer(object container, string template, string resref);

// Generates a random item of the provided template, and tailors it to the provided creature.
// The process of tailoring ensures that the item will always be useful to the creature in question.
// Type should be one of the ITEM_TYPE_* constants.
object GenerateTailoredLootInContainer(object container, object creature, string template, string resref);

// ------ LGEN SCRIPT API ------

// The LGEN_PropertyStruct is used to pass information about properties between functions.
struct LGEN_PropertyStruct
{
    // The id corresponds to one of the PROPERTY_* constants, depending on gear type.
    int id;

    // The modifiers are used to store each property value.
    // The first modifier is usually the type of property, e.g. cold resistance.
    int mod1;

    // The second modifier is usually the amount of the property, e.g. +3.
    int mod2;
};

const string LGEN_PROPERTY_ARRAY_TAG = "LGEN_PROPS";
const string LGEN_MOD1_ARRAY_TAG = "LGEN_MOD1";
const string LGEN_MOD2_ARRAY_TAG = "LGEN_MOD2";

// lgen scripts may call this to find the item type that is currenty being generated.
int LGEN_GetGenType();

// lgen scripts should call these functions during the first phase to select the min and max property count.
void LGEN_SetMinPropertyCount(int min);
void LGEN_SetMaxPropertyCount(int max);

// lgen scripts should call this function during the third phase to fetch the chosen property.
int LGEN_GetChosenProperty();

// lgen scripts should call these functions on the third phase to select the extent of the properties.
void LGEN_SetMinProperty1Value(int min);
void LGEN_SetMaxProperty1Value(int max);
void LGEN_SetMinProperty2Value(int min);
void LGEN_SetMaxProperty2Value(int max);

// lgen scripts may use these functions to query properties on the item and even manually overwrite
// properties during later phases of loot generation if it wishes to.
struct LGEN_PropertyStruct LGEN_GetProperty(int index);
void LGEN_SetProperty(int index, struct LGEN_PropertyStruct property);
struct LGEN_PropertyStruct LGEN_FindProperty(int propertyId, int nth = 0);
int LGEN_GetPropertyCount(int propertyId);

// ------ INTERNAL LGEN API ------

// Various opposites/complements of the above LGEN public API functions for use within the loot generation library.
int INTERNAL_LGEN_GetGenType(object item);
void INTERNAL_LGEN_SetGenType(object item, int type);
int INTERNAL_LGEN_GetMinPropertyCount(object item);
int INTERNAL_LGEN_GetMaxPropertyCount(object item);
void INTERNAL_LGEN_SetChosenProperty(object item, int property);
int INTERNAL_LGEN_GetMinProperty1Value(object item);
int INTERNAL_LGEN_GetMaxProperty1Value(object item);
int INTERNAL_LGEN_GetMinProperty2Value(object item);
int INTERNAL_LGEN_GetMaxProperty2Value(object item);
struct LGEN_PropertyStruct INTERNAL_LGEN_GetProperty(object item, int index);
void INTERNAL_LGEN_SetProperty(object item, int index, struct LGEN_PropertyStruct property);
struct LGEN_PropertyStruct INTERNAL_LGEN_FindProperty(object item, int propertyId, int nth = 0);
int INTERNAL_LGEN_GetPropertyCount(object item, int propertyId);

// ------ INTERNAL API ------

// The ProperyVarNameStruct is used to pass the string names for each index so that
// they can be accesses in a consistent way using Get/SetLocalVariable.
struct INTERNAL_PropertyVarNameStruct
{
    string id;
    string mod1;
    string mod2;
};


// This value will allow this system and other systems to modify items in the event
// of a breaking change. For example, converting items from version 1 to version 2.
const int INTERNAL_LOOTGEN_VERSION = 1;

// This is a hard-coded limit to keep things sane.
const int INTERNAL_MAX_PROPERTY_COUNT = 8;

const int INTERNAL_LOOT_GEN_PHASE_1 = 1;
const int INTERNAL_LOOT_GEN_PHASE_2 = 2;
const int INTERNAL_LOOT_GEN_PHASE_3 = 3;
const int INTERNAL_LOOT_GEN_PHASE_4 = 4;
const int INTERNAL_LOOT_GEN_PHASE_5 = 5;

// Does exactly what it says on the tin.
object INTERNAL_GenerateLootInContainer(object container, object creature, string template, string resref);

// "Executes a phase", e.g. calls the correct script for the provided phase.
void INTERNAL_ExecutePhase(object item, int phase, string template);

// Generates and applies a series of random properties to an item.
// The properties generated are determined by the lgen script for the provided template.
// If the provided creature is not OBJECT_INVALID, the properties will be tailored to the creature.
// Returns the count of properties applied.
int INTERNAL_GenerateAndApplyProperties(object item, object creature, int type, string template);

// Generates a unique property and returns the struct describing it.
// Doesn't apply it! INTERNAL_PopulateItemWithProperty needs to apply it!
struct LGEN_PropertyStruct INTERNAL_GenerateUniqueProperty(object item, object creature, string template);

// Returns the tailored mod1/mod2 value of the property provided.
// If creature is OBJECT_INVALID, doesn't tailor.
int INTERNAL_TailorMod1(object item, object creature, int property);
int INTERNAL_TailorMod2(object item, object creature, int property);

// Creates the Mod1 array of tailored items.
int INTERNAL_TailorMod1Array(object item, object creature, string tag, int property);

// Finalises an item. This handles tracking, logging, cleaning up variables, etc.
void INTERNAL_FinaliseGeneratedItem(object item, object container, object creature, int propertyCount, string template);

// Applies a generated property to an item.
void INTERNAL_PopulateItemWithProperty(object item, struct LGEN_PropertyStruct property);

// Returns whether the property is valid. This checks for duplicates etc.
int INTERNAL_IsPropertyValid(object item, struct LGEN_PropertyStruct property);

// Returns a structure which contains the string names for each variable field.
// This is a convenience function.
struct INTERNAL_PropertyVarNameStruct INTERNAL_GetPropertyVarNames(int index);

// Returns the ITEM_TYPE_* constant of the provided item.
int INTERNAL_GetItemTypeFromItem(object item);

// If the array has any elements in it, select from it.
// Else, return a random number in the provided range.
int INTERNAL_RandomFromArrayOrRange(object item, string array, int min, int max);

//
// -----
//

object GenerateLootInContainer(object container, string template, string resref)
{
    return GenerateTailoredLootInContainer(container, OBJECT_INVALID, template, resref);
}

object GenerateTailoredLootInContainer(object container, object creature, string template, string resref)
{
    return INTERNAL_GenerateLootInContainer(container, creature, template, resref);
}


int LGEN_GetGenType()
{
    return INTERNAL_LGEN_GetGenType(OBJECT_SELF);
}

void LGEN_SetMinPropertyCount(int min)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MIN_PROP_COUNT", min);
}

void LGEN_SetMaxPropertyCount(int max)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MAX_PROP_COUNT", max);
}

int LGEN_GetChosenProperty()
{
    return GetLocalInt(OBJECT_SELF, "LGEN_PROPERTY");
}

void LGEN_SetMinProperty1Value(int min)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MIN_PROP1", min);
}

void LGEN_SetMaxProperty1Value(int max)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MAX_PROP1", max);
}

void LGEN_SetMinProperty2Value(int min)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MIN_PROP2", min);
}

void LGEN_SetMaxProperty2Value(int max)
{
    SetLocalInt(OBJECT_SELF, "LGEN_MAX_PROP2", max);
}

struct LGEN_PropertyStruct LGEN_GetProperty(int index)
{
    return INTERNAL_LGEN_GetProperty(OBJECT_SELF, index);
}

void LGEN_SetProperty(int index, struct LGEN_PropertyStruct property)
{
    INTERNAL_LGEN_SetProperty(OBJECT_SELF, index, property);
}

struct LGEN_PropertyStruct LGEN_FindProperty(int propertyId, int nth)
{
    return INTERNAL_LGEN_FindProperty(OBJECT_SELF, propertyId, nth);
}

int LGEN_GetPropertyCount(int propertyId)
{
    return INTERNAL_LGEN_GetPropertyCount(OBJECT_SELF, propertyId);
}

int INTERNAL_LGEN_GetGenType(object item)
{
    return GetLocalInt(item, "LGEN_TYPE");
}

void INTERNAL_LGEN_SetGenType(object item, int type)
{
    SetLocalInt(item, "LGEN_TYPE", type);
}

int INTERNAL_LGEN_GetMinPropertyCount(object item)
{
    return GetLocalInt(item, "LGEN_MIN_PROP_COUNT");
}

int INTERNAL_LGEN_GetMaxPropertyCount(object item)
{
    return GetLocalInt(item, "LGEN_MAX_PROP_COUNT");
}

void INTERNAL_LGEN_SetChosenProperty(object item, int property)
{
    SetLocalInt(item, "LGEN_PROPERTY", property);
}

int INTERNAL_LGEN_GetMinProperty1Value(object item)
{
    return GetLocalInt(item, "LGEN_MIN_PROP1");
}

int INTERNAL_LGEN_GetMaxProperty1Value(object item)
{
    return GetLocalInt(item, "LGEN_MAX_PROP1");
}

int INTERNAL_LGEN_GetMinProperty2Value(object item)
{
    return GetLocalInt(item, "LGEN_MIN_PROP2");
}

int INTERNAL_LGEN_GetMaxProperty2Value(object item)
{
    return GetLocalInt(item, "LGEN_MAX_PROP2");
}

struct LGEN_PropertyStruct INTERNAL_LGEN_GetProperty(object item, int index)
{
    struct INTERNAL_PropertyVarNameStruct varNames = INTERNAL_GetPropertyVarNames(index);
    struct LGEN_PropertyStruct property;
    property.id   = GetLocalInt(item, varNames.id);
    property.mod1 = GetLocalInt(item, varNames.mod1);
    property.mod2 = GetLocalInt(item, varNames.mod2);
    return property;
}

void INTERNAL_LGEN_SetProperty(object item, int index, struct LGEN_PropertyStruct property)
{
    if (index >= INTERNAL_MAX_PROPERTY_COUNT)
    {
        return;
    }

    struct INTERNAL_PropertyVarNameStruct varNames = INTERNAL_GetPropertyVarNames(index);
    SetLocalInt(item, varNames.id, property.id);
    SetLocalInt(item, varNames.mod1, property.mod1);
    SetLocalInt(item, varNames.mod2, property.mod2);
}

struct LGEN_PropertyStruct INTERNAL_LGEN_FindProperty(object item, int propertyId, int nth)
{
    int hit = 0;
    struct LGEN_PropertyStruct property;

    int i;
    for (i = 0; i < INTERNAL_MAX_PROPERTY_COUNT; ++i)
    {
        property = INTERNAL_LGEN_GetProperty(item, i);

        if (property.id == PROPERTY_INVALID)
        {
            // No more properties to search ...
            break;
        }

        if (property.id == propertyId)
        {
            if (hit == nth)
            {
                return property;
            }
            else
            {
                ++hit;
            }
        }
    }

    property.id = PROPERTY_INVALID;
    return property;
}

int INTERNAL_LGEN_GetPropertyCount(object item, int propertyId)
{
    int count = 0;

    int i;
    for (i = 0; i < INTERNAL_MAX_PROPERTY_COUNT; ++i)
    {
        struct LGEN_PropertyStruct property = INTERNAL_LGEN_GetProperty(item, i);

        if (property.id == PROPERTY_INVALID)
        {
            // No more properties to search ...
            break;
        }

        if (property.id == propertyId)
        {
            ++count;
        }
    }

    return count;
}

object INTERNAL_GenerateLootInContainer(object container, object creature, string template, string resref)
{
    object item = CreateItemOnObject(resref, container);

    if (GetIsObjectValid(item))
    {
        SetName(item, template  + " Generated Loot Item");
        SetDescription(item, "If you see this name or description, please report this bug to the development team.");

        int itemType = INTERNAL_GetItemTypeFromItem(item);
        int propertyCount = INTERNAL_GenerateAndApplyProperties(item, creature, itemType, template);
        INTERNAL_FinaliseGeneratedItem(item, container, creature, propertyCount, template);
        INTERNAL_ExecutePhase(item, INTERNAL_LOOT_GEN_PHASE_5, template);
    }

    return item;
}

void INTERNAL_ExecutePhase(object item, int phase, string template)
{
    ExecuteScript("lgen_" + GetStringLowerCase(template) + "_" + IntToString(phase), item);
}

int INTERNAL_GenerateAndApplyProperties(object item, object creature, int type, string template)
{
    INTERNAL_LGEN_SetGenType(item, type);
    INTERNAL_ExecutePhase(item, INTERNAL_LOOT_GEN_PHASE_1, template);

    int minPropertyCount = INTERNAL_LGEN_GetMinPropertyCount(item);
    int maxPropertyCount = INTERNAL_LGEN_GetMaxPropertyCount(item);
    int desiredPropertyCount = ClampedRandom(minPropertyCount, maxPropertyCount);

    int i;
    for (i = 0; i < desiredPropertyCount; ++i)
    {
        // Generate the properties, but don't apply them yet.
        struct LGEN_PropertyStruct property = INTERNAL_GenerateUniqueProperty(item, creature, template);

        if (property.id == PROPERTY_INVALID)
        {
            // We couldn't generate a unique property.
            // This could be because we've run out of skills, and the stacking code does not allow duplicates.
            // In this case, we just leave the loop here -- the properties will be recounted lower down anyway.
            break;
        }

       INTERNAL_LGEN_SetProperty(item, i, property);
    }

    INTERNAL_ExecutePhase(item, INTERNAL_LOOT_GEN_PHASE_4, template);

    // Now we count the valid properties again ... we do this because the phase 4 generation could have
    // added properties that we did not generate ourselves, and we want to report them correctly.
    for (i = 0; i < INTERNAL_MAX_PROPERTY_COUNT; ++i)
    {
        // Apply all of the properties.
        struct LGEN_PropertyStruct property = INTERNAL_LGEN_GetProperty(item, i);

        if (property.id == PROPERTY_INVALID)
        {
            // We've counted all the properties.
            break;
        }

        // Actually apply the property to the item.
        INTERNAL_PopulateItemWithProperty(item, property);
    }

    return i;
}

struct LGEN_PropertyStruct INTERNAL_GenerateUniqueProperty(object item, object creature, string template)
{
    INTERNAL_ExecutePhase(item, INTERNAL_LOOT_GEN_PHASE_2, template);
    struct LGEN_PropertyStruct property;

    // We have a maximum cap of 10 attempts when attempting to generate a new property.
    // This cap could be hit by faulty lgen logic (not enough properties to fill slots),
    // or by a character so weird that it confuses the loot tailoring algorithm.
    int attempts;
    for (attempts = 0; attempts < 10; ++attempts)
    {
        int isWeapon = INTERNAL_LGEN_GetGenType(item) == ITEM_TYPE_WEAPON;
        int potentialProperty = INTERNAL_RandomFromArrayOrRange(item,
            LGEN_PROPERTY_ARRAY_TAG,
            (isWeapon ? PROPERTY_COUNT : 0) + 1,
            (isWeapon ? PROPERTY_WEAPON_COUNT : PROPERTY_COUNT));

        INTERNAL_LGEN_SetChosenProperty(item, potentialProperty);
        INTERNAL_ExecutePhase(item, INTERNAL_LOOT_GEN_PHASE_3, template);

        property.id = potentialProperty;
        property.mod1 = INTERNAL_TailorMod1(item, creature, property.id);
        property.mod2 = INTERNAL_TailorMod2(item, creature, property.id);

        IntArray_Clear(item, LGEN_MOD1_ARRAY_TAG);
        IntArray_Clear(item, LGEN_MOD2_ARRAY_TAG);

        if (INTERNAL_IsPropertyValid(item, property))
        {
            // We've got a good property. We can bail out of this loop now.
            break;
        }
        else
        {
            // We failed to generate a valid property, so let's update the ID to reflect that.
            property.id = PROPERTY_INVALID;
        }
    }

    IntArray_Clear(item, LGEN_PROPERTY_ARRAY_TAG);
    return property;
}

int INTERNAL_TailorMod1(object item, object creature, int property)
{
    string arrayTag = "LGEN_MOD1_TAILORING";

    if (INTERNAL_TailorMod1Array(item, creature, arrayTag, property))
    {
        int subsetSize = IntArray_Size(item, LGEN_MOD1_ARRAY_TAG);
        if (subsetSize)
        {
            // We already have a subset. In this case ... we need to strip out anything that doesn't fit our tailoring rules.
            int i;
            for (i = subsetSize - 1; i >= 0; --i)
            {
                int element = IntArray_At(item, LGEN_MOD1_ARRAY_TAG, i);
                if (!IntArray_Contains(item, arrayTag, element))
                {
                    // We have a quick check here. Don't tailor away heal or discipline.
                    if (property == PROPERTY_SKILL_BONUS && (element == SKILL_HEAL || element == SKILL_DISCIPLINE))
                    {
                        // TODO: Move tailoring to a separate script. This isn't generic, it's Arelith-specific.
                        continue;
                    }

                    // Our array of allowable values doesn't include this value. We need to remove it.
                    IntArray_Erase(item, LGEN_MOD1_ARRAY_TAG, i);
                }
            }
        }
        else
        {
            // No subset, so let's just copy the tailoring array to the mod1 array.
            IntArray_Copy(item, LGEN_MOD1_ARRAY_TAG, arrayTag);
        }

        IntArray_Clear(item, arrayTag);
    }

    // At this point, we either have a fully tailored subset, or a partial subset which has been tailored, or no subset at
    // all, in which case we use the ranged generation logic instead.
    return INTERNAL_RandomFromArrayOrRange(item,
        LGEN_MOD1_ARRAY_TAG,
        INTERNAL_LGEN_GetMinProperty1Value(item),
        INTERNAL_LGEN_GetMaxProperty1Value(item));
}

int INTERNAL_TailorMod2(object item, object creature, int property)
{
    // We don't need to do anything special yet for mod 2.
    return INTERNAL_RandomFromArrayOrRange(item,
        LGEN_MOD2_ARRAY_TAG,
        INTERNAL_LGEN_GetMinProperty2Value(item),
        INTERNAL_LGEN_GetMaxProperty2Value(item));
}

int INTERNAL_TailorMod1Array(object item, object creature, string tag, int property)
{
    if (!GetIsObjectValid(creature))
    {
        // The creature isn't valid, so we couldn't possibly tailor to match it.
        return 0;
    }

    if (property == PROPERTY_ABILITY_BONUS)
    {
        // We want to allow a draw of three stats here. Take the highest two stats + constitution.
        // These four variables track them!
        int highestStatType = 0;
        int highestStatValue = 0;
        int secondHighestStatType = 0;
        int secondHighestStatValue = 0;

        // A lot of builds might want to pump INT -- but won't want it on their items unless they
        // could actually use it. So we do a quick sanity check later on using this.
        int hasIntUsingClass = GetLevelByClass(CLASS_TYPE_WIZARD, creature) || GetLevelByClass(CLASS_TYPE_ASSASSIN, creature);

        int i;
        for (i = 0; i < 6; ++i)
        {
            if (i == ABILITY_CONSTITUTION)
            {
                // We will always include CON; skip it!
                continue;
            }

            if (i == ABILITY_INTELLIGENCE && !hasIntUsingClass)
            {
                // No wizard or assassin ... so we probably don't want int loot.
                continue;
            }

            int statType = i;
            int statValue = GetAbilityScore(creature, i, TRUE);

            if (statValue > highestStatValue)
            {
                secondHighestStatType = highestStatType;
                secondHighestStatValue = highestStatValue;
                highestStatType = statType;
                highestStatValue = statValue;
            }
            else if (statValue > secondHighestStatValue)
            {
                secondHighestStatType = statType;
                secondHighestStatValue = statValue;
            }
        }

        IntArray_PushBack(item, tag, highestStatType);
        IntArray_PushBack(item, tag, secondHighestStatType);
        IntArray_PushBack(item, tag, ABILITY_CONSTITUTION);
    }
    else if (property == PROPERTY_SKILL_BONUS)
    {
        // We want to allow generation of items for any skills that the character has invested in.
        int i;
        for (i = 0; i < 28; ++i)
        {
            int ranks = GetSkillRank(i, creature, TRUE);

            if (ranks)
            {
                IntArray_PushBack(item, tag, i);
            }
        }

        // Also, add appraise, discipline and heal, because those are universally useful.
        if (!IntArray_Contains(item, tag, SKILL_DISCIPLINE))
        {
            IntArray_PushBack(item, tag, SKILL_DISCIPLINE);
        }

        if (!IntArray_Contains(item, tag, SKILL_HEAL))
        {
            IntArray_PushBack(item, tag, SKILL_HEAL);
        }

        if (!IntArray_Contains(item, tag, SKILL_APPRAISE))
        {
            IntArray_PushBack(item, tag, SKILL_APPRAISE);
        }
    }

    return IntArray_Size(item, tag);
}

void INTERNAL_PopulateItemWithProperty(object item, struct LGEN_PropertyStruct property)
{
    switch (property.id)
    {
        case PROPERTY_AC_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(property.mod1), item);
            break;

        case PROPERTY_AC_BONUS_VS_RACE:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsRace(property.mod1, property.mod2), item);
            break;

        case PROPERTY_SAVE_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(property.mod1, property.mod2), item);
            break;

        case PROPERTY_SPECIFIC_SAVE_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(property.mod1, property.mod2), item);
            break;

        case PROPERTY_ELEMENTAL_DR:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(property.mod1, property.mod2), item);
            break;

        case PROPERTY_ABILITY_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(property.mod1, property.mod2), item);
            break;

        case PROPERTY_SKILL_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(property.mod1, property.mod2), item);
            break;

        case PROPERTY_USAGE_RESTRICTION_CLASS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(property.mod1), item);
            break;

        case PROPERTY_USAGE_RESTRICTION_RACE:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByRace(property.mod1), item);
            break;

        case PROPERTY_WEAPON_ENH_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(property.mod1), item);
            break;

        case PROPERTY_WEAPON_AB_BONUS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(property.mod1), item);
            break;

        case PROPERTY_WEAPON_ENH_BONUS_VS_RACE:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsRace(property.mod1, property.mod2), item);
            break;

        case PROPERTY_WEAPON_ELEMENTAL_DAMAGE:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(property.mod1, property.mod2), item);
            break;

        case PROPERTY_WEAPON_MASSIVE_CRITICALS:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(property.mod1), item);
            break;

        case PROPERTY_WEAPON_VISUAL:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(property.mod1), item);
            break;

        case PROPERTY_WEAPON_FREEDOM:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyFreeAction(), item);
            break;

        case PROPERTY_WEAPON_FEAR:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), item);
            break;

        case PROPERTY_WEAPON_LIGHT:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(property.mod1, property.mod2), item);
            break;

        case PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN:
        {
            int itemType = GetBaseItemType(item);

            // Only count ranged weapons that consume separate ammunition as ranged.
            int ranged = itemType == BASE_ITEM_HEAVYCROSSBOW ||
                         itemType == BASE_ITEM_LIGHTCROSSBOW ||
                         itemType == BASE_ITEM_LONGBOW ||
                         itemType == BASE_ITEM_SHORTBOW ||
                         itemType == BASE_ITEM_SLING;

            if (ranged)
            {
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo(property.mod1), item);
            }
            else
            {
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(property.mod1), item);
            }

            break;
        }

        default: break;
    }
}

void INTERNAL_FinaliseGeneratedItem(object item, object container, object creature, int propertyCount, string template)
{
    // Add tracking variables to the item.
    SetLocalInt(item, "GENERATED_LOOT_ITEM", 1);
    SetLocalInt(item, "GENERATED_LOOT_ITEM_PROPERTIES", propertyCount);
    SetLocalInt(item, "GENERATED_LOOT_ITEM_VERSION", INTERNAL_LOOTGEN_VERSION);
    SetLocalString(item, "GENERATED_LOOT_ITEM_TEMPLATE", template);

    // Clean up the generation variables.
    int i;
    for (i = 0; i < INTERNAL_MAX_PROPERTY_COUNT; ++i)
    {
        struct INTERNAL_PropertyVarNameStruct varNames = INTERNAL_GetPropertyVarNames(i);
        DeleteLocalInt(item, varNames.id);
        DeleteLocalInt(item, varNames.mod1);
        DeleteLocalInt(item, varNames.mod2);
    }

    DeleteLocalInt(item, "LGEN_TYPE");
    DeleteLocalInt(item, "LGEN_BASE_ITEM_TYPE");
    DeleteLocalInt(item, "LGEN_MIN_PROP_COUNT");
    DeleteLocalInt(item, "LGEN_MAX_PROP_COUNT");
    DeleteLocalInt(item, "LGEN_PROPERTY");
    DeleteLocalInt(item, "LGEN_MIN_PROP1");
    DeleteLocalInt(item, "LGEN_MAX_PROP1");
    DeleteLocalInt(item, "LGEN_MIN_PROP2");
    DeleteLocalInt(item, "LGEN_MAX_PROP2");
}

int INTERNAL_IsPropertyValid(object item, struct LGEN_PropertyStruct property)
{
    if (property.id == PROPERTY_INVALID)
    {
        return FALSE;
    }

    int i;
    for (i = 0; i < INTERNAL_MAX_PROPERTY_COUNT; ++i)
    {
        struct LGEN_PropertyStruct otherProperty = INTERNAL_LGEN_GetProperty(item, i);

        // If we have a property that is the same type as any other property ...
        if (property.id == otherProperty.id)
        {
            // ... We need to check a series of basic rules about stacking.
            // Generally, nothing can stack.
            // Custom rules to allow stacking go here.
            switch (property.id)
            {
                case PROPERTY_AC_BONUS_VS_RACE: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_SPECIFIC_SAVE_BONUS: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_ELEMENTAL_DR: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_ABILITY_BONUS: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_SKILL_BONUS: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_USAGE_RESTRICTION_CLASS: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_USAGE_RESTRICTION_RACE: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_WEAPON_ENH_BONUS_VS_RACE: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                case PROPERTY_WEAPON_ELEMENTAL_DAMAGE: if (property.mod1 == otherProperty.mod1) return FALSE; break;
                default: return FALSE;
            }
        }

        // At this point, we've passed the basic stacking sanity checks.
        // Now we need to complete more detailed checks that handle stacking oddities.

        int propertyTypeToFind = -1;
        switch (property.id)
        {
            case PROPERTY_AC_BONUS: propertyTypeToFind = PROPERTY_AC_BONUS_VS_RACE; break;
            case PROPERTY_AC_BONUS_VS_RACE: propertyTypeToFind = PROPERTY_AC_BONUS; break;
            case PROPERTY_SAVE_BONUS: propertyTypeToFind = PROPERTY_SPECIFIC_SAVE_BONUS; break;
            case PROPERTY_SPECIFIC_SAVE_BONUS: propertyTypeToFind = PROPERTY_SAVE_BONUS; break;
            case PROPERTY_WEAPON_AB_BONUS: propertyTypeToFind = PROPERTY_WEAPON_ENH_BONUS; break;
            case PROPERTY_WEAPON_ENH_BONUS: propertyTypeToFind = PROPERTY_WEAPON_ENH_BONUS_VS_RACE; break;
            case PROPERTY_WEAPON_ENH_BONUS_VS_RACE: propertyTypeToFind = PROPERTY_WEAPON_ENH_BONUS; break;
            default: break;
        }

        if (propertyTypeToFind != -1)
        {
            int j = 0;

            while (TRUE)
            {
                otherProperty = INTERNAL_LGEN_FindProperty(item, propertyTypeToFind, j++);

                if (otherProperty.id == PROPERTY_INVALID)
                {
                    break;
                }

                if (property.id == PROPERTY_AC_BONUS)
                {
                    int acBonus = property.mod1;
                    int acBonusVsRace = otherProperty.mod2;
                    if (acBonusVsRace >= acBonus)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_AC_BONUS_VS_RACE)
                {
                    int acBonus = otherProperty.mod1;
                    int acBonusVsRace = property.mod2;
                    if (acBonus >= acBonusVsRace)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_SAVE_BONUS)
                {
                    int uniSave = property.mod2;
                    int specificSave = otherProperty.mod2;
                    if (specificSave >= uniSave)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_SPECIFIC_SAVE_BONUS)
                {
                    int uniSave = otherProperty.mod2;
                    int specificSave = property.mod2;
                    if (uniSave >= specificSave)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_WEAPON_AB_BONUS)
                {
                    int abBonus = property.mod1;
                    int enhBonus = otherProperty.mod1;
                    if (enhBonus >= abBonus)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_WEAPON_ENH_BONUS)
                {
                    int enhBonus = property.mod1;
                    int enhBonusVsRace = otherProperty.mod2;
                    if (enhBonusVsRace >= enhBonus)
                    {
                        return FALSE;
                    }
                }
                else if (property.id == PROPERTY_WEAPON_ENH_BONUS_VS_RACE)
                {
                    int enhBonus = otherProperty.mod1;
                    int enhBonusVsRace = property.mod2;
                    if (enhBonus >= enhBonusVsRace)
                    {
                        return FALSE;
                    }
                }
            }
        }
    }

    return TRUE;
}

struct INTERNAL_PropertyVarNameStruct INTERNAL_GetPropertyVarNames(int index)
{
    string propertyArrBase = "PROPERTY_ARR_" + IntToString(index);
    struct INTERNAL_PropertyVarNameStruct varNames;
    varNames.id   = propertyArrBase + "_ID";
    varNames.mod1 = propertyArrBase + "_MOD1";
    varNames.mod2 = propertyArrBase + "_MOD2";
    return varNames;
}

int INTERNAL_GetItemTypeFromItem(object item)
{
    int itemType = GetBaseItemType(item);

    switch (itemType)
    {
        case BASE_ITEM_AMULET:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_RING:
            return ITEM_TYPE_GEAR;

        case BASE_ITEM_ARMOR:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD:
            return ITEM_TYPE_ARMOUR;

        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
		case BASE_ITEM_DART:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
            return ITEM_TYPE_WEAPON;
    }

    return -1;
}

int INTERNAL_RandomFromArrayOrRange(object item, string array, int min, int max)
{
    int size = IntArray_Size(item, array);
    return size ? IntArray_At(item, array, Random(size)) : ClampedRandom(min, max);
}

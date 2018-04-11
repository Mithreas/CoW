#include "inc_lootgen"

void Tier1_Phase2Common();
void Tier1_Phase3Common();

void Tier2_Phase2Common();
void Tier2_Phase3Common();

void Tier1_Phase2Common()
{
    IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);

    int acCount = LGEN_GetPropertyCount(PROPERTY_AC_BONUS);
    int statCount = LGEN_GetPropertyCount(PROPERTY_ABILITY_BONUS);

    if (acCount + statCount < 1)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ABILITY_BONUS);

        if (GetBaseItemType(OBJECT_SELF) == BASE_ITEM_BOOTS)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
        }
    }
}

void Tier1_Phase3Common()
{
    int property = LGEN_GetChosenProperty();

    if (property == PROPERTY_ABILITY_BONUS)
    {
        LGEN_SetMinProperty1Value(0);
        LGEN_SetMaxProperty1Value(5);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(1);
    }
    else if (property == PROPERTY_SKILL_BONUS)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_CONCENTRATION);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_DISCIPLINE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HIDE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_LISTEN);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_MOVE_SILENTLY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PARRY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PERFORM);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPELLCRAFT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPOT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_TAUNT);

        int itemType = GetBaseItemType(OBJECT_SELF);

        if (itemType == BASE_ITEM_RING || itemType == BASE_ITEM_AMULET)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HEAL);
        }
    }
    else if (property == PROPERTY_AC_BONUS)
    {
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(1);
    }
}

void Tier2_Phase2Common()
{
    IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);

    int acCount = LGEN_GetPropertyCount(PROPERTY_AC_BONUS);
    int statCount = LGEN_GetPropertyCount(PROPERTY_ABILITY_BONUS);

    if (acCount + statCount < 2)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ABILITY_BONUS);

        if (GetBaseItemType(OBJECT_SELF) == BASE_ITEM_BOOTS)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
        }
    }
}

void Tier2_Phase3Common()
{
    Tier1_Phase3Common();
}

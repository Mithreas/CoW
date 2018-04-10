#include "inc_lgen"

void main()
{
    Tier2_Phase3Common();

    if (LGEN_GetChosenProperty() == PROPERTY_SKILL_BONUS)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 1);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 1);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 1);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 1);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD2_ARRAY_TAG, 2);
    }
}

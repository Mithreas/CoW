#include "nwnx_data"

// Refer to inc_data_arr for further information.

float FloatArray_At(object obj, string tag, int index);
void FloatArray_Clear(object obj, string tag);
int FloatArray_Contains(object obj, string tag, float element);
void FloatArray_Copy(object obj, string tag, string otherTag);
void FloatArray_Erase(object obj, string tag, int index);
int FloatArray_Find(object obj, string tag, float element);
void FloatArray_Insert(object obj, string tag, int index, float element);
void FloatArray_PushBack(object obj, string tag, float element);
void FloatArray_Resize(object obj, string tag, int size);
void FloatArray_Shuffle(object obj, string tag);
int FloatArray_Size(object obj, string tag);
void FloatArray_SortAscending(object obj, string tag);
void FloatArray_SortDescending(object obj, string tag);

//
// ------
//

float FloatArray_At(object obj, string tag, int index)
{
    return NWNX_Data_Array_At_Flt(obj, tag, index);
}

void FloatArray_Clear(object obj, string tag)
{
    NWNX_Data_Array_Clear(NWNX_DATA_TYPE_FLOAT, obj, tag);
}

int FloatArray_Contains(object obj, string tag, float element)
{
    return NWNX_Data_Array_Contains_Flt(obj, tag, element);
}

void FloatArray_Copy(object obj, string tag, string otherTag)
{
    NWNX_Data_Array_Copy(NWNX_DATA_TYPE_FLOAT, obj, tag, otherTag);
}

void FloatArray_Erase(object obj, string tag, int index)
{
    NWNX_Data_Array_Erase(NWNX_DATA_TYPE_FLOAT, obj, tag, index);
}

int FloatArray_Find(object obj, string tag, float element)
{
    return NWNX_Data_Array_Find_Flt(obj, tag, element);
}

void FloatArray_Insert(object obj, string tag, int index, float element)
{
    NWNX_Data_Array_Insert_Flt(obj, tag, index, element);
}

void FloatArray_PushBack(object obj, string tag, float element)
{
    NWNX_Data_Array_PushBack_Flt(obj, tag, element);
}

void FloatArray_Resize(object obj, string tag, int size)
{
    NWNX_Data_Array_Resize(NWNX_DATA_TYPE_FLOAT, obj, tag, size);
}

void FloatArray_Shuffle(object obj, string tag)
{
    NWNX_Data_Array_Shuffle(NWNX_DATA_TYPE_FLOAT, obj, tag);
}

int FloatArray_Size(object obj, string tag)
{
    return NWNX_Data_Array_Size(NWNX_DATA_TYPE_FLOAT, obj, tag);
}

void FloatArray_SortAscending(object obj, string tag)
{
    NWNX_Data_Array_SortAscending(NWNX_DATA_TYPE_FLOAT, obj, tag);
}

void FloatArray_SortDescending(object obj, string tag)
{
    NWNX_Data_Array_SortDescending(NWNX_DATA_TYPE_FLOAT, obj, tag);
}

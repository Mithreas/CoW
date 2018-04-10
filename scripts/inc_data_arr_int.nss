#include "nwnx_data"

// Refer to inc_data_arr for further information.

int IntArray_At(object obj, string tag, int index);
void IntArray_Clear(object obj, string tag);
int IntArray_Contains(object obj, string tag, int element);
void IntArray_Copy(object obj, string tag, string otherTag);
void IntArray_Erase(object obj, string tag, int index);
int IntArray_Find(object obj, string tag, int element);
void IntArray_Insert(object obj, string tag, int index, int element);
void IntArray_PushBack(object obj, string tag, int element);
void IntArray_Resize(object obj, string tag, int size);
void IntArray_Shuffle(object obj, string tag);
int IntArray_Size(object obj, string tag);
void IntArray_SortAscending(object obj, string tag);
void IntArray_SortDescending(object obj, string tag);

//
// ------
//

int IntArray_At(object obj, string tag, int index)
{
    return NWNX_Data_Array_At_Int(obj, tag, index);
}

void IntArray_Clear(object obj, string tag)
{
    NWNX_Data_Array_Clear(NWNX_DATA_TYPE_INTEGER, obj, tag);
}

int IntArray_Contains(object obj, string tag, int element)
{
    return NWNX_Data_Array_Contains_Int(obj, tag, element);
}

void IntArray_Copy(object obj, string tag, string otherTag)
{
    NWNX_Data_Array_Copy(NWNX_DATA_TYPE_INTEGER, obj, tag, otherTag);
}

void IntArray_Erase(object obj, string tag, int index)
{
    NWNX_Data_Array_Erase(NWNX_DATA_TYPE_INTEGER, obj, tag, index);
}

int IntArray_Find(object obj, string tag, int element)
{
    return NWNX_Data_Array_Find_Int(obj, tag, element);
}

void IntArray_Insert(object obj, string tag, int index, int element)
{
    NWNX_Data_Array_Insert_Int(obj, tag, index, element);
}

void IntArray_PushBack(object obj, string tag, int element)
{
    NWNX_Data_Array_PushBack_Int(obj, tag, element);
}

void IntArray_Resize(object obj, string tag, int size)
{
    NWNX_Data_Array_Resize(NWNX_DATA_TYPE_INTEGER, obj, tag, size);
}

void IntArray_Shuffle(object obj, string tag)
{
    NWNX_Data_Array_Shuffle(NWNX_DATA_TYPE_INTEGER, obj, tag);
}

int IntArray_Size(object obj, string tag)
{
    return NWNX_Data_Array_Size(NWNX_DATA_TYPE_INTEGER, obj, tag);
}

void IntArray_SortAscending(object obj, string tag)
{
    NWNX_Data_Array_SortAscending(NWNX_DATA_TYPE_INTEGER, obj, tag);
}

void IntArray_SortDescending(object obj, string tag)
{
    NWNX_Data_Array_SortDescending(NWNX_DATA_TYPE_INTEGER, obj, tag);
}

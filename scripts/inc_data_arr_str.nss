#include "nwnx_data"

// Refer to inc_data_arr for further information.

string StringArray_At(object obj, string tag, int index);
void StringArray_Clear(object obj, string tag);
int StringArray_Contains(object obj, string tag, string element);
void StringArray_Copy(object obj, string tag, string otherTag);
void StringArray_Erase(object obj, string tag, int index);
int StringArray_Find(object obj, string tag, string element);
void StringArray_Insert(object obj, string tag, int index, string element);
void StringArray_PushBack(object obj, string tag, string element);
void StringArray_Resize(object obj, string tag, int size);
void StringArray_Shuffle(object obj, string tag);
int StringArray_Size(object obj, string tag);
void StringArray_SortAscending(object obj, string tag);
void StringArray_SortDescending(object obj, string tag);

//
// ------
//

string StringArray_At(object obj, string tag, int index)
{
    return NWNX_Data_Array_At_Str(obj, tag, index);
}

void StringArray_Clear(object obj, string tag)
{
    NWNX_Data_Array_Clear(NWNX_DATA_TYPE_STRING, obj, tag);
}

int StringArray_Contains(object obj, string tag, string element)
{
    return NWNX_Data_Array_Contains_Str(obj, tag, element);
}

void StringArray_Copy(object obj, string tag, string otherTag)
{
    NWNX_Data_Array_Copy(NWNX_DATA_TYPE_STRING, obj, tag, otherTag);
}

void StringArray_Erase(object obj, string tag, int index)
{
    NWNX_Data_Array_Erase(NWNX_DATA_TYPE_STRING, obj, tag, index);
}

int StringArray_Find(object obj, string tag, string element)
{
    return NWNX_Data_Array_Find_Str(obj, tag, element);
}

void StringArray_Insert(object obj, string tag, int index, string element)
{
    NWNX_Data_Array_Insert_Str(obj, tag, index, element);
}

void StringArray_PushBack(object obj, string tag, string element)
{
    NWNX_Data_Array_PushBack_Str(obj, tag, element);
}

void StringArray_Resize(object obj, string tag, int size)
{
    NWNX_Data_Array_Resize(NWNX_DATA_TYPE_STRING, obj, tag, size);
}

void StringArray_Shuffle(object obj, string tag)
{
    NWNX_Data_Array_Shuffle(NWNX_DATA_TYPE_STRING, obj, tag);
}

int StringArray_Size(object obj, string tag)
{
    return NWNX_Data_Array_Size(NWNX_DATA_TYPE_STRING, obj, tag);
}

void StringArray_SortAscending(object obj, string tag)
{
    NWNX_Data_Array_SortAscending(NWNX_DATA_TYPE_STRING, obj, tag);
}

void StringArray_SortDescending(object obj, string tag)
{
    NWNX_Data_Array_SortDescending(NWNX_DATA_TYPE_STRING, obj, tag);
}

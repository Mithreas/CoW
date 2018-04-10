#include "nwnx_data"

// Refer to inc_data_arr for further information.

object ObjectArray_At(object obj, string tag, int index);
void ObjectArray_Clear(object obj, string tag);
int ObjectArray_Contains(object obj, string tag, object element);
void ObjectArray_Copy(object obj, string tag, string otherTag);
void ObjectArray_Erase(object obj, string tag, int index);
int ObjectArray_Find(object obj, string tag, object element);
void ObjectArray_Insert(object obj, string tag, int index, object element);
void ObjectArray_PushBack(object obj, string tag, object element);
void ObjectArray_Resize(object obj, string tag, int size);
void ObjectArray_Shuffle(object obj, string tag);
int ObjectArray_Size(object obj, string tag);
void ObjectArray_SortAscending(object obj, string tag);
void ObjectArray_SortDescending(object obj, string tag);

//
// ------
//

object ObjectArray_At(object obj, string tag, int index)
{
    return NWNX_Data_Array_At_Obj(obj, tag, index);
}

void ObjectArray_Clear(object obj, string tag)
{
    NWNX_Data_Array_Clear(NWNX_DATA_TYPE_OBJECT, obj, tag);
}

int ObjectArray_Contains(object obj, string tag, object element)
{
    return NWNX_Data_Array_Contains_Obj(obj, tag, element);
}

void ObjectArray_Copy(object obj, string tag, string otherTag)
{
    NWNX_Data_Array_Copy(NWNX_DATA_TYPE_OBJECT, obj, tag, otherTag);
}

void ObjectArray_Erase(object obj, string tag, int index)
{
    NWNX_Data_Array_Erase(NWNX_DATA_TYPE_OBJECT, obj, tag, index);
}

int ObjectArray_Find(object obj, string tag, object element)
{
    return NWNX_Data_Array_Find_Obj(obj, tag, element);
}

void ObjectArray_Insert(object obj, string tag, int index, object element)
{
    NWNX_Data_Array_Insert_Obj(obj, tag, index, element);
}

void ObjectArray_PushBack(object obj, string tag, object element)
{
    NWNX_Data_Array_PushBack_Obj(obj, tag, element);
}

void ObjectArray_Resize(object obj, string tag, int size)
{
    NWNX_Data_Array_Resize(NWNX_DATA_TYPE_OBJECT, obj, tag, size);
}

void ObjectArray_Shuffle(object obj, string tag)
{
    NWNX_Data_Array_Shuffle(NWNX_DATA_TYPE_OBJECT, obj, tag);
}

int ObjectArray_Size(object obj, string tag)
{
    return NWNX_Data_Array_Size(NWNX_DATA_TYPE_OBJECT, obj, tag);
}

void ObjectArray_SortAscending(object obj, string tag)
{
    NWNX_Data_Array_SortAscending(NWNX_DATA_TYPE_OBJECT, obj, tag);
}

void ObjectArray_SortDescending(object obj, string tag)
{
    NWNX_Data_Array_SortDescending(NWNX_DATA_TYPE_OBJECT, obj, tag);
}

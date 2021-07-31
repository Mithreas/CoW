
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
    return Array_At_Flt(tag, index, obj);
}

void FloatArray_Clear(object obj, string tag)
{
    Array_Clear(tag, obj);
}

int FloatArray_Contains(object obj, string tag, float element)
{
    return Array_Contains_Flt(tag, element, obj);
}

void FloatArray_Copy(object obj, string tag, string otherTag)
{
    Array_Copy(tag, otherTag, obj);
}

void FloatArray_Erase(object obj, string tag, int index)
{
    Array_Erase(tag, index, obj);
}

int FloatArray_Find(object obj, string tag, float element)
{
    return Array_Find_Flt(tag, element, obj);
}

void FloatArray_Insert(object obj, string tag, int index, float element)
{
    Array_Insert_Flt(tag, index, element, obj);
}

void FloatArray_PushBack(object obj, string tag, float element)
{
    Array_PushBack_Flt(tag, element, obj);
}

void FloatArray_Resize(object obj, string tag, int size)
{
    Array_Resize(tag, size, obj);
}

void FloatArray_Shuffle(object obj, string tag)
{
    Array_Shuffle(tag, obj);
}

int FloatArray_Size(object obj, string tag)
{
    return Array_Size(tag, obj);
}

void FloatArray_SortAscending(object obj, string tag)
{
    Array_SortAscending(tag, TYPE_FLOAT, obj);
}

void FloatArray_SortDescending(object obj, string tag)
{
    Array_SortDescending(tag, TYPE_FLOAT, obj);
}

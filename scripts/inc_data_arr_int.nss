
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
    return Array_At_Int(tag, index, obj);
}

void IntArray_Clear(object obj, string tag)
{
    Array_Clear(tag, obj);
}

int IntArray_Contains(object obj, string tag, int element)
{
    return Array_Contains_Int(tag, element, obj);
}

void IntArray_Copy(object obj, string tag, string otherTag)
{
    Array_Copy(tag, otherTag, obj);
}

void IntArray_Erase(object obj, string tag, int index)
{
    Array_Erase(tag, index, obj);
}

int IntArray_Find(object obj, string tag, int element)
{
    return Array_Find_Int(tag, element, obj);
}

void IntArray_Insert(object obj, string tag, int index, int element)
{
    Array_Insert_Int(tag, index, element, obj);
}

void IntArray_PushBack(object obj, string tag, int element)
{
    Array_PushBack_Int(tag, element, obj);
}

void IntArray_Resize(object obj, string tag, int size)
{
    Array_Resize(tag, size, obj);
}

void IntArray_Shuffle(object obj, string tag)
{
    Array_Shuffle(tag, obj);
}

int IntArray_Size(object obj, string tag)
{
    return Array_Size(tag, obj);
}

void IntArray_SortAscending(object obj, string tag)
{
    Array_SortAscending(tag, TYPE_INTEGER, obj);
}

void IntArray_SortDescending(object obj, string tag)
{
    Array_SortDescending(tag, TYPE_INTEGER, obj);
}

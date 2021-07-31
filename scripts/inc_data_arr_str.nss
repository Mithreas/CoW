
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
    return Array_At_Str(tag, index, obj);
}

void StringArray_Clear(object obj, string tag)
{
    Array_Clear(tag, obj);
}

int StringArray_Contains(object obj, string tag, string element)
{
    return Array_Contains_Str(tag, element, obj);
}

void StringArray_Copy(object obj, string tag, string otherTag)
{
    Array_Copy(tag, otherTag, obj);
}

void StringArray_Erase(object obj, string tag, int index)
{
    Array_Erase(tag, index, obj);
}

int StringArray_Find(object obj, string tag, string element)
{
    return Array_Find_Str(tag, element, obj);
}

void StringArray_Insert(object obj, string tag, int index, string element)
{
    Array_Insert_Str(tag, index, element, obj);
}

void StringArray_PushBack(object obj, string tag, string element)
{
    Array_PushBack_Str(tag, element, obj);
}

void StringArray_Resize(object obj, string tag, int size)
{
    Array_Resize(tag, size, obj);
}

void StringArray_Shuffle(object obj, string tag)
{
    Array_Shuffle(tag, obj);
}

int StringArray_Size(object obj, string tag)
{
    return Array_Size(tag, obj);
}

void StringArray_SortAscending(object obj, string tag)
{
    Array_SortAscending(tag, TYPE_STRING, obj);
}

void StringArray_SortDescending(object obj, string tag)
{
    Array_SortDescending(tag, TYPE_STRING, obj);
}

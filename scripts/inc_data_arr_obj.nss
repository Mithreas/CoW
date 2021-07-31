
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
    return Array_At_Obj(tag, index, obj);
}

void ObjectArray_Clear(object obj, string tag)
{
    Array_Clear(tag, obj);
}

int ObjectArray_Contains(object obj, string tag, object element)
{
    return Array_Contains_Obj(tag, element, obj);
}

void ObjectArray_Copy(object obj, string tag, string otherTag)
{
    Array_Copy(tag, otherTag, obj);
}

void ObjectArray_Erase(object obj, string tag, int index)
{
    Array_Erase(tag, index, obj);
}

int ObjectArray_Find(object obj, string tag, object element)
{
    return Array_Find_Obj(tag, element, obj);
}

void ObjectArray_Insert(object obj, string tag, int index, object element)
{
    Array_Insert_Obj(tag, index, element, obj);
}

void ObjectArray_PushBack(object obj, string tag, object element)
{
    Array_PushBack_Obj(tag, element, obj);
}

void ObjectArray_Resize(object obj, string tag, int size)
{
    Array_Resize(tag, size, obj);
}

void ObjectArray_Shuffle(object obj, string tag)
{
    Array_Shuffle(tag, obj);
}

int ObjectArray_Size(object obj, string tag)
{
    return Array_Size(tag, obj);
}

void ObjectArray_SortAscending(object obj, string tag)
{
    Array_SortAscending(tag, TYPE_OBJECT, obj);
}

void ObjectArray_SortDescending(object obj, string tag)
{
    Array_SortDescending(tag, TYPE_OBJECT, obj);
}

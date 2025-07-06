//::///////////////////////////////////////////////
//:: Array Function Library
//:: _inc_array
//:://////////////////////////////////////////////
/*
    Contains functions for creating and managing
    variable arrays.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 13, 2016
//:://////////////////////////////////////////////

#include "inc_math"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// The maximum number of elements in an array.
const int ARRAY_MAX_SIZE = 50;

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// The minimum number of elements in an array.
const int ARRAY_MIN_SIZE = 0;
// Return value when fetching a value's index if none is found.
const int INDEX_INVALID = -1;
// Return value of float on error.
const float NULL_FLOAT = 0.0f;
// Return value of int on error.
const int NULL_INT = 0;
// Return value of string on error.
const string NULL_STRING = "";

// Variable name prefix used to distinguish array variables from other variables.
const string LIB_ARRAY_PREFIX = "Lib_Array_";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Creates an array of floats on the specified object. This function must be called before
// array variables can be set.
void CreateFloatArray(object oObject, string sArrayName, int nSize);
// Creates an array of ints on the specified object. This function must be called before
// array variables can be set.
void CreateIntArray(object oObject, string sArrayName, int nSize);
// Creates an array of locations on the specified object. This function must be called before
// array variables can be set.
void CreateLocationArray(object oObject, string sArrayName, int nSize);
// Creates an array of objects on the specified object. This function must be called before
// array variables can be set.
void CreateObjectArray(object oObject, string sArrayName, int nSize);
// Creates an array of strings on the specified object. This function must be called before
// array variables can be set.
void CreateStringArray(object oObject, string sArrayName, int nSize);
// Deletes the float array variable at the specified index (i.e. element).
void DeleteArrayFloat(object oObject, string sArrayName, int nElement);
// Deletes the int array variable at the specified index (i.e. element).
void DeleteArrayInt(object oObject, string sArrayName, int nElement);
// Deletes the location array variable at the specified index (i.e. element).
void DeleteArrayLocation(object oObject, string sArrayName, int nElement);
// Deletes the object array variable at the specified index (i.e. element).
void DeleteArrayObject(object oObject, string sArrayName, int nElement);
// Deletes the string array variable at the specified index (i.e. element).
void DeleteArrayString(object oObject, string sArrayName, int nElement);
// Deletes the specified float array (and all child components) from the object.
void DeleteFloatArray(object oObject, string sArrayName);
// Deletes the specified int array (and all child components) from the object.
void DeleteIntArray(object oObject, string sArrayName);
// Deletes the specified location array (and all child components) from the object.
void DeleteLocationArray(object oObject, string sArrayName);
// Deletes the specified object array (and all child components) from the object.
void DeleteObjectArray(object oObject, string sArrayName);
// Deletes the specified string array (and all child components) from the object.
void DeleteStringArray(object oObject, string sArrayName);
// Returns the value of the float at the specified array index (i.e. element).
float GetArrayFloat(object oObject, string sArrayName, int nElement);
// Returns the value of the int at the specified array index (i.e. element).
int GetArrayInt(object oObject, string sArrayName, int nElement);
// Returns the value of the location at the specified array index (i.e. element).
location GetArrayLocation(object oObject, string sArrayName, int nElement);
// Returns the value of the object at the specified array index (i.e. element).
object GetArrayObject(object oObject, string sArrayName, int nElement);
// Returns the value of the string at the specified array index (i.e. element).
string GetArrayString(object oObject, string sArrayName, int nElement);
// Returns the location of nNth element in an array matching the specified value.
// Returns INDEX_INVALID if the element is not found.
int GetFloatArrayIndexOf(object oObject, string sArrayName, float fValue, int nNth = 1);
// Returns the size (i.e. maximum capacity) of the specified float array.
int GetFloatArraySize(object oObject, string sArrayName);
// Returns the location of nNth element in an array matching the specified value.
// Returns INDEX_INVALID if the element is not found.
int GetIntArrayIndexOf(object oObject, string sArrayName, int nValue, int nNth = 1);
// Returns the size (i.e. maximum capacity) of the specified int array.
int GetIntArraySize(object oObject, string sArrayName);
// Returns TRUE if nIndex falls within the bounds of the specified array.
int GetIsValidFloatArrayIndex(object oObject, string sArrayName, int nIndex);
// Returns TRUE if nIndex falls within the bounds of the specified array.
int GetIsValidIntArrayIndex(object oObject, string sArrayName, int nIndex);
// Returns TRUE if nIndex falls within the bounds of the specified array.
int GetIsValidLocationArrayIndex(object oObject, string sArrayName, int nIndex);
// Returns TRUE if nIndex falls within the bounds of the specified array.
int GetIsValidObjectArrayIndex(object oObject, string sArrayName, int nIndex);
// Returns TRUE if nIndex falls within the bounds of the specified array.
int GetIsValidStringArrayIndex(object oObject, string sArrayName, int nIndex);
// Returns the location of nNth element in an array matching the specified value.
// Returns INDEX_INVALID if the element is not found.
int GetLocationArrayIndexOf(object oObject, string sArrayName, location lValue, int nNth = 1);
// Returns the size (i.e. maximum capacity) of the specified location array.
int GetLocationArraySize(object oObject, string sArrayName);
// Returns the location of nNth element in an array matching the specified value.
// Returns INDEX_INVALID if the element is not found.
int GetObjectArrayIndexOf(object oObject, string sArrayName, object oValue, int nNth = 1);
// Returns the size (i.e. maximum capacity) of the specified object array.
int GetObjectArraySize(object oObject, string sArrayName);
// Returns the location of nNth element in an array matching the specified value.
// Returns INDEX_INVALID if the element is not found.
int GetStringArrayIndexOf(object oObject, string sArrayName, string sValue, int nNth = 1);
// Returns the size (i.e. maximum capacity) of the specified string array.
int GetStringArraySize(object oObject, string sArrayName);
// Alters the size (i.e. maximum capacity) of the specified array. If the size is
// decreased, then any values that extend beyond the bounds of the new array will be deleted.
void ResizeFloatArray(object oObject, string sArrayName, int nSize);
// Alters the size (i.e. maximum capacity) of the specified array. If the size is
// decreased, then any values that extend beyond the bounds of the new array will be deleted.
void ResizeIntArray(object oObject, string sArrayName, int nSize);
// Alters the size (i.e. maximum capacity) of the specified array. If the size is
// decreased, then any values that extend beyond the bounds of the new array will be deleted.
void ResizeLocationArray(object oObject, string sArrayName, int nSize);
// Alters the size (i.e. maximum capacity) of the specified array. If the size is
// decreased, then any values that extend beyond the bounds of the new array will be deleted.
void ResizeObjectArray(object oObject, string sArrayName, int nSize);
// Alters the size (i.e. maximum capacity) of the specified array. If the size is
// decreased, then any values that extend beyond the bounds of the new array will be deleted.
void ResizeStringArray(object oObject, string sArrayName, int nSize);
// Sets a float array value. Note that the array must first be initialized with
// CreateFloatArray() for this function to work.
void SetArrayFloat(object oObject, string sArrayName, int nElement, float fValue);
// Sets an int array value. Note that the array must first be initialized with
// CreateIntArray() for this function to work.
void SetArrayInt(object oObject, string sArrayName, int nElement, int nValue);
// Sets a location array value. Note that the array must first be initialized with
// CreateLocationArray() for this function to work.
void SetArrayLocation(object oObject, string sArrayName, int nElement, location lValue);
// Sets an object array value. Note that the array must first be initialized with
// CreateObjectArray() for this function to work.
void SetArrayObject(object oObject, string sArrayName, int nElement, object oValue);
// Sets a string array value. Note that the array must first be initialized with
// CreateStringArray() for this function to work.
void SetArrayString(object oObject, string sArrayName, int nElement, string sValue);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: CreateFloatArray
//:://////////////////////////////////////////////
/*
    Creates an array of floats on the specified
    object. This function must be called before
    array variables can be set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void CreateFloatArray(object oObject, string sArrayName, int nSize)
{
    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + "Size", nSize);
}

//::///////////////////////////////////////////////
//:: CreateIntArray
//:://////////////////////////////////////////////
/*
    Creates an array of ints on the specified
    object. This function must be called before
    array variables can be set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void CreateIntArray(object oObject, string sArrayName, int nSize)
{
    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + "Size", nSize);
}

//::///////////////////////////////////////////////
//:: CreateLocationArray
//:://////////////////////////////////////////////
/*
    Creates an array of locations on the specified
    object. This function must be called before
    array variables can be set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void CreateLocationArray(object oObject, string sArrayName, int nSize)
{
    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + "Size", nSize);
}

//::///////////////////////////////////////////////
//:: CreateObjectArray
//:://////////////////////////////////////////////
/*
    Creates an array of objects on the specified
    object. This function must be called before
    array variables can be set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void CreateObjectArray(object oObject, string sArrayName, int nSize)
{
    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + "Size", nSize);
}

//::///////////////////////////////////////////////
//:: CreateStringArray
//:://////////////////////////////////////////////
/*
    Creates an array of strings on the specified
    object. This function must be called before
    array variables can be set.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void CreateStringArray(object oObject, string sArrayName, int nSize)
{
    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + "Size", nSize);
}

//::///////////////////////////////////////////////
//:: DeleteArrayFloat
//:://////////////////////////////////////////////
/*
    Deletes the float array variable at the
    specified index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteArrayFloat(object oObject, string sArrayName, int nElement)
{
    DeleteLocalFloat(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + IntToString(nElement));
}

//::///////////////////////////////////////////////
//:: DeleteArrayInt
//:://////////////////////////////////////////////
/*
    Deletes the int array variable at the
    specified index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteArrayInt(object oObject, string sArrayName, int nElement)
{
    DeleteLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + IntToString(nElement));
}

//::///////////////////////////////////////////////
//:: DeleteArrayLocation
//:://////////////////////////////////////////////
/*
    Deletes the location array variable at the
    specified index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteArrayLocation(object oObject, string sArrayName, int nElement)
{
    DeleteLocalLocation(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + IntToString(nElement));
}

//::///////////////////////////////////////////////
//:: DeleteArrayObject
//:://////////////////////////////////////////////
/*
    Deletes the object array variable at the
    specified index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteArrayObject(object oObject, string sArrayName, int nElement)
{
    DeleteLocalObject(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + IntToString(nElement));
}

//::///////////////////////////////////////////////
//:: DeleteArrayString
//:://////////////////////////////////////////////
/*
    Deletes the string array variable at the
    specified index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteArrayString(object oObject, string sArrayName, int nElement)
{
    DeleteLocalString(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + IntToString(nElement));
}

//::///////////////////////////////////////////////
//:: DeleteFloatArray
//:://////////////////////////////////////////////
/*
    Deletes the specified float array (and all
    child components) from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteFloatArray(object oObject, string sArrayName)
{
    ResizeFloatArray(oObject, sArrayName, 0);
    DeleteLocalFloat(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: DeleteIntArray
//:://////////////////////////////////////////////
/*
    Deletes the specified int array (and all
    child components) from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteIntArray(object oObject, string sArrayName)
{
    ResizeIntArray(oObject, sArrayName, 0);
    DeleteLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: DeleteLocationArray
//:://////////////////////////////////////////////
/*
    Deletes the specified location array (and all
    child components) from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteLocationArray(object oObject, string sArrayName)
{
    ResizeLocationArray(oObject, sArrayName, 0);
    DeleteLocalLocation(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: DeleteObjectArray
//:://////////////////////////////////////////////
/*
    Deletes the specified object array (and all
    child components) from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteObjectArray(object oObject, string sArrayName)
{
    ResizeObjectArray(oObject, sArrayName, 0);
    DeleteLocalObject(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: DeleteStringArray
//:://////////////////////////////////////////////
/*
    Deletes the specified string array (and all
    child components) from the object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void DeleteStringArray(object oObject, string sArrayName)
{
    ResizeStringArray(oObject, sArrayName, 0);
    DeleteLocalString(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: GetArrayFloat
//:://////////////////////////////////////////////
/*
    Returns the value of the float at the
    specified array index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
float GetArrayFloat(object oObject, string sArrayName, int nElement)
{
    if(GetIsValidFloatArrayIndex(oObject, sArrayName, nElement))
        return GetLocalFloat(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + IntToString(nElement));

    return NULL_FLOAT;
}

//::///////////////////////////////////////////////
//:: GetArrayInt
//:://////////////////////////////////////////////
/*
    Returns the value of the int at the
    specified array index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetArrayInt(object oObject, string sArrayName, int nElement)
{
    if(GetIsValidIntArrayIndex(oObject, sArrayName, nElement))
        return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + IntToString(nElement));

    return NULL_INT;
}

//::///////////////////////////////////////////////
//:: GetArrayLocation
//:://////////////////////////////////////////////
/*
    Returns the value of the location at the
    specified array index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
location GetArrayLocation(object oObject, string sArrayName, int nElement)
{
    location lLoc;
    if(GetIsValidLocationArrayIndex(oObject, sArrayName, nElement))
        return GetLocalLocation(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + IntToString(nElement));

    return lLoc;
}

//::///////////////////////////////////////////////
//:: GetArrayObject
//:://////////////////////////////////////////////
/*
    Returns the value of the object at the
    specified array index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
object GetArrayObject(object oObject, string sArrayName, int nElement)
{
    if(GetIsValidObjectArrayIndex(oObject, sArrayName, nElement))
        return GetLocalObject(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + IntToString(nElement));

    return OBJECT_INVALID;
}

//::///////////////////////////////////////////////
//:: GetArrayString
//:://////////////////////////////////////////////
/*
    Returns the value of the string at the
    specified array index (i.e. element).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
string GetArrayString(object oObject, string sArrayName, int nElement)
{
    if(GetIsValidStringArrayIndex(oObject, sArrayName, nElement))
        return GetLocalString(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + IntToString(nElement));

    return NULL_STRING;
}

//::///////////////////////////////////////////////
//:: GetFloatArrayIndexOf
//:://////////////////////////////////////////////
/*
    Returns the location of nNth element in
    an array matching the specified value.
    Returns INDEX_INVALID if the element is not
    found.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetFloatArrayIndexOf(object oObject, string sArrayName, float fValue, int nNth = 1)
{
    int i;
    int nSize = GetFloatArraySize(oObject, sArrayName);

    for(i = 0; i < nSize; i++)
    {
        if(GetArrayFloat(oObject, sArrayName, i) == fValue)
            nNth--;
        if(!nNth)
            return i;
    }

    return INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetFloatArraySize
//:://////////////////////////////////////////////
/*
    Returns the size (i.e. maximum capacity)
    of the specified float array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetFloatArraySize(object oObject, string sArrayName)
{
    return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: GetIntArrayIndexOf
//:://////////////////////////////////////////////
/*
    Returns the location of nNth element in
    an array matching the specified value.
    Returns INDEX_INVALID if the element is not
    found.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIntArrayIndexOf(object oObject, string sArrayName, int nValue, int nNth = 1)
{
    int i;
    int nSize = GetIntArraySize(oObject, sArrayName);

    for(i = 0; i < nSize; i++)
    {
        if(GetArrayInt(oObject, sArrayName, i) == nValue)
            nNth--;
        if(!nNth)
            return i;
    }

    return INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetIntArraySize
//:://////////////////////////////////////////////
/*
    Returns the size (i.e. maximum capacity)
    of the specified int array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIntArraySize(object oObject, string sArrayName)
{
    return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: GetIsValidFloatArrayIndex
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex falls within the
    bounds of the specified array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIsValidFloatArrayIndex(object oObject, string sArrayName, int nIndex)
{
    int nSize = GetFloatArraySize(oObject, sArrayName);

    return (nIndex >= 0) && (nIndex <= nSize - 1);
}

//::///////////////////////////////////////////////
//:: GetIsValidIntArrayIndex
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex falls within the
    bounds of the specified array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIsValidIntArrayIndex(object oObject, string sArrayName, int nIndex)
{
    int nSize = GetIntArraySize(oObject, sArrayName);

    return (nIndex >= 0) && (nIndex <= nSize - 1);
}

//::///////////////////////////////////////////////
//:: GetIsValidLocationArrayIndex
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex falls within the
    bounds of the specified array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIsValidLocationArrayIndex(object oObject, string sArrayName, int nIndex)
{
    int nSize = GetLocationArraySize(oObject, sArrayName);

    return (nIndex >= 0) && (nIndex <= nSize - 1);
}

//::///////////////////////////////////////////////
//:: GetIsValidObjectArrayIndex
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex falls within the
    bounds of the specified array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIsValidObjectArrayIndex(object oObject, string sArrayName, int nIndex)
{
    int nSize = GetObjectArraySize(oObject, sArrayName);

    return (nIndex >= 0) && (nIndex <= nSize - 1);
}

//::///////////////////////////////////////////////
//:: GetIsValidStringArrayIndex
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex falls within the
    bounds of the specified array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetIsValidStringArrayIndex(object oObject, string sArrayName, int nIndex)
{
    int nSize = GetStringArraySize(oObject, sArrayName);

    return (nIndex >= 0) && (nIndex <= nSize - 1);
}

//::///////////////////////////////////////////////
//:: GetLocationArrayIndexOf
//:://////////////////////////////////////////////
/*
    Returns the location of nNth element in
    an array matching the specified value.
    Returns INDEX_INVALID if the element is not
    found.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetLocationArrayIndexOf(object oObject, string sArrayName, location lValue, int nNth = 1)
{
    int i;
    int nSize = GetLocationArraySize(oObject, sArrayName);

    for(i = 0; i < nSize; i++)
    {
        if(GetArrayLocation(oObject, sArrayName, i) == lValue)
            nNth--;
        if(!nNth)
            return i;
    }

    return INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetLocationArraySize
//:://////////////////////////////////////////////
/*
    Returns the size (i.e. maximum capacity)
    of the specified location array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetLocationArraySize(object oObject, string sArrayName)
{
    return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: GetObjectArrayIndexOf
//:://////////////////////////////////////////////
/*
    Returns the location of nNth element in
    an array matching the specified value.
    Returns INDEX_INVALID if the element is not
    found.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetObjectArrayIndexOf(object oObject, string sArrayName, object oValue, int nNth = 1)
{
    int i;
    int nSize = GetObjectArraySize(oObject, sArrayName);

    for(i = 0; i < nSize; i++)
    {
        if(GetArrayObject(oObject, sArrayName, i) == oValue)
            nNth--;
        if(!nNth)
            return i;
    }

    return INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetObjectArraySize
//:://////////////////////////////////////////////
/*
    Returns the size (i.e. maximum capacity)
    of the specified object array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetObjectArraySize(object oObject, string sArrayName)
{
    return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: GetStringArrayIndexOf
//:://////////////////////////////////////////////
/*
    Returns the location of nNth element in
    an array matching the specified value.
    Returns INDEX_INVALID if the element is not
    found.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetStringArrayIndexOf(object oObject, string sArrayName, string sValue, int nNth = 1)
{
    int i;
    int nSize = GetStringArraySize(oObject, sArrayName);

    for(i = 0; i < nSize; i++)
    {
        if(GetArrayString(oObject, sArrayName, i) == sValue)
            nNth--;
        if(!nNth)
            return i;
    }

    return INDEX_INVALID;
}

//::///////////////////////////////////////////////
//:: GetStringArraySize
//:://////////////////////////////////////////////
/*
    Returns the size (i.e. maximum capacity)
    of the specified string array.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
int GetStringArraySize(object oObject, string sArrayName)
{
    return GetLocalInt(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + "Size");
}

//::///////////////////////////////////////////////
//:: ResizeFloatArray
//:://////////////////////////////////////////////
/*
    Alters the size (i.e. maximum capacity)
    of the specified array. If the size is
    decreased, then any values that extend beyond
    the bounds of the new array will be deleted.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void ResizeFloatArray(object oObject, string sArrayName, int nSize)
{
    int nPreviousSize = GetFloatArraySize(oObject, sArrayName);

    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + "Size", nSize);

    if(nSize < nPreviousSize)
        while(nPreviousSize > nSize)
        {
            nPreviousSize--;
            DeleteArrayFloat(oObject, sArrayName, nPreviousSize);
        }
}

//::///////////////////////////////////////////////
//:: ResizeIntArray
//:://////////////////////////////////////////////
/*
    Alters the size (i.e. maximum capacity)
    of the specified array. If the size is
    decreased, then any values that extend beyond
    the bounds of the new array will be deleted.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void ResizeIntArray(object oObject, string sArrayName, int nSize)
{
    int nPreviousSize = GetIntArraySize(oObject, sArrayName);

    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + "Size", nSize);

    if(nSize < nPreviousSize)
        while(nPreviousSize > nSize)
        {
            nPreviousSize--;
            DeleteArrayInt(oObject, sArrayName, nPreviousSize);
        }
}

//::///////////////////////////////////////////////
//:: ResizeLocationArray
//:://////////////////////////////////////////////
/*
    Alters the size (i.e. maximum capacity)
    of the specified array. If the size is
    decreased, then any values that extend beyond
    the bounds of the new array will be deleted.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void ResizeLocationArray(object oObject, string sArrayName, int nSize)
{
    int nPreviousSize = GetLocationArraySize(oObject, sArrayName);

    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + "Size", nSize);

    if(nSize < nPreviousSize)
        while(nPreviousSize > nSize)
        {
            nPreviousSize--;
            DeleteArrayLocation(oObject, sArrayName, nPreviousSize);
        }
}

//::///////////////////////////////////////////////
//:: ResizeObjectArray
//:://////////////////////////////////////////////
/*
    Alters the size (i.e. maximum capacity)
    of the specified array. If the size is
    decreased, then any values that extend beyond
    the bounds of the new array will be deleted.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void ResizeObjectArray(object oObject, string sArrayName, int nSize)
{
    int nPreviousSize = GetObjectArraySize(oObject, sArrayName);

    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + "Size", nSize);

    if(nSize < nPreviousSize)
        while(nPreviousSize > nSize)
        {
            nPreviousSize--;
            DeleteArrayObject(oObject, sArrayName, nPreviousSize);
        }
}

//::///////////////////////////////////////////////
//:: ResizeStringArray
//:://////////////////////////////////////////////
/*
    Alters the size (i.e. maximum capacity)
    of the specified array. If the size is
    decreased, then any values that extend beyond
    the bounds of the new array will be deleted.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void ResizeStringArray(object oObject, string sArrayName, int nSize)
{
    int nPreviousSize = GetStringArraySize(oObject, sArrayName);

    nSize = ClampInt(nSize, ARRAY_MIN_SIZE, ARRAY_MAX_SIZE);
    SetLocalInt(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + "Size", nSize);

    if(nSize < nPreviousSize)
        while(nPreviousSize > nSize)
        {
            nPreviousSize--;
            DeleteArrayString(oObject, sArrayName, nPreviousSize);
        }
}

//::///////////////////////////////////////////////
//:: SetArrayFloat
//:://////////////////////////////////////////////
/*
    Sets a float array value. Note that the array
    must first be initialized with
    CreateFloatArray() for this function to work.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void SetArrayFloat(object oObject, string sArrayName, int nElement, float fValue)
{
    if(GetIsValidFloatArrayIndex(oObject, sArrayName, nElement))
        SetLocalFloat(oObject, LIB_ARRAY_PREFIX + "Float" + sArrayName + IntToString(nElement), fValue);
}

//::///////////////////////////////////////////////
//:: SetArrayInt
//:://////////////////////////////////////////////
/*
    Sets an int array value. Note that the array
    must first be initialized with
    CreateIntArray() for this function to work.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void SetArrayInt(object oObject, string sArrayName, int nElement, int nValue)
{
    if(GetIsValidIntArrayIndex(oObject, sArrayName, nElement))
        SetLocalInt(oObject, LIB_ARRAY_PREFIX + "Int" + sArrayName + IntToString(nElement), nValue);
}

//::///////////////////////////////////////////////
//:: SetArrayLocation
//:://////////////////////////////////////////////
/*
    Sets a location array value. Note that the array
    must first be initialized with
    CreateLocationArray() for this function to work.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void SetArrayLocation(object oObject, string sArrayName, int nElement, location lValue)
{
    if(GetIsValidLocationArrayIndex(oObject, sArrayName, nElement))
        SetLocalLocation(oObject, LIB_ARRAY_PREFIX + "Location" + sArrayName + IntToString(nElement), lValue);
}

//::///////////////////////////////////////////////
//:: SetArrayObject
//:://////////////////////////////////////////////
/*
    Sets an object array value. Note that the array
    must first be initialized with
    CreateObjectArray() for this function to work.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////
void SetArrayObject(object oObject, string sArrayName, int nElement, object oValue)
{
    if(GetIsValidObjectArrayIndex(oObject, sArrayName, nElement))
        SetLocalObject(oObject, LIB_ARRAY_PREFIX + "Object" + sArrayName + IntToString(nElement), oValue);
}

//::///////////////////////////////////////////////
//:: SetArrayString
//:://////////////////////////////////////////////
/*
    Sets a string array value. Note that the array
    must first be initialized with
    CreateStringArray() for this function to work.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 13, 2016
//:://////////////////////////////////////////////
void SetArrayString(object oObject, string sArrayName, int nElement, string sValue)
{
    if(GetIsValidStringArrayIndex(oObject, sArrayName, nElement))
        SetLocalString(oObject, LIB_ARRAY_PREFIX + "String" + sArrayName + IntToString(nElement), sValue);
}
//::///////////////////////////////////////////////
//:: String List Library
//:: inc_list
//:://////////////////////////////////////////////
/*
    Contains functions for handling and
    manipulating string lists--that is, string
    arrays stored as a single delimited value.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////

#include "inc_string"

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// List index out of bounds.
const int LIST_INDEX_OUT_OF_BOUNDS = -1;
// Delimiter between strings in a string list. String lists must NEVER contain
// strings that include the delimiter in themselves.
const string LIST_DELIMITER = "¤";
// Variable name prefix used to distinguish list variables from other variables.
const string LIST_VARIABLE_PREFIX = "Lib_List_";
// Return value if a string fetch attempt was out of bounds.
const string STRING_NOT_FOUND = "";

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Appends a list string to the object's specified string list.
void AddListElement(object oObject, string sListName, string sValue);
// Deletes a string list from an object.
void DeleteListArray(object oObject, string sListName);
// Returns TRUE if the specified list exists.
int GetIsListValid(object oObject, string sListName);
// Returns TRUE if nIndex is valid for the specified string list.
int GetIsListIndexValid(object oObject, string sListName, int nIndex);
// Returns a full delimited list.
string GetList(object oObject, string sListName);
// Returns the string at the specified index of a string list.
string GetListElement(object oObject, string sListName, int nIndex);
// Returns the index of the first value matching sValue in a string list.
int GetListElementIndex(object oObject, string sListName, string sValue);
// Returns the size of a string list.
int GetListSize(object oObject, string sListName);
// Inserts a string into a string list at the specified index. Returns LIST_INDEX_OUT_OF_BOUNDS
// on error.
int InsertListElement(object oObject, string sListName, int nIndex, string sValue);
// Removes the string found at the specified index. Returns LIST_INDEX_OUT_OF_BOUNDS on error.
int RemoveListElement(object oObject, string sListName, int nIndex);
// Sets the string value found at the specified index. Returns LIST_INDEX_OUT_OF_BOUNDS on error.
int SetListElement(object oObject, string sListName, int nIndex, string sValue);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Decrements the size of a string list. */
void _DecrementListSize(object oObject, string sListName);
/* Increments the size of a string list. */
void _IncrementListSize(object oObject, string sListName);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AddListElement
//:://////////////////////////////////////////////
/*
    Appends a list string to the object's
    specified string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void AddListElement(object oObject, string sListName, string sValue)
{
    string sNewString = GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName) + LIST_DELIMITER + sValue;

    SetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName, sNewString);
    _IncrementListSize(oObject, sListName);
}

//::///////////////////////////////////////////////
//:: DeleteListArray
//:://////////////////////////////////////////////
/*
    Deletes a string list from an object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void DeleteListArray(object oObject, string sListName)
{
    DeleteLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
    DeleteLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName);
}

//::///////////////////////////////////////////////
//:: GetIsListIndexValid
//:://////////////////////////////////////////////
/*
    Returns TRUE if nIndex is valid for
    the specified string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetIsListIndexValid(object oObject, string sListName, int nIndex)
{
    return (nIndex >= 0) && (nIndex <= GetListSize(oObject, sListName) - 1);
}

//::///////////////////////////////////////////////
//:: GetIsListValid
//:://////////////////////////////////////////////
/*
    Returns TRUE if the specified list exists.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetIsListValid(object oObject, string sListName)
{
    return GetListSize(oObject, sListName) > 0;
}

//::///////////////////////////////////////////////
//:: GetList
//:://////////////////////////////////////////////
/*
    Returns a full delimited list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May21, 2016
//:://////////////////////////////////////////////
string GetList(object oObject, string sListName)
{
    return GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
}

//::///////////////////////////////////////////////
//:: GetListElement
//:://////////////////////////////////////////////
/*
    Returns the string at the specified index
    of a string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
string GetListElement(object oObject, string sListName, int nIndex)
{
    string sList = GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
    int nStartPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 1);

    if(nStartPos == -1)
        return STRING_NOT_FOUND;

    int nEndPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 2);

    if(nEndPos == -1)
        return GetStringRight(sList, GetStringLength(sList) - nStartPos - 1);
    else
        return GetSubString(sList, nStartPos + 1, nEndPos - nStartPos - 1);
}

//::///////////////////////////////////////////////
//:: GetListElementIndex
//:://////////////////////////////////////////////
/*
    Returns the index of the first value
    matching sValue in a string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetListElementIndex(object oObject, string sListName, string sValue)
{
    int i;
    int nElements = GetListSize(oObject, sListName);

    for(i = 0; i < nElements; i++)
        if(GetListElement(oObject, sListName, i) == sValue)
            return i;

    return LIST_INDEX_OUT_OF_BOUNDS;
}

//::///////////////////////////////////////////////
//::  GetListSize
//:://////////////////////////////////////////////
/*
    Returns the size of a string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int GetListSize(object oObject, string sListName)
{
    return GetLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName);
}

//::///////////////////////////////////////////////
//:: InsertListElement
//:://////////////////////////////////////////////
/*
    Inserts a string into a string list at the
    specified index. Returns LIST_INDEX_OUT_OF_BOUNDS
    on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int InsertListElement(object oObject, string sListName, int nIndex, string sValue)
{
    if(!GetIsListIndexValid(oObject, sListName, nIndex))
        return LIST_INDEX_OUT_OF_BOUNDS;

    string sList = GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
    string sListLeft;
    string sListRight;
    int nStartPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 1);

    sListLeft = GetStringLeft(sList, nStartPos);
    sListRight = GetStringRight(sList, GetStringLength(sList) - nStartPos);
    SetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName, sListLeft + LIST_DELIMITER + sValue + sListRight);
    _IncrementListSize(oObject, sListName);

    return nStartPos;
}

//::///////////////////////////////////////////////
//:: RemoveListElement
//:://////////////////////////////////////////////
/*
    Removes the string found at the specified
    index. Returns LIST_INDEX_OUT_OF_BOUNDS on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int RemoveListElement(object oObject, string sListName, int nIndex)
{
    if(!GetIsListIndexValid(oObject, sListName, nIndex)) { return LIST_INDEX_OUT_OF_BOUNDS; }

    string sList = GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
    string sListLeft;
    string sListRight;
    int nStartPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 1);
    int nEndPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 2);

    sListLeft = GetStringLeft(sList, nStartPos);
    if(nEndPos > 0)
        sListRight = GetStringRight(sList, GetStringLength(sList) - nEndPos);
    SetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName, sListLeft + sListRight);
    _DecrementListSize(oObject, sListName);

    return nStartPos;
}

//::///////////////////////////////////////////////
//:: SetListElement
//:://////////////////////////////////////////////
/*
    Sets the string value found at the specified
    index. Returns LIST_INDEX_OUT_OF_BOUNDS on error.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int SetListElement(object oObject, string sListName, int nIndex, string sValue)
{
    if(!GetIsListIndexValid(oObject, sListName, nIndex))
        return LIST_INDEX_OUT_OF_BOUNDS;

    string sList = GetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName);
    string sListLeft;
    string sListRight;
    int nStartPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 1);
    int nEndPos = FindNthSubString(sList, LIST_DELIMITER, 0, nIndex + 2);

    sListLeft = GetStringLeft(sList, nStartPos);
    if(nEndPos > 0)
        sListRight = GetStringRight(sList, GetStringLength(sList) - nEndPos);
    SetLocalString(oObject, LIST_VARIABLE_PREFIX + sListName, sListLeft + LIST_DELIMITER + sValue + sListRight);

    return nStartPos;
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _DecrementListSize
//:://////////////////////////////////////////////
/*
    Decrements the size of a string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void _DecrementListSize(object oObject, string sListName)
{
    int nNewSize = GetLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName) - 1;

    SetLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName, nNewSize);
}

//::///////////////////////////////////////////////
//:: _IncrementListSize
//:://////////////////////////////////////////////
/*
    Increments the size of a string list.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
void _IncrementListSize(object oObject, string sListName)
{
    int nNewSize = GetLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName) + 1;

    SetLocalInt(oObject, LIST_VARIABLE_PREFIX + "Size_" + sListName, nNewSize);
}

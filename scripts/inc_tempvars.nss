//::///////////////////////////////////////////////
//:: Temporary Variables Library
//:: inc_tempvars
//:://////////////////////////////////////////////
/*
    Library for handling temporary variables.
    Temporary variables are local variables that
    are automatically removed on the designated
    event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////

#include "inc_list"

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate temporary variable variables from other libraries.
const string LIB_TEMP_VARS_PREFIX = "Lib_TempVars_";

// Variable types.
const int TEMP_VARIABLE_TYPE_FLOAT = 0;
const int TEMP_VARIABLE_TYPE_INT = 1;
const int TEMP_VARIABLE_TYPE_LOCATION = 2;
const int TEMP_VARIABLE_TYPE_OBJECT = 3;
const int TEMP_VARIABLE_TYPE_STRING = 4;

// Expiration events. Configured for use as bitwise operators.
const int TEMP_VARIABLE_EXPIRATION_EVENT_ANY = 1;
const int TEMP_VARIABLE_EXPIRATION_EVENT_REST = 2;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Deletes all variables from the object that have been flagged for deleted on
// the specified event.
void DeleteTempVariables(object oObject, int nExpirationEvent);
// Sets a float on the object. Will be deleted on the specified event.
void SetTempFloat(object oObject, string sVarName, float fValue, int nExpirationEvent);
// Sets an int on the object. Will be deleted on the specified event.
void SetTempInt(object oObject, string sVarName, int nValue, int nExpirationEvent);
// Sets a location on the object. Will be deleted on the specified event.
void SetTempLocation(object oObject, string sVarName, location lValue, int nExpirationEvent);
// Sets an object on the object. Will be deleted on the specified event.
void SetTempObject(object oObject, string sVarName, object oValue, int nExpirationEvent);
// Sets a string on the object. Will be deleted on the specified event.
void SetTempString(object oObject, string sVarName, string sValue, int nExpirationEvent);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Deletes all temporary variables from the object flagged for deleted on the specified
   event and removes them from tracking. */
void _FlushTempVariables(object oObject, int nVarType, int nExpirationEvent);
/* Tracks the temporary variable for deletion on the specified event. */
void _TrackTempVariable(object oObject, string sVarName, int nVarType, int nExpirationEvent);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: DeleteTempVariables
//:://////////////////////////////////////////////
/*
    Deletes all variables from the object
    that have been flagged for deleted on
    the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void DeleteTempVariables(object oObject, int nExpirationEvent)
{
    int i;

    for(i = TEMP_VARIABLE_TYPE_FLOAT; i <= TEMP_VARIABLE_TYPE_STRING; i++)
    {
        _FlushTempVariables(oObject, i, nExpirationEvent);
    }
}

//::///////////////////////////////////////////////
//:: SetTempFloat
//:://////////////////////////////////////////////
/*
    Sets a float on the object. Will be deleted
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void SetTempFloat(object oObject, string sVarName, float fValue, int nExpirationEvent)
{
    SetLocalFloat(oObject, sVarName, fValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_FLOAT, nExpirationEvent);
}

//::///////////////////////////////////////////////
//:: SetTempInt
//:://////////////////////////////////////////////
/*
    Sets an int on the object. Will be deleted
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void SetTempInt(object oObject, string sVarName, int nValue, int nExpirationEvent)
{
    SetLocalInt(oObject, sVarName, nValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_INT, nExpirationEvent);
}

//::///////////////////////////////////////////////
//:: SetTempLocation
//:://////////////////////////////////////////////
/*
    Sets a location on the object. Will be deleted
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void SetTempLocation(object oObject, string sVarName, location lValue, int nExpirationEvent)
{
    SetLocalLocation(oObject, sVarName, lValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_LOCATION, nExpirationEvent);
}

//::///////////////////////////////////////////////
//:: SetTempObject
//:://////////////////////////////////////////////
/*
    Sets an object on the object. Will be deleted
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void SetTempObject(object oObject, string sVarName, object oValue, int nExpirationEvent)
{
    SetLocalObject(oObject, sVarName, oValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_OBJECT, nExpirationEvent);
}

//::///////////////////////////////////////////////
//:: SetTempString
//:://////////////////////////////////////////////
/*
    Sets a string on the object. Will be deleted
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void SetTempString(object oObject, string sVarName, string sValue, int nExpirationEvent)
{
    SetLocalString(oObject, sVarName, sValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_STRING, nExpirationEvent);
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _FlushTempVariables
//:://////////////////////////////////////////////
/*
    Deletes all temporary variables from the
    object flagged for deleted on the specified
    event and removes them from tracking.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void _FlushTempVariables(object oObject, int nVarType, int nExpirationEvent)
{
    int i;

    for(i = 0; i < GetListSize(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType)); i++)
    {
        if(nExpirationEvent & StringToInt(GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarExpirationEvents" + IntToString(nVarType), i)))
        {
            switch(nVarType)
            {
                case TEMP_VARIABLE_TYPE_FLOAT:
                    DeleteLocalFloat(oObject, GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i));
                    break;
                case TEMP_VARIABLE_TYPE_INT:
                    DeleteLocalInt(oObject, GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i));
                    break;
                case TEMP_VARIABLE_TYPE_LOCATION:
                    DeleteLocalLocation(oObject, GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i));
                    break;
                case TEMP_VARIABLE_TYPE_OBJECT:
                    DeleteLocalObject(oObject, GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i));
                    break;
                case TEMP_VARIABLE_TYPE_STRING:
                    DeleteLocalString(oObject, GetListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i));
                    break;
            }
            RemoveListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), i);
            RemoveListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarExpirationEvents" + IntToString(nVarType), i);
            i--;
        }
    }
}

//::///////////////////////////////////////////////
//:: _TrackTempVariable
//:://////////////////////////////////////////////
/*
    Tracks the temporary variable for deletion
    on the specified event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 14, 2016
//:://////////////////////////////////////////////
void _TrackTempVariable(object oObject, string sVarName, int nVarType, int nExpirationEvent)
{
    AddListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarNames" + IntToString(nVarType), sVarName);
    AddListElement(oObject, LIB_TEMP_VARS_PREFIX + "TempVarExpirationEvents" + IntToString(nVarType), IntToString(nExpirationEvent));
}

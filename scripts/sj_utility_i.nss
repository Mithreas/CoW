//  ----------------------------------------------------------------------------
//  sj_utility_i
//  ----------------------------------------------------------------------------
/*
    Utility Library
*/
//  ----------------------------------------------------------------------------
/*
   Version: 0.00 - 25/06/04 - Sunjammer
    - cut-down version for use with sj_tilemagic_i
*/
//  ----------------------------------------------------------------------------
#include "sj_debug_i"


//  ----------------------------------------------------------------------------
//  CONSTANTS
//  ----------------------------------------------------------------------------

// rotation (all counter-clockwise)
const int SJ_ROTATION_RANDOM    = -1;
const int SJ_ROTATION_NONE      = 0;
const int SJ_ROTATION_90        = 1;
const int SJ_ROTATION_180       = 2;
const int SJ_ROTATION_270       = 3;

// maximum number of tiles in an area's height or width.
const int SJ_MAX_AREA_DIMENSION = 32;

// numbers indicating an invalid tile
const int SJ_MAINLIGHT1_COLOR_INVALID   = 517;
const int SJ_MAINLIGHT2_COLOR_INVALID   = 518;
const int SJ_SOURCELIGHT1_COLOR_INVALID = 519;
const int SJ_SOURCELIGHT2_COLOR_INVALID = 520;

// datapoint blueprint and tag
const string SJ_RES_DATAPOINT   = "sj_datapoint";
const string SJ_TAG_DATAPOINT   = "sj_datapoint_";


//  ----------------------------------------------------------------------------
//  PROTOTYPES
//  ----------------------------------------------------------------------------

// Returns TRUE if a fX and fY are both within the bounds of oArea.
int SJ_GetIsSpotValid(object oArea, float fX, float fY);

// Returns TRUE if a nColumn and nRow are both within the bounds of oArea.
int SJ_GetIsTileValid(object oArea, int nColumn, int nRow);

// Returns oArea's width as a number of tiles.
int SJ_GetAreaWidth(object oArea = OBJECT_SELF);

// Returns oArea's height as a number of tiles.
int SJ_GetAreaHeight(object oArea = OBJECT_SELF);

// Converts nInteger to a string and if required pads it by prefixing it with
// sPadWith until it is at least nLength characters long.
//  - nInteger:     number to be converted and padded
//  - nLength:      minimum length of returned string
//  - sPadding:     charater(s) to prefix
string SJ_IntToPrePaddedString(int nInteger, int nLength, string sPadding = "0");

// Removes one instance of sSubString from anywhere sString.
//  * Returns:      modified sString
//  * OnError:      sString if sSubstring null or not found
string SJ_RemoveSubString(string sString, string sSubString);

// Creates a waypoint at the start location to act as a temporary DataBase.
// Requires a unique tag created by adding SJ_TAG_DATAPOINT and sName. The tag
// cannot exceed 32 chars.
//  - sName:        unique identifier
//  * Returns:      waypoint object
//  * OnError:      returns OBJECT_INVALID
object SJ_CreateDatapoint(string sName);

// Destroys the datapoint (specially formatted/located waypoint) with sName.
//  - sName:        unique identifier
void SJ_DestroyDatapoint(string sName);

// Returns the datapoint (specially formatted/located waypoint) with sName.
//  - sName:        unique identifier
//  * Returns:      waypoint object
//  * OnError:      returns OBJECT_INVALID
object SJ_GetDatapoint(string sName);

// Returns TRUE datapoint (specially formatted/located waypoint) with sName.
//  - sName:        unique identifier
//  * Returns:      waypoint object
int SJ_GetIsDatapointValid(string sName);


//  ----------------------------------------------------------------------------
//  FUNCTIONS
//  ----------------------------------------------------------------------------

int SJ_GetIsSpotValid(object oArea, float fX, float fY)
{
    // for SJ_GetIsTileValid a tile is considered to be 1 unit wide rather than
    // the normal 10.
    return SJ_GetIsTileValid(oArea, FloatToInt(fX) / 10, FloatToInt(fY) / 10);
}


int SJ_GetIsTileValid(object oArea, int nColumn, int nRow)
{
    // create a "tile" location in contrast to a "real" location.  This location
    // is only used to pass an X and Y value to GetTileMainLight1Color(). This
    // means a tile is considered to be 1 unit wide rather than the normal 10.
    vector vTile = Vector(IntToFloat(nColumn), IntToFloat(nRow));
    location lTile = Location(oArea, vTile, 0.0);

    // if the tile's mainlight is invalid then the tile too is invalid
    if(GetTileMainLight1Color(lTile) == SJ_MAINLIGHT1_COLOR_INVALID)
    {
        return FALSE;
    }
    return TRUE;
}

int SJ_GetAreaWidth(object oArea = OBJECT_SELF)
{
    // check each tile and return the index of the first invalid tile found
    // since tiles are numbered form 0 this gives the correct width

    int n;
    for(n = 0; n < SJ_MAX_AREA_DIMENSION; n++)
    {
        if(SJ_GetIsTileValid(oArea, n, 0) == FALSE)
        {
            return n;
        }
    }
    return SJ_MAX_AREA_DIMENSION;
}

int SJ_GetAreaHeight(object oArea = OBJECT_SELF)
{
    // check each tile and return the index of the first invalid tile found
    // since tiles are numbered form 0 this gives the correct height

    int n;
    for(n = 0; n < SJ_MAX_AREA_DIMENSION; n++)
    {
        if(SJ_GetIsTileValid(oArea, 0, n) == FALSE)
        {
            return n;
        }
    }
    return SJ_MAX_AREA_DIMENSION;
}


string SJ_IntToPrePaddedString(int nInteger, int nLength, string sPadding = "0")
{
    // convert to string and prefix as required until minimum length reached

    string sRet = IntToString(nInteger);

    while(GetStringLength(sRet) < nLength)
    {
        sRet = sPadding + sRet;
    }

    return sRet;
}


string SJ_RemoveSubString(string sString, string sSubString)
{
    // format = left + substring + right
    // where left and/or right can be null

    int nPosition = FindSubString(sString, sSubString);

    if(nPosition > -1)
    {
        // get left stringlet
        string sLeft = GetStringLeft(sString, nPosition);

        // calculate remaining characters, get right stringlet
        int nCount = GetStringLength(sString) - GetStringLength(sLeft + sSubString);
        string sRight = GetStringRight(sString, nCount);

        // return left + right
        return sLeft + sRight;
    }
    else
    {
        // substring not found: return string
        return sString;
    }
}

object SJ_CreateDatapoint(string sName)
{
    string sDebug;
    string sTag = SJ_TAG_DATAPOINT + sName;

    // checks
    if(sName == "")
    {
        // check: name is null
        sDebug = "SJ_CreateDatapoint: failled as name was null.";
    }
    else if(GetStringLength(sTag) > 32)
    {
        // check: tag is too long
        sDebug = "SJ_CreateDatapoint: failled as tag (" + sTag + ") exceeded 32 characters.";
    }
    else if(GetIsObjectValid(GetWaypointByTag(sTag)))
    {
        // datapoint exists
        sDebug = "SJ_CreateDatapoint: failled as datpoint (" + sName + ") already exists.";
    }

    // create?
    if(sDebug == "")
    {
        // passed all checks: create datapoint
        location lDP = GetStartingLocation();
        return CreateObject(OBJECT_TYPE_WAYPOINT, SJ_RES_DATAPOINT, lDP, FALSE, sTag);
    }
    else
    {
        // log an error
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }
}


void SJ_DestroyDatapoint(string sName)
{
    string sTag = SJ_TAG_DATAPOINT + sName;
    object oDP = GetWaypointByTag(sTag);

    if(GetIsObjectValid(oDP) == FALSE)
    {
        // log an error
        string sDebug = "SJ_DestroyDatapoint: failled as datapoint (" + sName + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // datapoint is valid: destroy it
    DestroyObject(oDP);
}


object SJ_GetDatapoint(string sName)
{
    string sTag = SJ_TAG_DATAPOINT + sName;
    object oDP = GetWaypointByTag(sTag);

    if(GetIsObjectValid(oDP) == FALSE)
    {
        // log an error
        string sDebug = "SJ_GetDatapoint: failled as datapoint (" + sName + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }

    // datapoint is valid: return it
    return oDP;
}


int SJ_GetIsDatapointValid(string sName)
{
    string sTag = SJ_TAG_DATAPOINT + sName;
    object oDP = GetWaypointByTag(sTag);

    // check if a valid datapoint with sName exists
    return GetIsObjectValid(oDP);
}

//void main(){}

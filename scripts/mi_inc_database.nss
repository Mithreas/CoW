/*
  mi_inc_database

  Based on aps_include from the Avlis Persistent World script set, to interface
  with an external database via NWNX.

  Edits by Mith:
    - Added database caching mechanism (miDAGetCacheObject())
    - Added a method to extract a particular column from a database table row.
      Table needs to contain:
        * key column containing unique identifier for the row
        * (data columns)
        * Timestamp column for housekeeping

*/

#include "__server_config"
#include "mi_log"
#include "nwnx_sql"

const string DATABASE = "DATABASE"; // for logging

/************************************/
/* Return codes                     */
/************************************/

const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

/************************************/
/* Function prototypes              */
/************************************/

// Execute statement in sSQL
void SQLExecDirect(string sSQL);

// See SQLExecStatement. This function is exactly the same, except instead of
// running the query it returns it, allowing you to use SQLExecDirect on it.
// This method should be used when the same query must be executed more than
// once, or a query needs further tinkering before being passed to the DBMS.
string SQLPrepareStatement(string sSQL, string sStr0="", string sStr1="", string sStr2="", string sStr3="", string sStr4="", string sStr5="", string sStr6="", string sStr7="", string sStr8="", string sStr9="", string sStr10="", string sStr11="", string sStr12="", string sStr13="", string sStr14="", string sStr15="");

// Executes sSQL, swapping out the ? character for sStr0, sStr1, ... and
// properly escaping special characters. Should be used in preference to
// embedding dynamic statements directly in the SQL, for readability and because
// it helps to avoid issues with quotes.
void SQLExecStatement(string sSQL, string sStr0="", string sStr1="", string sStr2="", string sStr3="", string sStr4="", string sStr5="", string sStr6="", string sStr7="", string sStr8="", string sStr9="", string sStr10="", string sStr11="", string sStr12="", string sStr13="", string sStr14="", string sStr15="");

// Position cursor on next row of the resultset
// Call this before using SQLGetData().
// returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int SQLFetch();

// Return value of column iCol in the current row of result set sResultSetName
string SQLGetData(int iCol);

// Return a string value when given a location
string APSLocationToString(location lLocation);

// Return a location value when given the string form of the location
location APSStringToLocation(string sLocation);

// Return a string value when given a vector
string APSVectorToString(vector vVector);

// Return a vector value when given the string form of the vector
vector APSStringToVector(string sVector);

// Escape special character ' in sString. Not usually necessary when using the
// SQLExecStatement or SQLPrepareStatement functions.
string SQLEncodeSpecialChars(string sString);

//adapted for nwnx standard from FF's code.
int SQLExecAndFetchSingleInt(string sSQL);

// returns result of SELECT sColumn FROM sTable WHERE sKeyField='sKey';
// Encodes sColumn, sDatabase and sKey and decodes the result.
string miDAGetKeyedValue(string sTable, string sKey, string sColumn, string sKeyField = "PRIMARYKEY");

// Performs INSERT INTO/UPDATE to set sColumn = sValue where sKeyField=sKey;
// Encodes sValue and sKey.
void miDASetKeyedValue(string sTable, string sKey, string sColumn, string sValue, string sKeyField = "PRIMARYKEY");

// Returns the object to use to cache database information on.  sKey is an
// arbitrary key.
object miDAGetCacheObject(string sKey);

// Deletes the gs_pc_data row with ID sID
void miDADeleteDatabaseEntry(string sID);

/************************************/
/* Implementation                   */
/************************************/

// Functions for initializing APS and working with result sets

void SQLExecDirect(string sSQL)
{
    NWNX_SQL_ExecuteQuery(sSQL);
}

string SQLPrepareStatement(string sSQL, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="")
{
  int nPos, nCount = 0;

  string sLeft = "", sRight = sSQL;

  while ((nPos = FindSubString(sRight, "?")) != -1)
  {
    string sInsert;

    switch (nCount++)
    {
      case 0:  sInsert = sStr0; break;
      case 1:  sInsert = sStr1; break;
      case 2:  sInsert = sStr2; break;
      case 3:  sInsert = sStr3; break;
      case 4:  sInsert = sStr4; break;
      case 5:  sInsert = sStr5; break;
      case 6:  sInsert = sStr6; break;
      case 7:  sInsert = sStr7; break;
      case 8:  sInsert = sStr8; break;
      case 9:  sInsert = sStr9; break;
      case 10: sInsert = sStr10; break;
      case 11: sInsert = sStr11; break;
      case 12: sInsert = sStr12; break;
      case 13: sInsert = sStr13; break;
      case 14: sInsert = sStr14; break;
      case 15: sInsert = sStr15; break;
      default: sInsert = "*INVALID*"; break;
    }

    sLeft += GetStringLeft(sRight, nPos) + "'" + SQLEncodeSpecialChars(sInsert) + "'";
    sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
  }

  return sLeft + sRight;
}

void SQLExecStatement(string sSQL, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="")
{
  SQLExecDirect(SQLPrepareStatement(sSQL, sStr0, sStr1, sStr2, sStr3, sStr4, sStr5,
   sStr6, sStr7, sStr8, sStr9, sStr10, sStr11, sStr12, sStr13, sStr14, sStr15));
}

int SQLFetch()
{
    int ready = NWNX_SQL_ReadyToReadNextRow();

    if (ready)
    {
        NWNX_SQL_ReadNextRow();
        return SQL_SUCCESS;
    }

    return SQL_ERROR;
}

string _SanitizeData(string sString)
{
  Trace(DATABASE, "Fetched: " + sString);

  int nPos = FindSubString(sString, "~");
  if (nPos == -1) return sString;

  string sReturn = "";
  while (nPos != -1)
  {
      sReturn += GetStringLeft(sString, nPos) + "'";
      sString = GetStringRight(sString, GetStringLength(sString) - (nPos + 1));
      nPos = FindSubString(sString, "~");
  }
  sReturn += sString;

  Trace(DATABASE, "Decoded to: " + sReturn);
  return sReturn;
}

string SQLGetData(int iCol)
{
    return _SanitizeData(NWNX_SQL_ReadDataInActiveRow(iCol - 1)); // C++ is 0-based, current NWScript API is 1-based.
}

// These functions deal with various data types. Ultimately, all information
// must be stored in the database as strings, and converted back to the proper
// form when retrieved.

string APSVectorToString(vector vVector)
{
    return "#POSITION_X#" + FloatToString(vVector.x) + "#POSITION_Y#" + FloatToString(vVector.y) +
        "#POSITION_Z#" + FloatToString(vVector.z) + "#END#";
}

vector APSStringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, iCount));
    }

    return Vector(fX, fY, fZ);
}

string APSLocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    sReturnValue =
            "#AREA#" + GetTag(oArea) + "#POSITION_X#" + FloatToString(vPosition.x) +
            "#POSITION_Y#" + FloatToString(vPosition.y) + "#POSITION_Z#" +
            FloatToString(vPosition.z) + "#ORIENTATION#" + FloatToString(fOrientation) + "#END#";

    return sReturnValue;
}

location APSStringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#AREA#") + 6;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#ORIENTATION#") + 13;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}

string SQLEncodeSpecialChars(string sString)
{
  int nPos = FindSubString(sString, "'");
  if (nPos == -1) return sString;

  string sReturn = "";
  while (nPos != -1)
  {
      sReturn += GetStringLeft(sString, nPos) + "~";
      sString = GetStringRight(sString, GetStringLength(sString) - (nPos + 1));
      nPos = FindSubString(sString, "'");
  }
  sReturn += sString;
  return sReturn;
}

// Depreciated, this all happens automatically now
string SQLDecodeSpecialChars(string sString)
{
  return sString;
}

//adapted for nwnx standard from FF's code.
int SQLExecAndFetchSingleInt(string sSQL)
{
    SQLExecDirect(sSQL);
    if(SQLFetch())
        return StringToInt(SQLGetData(1));
    else
        return 0;
}

// Returns the primary key of sTable, by default 'id'.
string _miDAGetPrimaryKey(string sTable)
{
  string sPk = "id";

  if (sTable == "gs_deities" ||
      sTable == "gs_quarter" ||
      sTable == "gs_system" ||
      sTable == "ar_land_broker" ||
      sTable == "micz_positions") sPk = "row_key";

  else if (sTable == "web_server" || sTable == "nwn.web_server") sPk = "sid";

  else if (sTable == "landbroker") sPk = "area_id";

  return sPk;
}

// returns result of SELECT sColumn FROM sTable WHERE sKeyField='sKey';
// Encodes sKey and decodes the result. If NULL is given for sKey, the query is
// adjusted accordingly.
string miDAGetKeyedValue(string sTable, string sKey, string sColumn, string sKeyField = "PRIMARYKEY")
{
  if (sKeyField == "PRIMARYKEY")
  {
    sKeyField = _miDAGetPrimaryKey(sTable);
  }

  if (sKey != "NULL")
  {
    sKey = sKeyField + " = '" + SQLEncodeSpecialChars(sKey) + "'";
  }
  else
  {
    sKey = sKeyField + " IS NULL";
  }

  string sSQL = "SELECT " + sColumn + " FROM " + sTable + " WHERE " + sKey;

  Trace (DATABASE, "Query string: " + sSQL);
  SQLExecDirect(sSQL);

  if (SQLFetch() == SQL_SUCCESS)
  {
    string sData = SQLGetData(1);
    Trace (DATABASE, "Got data: " + sData);
    return sData;
  }
  else
  {
    Trace (DATABASE, "Query failed.");
    return "";
  }
}

// Performs INSERT INTO/UPDATE to set sColumn = sValue where sKeyField=sKey;
// Encodes sValue and sKey. If NULL is given for sValue or sKey, the query is
// adjusted accordingly.
void miDASetKeyedValue(string sTable, string sKey, string sColumn, string sValue, string sKeyField = "PRIMARYKEY")
{
  if (sKeyField == "PRIMARYKEY")
  {
    sKeyField = _miDAGetPrimaryKey(sTable);
  }

  // Need to use SQLExecDirect here to deal with NULL.
  string sKeyQuery;
  if (sKey != "NULL")
  {
    sKey      = "'" + SQLEncodeSpecialChars(sKey) + "'";
    sKeyQuery = sKeyField + " = " + sKey;
  }
  else
  {
    sKeyQuery = sKeyField + " IS NULL";
  }

  if (sValue != "NULL")
  {
    sValue = "'" + SQLEncodeSpecialChars(sValue) + "'";
  }

  // Execute queries.
  SQLExecDirect("SELECT " + sKeyField + " FROM " + sTable + " WHERE " + sKeyQuery);

  if (SQLFetch() == SQL_SUCCESS)
  {
    // row exists
    SQLExecDirect("UPDATE " + sTable + " SET " + sColumn + " = " + sValue + " WHERE " + sKeyQuery);
  }
  else
  {
    // row doesn't exist
    SQLExecDirect("INSERT INTO " + sTable + " (" + sKeyField + "," + sColumn +
      ") VALUES (" + sKey + "," + sValue + ")");
  }
}

// Returns the object to use to cache database information on.  sKey is an
// arbitrary key.
object miDAGetCacheObject(string sKey)
{
  object oCacheContainer = GetObjectByTag("MI_DA_CACHE");

  if (!GetIsObjectValid(oCacheContainer))
  {
    Error(DATABASE, "Database cache container not found!!!");
    return OBJECT_INVALID;
  }
  else
  {
    object oCache = GetItemPossessedBy(oCacheContainer, "MI_DA_CACHE_" + sKey);

    if (!GetIsObjectValid (oCache))
    {
      oCache = CreateItemOnObject("mi_da_cache", oCacheContainer, 1, "MI_DA_CACHE_" + sKey);
    }

    return oCache;
  }
}

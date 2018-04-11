/* AREA Library by Gigaschatten */

#include "inc_database"
#include "inc_xfer"

//void main() {}

// MI_PLANE constants (values of the MI_PLANE area variable).
const int MI_PLANE_MATERIAL = 0;
const int MI_PLANE_SHADOW   = 1;
const int MI_PLANE_ETHEREAL = 2;
const int MI_PLANE_BAATOR   = 3;
const int MI_PLANE_ABYSS    = 4;

//register oArea
void gsARRegisterArea(object oArea);
//return registered area by nIndex
object gsARGetRegisteredArea(int nIndex);
//unregister oArea
void gsARUnregisterArea(object oArea);
//return number of registered areas
int gsARGetRegisteredAreaCount();
//return TRUE if oArea is active
int gsARGetIsAreaActive(object oArea);
//return x size of oArea
float gsARGetSizeX(object oArea);
//return y size of oArea
float gsARGetSizeY(object oArea);

// load id and any variables stored in the database for this area
void gvd_LoadAreaVars(object oArea);

// set local int/string/float variable on area and save it to the area variable db table
void gvd_SetAreaInt(object oArea, string sVarName, int iVarValue);
void gvd_SetAreaString(object oArea, string sVarName, string sVarValue);
void gvd_SetAreaFloat(object oArea, string sVarName, float fVarValue);

// get ID at which oArea is registered in the database
int gvd_GetAreaID(object oArea);

// delete variable sVarName from oArea and from the database
void gvd_DeleteAreaVar(object oArea, string sVarName);


void gsARRegisterArea(object oArea)
{
    if (GetLocalInt(oArea, "GS_AR_INDEX")) return;

    object oModule = GetModule();
    int nIndex     = gsARGetRegisteredAreaCount() + 1;

    SetLocalObject(oModule, "GS_AR_" + IntToString(nIndex), oArea);
    SetLocalInt(oModule, "GS_AR_COUNT", nIndex);
    SetLocalInt(oArea, "GS_AR_INDEX", nIndex);
}
//----------------------------------------------------------------
object gsARGetRegisteredArea(int nIndex)
{
    return GetLocalObject(GetModule(), "GS_AR_" + IntToString(nIndex));
}
//----------------------------------------------------------------
void gsARUnregisterArea(object oArea)
{
    object oModule = GetModule();
    int nIndex     = GetLocalInt(oArea, "GS_AR_INDEX");
    int nCount     = gsARGetRegisteredAreaCount();

    if (nIndex >= 1 && nIndex <= nCount)
    {
        if (nIndex < nCount)
        {
            object oObject = GetLocalObject(oModule, "GS_AR_" + IntToString(nCount));

            SetLocalObject(oModule, "GS_AR_" + IntToString(nIndex), oObject);
            SetLocalInt(oObject, "GS_AR_INDEX", nIndex);
            nIndex         = nCount;
        }

        DeleteLocalObject(oModule, "GS_AR_" + IntToString(nIndex));
        SetLocalInt(oModule, "GS_AR_COUNT", nCount - 1);
    }

    DeleteLocalInt(oArea, "GS_AR_INDEX");
}
//----------------------------------------------------------------
int gsARGetRegisteredAreaCount()
{
    return GetLocalInt(GetModule(), "GS_AR_COUNT");
}
//----------------------------------------------------------------
int gsARGetIsAreaActive(object oArea)
{
    return GetLocalInt(oArea, "GS_ENABLED") &&
           GetLocalInt(oArea, "GS_TIMESTAMP") == GetLocalInt(GetModule(), "GS_TIMESTAMP");
}
//----------------------------------------------------------------
float gsARGetSizeX(object oArea)
{
    return IntToFloat(GetAreaSize(AREA_WIDTH, oArea) * 10);
}
//----------------------------------------------------------------
float gsARGetSizeY(object oArea)
{
    return IntToFloat(GetAreaSize(AREA_HEIGHT, oArea) * 10);
}

void gvd_LoadAreaVars(object oArea) {

  string sResRef = SQLEncodeSpecialChars(GetResRef(oArea));
  int iAreaID;
  string sServerID = miXFGetCurrentServer();

  // first get/set the id for the area

  // check if record already exists for this area
  SQLExecDirect("SELECT id FROM gvd_area_data WHERE (server = " + sServerID + ") and (resref = '" + sResRef + "')");

  if (SQLFetch() == SQL_SUCCESS) {
    // area exists, store area id as a variable on the area itself
    iAreaID = StringToInt(SQLGetData(1));

  } else {
    // area doesn't exist in the db yet, add it
    SQLExecDirect("INSERT INTO gvd_area_data (server, resref, tag, name) VALUES (" + sServerID + ",'" + sResRef + "','" + SQLEncodeSpecialChars(GetTag(oArea)) + "','" + SQLEncodeSpecialChars(GetName(oArea)) + "')");

    // retrieve the id
    SQLExecDirect("SELECT id FROM gvd_area_data WHERE (server = " + sServerID + ") and (resref = '" + sResRef + "')");    

    if (SQLFetch() == SQL_SUCCESS) {
      iAreaID = StringToInt(SQLGetData(1));

    }
 
  }

  // store area id as variable on the area object itself
  SetLocalInt(oArea, "GVD_AREA_ID", iAreaID);    

  // now check for any db stored area variables
  SQLExecDirect("SELECT var_name, var_type, var_value FROM gvd_area_vars WHERE area_id = " + IntToString(iAreaID));

  string sVarType;

  while (SQLFetch()) {

    sVarType = SQLGetData(2);

    if (sVarType == "INT") {
      SetLocalInt(oArea, SQLGetData(1), StringToInt(SQLGetData(3)));
    } else if (sVarType == "STRING") {
      SetLocalString(oArea, SQLGetData(1), SQLGetData(3));
    } else {
      // float
      SetLocalFloat(oArea, SQLGetData(1), StringToFloat(SQLGetData(3)));
    }

  }

}

void gvd_SetAreaInt(object oArea, string sVarName, int iVarValue) {

  // set the variable normally
  SetLocalInt(oArea, sVarName, iVarValue);

  int iAreaID = gvd_GetAreaID(oArea);
  string sAreaID = IntToString(iAreaID);

  // and store it in db, delete/insert to avoid duplications
  SQLExecDirect("DELETE FROM gvd_area_vars WHERE (area_id = " + sAreaID + ") and (var_name = '" + sVarName + "')");
  SQLExecDirect("INSERT INTO gvd_area_vars (area_id, var_name, var_type, var_value) VALUES (" + sAreaID + ", '" + sVarName + "', 'INT', " + IntToString(iVarValue) + ")");

}

void gvd_SetAreaString(object oArea, string sVarName, string sVarValue) {

  // set the variable normally
  SetLocalString(oArea, sVarName, sVarValue);

  int iAreaID = gvd_GetAreaID(oArea);
  string sAreaID = IntToString(iAreaID);

  // and store it in db, delete/insert to avoid duplications
  SQLExecDirect("DELETE FROM gvd_area_vars WHERE (area_id = " + sAreaID + ") and (var_name = '" + sVarName + "')");
  SQLExecDirect("INSERT INTO gvd_area_vars (area_id, var_name, var_type, var_value) VALUES (" + sAreaID + ", '" + sVarName + "', 'STRING', '" + sVarValue + "')");

}

void gvd_SetAreaFloat(object oArea, string sVarName, float fVarValue) {

  // set the variable normally
  SetLocalFloat(oArea, sVarName, fVarValue);

  int iAreaID = gvd_GetAreaID(oArea);
  string sAreaID = IntToString(iAreaID);

  // and store it in db, delete/insert to avoid duplications
  SQLExecDirect("DELETE FROM gvd_area_vars WHERE (area_id = " + sAreaID + ") and (var_name = '" + sVarName + "')");
  SQLExecDirect("INSERT INTO gvd_area_vars (area_id, var_name, var_type, var_value) VALUES (" + sAreaID + ", '" + sVarName + "', 'FLOAT', " + FloatToString(fVarValue) + ")");

}

int gvd_GetAreaID(object oArea) {

  return GetLocalInt(oArea,"GVD_AREA_ID");

}

void gvd_DeleteAreaVar(object oArea, string sVarName) {

  // delete the variable normally
  DeleteLocalInt(oArea, sVarName);
  DeleteLocalString(oArea, sVarName);
  DeleteLocalFloat(oArea, sVarName);

  int iAreaID = gvd_GetAreaID(oArea);
  string sAreaID = IntToString(iAreaID);

  // delete it from db
  SQLExecDirect("DELETE FROM gvd_area_vars WHERE (area_id = " + sAreaID + ") and (var_name = '" + sVarName + "')");

}

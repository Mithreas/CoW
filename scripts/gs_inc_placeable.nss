/* PLACEABLE library by Gigaschatten */

#include "gs_inc_area"

//void main() {}

const int GS_PL_LIMIT_SLOT = 20;

//add oPlaceable to permanent placeable list
void gsPLAddPlaceable(object oPlaceable = OBJECT_SELF);
//return slot of oPlaceable or FALSE if oPlaceable is not listed
int gsPLGetPlaceableSlot(object oPlaceable = OBJECT_SELF);
//return name of placeable in nSlot of oArea
string gsPLGetPlaceableName(int nSlot, object oArea = OBJECT_SELF);
//return template of placeable in nSlot of oArea
string gsPLGetPlaceableTemplate(int nSlot, object oArea = OBJECT_SELF);
//return location of placeable in nSlot of oArea
location gsPLGetPlaceableLocation(int nSlot, object oArea = OBJECT_SELF);
//return ID of placeable in nSlot of oArea
int gsPLGetPlaceableID(int nSlot, object oArea = OBJECT_SELF);
//remove placeable in nSlot from oArea
void gsPLRemovePlaceable(int nSlot, object oArea = OBJECT_SELF);
//save settings of oArea
void gsPLSaveArea(object oArea = OBJECT_SELF);
//load settings of oArea
void gsPLLoadArea(object oArea = OBJECT_SELF);

// load any variables stored in the database for this placeable
void gvd_LoadPlaceableVars(object oPlaceable);

// set local int/string/float variable on placeable and save it to the placeable variable db table
void gvd_SetPlaceableInt(object oPlaceable, string sVarName, int iVarValue);
void gvd_SetPlaceableString(object oPlaceable, string sVarName, string sVarValue);
void gvd_SetPlaceableFloat(object oPlaceable, string sVarName, float fVarValue);

// get ID at which oPlaceable is registered in the database
int gvd_GetPlaceableID(object oPlaceable);

// delete variable sVarName from oPlaceable and from the database
void gvd_DeletePlaceableVar(object oPlaceable, string sVarName);



// dunshine, internal function to hide quest flavor placeables in case quest target placeable spawns on area load
void _HandleQuestPlaceables(object oQuestTarget);

void _HandleQuestPlaceables(object oQuestTarget) {

  object oQuestTracker = GetObjectByTag("gvd_quest_tracker");
  if (oQuestTracker != OBJECT_INVALID) {
    // check if quest tracker item is still in the container
    object oItem = GetFirstItemInInventory(oQuestTracker);
    string sActiveQuest = GetName(oItem);

    WriteTimestampedLogEntry("Quest system: Quest target found: " + GetName(oQuestTarget));

    // quest active?
    if (sActiveQuest == GetName(oQuestTarget)) {

      int iNearest;
      object oQuestFlavor;

      // make flavor placeables in the same area disappear by setting not useable
      WriteTimestampedLogEntry("Quest system: Quest target active: " + GetName(oQuestTarget));

      iNearest = 1;
      oQuestFlavor = GetNearestObjectByTag("gvd_quest_flavor", oQuestTarget, iNearest);

      while (oQuestFlavor != OBJECT_INVALID) {
        SetUseableFlag(oQuestFlavor, 0);

        WriteTimestampedLogEntry("Quest system: Quest flavor hidden: " + GetName(oQuestFlavor));

        iNearest = iNearest + 1;
        oQuestFlavor = GetNearestObjectByTag("gvd_quest_flavor", oQuestTarget, iNearest);

      }

    } 

  } else {
    // no active quests

  }

}


void gsPLAddPlaceable(object oPlaceable = OBJECT_SELF)
{
    if (GetObjectType(oPlaceable) != OBJECT_TYPE_PLACEABLE) return;

    string sTemplate1  = GetResRef(oPlaceable);
    if (sTemplate1 == "")                                   return;
    object oArea       = GetArea(oPlaceable);
    location lLocation = GetLocation(oPlaceable);
    string sTemplate2  = "";
    int nSlot          = FALSE;
    int nNth           = 0;

    for (nNth = 1; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        sTemplate2 = gsPLGetPlaceableTemplate(nNth, oArea);

        if (sTemplate1 == sTemplate2 &&
            lLocation == gsPLGetPlaceableLocation(nNth, oArea))
        {
            return;
        }

        if (! nSlot &&
            sTemplate2 == "")
        {
            nSlot = nNth;
        }
    }

    if (nSlot)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_PL_NAME_" + sNth, GetName(oPlaceable));
        SetLocalString(oArea, "GS_PL_RESREF_" + sNth, sTemplate1);
        SetLocalLocation(oArea, "GS_PL_LOCATION_" + sNth, lLocation);
        SetLocalInt(oPlaceable, "GS_STATIC", TRUE);
    }
}
//----------------------------------------------------------------
int gsPLGetPlaceableSlot(object oPlaceable = OBJECT_SELF)
{
    object oArea       = GetArea(oPlaceable);
    location lLocation = GetLocation(oPlaceable);
    string sTemplate   = GetResRef(oPlaceable);
    int nNth           = 0;

    for (; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        if (sTemplate == gsPLGetPlaceableTemplate(nNth, oArea) &&
            lLocation == gsPLGetPlaceableLocation(nNth, oArea))
        {
            return nNth;
        }
    }

    return FALSE;
}
//----------------------------------------------------------------
string gsPLGetPlaceableName(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_PL_NAME_" + IntToString(nSlot));
}
//----------------------------------------------------------------
string gsPLGetPlaceableTemplate(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_PL_RESREF_" + IntToString(nSlot));
}
//----------------------------------------------------------------
location gsPLGetPlaceableLocation(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalLocation(oArea, "GS_PL_LOCATION_" + IntToString(nSlot));
}
//----------------------------------------------------------------
int gsPLGetPlaceableID(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_PL_ID_" + IntToString(nSlot));
}
//----------------------------------------------------------------
void gsPLRemovePlaceable(int nSlot, object oArea = OBJECT_SELF)
{
    location lLocation = gsPLGetPlaceableLocation(nSlot, oArea);
    object oObject     = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);
    string sNth        = IntToString(nSlot);

    if (GetIsObjectValid(oObject) &&
        GetLocation(oObject) == lLocation &&
        GetResRef(oObject) == gsPLGetPlaceableTemplate(nSlot, oArea))
    {
        DestroyObject(oObject);
    }

    // transfer ID to seperate variable, so we can use that to delete the fixture from the database in case the area gets saved
    SetLocalInt(oArea, "GS_PL_DELETED_ID_" + sNth, GetLocalInt(oArea, "GS_PL_ID_" + sNth));

    DeleteLocalInt(oArea, "GS_PL_ID_" + sNth);
    DeleteLocalString(oArea, "GS_PL_NAME_" + sNth);
    DeleteLocalString(oArea, "GS_PL_RESREF_" + sNth);
    DeleteLocalLocation(oArea, "GS_PL_LOCATION_" + sNth);

}
//----------------------------------------------------------------
void gsPLSaveArea(object oArea = OBJECT_SELF)
{
    int iAreaID = gvd_GetAreaID(oArea);
    string sNth      = "";
    int nNth         = 0;
    string sName;
    string sDescription;
    string sResRef;
    string sLocation;
    int iPlaceableID;
    object oPlaceable;

    for (nNth = 1; nNth <= GS_PL_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);
        iPlaceableID = gsPLGetPlaceableID(nNth, oArea);
        sName = SQLEncodeSpecialChars(gsPLGetPlaceableName(nNth, oArea));
        sResRef = SQLEncodeSpecialChars(gsPLGetPlaceableTemplate(nNth, oArea));
        sLocation = APSLocationToString(gsPLGetPlaceableLocation(nNth, oArea));
        oPlaceable = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, APSStringToLocation(sLocation));
        sDescription = SQLEncodeSpecialChars(GetDescription(oPlaceable));

        if (iPlaceableID != 0) {
          // placeable already exists in the database, update only
          SQLExecDirect("UPDATE gvd_placeable SET resref = '" + sResRef + "', name = '" + sName + "', description = '" + sDescription + "', location = '" + sLocation + "' WHERE id = " + IntToString(iPlaceableID));            

        } else {
          // does not exist yet, insert
          if (sResRef != "") { 
            SQLExecDirect("INSERT INTO gvd_placeable (area_id, resref, name, description, location) VALUES (" + IntToString(iAreaID) + ",'" + sResRef + "','" + sName + "','" + sDescription + "','" + sLocation + "')");          

            // retrieve the ID for the placeable
            SQLExecDirect("SELECT id FROM gvd_placeable WHERE (area_id = " + IntToString(iAreaID) + ") AND (location = '" + sLocation + "')");
            if (SQLFetch() == SQL_SUCCESS) {
              iPlaceableID = StringToInt(SQLGetData(1));
            }

            // store id on the placeable itself
            SetLocalInt(oPlaceable, "GVD_PLACEABLE_ID", iPlaceableID);
            SetLocalInt(oArea, "GS_PL_ID_" + sNth , iPlaceableID);

          }

          // check if an old placeable was removed in this slot
          iPlaceableID = GetLocalInt(oArea, "GS_PL_DELETED_ID_" + sNth);
          if (iPlaceableID != 0) {
            // placeable was removed, delete it from database
            SQLExecDirect("DELETE FROM gvd_placeable WHERE id = " + IntToString(iPlaceableID));            
            SQLExecDirect("DELETE FROM gvd_pl_vars WHERE pl_id = " + IntToString(iPlaceableID));            
          }

        }

    }
}
//----------------------------------------------------------------
void gsPLLoadArea(object oArea = OBJECT_SELF)
{
    string sNth      = "";
    int nNth         = 1;

    int iAreaID = gvd_GetAreaID(oArea);
    string sID;
    int iPlaceableID;
    string sName;
    string sDescription;
    string sResRef;
    string sLocation;
    location lLocation;
    object oObject = OBJECT_INVALID;

    SQLExecDirect("SELECT id, resref, name, description, location FROM gvd_placeable WHERE (area_id = " + IntToString(iAreaID) + ")");

    while (SQLFetch()) {

      sID = SQLGetData(1);
      iPlaceableID = StringToInt(sID);
      sResRef = SQLGetData(2);
      sName = SQLDecodeSpecialChars(SQLGetData(3));
      sDescription = SQLDecodeSpecialChars(SQLGetData(4));
      sLocation = SQLGetData(5);
      lLocation = APSStringToLocation(sLocation);

      oObject = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);

      sNth = IntToString(nNth);

      if (! GetIsObjectValid(oObject) || GetLocation(oObject) != lLocation) {

        oObject = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocation);

        if (GetIsObjectValid(oObject)) {

          SetLocalInt(oObject, "GS_STATIC", TRUE);
          SetLocalInt(oObject, "GVD_PLACEABLE_ID", iPlaceableID);
          SetLocalInt(oArea, "GS_PL_ID_" + sNth, iPlaceableID);
          SetLocalString(oArea, "GS_PL_NAME_" + sNth, sName);
          SetLocalString(oArea, "GS_PL_RESREF_" + sNth, sResRef);
          SetLocalLocation(oArea, "GS_PL_LOCATION_" + sNth, lLocation);

          // dunshine, also set the name, description of the placeable itself in case this was changed
          if (sName != "") SetName(oObject, sName);
          if (sDescription != "") SetDescription(oObject, sDescription);

          // load placeable variables
          AssignCommand(oObject, DelayCommand(6.0f, gvd_LoadPlaceableVars(oObject)));

          // quest target?
          if (GetTag(oObject) == "gvd_quest_target") {
            // delay this a bit, in case the flavor placeables spawn after the target placeable
            DelayCommand(1.0f, _HandleQuestPlaceables(oObject));
          }

        }
      }

      nNth = nNth + 1;

    }

}

void gvd_LoadPlaceableVars(object oPlaceable) {

  int iPlaceableID = gvd_GetPlaceableID(oPlaceable);

  // only for placeables with an ID saved in the database
  if (iPlaceableID != 0) {

    // check for any db stored placeable variables
    SQLExecDirect("SELECT var_name, var_type, var_value FROM gvd_pl_vars WHERE pl_id = " + IntToString(iPlaceableID));

    string sVarType;

    while (SQLFetch()) {

      sVarType = SQLGetData(2);

      if (sVarType == "INT") {
        SetLocalInt(oPlaceable, SQLGetData(1), StringToInt(SQLGetData(3)));
      } else if (sVarType == "STRING") {
        SetLocalString(oPlaceable, SQLGetData(1), SQLGetData(3));
      } else {
        // float
        SetLocalFloat(oPlaceable, SQLGetData(1), StringToFloat(SQLGetData(3)));
      }

    }

  }

}

void gvd_SetPlaceableInt(object oPlaceable, string sVarName, int iVarValue) {

  // set the variable normally
  SetLocalInt(oPlaceable, sVarName, iVarValue);

  int iPlaceableID = gvd_GetPlaceableID(oPlaceable);

  // only allow this for placeables that are already saved to the db and have and ID
  if (iPlaceableID != 0) {

    string sPlaceableID = IntToString(iPlaceableID);

    // and store it in db, delete/insert to avoid duplications
    SQLExecDirect("DELETE FROM gvd_pl_vars WHERE (pl_id = " + sPlaceableID + ") and (var_name = '" + sVarName + "')");
    SQLExecDirect("INSERT INTO gvd_pl_vars (pl_id, var_name, var_type, var_value) VALUES (" + sPlaceableID + ", '" + sVarName + "', 'INT', " + IntToString(iVarValue) + ")");

  }

}

void gvd_SetPlaceableString(object oPlaceable, string sVarName, string sVarValue) {

  // set the variable normally
  SetLocalString(oPlaceable, sVarName, sVarValue);

  int iPlaceableID = gvd_GetPlaceableID(oPlaceable);

  // only allow this for placeables that are already saved to the db and have and ID
  if (iPlaceableID != 0) {
 
    string sPlaceableID = IntToString(iPlaceableID);

    // and store it in db, delete/insert to avoid duplications
    SQLExecDirect("DELETE FROM gvd_pl_vars WHERE (pl_id = " + sPlaceableID + ") and (var_name = '" + sVarName + "')");
    SQLExecDirect("INSERT INTO gvd_pl_vars (pl_id, var_name, var_type, var_value) VALUES (" + sPlaceableID + ", '" + sVarName + "', 'STRING', '" + sVarValue + "')");

  }

}

void gvd_SetPlaceableFloat(object oPlaceable, string sVarName, float fVarValue) {

  // set the variable normally
  SetLocalFloat(oPlaceable, sVarName, fVarValue);

  int iPlaceableID = gvd_GetPlaceableID(oPlaceable);

  // only allow this for placeables that are already saved to the db and have and ID
  if (iPlaceableID != 0) {

    string sPlaceableID = IntToString(iPlaceableID);
 
    // and store it in db, delete/insert to avoid duplications
    SQLExecDirect("DELETE FROM gvd_pl_vars WHERE (pl_id = " + sPlaceableID + ") and (var_name = '" + sVarName + "')");
    SQLExecDirect("INSERT INTO gvd_pl_vars (pl_id, var_name, var_type, var_value) VALUES (" + sPlaceableID + ", '" + sVarName + "', 'FLOAT', " + FloatToString(fVarValue) + ")");

  }

}


int gvd_GetPlaceableID(object oPlaceable) {

  return GetLocalInt(oPlaceable,"GVD_PLACEABLE_ID");

}

void gvd_DeletePlaceableVar(object oPlaceable, string sVarName) {

  // deletion from the placeable itself
  DeleteLocalInt(oPlaceable, sVarName);
  DeleteLocalFloat(oPlaceable, sVarName);
  DeleteLocalString(oPlaceable, sVarName);

  int iPlaceableID = gvd_GetPlaceableID(oPlaceable);

  // only allow this for placeables that are already saved to the db and have and ID
  if (iPlaceableID != 0) {

    string sPlaceableID = IntToString(iPlaceableID);

    // delete it from db
    SQLExecDirect("DELETE FROM gvd_pl_vars WHERE (pl_id = " + sPlaceableID + ") and (var_name = '" + sVarName + "')");

  }

}

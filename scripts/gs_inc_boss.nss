/* BOSS library by Gigaschatten */

//void main() {}

#include "gs_inc_area"
#include "gs_inc_effect"
#include "gs_inc_flag"
#include "gs_inc_location"
#include "inc_log"

const int GU_EN_VFX_BOSS             = 51;
const int GS_BO_LIMIT_SLOT           = 5;

// Marker waypoint for dynamic encounters
const string GU_BO_TEMPLATE_WAYPOINT = "gu_wp_encounter";

// For Logging
const string BOSS               = "BOSS";

//create boss spawn positions in oArea
void gsBOSetUpArea(object oArea = OBJECT_SELF);
//set oCreature for oArea
void gsBOSetCreature(object oCreature, object oArea = OBJECT_SELF);
//return name of creature in nSlot of oArea
string gsBOGetCreatureName(int nSlot, object oArea = OBJECT_SELF);
//return template of creature in nSlot of oArea
string gsBOGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF);
//return challenge rating of creature in nSlot of oArea
float gsBOGetCreatureRating(int nSlot, object oArea = OBJECT_SELF);
//return location of creature in nSlot of oArea
location gsBOGetCreatureLocation(int nSlot, object oArea = OBJECT_SELF);
//remove creature in nSlot from oArea
void gsBORemoveCreature(int nSlot, object oArea = OBJECT_SELF);
//return true if oCreature is a boss
int gsBOGetIsBossCreature(object oCreature = OBJECT_SELF);
//save settings of oArea
void gsBOSaveArea(object oArea = OBJECT_SELF);
//load setting of oArea
void gsBOLoadArea(object oArea = OBJECT_SELF);
// Place a new dynamic boss encounter at a given location,
// storing the sResRef on the encounter waypoint to remember the desired
// boss spawn.
void guENPlaceBossEncounter(location lWhere, string sResRef);

void gsBOSetUpArea(object oArea = OBJECT_SELF)
{
    object oCreature = OBJECT_INVALID;
    string sResRef   = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sResRef = gsBOGetCreatureTemplate(nNth, oArea);

        if (sResRef != "")
        {
            // Occasionally spawn multiple creatures!
            int nCount = 1;
            //if (d10() == 10) nCount = 2;

            for (; nCount > 0; nCount--)
            {
                guENPlaceBossEncounter(gsBOGetCreatureLocation(nNth),
                                       sResRef);
            }
        }
    }
}
//----------------------------------------------------------------
void gsBOSetCreature(object oCreature, object oArea = OBJECT_SELF)
{
    if (! GetIsObjectValid(oCreature))                    return;
    if (GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return;
    if (GetIsPC(oCreature))                               return;
    if (! GetIsObjectValid(oArea))                        return;

    string sTemplate = GetResRef(oCreature);
    if (sTemplate == "")                                  return;
    string sResRef   = "";
    int nSlot        = FALSE;
    int nNth         = 0;

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sResRef = gsBOGetCreatureTemplate(nNth, oArea);

        if (sResRef == sTemplate)
        {
            nSlot = nNth;
            break;
        }
        else if (! nSlot &&
                 sResRef == "")
        {
            nSlot = nNth;
        }
    }

    if (nNth)
    {
        string sNth = IntToString(nSlot);

        SetLocalString(oArea, "GS_BO_NAME_" + sNth, GetName(oCreature, TRUE));
        SetLocalString(oArea, "GS_BO_RESREF_" + sNth, sTemplate);
        SetLocalFloat(oArea, "GS_BO_RATING_" + sNth, GetChallengeRating(oCreature));
        SetLocalLocation(oArea, "GS_BO_LOCATION_" + sNth, GetLocation(oCreature));
    }
}
//----------------------------------------------------------------
string gsBOGetCreatureName(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_BO_NAME_" + IntToString(nSlot));
}
//----------------------------------------------------------------
string gsBOGetCreatureTemplate(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalString(oArea, "GS_BO_RESREF_" + IntToString(nSlot));
}
//----------------------------------------------------------------
float gsBOGetCreatureRating(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalFloat(oArea, "GS_BO_RATING_" + IntToString(nSlot));
}
//----------------------------------------------------------------
location gsBOGetCreatureLocation(int nSlot, object oArea = OBJECT_SELF)
{
    return GetLocalLocation(oArea, "GS_BO_LOCATION_" + IntToString(nSlot));
}
//----------------------------------------------------------------
void gsBORemoveCreature(int nSlot, object oArea = OBJECT_SELF)
{
    string sNth = IntToString(nSlot);

    DeleteLocalString(oArea, "GS_BO_NAME_" + sNth);
    DeleteLocalString(oArea, "GS_BO_RESREF_" + sNth);
    DeleteLocalFloat(oArea, "GS_BO_RATING_" + sNth);
    DeleteLocalLocation(oArea, "GS_BO_LOCATION_" + sNth);
}
//----------------------------------------------------------------
int gsBOGetIsBossCreature(object oCreature = OBJECT_SELF)
{
    return GetObjectType(oCreature) == OBJECT_TYPE_CREATURE &&
           gsFLGetFlag(GS_FL_BOSS, oCreature);
}
//----------------------------------------------------------------
void gsBOSaveArea(object oArea = OBJECT_SELF)
{

    string sNth      = "";
    int nNth         = 0;
    int iAreaID = gvd_GetAreaID(oArea);
    string sType;
    string sName;
    string sResRef;
    float fRating;
    int iChance;
    string sLocation;

    // Boss encounters.
    sType = "Boss";
    iChance = 100;

    // first delete all boss encounters from db for this area
    SQLExecDirect("DELETE FROM gvd_encounter WHERE (type = 'Boss') AND (area_id = " + IntToString(iAreaID) + ")");

    for (nNth = 1; nNth <= GS_BO_LIMIT_SLOT; nNth++)
    {
        sNth = IntToString(nNth);

        sName = SQLEncodeSpecialChars(gsBOGetCreatureName(nNth, oArea));
        sResRef = SQLEncodeSpecialChars(gsBOGetCreatureTemplate(nNth, oArea));
        fRating = gsBOGetCreatureRating(nNth, oArea);
        sLocation = APSLocationToString(gsBOGetCreatureLocation(nNth, oArea));

        if (sResRef != "") { 
          SQLExecDirect("INSERT INTO gvd_encounter (area_id, type, resref, name, rating, chance, location) VALUES (" + IntToString(iAreaID) + ",'" + sType + "','" + sResRef + "','" + sName + "'," + FloatToString(fRating) + "," + IntToString(iChance) + ",'" + sLocation + "')");          
        }

    }

}
//----------------------------------------------------------------
void gsBOLoadArea(object oArea = OBJECT_SELF)
{
    string sNth      = "";
    int nNth         = 1;

    int iAreaID = gvd_GetAreaID(oArea);
    string sType;
    string sName;
    string sResRef;
    float fRating;
    string sLocation;

    SQLExecDirect("SELECT type, resref, name, rating, location FROM gvd_encounter WHERE (area_id = " + IntToString(iAreaID) + ") AND (type = 'Boss')");

    while (SQLFetch()) {

      sType = SQLGetData(1);
      sResRef = SQLGetData(2);
      sName = SQLGetData(3);
      fRating = StringToFloat(SQLGetData(4));
      sLocation = SQLGetData(5);

      sNth = IntToString(nNth);
      SetLocalString(oArea, "GS_BO_NAME_" + sNth, sName);
      SetLocalString(oArea, "GS_BO_RESREF_" + sNth, sResRef);
      SetLocalFloat(oArea, "GS_BO_RATING_" + sNth, fRating);
      SetLocalLocation(oArea, "GS_BO_LOCATION_" + sNth, APSStringToLocation(sLocation));
      nNth = nNth + 1;

    }
}
//----------------------------------------------------------------
void guENPlaceBossEncounter(location lWhere, string sResRef)
{
    Trace(BOSS, "Boss attempt at " + APSLocationToString(lWhere));

    location lWalkable = guENFindNearestWalkable(lWhere);
    Trace(BOSS, "walkmesh probe at " + APSLocationToString(lWalkable));

    object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT,
                                    GU_BO_TEMPLATE_WAYPOINT,
                                    lWalkable,
                                    FALSE,
                                    "GU_BOSS");
    SetLocalString(oWaypoint, "GU_BOSS_RESREF", sResRef);

    effect eTrigger = EffectAreaOfEffect(GU_EN_VFX_BOSS);
    // Don't want it to be dispellable!
    eTrigger = SupernaturalEffect(eTrigger);
    object oAOE = gsFXCreateEffectAtLocation(DURATION_TYPE_PERMANENT,
                                             eTrigger,
                                             lWalkable);
    SetLocalObject(oWaypoint, "GU_EN_AOE", oAOE);
    SetLocalObject(oAOE, "GU_EN_WP", oWaypoint);

    Trace(BOSS, "Boss encounter initialised.");
}
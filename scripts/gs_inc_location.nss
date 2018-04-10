/* LOCATION Library by Gigaschatten */

//void main() {}

struct gsLOLocation
{
    string sArea;
    vector vPosition;
    float fDirection;
};

//return extended location of oObject
struct gsLOLocation gsLOGetLocationX(object oObject = OBJECT_SELF);
//save location of oObject to sDB using sID
void gsLOSetDBLocationOf(string sDB, string sID, object oObject = OBJECT_SELF);
//save lLocation to sDB using sID
void gsLOSetDBLocation(string sDB, string sID, location lLocation);
//return extended location from sDB using sID
struct gsLOLocation gsLOGetDBLocationX(string sDB, string sID);
//return location from sDB using sID
location gsLOGetDBLocation(string sDB, string sID);

struct gsLOLocation gsLOGetLocationX(object oObject = OBJECT_SELF)
{
    struct gsLOLocation gsLocation;

    gsLocation.sArea      = GetTag(GetArea(oObject));
    gsLocation.vPosition  = GetPosition(oObject);
    gsLocation.fDirection = GetFacing(oObject);

    return gsLocation;
}
//----------------------------------------------------------------
void gsLOSetDBLocationOf(string sDB, string sID, object oObject = OBJECT_SELF)
{
    if (! GetIsObjectValid(oObject)) return;

    sID = GetStringRight(sID, 30);

    SetCampaignString(sDB, sID + "_A", GetTag(GetArea(oObject)));
    SetCampaignVector(sDB, sID + "_P", GetPosition(oObject));
    SetCampaignFloat(sDB, sID + "_D", GetFacing(oObject));
}
//----------------------------------------------------------------
void gsLOSetDBLocation(string sDB, string sID, location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    if (! GetIsObjectValid(oArea)) return;

    sID          = GetStringRight(sID, 30);

    SetCampaignString(sDB, sID + "_A", GetTag(oArea));
    SetCampaignVector(sDB, sID + "_P", GetPositionFromLocation(lLocation));
    SetCampaignFloat(sDB, sID + "_D", GetFacingFromLocation(lLocation));
}
//----------------------------------------------------------------
struct gsLOLocation gsLOGetDBLocationX(string sDB, string sID)
{
    struct gsLOLocation gsLocation;

    sID                   = GetStringRight(sID, 30);
    gsLocation.sArea      = GetCampaignString(sDB, sID + "_A");
    gsLocation.vPosition  = GetCampaignVector(sDB, sID + "_P");
    gsLocation.fDirection = GetCampaignFloat(sDB, sID + "_D");

    return gsLocation;
}
//----------------------------------------------------------------
location gsLOGetDBLocation(string sDB, string sID)
{
    sID          = GetStringRight(sID, 30);
    string sArea = GetCampaignString(sDB, sID + "_A");

    if (sArea != "")
    {
        object oArea = GetObjectByTag(sArea);

        if (GetIsObjectValid(oArea))
        {
            vector vPosition = GetCampaignVector(sDB, sID + "_P");
            float fDirection = GetCampaignFloat(sDB, sID + "_D");

            return Location(oArea, vPosition, fDirection);
        }
    }

    return Location(OBJECT_INVALID, Vector(), 0.0);
}

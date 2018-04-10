const string GS_TEMPLATE_CHAIR = "gs_placeable007";
const string GS_TEMPLATE_TABLE = "gs_placeable038";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea      = GetArea(OBJECT_SELF);
    location lLocation;
    vector vPosition  = GetPosition(OBJECT_SELF);
    float fFacing     = GetFacing(OBJECT_SELF);
    int nFlag         = FALSE;

    //chair
    float fAngle      = fFacing +  67.5;
    float fMaximum    = fAngle  + 225.0;

    while (fAngle <= fMaximum)
    {
        lLocation  = Location(oArea, vPosition + AngleToVector(fAngle) * 6.5, fAngle);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIR, lLocation);
        fAngle    += 25.0;
    }

    //table
    fAngle            = fFacing +  55.0;
    fMaximum          = fAngle  + 250.0;
    vPosition.z      -= 0.5;

    while (fAngle <= fMaximum)
    {
        if (nFlag) vPosition.z -= 0.01;
        else       vPosition.z += 0.01;
        nFlag      = ! nFlag;

        lLocation  = Location(oArea, vPosition + AngleToVector(fAngle) * 5.0, fAngle);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_TABLE, lLocation);
        fAngle    += 10.0;
    }

    DestroyObject(OBJECT_SELF);
}

const string GS_TEMPLATE_CHAIR  = "gs_placeable271";
const string GS_TEMPLATE_TABLE  = "gs_placeable254";
const string GS_TEMPLATE_BOTTLE = "gs_placeable256";

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
    float fAngle      = fFacing;
    float fMaximum    = fAngle + 340.0;

    while (fAngle < fMaximum)
    {
        lLocation  = Location(oArea,
                              vPosition + AngleToVector(fAngle) * 6.5,
                              fAngle + IntToFloat(Random(201)) / 10.0);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIR, lLocation);
        fAngle    += 10.0 + IntToFloat(Random(201)) / 10.0;
    }

    //table
    fAngle            = fFacing;
    fMaximum          = fAngle + 360.0;

    while (fAngle < fMaximum)
    {
        if (nFlag) vPosition.z -= 0.01;
        else       vPosition.z += 0.01;
        nFlag      = ! nFlag;

        lLocation  = Location(oArea, vPosition + AngleToVector(fAngle) * 5.0, fAngle);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_TABLE, lLocation);
        fAngle    += 10.0;
    }

    //bottle
    fAngle            = fFacing;
    fMaximum          = fAngle + 360.0;
    vPosition.z      += 1.13;

    while (fAngle < fMaximum)
    {
        lLocation  = Location(oArea,
                              vPosition + AngleToVector(fAngle) *
                              (4.65 + IntToFloat(Random(8)) / 10.0),
                              IntToFloat(Random(360)));
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_BOTTLE, lLocation);
        fAngle    += 2.0 + IntToFloat(Random(281)) / 10.0;
    }

    DestroyObject(OBJECT_SELF);
}

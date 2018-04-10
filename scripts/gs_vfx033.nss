const string GS_TEMPLATE_STONE = "gs_placeable296";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea      = GetArea(OBJECT_SELF);
    location lLocation;
    vector vPosition  = GetPosition(OBJECT_SELF);
    vPosition.z      -= 1.0;
    float fDirection  = GetFacing(OBJECT_SELF);
    float fDistance   = 3.0;
    int nNth;

    for (nNth = 0; nNth < 6; nNth++)
    {
        if (nNth == 3)      {fDistance    = 2.7; vPosition.z += 1.0;}
        else if (nNth == 4) {fDistance    = 2.1; vPosition.z += 0.75;}
        else if (nNth == 5) {fDistance    = 1.2; vPosition.z += 0.5;}
        else                {vPosition.z += 1.0;}
        lLocation    = Location(oArea,
                                vPosition + AngleToVector(fDirection - 90) * fDistance,
                                fDirection - 90 + IntToFloat(Random(25)) - 12.0);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_STONE, lLocation);
        lLocation    = Location(oArea,
                                vPosition + AngleToVector(fDirection + 90) * fDistance,
                                fDirection + 90 + IntToFloat(Random(25)) - 12.0);
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_STONE, lLocation);
    }

    vPosition.z += 0.25;
    lLocation    = Location(oArea, vPosition, fDirection - 90);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_STONE, lLocation);

    DestroyObject(OBJECT_SELF);
}

const string GS_TEMPLATE_CAGE     = "gs_placeable009";
const string GS_TEMPLATE_FLOOR    = "gs_placeable010";
const string GS_TEMPLATE_SKELETON = "gs_placeable011";
const string GS_TEMPLATE_CHAIN    = "gs_placeable012";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea        = GetArea(OBJECT_SELF);
    location lLocation  = Location(OBJECT_INVALID, Vector(), 0.0);
    vector vPosition    = GetPosition(OBJECT_SELF);
    float fFacing       = GetFacing(OBJECT_SELF) + IntToFloat(Random(151) - 75) / 10.0;

    vPosition.z        += 3.25 - IntToFloat(Random(101)) / 100.0;
    lLocation           = Location(oArea, vPosition, fFacing);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CAGE,     lLocation);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_FLOOR,    lLocation);
    vPosition.z        += 0.02;
    lLocation           = Location(oArea, vPosition, IntToFloat(Random(360)));
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_SKELETON, lLocation);
    vPosition.z        += 0.91;
    lLocation           = Location(oArea, vPosition + AngleToVector(fFacing - 45.0)  * 0.85, fFacing);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIN,    lLocation);
    lLocation           = Location(oArea, vPosition + AngleToVector(fFacing - 135.0) * 0.85, fFacing);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIN,    lLocation);
    lLocation           = Location(oArea, vPosition + AngleToVector(fFacing + 45.0)  * 0.85, fFacing);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIN,    lLocation);
    lLocation           = Location(oArea, vPosition + AngleToVector(fFacing + 135.0) * 0.85, fFacing);
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_CHAIN,    lLocation);

    DestroyObject(OBJECT_SELF);
}

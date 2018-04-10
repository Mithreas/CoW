const string GS_TEMPLATE_COUCH = "gs_placeable304";
const string GS_TEMPLATE_SEAT  = "gs_placeable302";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea        = GetArea(OBJECT_SELF);
    location lLocation  = GetLocation(OBJECT_SELF);
    vector vPosition    = GetPosition(OBJECT_SELF);
    float fFacing       = GetFacing(OBJECT_SELF);

    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_COUCH, lLocation);
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SEAT,
        Location(oArea, vPosition + AngleToVector(fFacing - 90.0) * 0.4, fFacing));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SEAT,
        Location(oArea, vPosition + AngleToVector(fFacing + 90.0) * 0.4, fFacing));

    DestroyObject(OBJECT_SELF);
}

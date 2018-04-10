const string GS_TEMPLATE_SKULL = "gs_placeable309";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea     = GetArea(OBJECT_SELF);
    float fFacing    = GetFacing(OBJECT_SELF);
    vector vPosition = GetPosition(OBJECT_SELF);
    vector vVector1  = AngleToVector(fFacing -  90);
    vector vVector2  = AngleToVector(fFacing +  90);
    vector vVector3  = AngleToVector(fFacing + 180);

    //row 1
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1 * 2.0,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2 * 2.0,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));

    //row 2
    vPosition   += vVector3 * 0.5;
    vPosition.z += 0.5;

    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1 * 1.75,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1 * 0.875,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2 * 0.875,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2 * 1.75,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));

    //row 3
    vPosition   += vVector3 * 0.5;
    vPosition.z += 0.5;

    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1 * 1.5,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector1 * 0.75,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2 * 0.75,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        GS_TEMPLATE_SKULL,
        Location(
            oArea,
            vPosition + vVector2 * 1.5,
            fFacing + IntToFloat(Random(101)) / 10.0 - 5.0));

    DestroyObject(OBJECT_SELF);
}

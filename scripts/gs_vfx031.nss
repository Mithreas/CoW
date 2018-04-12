#include "inc_effect"

const string GS_TEMPLATE_WALL    = "gs_placeable289";
const string GS_TEMPLATE_STONE   = "gs_placeable299";
const string GS_TEMPLATE_PANEL   = "gs_placeable247";
const string GS_TEMPLATE_STATUE1 = "gs_placeable294";
const string GS_TEMPLATE_STATUE2 = "gs_placeable218";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea      = GetArea(OBJECT_SELF);
    vector vPosition  = GetPosition(OBJECT_SELF);
    float fStart      = GetFacing(OBJECT_SELF);
    float fEnd        = fStart + 360.0;
    float fFloor      = 0.0;
    int nHeight       = GetLocalInt(OBJECT_SELF, "GS_HEIGHT");
    int nNth          = 1;

    for (; nNth <= nHeight; nNth++)
    {
        gsFXCreateCircle(fStart, fEnd, 45.0, 3.18, fFloor, 180.0, 0, GS_TEMPLATE_WALL);
        fFloor += 3.1;
    }

    gsFXCreateCircle(fStart + 15.0, fEnd + 15.0, 30.0, 3.5, fFloor,          0.0, 12, GS_TEMPLATE_STONE);
    gsFXCreateCircle(fStart + 30.0, fEnd + 30.0, 60.0, 3.8, fFloor + 0.5,   90.0, 12, GS_TEMPLATE_STONE);
    gsFXCreateCircle(fStart + 30.0, fEnd + 30.0, 60.0, 4.0, fFloor + 1.53, 180.0,  0, GS_TEMPLATE_STATUE1);

    vPosition.z      += fFloor + 0.75;
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_PANEL,   Location(oArea, vPosition, fStart));
    vPosition        -= AngleToVector(fStart) * 0.5;
    CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_STATUE2, Location(oArea, vPosition, fStart));

    DestroyObject(OBJECT_SELF);
}

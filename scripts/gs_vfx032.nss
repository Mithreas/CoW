#include "gs_inc_effect"

const string GS_TEMPLATE_STONE  = "gs_placeable291";
const string GS_TEMPLATE_COLUMN = "gs_placeable292";
const string GS_TEMPLATE_STATUE = "gs_placeable293";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    float fStart = GetFacing(OBJECT_SELF);
    float fEnd   = fStart + 360.0;

    //base
    gsFXCreateCircle(fStart + 45.0, fEnd + 45.0, 90.0, 4.0,  0.0,  -180.0, 12, GS_TEMPLATE_STONE);

    //column
    gsFXCreateCircle(fStart - 30.0, fEnd - 30.0, 90.0, 4.3,  0.0,  -180.0,  0, GS_TEMPLATE_COLUMN);
    gsFXCreateCircle(fStart + 30.0, fEnd + 30.0, 90.0, 4.3,  0.0,  -180.0,  0, GS_TEMPLATE_COLUMN);

    //statue
    gsFXCreateCircle(fStart,        fEnd,        30.0, 4.62, 3.61, -180.0,  0, GS_TEMPLATE_STATUE);

    //stone
    gsFXCreateCircle(fStart,        fEnd,        20.0, 4.0,  3.64, -180.0, 12, GS_TEMPLATE_STONE);

    //column
    gsFXCreateCircle(fStart,        fEnd,        30.0, 4.0,  4.64, -180.0,  0, GS_TEMPLATE_COLUMN);

    //statue
    gsFXCreateCircle(fStart,        fEnd,        30.0, 4.32, 8.21, -180.0,  0, GS_TEMPLATE_STATUE);

    //stone
    gsFXCreateCircle(fStart,        fEnd,        20.0, 3.7,  8.28, -180.0, 12, GS_TEMPLATE_STONE);

    DestroyObject(OBJECT_SELF);
}

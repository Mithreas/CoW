#include "inc_effect"

const string GS_TEMPLATE_WALL    = "gs_placeable362";
const string GS_TEMPLATE_STONE_1 = "gs_placeable363";
const string GS_TEMPLATE_STONE_2 = "gs_placeable364";
const string GS_TEMPLATE_STATUE  = "gs_placeable365";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    float fStart = GetFacing(OBJECT_SELF);
    float fEnd   = fStart + 360.0;

    //wall
    gsFXCreateCircle(fStart,        fEnd,        18.0, 6.0,  -0.33,    1.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.75,  1.8,     1.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,   3.93, -181.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,   6.06, -181.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,   8.19, -181.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,  10.32, -181.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,  12.45, -181.0, 0, GS_TEMPLATE_WALL);
    gsFXCreateCircle(fStart,        fEnd,        18.0, 5.5,  14.58, -181.0, 0, GS_TEMPLATE_WALL);

    //column
    gsFXCreateCircle(fStart,        fEnd,        72.0, 8.0,   0.0,  -180.0, 0, GS_TEMPLATE_STONE_1);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 8.0,   0.97, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 8.0,   1.72, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 8.0,   2.47, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 7.9,   3.22, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 7.7,   3.97, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 7.4,   4.72, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 6.65,  4.72, -180.0, 0, GS_TEMPLATE_STONE_2);
    gsFXCreateCircle(fStart,        fEnd,        72.0, 5.9,   4.72, -180.0, 0, GS_TEMPLATE_STONE_2);

    //statue
    gsFXCreateCircle(fStart - 0.75, fEnd - 0.75, 72.0, 7.05,  5.47, -180.0, 0, GS_TEMPLATE_STATUE);

    DestroyObject(OBJECT_SELF);
}

#include "gs_inc_placeable"

void main()
{
    JumpToLocation(
        gsPLGetPlaceableLocation(
            GetLocalInt(OBJECT_SELF, "GS_PL_SLOT"),
            GetArea(OBJECT_SELF)));
}

#include "inc_placeable"

void main()
{
    gsPLRemovePlaceable(GetLocalInt(OBJECT_SELF, "GS_PL_SLOT"), GetArea(OBJECT_SELF));
}

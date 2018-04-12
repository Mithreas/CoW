#include "inc_boss"

void main()
{
    JumpToLocation(
        gsBOGetCreatureLocation(
            GetLocalInt(OBJECT_SELF, "GS_BO_SLOT"),
            GetArea(OBJECT_SELF)));
}

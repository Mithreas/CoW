#include "inc_caravan"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    Trace(CARAVANS, "Creating destination with tag: " + GetTag(OBJECT_SELF));
    object oObject = CreateObject(OBJECT_TYPE_WAYPOINT,
                                  "nw_waypoint001",
                                  GetLocation(OBJECT_SELF),
                                  FALSE,
                                  GetTag(OBJECT_SELF));

    if (GetIsObjectValid(oObject)) miCARegisterCaravan(oObject);

    DestroyObject(OBJECT_SELF);
}

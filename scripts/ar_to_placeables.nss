//::  Lets a torturer tortue placeables with the tag AR_OBJ_TORTURED

#include "inc_area"
#include "inc_event"

//----------------------------------------------------------------
void Run()
{
    object oArea = GetArea(OBJECT_SELF);

    if (!gsARGetIsAreaActive(oArea))
        return;

    object oPlaceable = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oPlaceable))
    {
        if (GetTag(oPlaceable) == "AR_OBJ_TORTURED")
        {
            SignalEvent(oPlaceable, EventUserDefined(GS_EV_ON_SPAWN));
        }

        oPlaceable = GetNextObjectInArea(oArea);
    };

    DestroyObject(OBJECT_SELF, 2.0);
}

//----------------------------------------------------------------
void main()
{
    Run();
}



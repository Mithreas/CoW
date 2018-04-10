#include "gs_inc_common"

void main()
{
    object oUser = GetLastUsedBy();
    string sTag  = GetTag(OBJECT_SELF);

    //workaround to prevent unwanted transitions
    //put underscore to beginning of lever tag
    if (GetStringLeft(sTag, 1) == "_")
        sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);

    //animation
    PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    DelayCommand(2.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    AssignCommand(oUser, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.0));

    //toggle lock
    object oDoor = gsCMGetNearestObject(sTag, OBJECT_TYPE_DOOR);

    if (GetIsObjectValid(oDoor))
    {
        if (GetLocked(oDoor))
        {
            SetLocked(oDoor, FALSE);
            if (! GetIsOpen(oDoor)) AssignCommand(oDoor, ActionOpenDoor(oDoor));
        }
        else
        {
            SetLocked(oDoor, TRUE);
            if (GetIsOpen(oDoor))   AssignCommand(oDoor, ActionCloseDoor(oDoor));
        }
    }
}

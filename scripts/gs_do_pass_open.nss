void main()
{
    if (GetLastClosedBy() != OBJECT_SELF)
    {
        string sTag    = GetLocalString(OBJECT_SELF, "GS_TARGET");
        object oTarget = GetObjectByTag(sTag);

        if (GetIsObjectValid(oTarget))
        {
            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_DOOR:
                if (! GetIsOpen(oTarget))
                {
                    SetLocked(oTarget, FALSE);
                    AssignCommand(oTarget, ActionOpenDoor(oTarget));
                }
                break;

            case OBJECT_TYPE_PLACEABLE:
                if (GetLocalInt(oTarget, "GS_DOOR") &&
                    ! GetLocalInt(oTarget, "GS_STATE"))
                {
                    AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
                    SetLocalInt(oTarget, "GS_STATE", TRUE);
                }
            }
        }
    }
}

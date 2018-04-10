void gsClose()
{
    string sTag    = GetLocalString(OBJECT_SELF, "GS_TARGET");
    object oTarget = GetObjectByTag(sTag);

    PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
    DeleteLocalInt(OBJECT_SELF, "GS_STATE");

    switch (GetObjectType(oTarget))
    {
    case OBJECT_TYPE_DOOR:
        AssignCommand(oTarget, ActionCloseDoor(oTarget));
        break;

    case OBJECT_TYPE_PLACEABLE:
        if (GetLocalInt(oTarget, "GS_DOOR"))
        {
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
            DeleteLocalInt(oTarget, "GS_STATE");
        }
    }
}
//----------------------------------------------------------------
void gsOpen()
{
    string sTag    = GetLocalString(OBJECT_SELF, "GS_TARGET");
    object oTarget = GetObjectByTag(sTag);

    PlayAnimation(ANIMATION_PLACEABLE_OPEN);
    SetLocalInt(OBJECT_SELF, "GS_STATE", TRUE);
    DelayCommand(60.0, gsClose());

    switch (GetObjectType(oTarget))
    {
    case OBJECT_TYPE_DOOR:
        SetLocked(oTarget, FALSE);
        AssignCommand(oTarget, ActionOpenDoor(oTarget));
        break;

    case OBJECT_TYPE_PLACEABLE:
        if (GetLocalInt(oTarget, "GS_DOOR"))
        {
            AssignCommand(oTarget, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
            SetLocalInt(oTarget, "GS_STATE", TRUE);
        }
    }
}
//----------------------------------------------------------------
void main()
{
    object oUser   = GetLastUsedBy();
    string sTag    = GetLocalString(OBJECT_SELF, "GS_TARGET");
    object oTarget = GetObjectByTag(sTag);

    if  (GetLocalInt(OBJECT_SELF, "GS_DOOR"))
    {
        if (! GetLocalInt(OBJECT_SELF, "GS_STATE"))
        {
            AssignCommand(oUser, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
            DelayCommand(1.0, gsOpen());
            return;
        }
    }

    if (GetIsObjectValid(oTarget))
    {
        AssignCommand(oUser, ActionJumpToObject(oTarget));
    }
}

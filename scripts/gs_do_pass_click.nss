void main()
{
    object oUser   = GetClickingObject();
    string sTag    = GetLocalString(OBJECT_SELF, "GS_TARGET");
    object oTarget = GetObjectByTag(sTag);

    if (GetIsObjectValid(oTarget))
    {
        AssignCommand(oUser, ActionJumpToObject(oTarget));
    }
}

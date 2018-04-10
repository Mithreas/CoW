void main()
{
    object oUser = GetLastUsedBy();

    if (GetIsPC(oUser))
    {
        object oSelf = OBJECT_SELF;
        AssignCommand(oUser, ActionExamine(oSelf));
    }
}

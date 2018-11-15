void main()
{
    if (! GetIsObjectValid(GetSittingCreature(OBJECT_SELF)))
    {
        object oSelf = OBJECT_SELF;
		object oUser = GetLastUsedBy();

        AssignCommand(oUser, ActionSit(oSelf));
		AssignCommand(oUser, SetLocalLocation(oUser, "MI_SIT_LOCATION", GetLocation(oUser)));
    }
}

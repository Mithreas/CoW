void main()
{
    if (! GetIsObjectValid(GetSittingCreature(OBJECT_SELF)))
    {
        object oSelf = OBJECT_SELF;

        AssignCommand(GetLastUsedBy(), ActionSit(oSelf));
    }
}

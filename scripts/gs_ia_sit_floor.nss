void main()
{
    object oUsedBy = GetLastUsedBy();
    object oSelf   = OBJECT_SELF;

    AssignCommand(oUsedBy, ActionMoveToLocation(GetLocation(oSelf)));
    AssignCommand(oUsedBy, ActionDoCommand(SetFacing(GetFacing(oSelf) + 180.0)));
    AssignCommand(oUsedBy, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
}

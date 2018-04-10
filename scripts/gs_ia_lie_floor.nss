void main()
{
    object oUsedBy = GetLastUsedBy();
    object oSelf   = OBJECT_SELF;

    AssignCommand(oUsedBy, ActionMoveToLocation(GetLocation(oSelf)));
    AssignCommand(oUsedBy, ActionDoCommand(SetFacing(GetFacing(oSelf) + 180.0)));
    if (d2(1) == 1) {
      AssignCommand(oUsedBy, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3600.0));
    } else {
      AssignCommand(oUsedBy, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 3600.0));
    }
}

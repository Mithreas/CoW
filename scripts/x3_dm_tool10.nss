void main()
{
    if (!GetIsDM(OBJECT_SELF)) return;
    
    object oTarget = GetSpellTargetObject();
    if ((GetObjectType(oTarget) == OBJECT_TYPE_DOOR)||(GetObjectType(oTarget) == OBJECT_TYPE_TRIGGER))
    {
        object oDestination = GetTransitionTarget(oTarget);
        location lDestination = GetLocation(oDestination);
        AssignCommand(OBJECT_SELF, JumpToLocation(lDestination));
    }
    else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        AssignCommand(OBJECT_SELF, JumpToObject(oTarget));
    }
    else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        object oDestination = GetObjectByTag(GetLocalString(oTarget, "CustomFlag"));
        if (GetIsObjectValid(oDestination))
        {
            location lDestination = GetLocation(oDestination);
            AssignCommand(OBJECT_SELF, JumpToLocation(lDestination));
        }
    }
    else if (GetIsObjectValid(oTarget) == FALSE)
    {
        location lTarget = GetSpellTargetLocation();
        AssignCommand(OBJECT_SELF, JumpToLocation(lTarget));
    }
}
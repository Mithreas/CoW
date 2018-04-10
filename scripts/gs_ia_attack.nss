void main()
{
    object oUser = GetLastUsedBy();
    object oSelf = OBJECT_SELF;

    AssignCommand(oUser, ActionEquipMostDamagingMelee(oSelf));
    AssignCommand(oUser, ActionAttack(oSelf));
}

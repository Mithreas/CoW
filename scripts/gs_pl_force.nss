void main()
{
    if (GetIsOpen(OBJECT_SELF) || GetLockKeyRequired(OBJECT_SELF)) return;

    if (GetLocked(OBJECT_SELF))
    {
        object oAttacker      = GetLastAttacker();
        int nLockDC           = GetLockUnlockDC(OBJECT_SELF);
        int nStrengthModifier = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);

        if (nStrengthModifier + d20() >= nLockDC)
        {
            SetLocked(OBJECT_SELF, FALSE);
            ActionOpenDoor(OBJECT_SELF);
        }
    }
    else
    {
        ActionOpenDoor(OBJECT_SELF);
    }
}

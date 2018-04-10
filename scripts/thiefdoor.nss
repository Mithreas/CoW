void main()
{
    object oPC = GetClickingObject();

    if (GetIsPC(oPC) &&
        GetLevelByClass(CLASS_TYPE_ROGUE, oPC) >= 4)
    {
        ActionDoCommand(SetLocked(OBJECT_SELF, FALSE));
        ActionOpenDoor(OBJECT_SELF);
        ActionDoCommand(SetLocked(OBJECT_SELF, TRUE));
    }
}

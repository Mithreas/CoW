void main()
{
    object oPlayer = GetPCSpeaker();
    object oDress = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);

    object oLent = GetLocalObject(oPlayer, "dresslent");
    if (oLent != OBJECT_INVALID)
    {
        DestroyObject(oLent);
    }

    object oCopy = CopyItem(oDress, oPlayer);
    SetLocalObject(oPlayer, "dresslent", oCopy);
    AssignCommand(oPlayer, ActionEquipItem(oCopy, INVENTORY_SLOT_CHEST));
}

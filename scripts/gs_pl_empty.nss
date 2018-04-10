void main()
{
    if (! GetIsObjectValid(GetFirstItemInInventory()))
    {
        DestroyObject(OBJECT_SELF);
    }
}

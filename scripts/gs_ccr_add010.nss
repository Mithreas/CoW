int StartingConditional()
{
    object oInput = GetObjectByTag("GS_CR_INPUT");
    return ! GetIsObjectValid(GetFirstItemInInventory(oInput));
}

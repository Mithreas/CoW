int StartingConditional()
{
    object oOutput = GetObjectByTag("GS_CR_OUTPUT");
    return ! GetIsObjectValid(GetFirstItemInInventory(oOutput));
}

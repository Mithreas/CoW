int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);

    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == "shiprattail") return TRUE;
        oItem = GetNextItemInInventory(oSpeaker);
    }

    return FALSE;
}

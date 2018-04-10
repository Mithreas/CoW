int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetIsObjectValid(GetItemPossessedBy(oPC, "md_jewelbox")) || GetIsObjectValid(GetItemPossessedBy(oPC, "md_jewelbox1")))
        return TRUE;

    return FALSE;
}

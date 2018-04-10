int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >= 8;
}

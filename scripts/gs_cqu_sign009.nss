int StartingConditional()
{
    return GetGold(GetPCSpeaker()) < GetLocalInt(OBJECT_SELF, "GS_COST") / 10;
}

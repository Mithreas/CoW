int StartingConditional()
{
    SetCustomToken(100, IntToString(GetLocalInt(OBJECT_SELF, "GS_COST") / 10));
    return TRUE;
}

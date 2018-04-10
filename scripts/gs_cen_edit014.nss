int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET") + 10 <
           GetLocalInt(OBJECT_SELF, "GS_EN_COUNT");
}

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "GS_PL_OFFSET") + 10 <
           GetLocalInt(OBJECT_SELF, "GS_PL_COUNT");
}

int StartingConditional()
{
    return (GetLocalInt(OBJECT_SELF, "in_progress") == 1);
}

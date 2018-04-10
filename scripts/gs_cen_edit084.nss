int StartingConditional()
{
    object oMemory = GetLocalObject(OBJECT_SELF, "GS_EN_MEMORY");

    return ! GetIsObjectValid(oMemory) ||
           oMemory != GetArea(OBJECT_SELF);
}

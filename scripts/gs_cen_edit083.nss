#include "inc_encounter"

void main()
{
    object oMemory = GetLocalObject(OBJECT_SELF, "GS_EN_MEMORY");

    if (GetIsObjectValid(oMemory))
    {
        object oArea = GetArea(OBJECT_SELF);
        if (oMemory != oArea) gsENCopyArea(oMemory, oArea);
    }
}

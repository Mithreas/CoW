#include "gs_inc_encounter"

void main()
{
    int bNight = GetLocalInt(GetPCSpeaker(), "NIGHT");
    gsENRemoveCreature(GetLocalInt(OBJECT_SELF, "GS_EN_SLOT"), GetArea(OBJECT_SELF), bNight);
}

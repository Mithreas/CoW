#include "gs_inc_encounter"

int StartingConditional()
{
    SetCustomToken(100, IntToString(gsENGetEncounterChance(GetArea(OBJECT_SELF))));
    return TRUE;
}

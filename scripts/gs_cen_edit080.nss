#include "inc_encounter"

int StartingConditional()
{
    SetCustomToken(100, FloatToString(gsENGetMinimumRating(GetArea(OBJECT_SELF)), 0, 1));
    return TRUE;
}

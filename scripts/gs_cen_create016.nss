#include "inc_encounter"

int StartingConditional()
{
    location lLocation = GetLocalLocation(OBJECT_SELF, "GS_TARGET");
    float fRating      = gsENGetRatingAtLocation(lLocation);

    SetCustomToken(100, FloatToString(fRating, 0, 1));
    return TRUE;
}

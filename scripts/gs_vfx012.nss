#include "inc_common"
#include "inc_encounter"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oObject = gsCMGetNearestObject("GS_FX_gs_item310");

        if (! GetIsObjectValid(oObject) ||
            GetDistanceToObject(oObject) > 2.5)
        {
            int nCount = gsENGetEncounterLimit(oArea);

            if (nCount > 0)
            {
                location lLocation = GetLocation(OBJECT_SELF);
                float fRating1     = gsENGetRatingAtLocation(lLocation);
                float fRating2     = gsENGetMinimumRating(oArea);

                if (fRating1 < fRating2) fRating1 = fRating2;

                if (fRating1 > 0.0)
                {
                    //spawn
                    gsENSpawnAtLocation(fRating1 * 2.0,
                                        nCount > 4 ? 4 : nCount,
                                        lLocation,
                                        2.5,
                                        VFX_IMP_POLYMORPH);
                }
            }
        }

        DelayCommand(30.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}

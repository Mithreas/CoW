#include "gs_inc_encounter"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    if (GetLastPerceptionSeen() ||
        GetLastPerceptionHeard())
    {
        object oPerceived = GetLastPerceived();

        if (GetIsPC(oPerceived) &&
            ! (GetIsDM(oPerceived) || GetIsDMPossessed(oPerceived)))
        {
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

            object oArea = GetArea(OBJECT_SELF);
            int nChance  = gsENGetEncounterChance(oArea);

            if (nChance > 0)
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
                        AssignCommand(
                            oArea,
                            gsENSpawnAtLocation(
                                fRating1,
                                nCount,
                                lLocation,
                                2.5));
                    }
                }
            }

            DestroyObject(OBJECT_SELF);
        }
    }
}

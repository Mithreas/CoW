// Dynamic spawn trigger code.
//
// Previously in gs_en_perc001 by Gigaschatten, on the on-perceived event for Dynamic
// Encounter spawns, reorganised by Gulni
//
// Now in the on-enter event for a dynamic encounter AoE trigger.

#include "gs_inc_encounter"

void main()
{
    Trace(ENCOUNTER, "Trigger spawn 1...");
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    object oEntering = GetEnteringObject();

    if (!GetIsPC(oEntering))
        return;

    if (GetIsDM(oEntering) || GetIsDMPossessed(oEntering))
        return;

    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    Trace(ENCOUNTER, "Trigger spawn 2 at " + APSLocationToString(GetLocation(OBJECT_SELF)));

    object oArea = GetArea(OBJECT_SELF);
    int nChance  = gsENGetEncounterChance(oArea);

    if (nChance > 0)
    {
        int nCount = gsENGetEncounterLimit(oArea);

        if (nCount > 0)
        {

            location lLocation = GetLocation(OBJECT_SELF);
            float fRating1     = gsENGetRatingAtLocation(GetLocation(oEntering));
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

    object oWaypoint = GetLocalObject(OBJECT_SELF, "GU_EN_WP");
    if (!GetIsObjectValid(oWaypoint))
        Error(ENCOUNTER, "Encounter has no waypoint.");

    DestroyObject(oWaypoint);
    DestroyObject(OBJECT_SELF);
}

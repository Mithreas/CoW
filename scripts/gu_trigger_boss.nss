// Dynamic boss trigger code.
//
// Previously in gs_bo_perc001 by Gigaschatten, on the on-perceived event for Dynamic
// Boss Encounter spawns, reorganised by Gulni
//
// Now in the on-enter event for a dynamic boss AoE trigger.

#include "gs_inc_encounter"

void main()
{
    Trace(ENCOUNTER, "Trigger boss spawn 1...");
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    object oEntering = GetEnteringObject();

    if (!GetIsPC(oEntering))
        return;

    if (GetIsDM(oEntering) || GetIsDMPossessed(oEntering))
        return;

    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    Trace(ENCOUNTER, "Trigger spawn 2 at " + __loc(GetLocation(OBJECT_SELF)));

    object oArea     = GetArea(OBJECT_SELF);
    int nChance      = gsENGetEncounterChance(oArea);
    object oWaypoint = GetLocalObject(OBJECT_SELF, "GU_EN_WP");
    if (!GetIsObjectValid(oWaypoint))
        Error(ENCOUNTER, "Boss spawn has no waypoint.");

    if (nChance > 0)
    {
        location lLocation = GetLocation(OBJECT_SELF);
        string sResRef     = GetLocalString(oWaypoint, "GU_BOSS_RESREF");
        int nCount         = gsENGetEncounterLimit(oArea);

        if (sResRef != "")
        {
            //spawn boss
            object oCreature = CreateObject(OBJECT_TYPE_CREATURE,
                                            sResRef,
                                            lLocation);

            if (GetIsObjectValid(oCreature))
            {
                gsFLSetFlag(GS_FL_BOSS, oCreature);

                //true seeing - removed by Mith
                //if (GetChallengeRating(oCreature) >= 15.0)
                //{
                //    ApplyEffectToObject(
                //        DURATION_TYPE_PERMANENT,
                //        ExtraordinaryEffect(EffectTrueSeeing()),
                //        oCreature);
                //}

                //phylactery
                object oObject = GetNearestObjectByTag("GS_PHYLACTERY", oCreature);
                int nNth       = 1;

                while (GetIsObjectValid(oObject) &&
                       GetDistanceBetween(oObject, oCreature) <= 35.0)
                {
                    if (! GetIsObjectValid(GetLocalObject(oObject, "GS_PHYLACTERY_CREATURE")))
                    {
                        SetLocalObject(oObject, "GS_PHYLACTERY_CREATURE", oCreature);
                        SetImmortal(oCreature, TRUE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                            EffectHeal(1000),
                                            oObject);
                        break;
                    }

                    oObject = GetNearestObjectByTag("GS_PHYLACTERY", oCreature, ++nNth);
                }
            }
        }

        if (nCount > 0)
        {
            //spawn encounter
            float fRating1 = gsENGetRatingAtLocation(GetLocation(oEntering));
            float fRating2 = gsENGetMinimumRating(oArea);

            if (fRating1 < fRating2) fRating1 = fRating2;

            if (fRating1 > 0.0)
            {
                AssignCommand(
                    oArea,
                    gsENSpawnAtLocation(
                        fRating1,
                        nCount,
                        lLocation,
                        2.5));
            }
        }

        Trace(ENCOUNTER, "Boss spawn '" + sResRef + "', "
                       + "count " + IntToString(nCount));
    }

    DestroyObject(OBJECT_SELF);
    DestroyObject(oWaypoint);
}

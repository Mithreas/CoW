// gu_inc_encounter
//
// Utility functions to assist with dynamic VFX-based encounter triggers.
//
// By Gulni
// Slight Performance Tweak to guENTryDynamicEncounter() by Space Pirate
//      in April 2011

//void main() {}

#include "mi_log"

// Temporary NPC to use for walkmesh probing
// (we use the existing Dynamic Encounter just for now)
const string GU_EN_TEMPLATE_WALKPROBE = "gu_walkmesh";

// Marker waypoint for dynamic encounters
const string GU_EN_TEMPLATE_WAYPOINT = "gu_wp_encounter";

// For Logging
const string ENCOUNTER = "ENCOUNTER";

// VFX entries to use for encounter/boss triggers
// To match the encounter trigger lines from vfx_persistent.2da

const int GU_EN_VFX_ENCOUNTER  = 50;
const int GU_EN_VFX_BOSS       = 51;

// Return the nearest walkable location to a given probe location.
location guENFindNearestWalkable(location lProbe);
// Attempt to place a new dynamic encounter at a given location, while
// ensuring that it is at least fMaxDistance from any other encounter.
void guENTryDynamicEncounter(location lWhere, float fMaxDistance);
// Place a new dynamic boss encounter at a given location,
// storing the sResRef on the encounter waypoint to remember the desired
// boss spawn.
void guENPlaceBossEncounter(location lWhere, string sResRef);

// Add a temporary safe zone to prevent mobs spawning near a certain point
// The caller must remove the returned waypoint later.
object guENCreateSafeZone(location lWhere);

location guENFindNearestWalkable(location lProbe)
{
    // This is expensive but appears to be the only portable way to achieve
    // this.
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE,
                                    GU_EN_TEMPLATE_WALKPROBE,
                                    lProbe,
                                    FALSE,
                                    "GU_WALKMESH_PROBE");

    location lNearest = GetLocation(oCreature);
    DestroyObject(oCreature);
    return lNearest;
}

// Debug:
string __loc(location lLoc)
{
    vector vPos = GetPositionFromLocation(lLoc);
    return "(" + FloatToString(vPos.x, 1, 2) +
           "," + FloatToString(vPos.y, 1, 2) +
           ")";
}

// Internal: Create an AoE effect, and return the object just created.
object __ApplyEffectAtLocation(int nDurationType, effect eEffect,
                               location lLocation, float fDuration=0.0f)
{
    ApplyEffectAtLocation(nDurationType, eEffect, lLocation, fDuration);

    int nNth = 1;
    object oAOE;
    while (TRUE)
    {
        oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT,
                                          lLocation, nNth++);
        if (!GetIsObjectValid(oAOE))
        {
            Error(ENCOUNTER, "Failed to find AOE object for last trigger.");
            break;
        }

        if (GetLocation(oAOE) == lLocation)
            break;
    }
    return oAOE;
}

void guENTryDynamicEncounter(location lWhere, float fMaxDistance)
{
    location lWalkable = guENFindNearestWalkable(lWhere);

    Trace(ENCOUNTER, "Spawn attempt at " + __loc(lWhere));

    object oObject = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT,
                                                lWalkable, 1);
    Trace(ENCOUNTER, "walkmesh probe at " + __loc(lWalkable));

    int nNth = 1;
    string sTag;

    // [Slight re-edit here by Space Pirate]
    // Now we break if the nearest WP is out of range,
    // even if it is not an encounter.
    while (GetIsObjectValid(oObject))
    {
        // Nearest WP is too far away to care about
        if (GetDistanceBetweenLocations(lWalkable, GetLocation(oObject))
            > fMaxDistance)

            break;

        sTag = GetTag(oObject);

        // Alreay an encounter in range, don't make another
        if (sTag == "GU_ENCOUNTER" || sTag == "GU_BOSS")
        {
            Trace(ENCOUNTER, "too near encounter at " + __loc(GetLocation(oObject)));

            return;
        }

        oObject = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT,
                                             lWalkable, ++nNth);
    }

    // Bingo... drop a waypoint to mark this dynamic encounter,
    // and an AoE trigger to activate it.

    object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT,
                                    GU_EN_TEMPLATE_WAYPOINT,
                                    lWalkable,
                                    FALSE,
                                    "GU_ENCOUNTER");

    effect eTrigger = EffectAreaOfEffect(GU_EN_VFX_ENCOUNTER);
    // Don't want it to be dispellable!
    eTrigger = SupernaturalEffect(eTrigger);
    object oAOE = __ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                                          eTrigger,
                                          lWalkable);
    SetLocalObject(oWaypoint, "GU_EN_AOE", oAOE);
    SetLocalObject(oAOE, "GU_EN_WP", oWaypoint);

    Trace(ENCOUNTER, "Encounter initialised.");
}

void guENPlaceBossEncounter(location lWhere, string sResRef)
{
    Trace(ENCOUNTER, "Boss attempt at " + __loc(lWhere));

    location lWalkable = guENFindNearestWalkable(lWhere);
    Trace(ENCOUNTER, "walkmesh probe at " + __loc(lWalkable));

    object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT,
                                    GU_EN_TEMPLATE_WAYPOINT,
                                    lWalkable,
                                    FALSE,
                                    "GU_BOSS");
    SetLocalString(oWaypoint, "GU_BOSS_RESREF", sResRef);

    effect eTrigger = EffectAreaOfEffect(GU_EN_VFX_BOSS);
    // Don't want it to be dispellable!
    eTrigger = SupernaturalEffect(eTrigger);
    object oAOE = __ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                                          eTrigger,
                                          lWalkable);
    SetLocalObject(oWaypoint, "GU_EN_AOE", oAOE);
    SetLocalObject(oAOE, "GU_EN_WP", oWaypoint);

    Trace(ENCOUNTER, "Boss encounter initialised.");
}

object guENCreateSafeZone(location lWhere)
{
    // Create a temporary encounter waypoint with no AoE trigger,
    // purely to prevent any other encounters from spawning near
    // this one.
    object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT,
                                    GU_EN_TEMPLATE_WAYPOINT,
                                    lWhere,
                                    FALSE,
                                    "GU_ENCOUNTER");
    return oWaypoint;
}

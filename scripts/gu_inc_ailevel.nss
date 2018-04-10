// gu_inc_ailevel.nss
//
// Include file to handle AI level transitions for NPCs, in particular to
// ensure that nearby NPCs are also woken up when something interesting
// occurs.

// Handle AI levels by intent so that we can change them easily for experimentation
// if desired.
const int GU_AI_LEVEL_COMBAT  = AI_LEVEL_NORMAL;    // Highest active level
const int GU_AI_LEVEL_WAITING = AI_LEVEL_LOW;       // Not active but PCs in area
const int GU_AI_LEVEL_IDLE    = AI_LEVEL_VERY_LOW;  // No PCs in area

// AI level to set nearby NPCs to when one NPC enters combat mode
const int GU_AI_LEVEL_NEAR_COMBAT = GU_AI_LEVEL_COMBAT;

// Radius of nearby NPCs to wake up on a combat event
const float GU_AI_WAKEUP_RADIUS = 35.0;

// Set an NPC's AI level to a desired value, waking up other
// nearby NPCs if appropriate.
void guALSetAILevel(int nAILevel, object oTarget = OBJECT_SELF)
{
    int nOldAILevel = GetAILevel(oTarget);

    if (nOldAILevel == nAILevel)
        return;

    SetAILevel(oTarget, nAILevel);

    // If, and only if, we're raising the NPC's AI level to combat, then search
    // for other NPCs to wake up too.

    if (!(nAILevel == GU_AI_LEVEL_COMBAT &&
          nOldAILevel <= nAILevel))
        return;

    location lTarget = GetLocation(oTarget);
    object oNPC = GetFirstObjectInShape(SHAPE_SPHERE,
                                        GU_AI_WAKEUP_RADIUS,
                                        lTarget,
                                        FALSE,  // No line-of-sight check
                                        OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oNPC))
    {
        if (!GetIsPC(oNPC) && GetAILevel(oNPC) < GU_AI_LEVEL_NEAR_COMBAT)
            SetAILevel(oNPC, GU_AI_LEVEL_NEAR_COMBAT);

        oNPC = GetNextObjectInShape(SHAPE_SPHERE,
                                    GU_AI_WAKEUP_RADIUS,
                                    lTarget,
                                    FALSE,  // No line-of-sight check
                                    OBJECT_TYPE_CREATURE);
    }
}

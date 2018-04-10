//::///////////////////////////////////////////////
//:: On Heartbeat: Unsummon
//:://////////////////////////////////////////////
/*
    Unsummons the the creature on heartbeat
    if it has survived past its despawn timer.

    Also executes the henchmen heartbeat
    script.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 3, 2016
//:://////////////////////////////////////////////

#include "inc_spells"
#include "inc_timelock"
#include "x0_i0_match"

void main()
{
    // Note: dominated creatures are unsummoned because this script is intended for "summons" in the henchmen position. If the creature is dominated,
    // then it was probably passed to another player. We don't want that, so just unsummon it.
    if(!GetIsObjectValid(GetMaster(OBJECT_SELF)) || GetModuleTime() > GetLocalInt(OBJECT_SELF, "Despawn_Time") || GetHasEffect(EFFECT_TYPE_DOMINATED))
    {
        UnsummonCreature(OBJECT_SELF);
        return;
    }
    ExecuteScript("x0_ch_hen_heart", OBJECT_SELF);
}

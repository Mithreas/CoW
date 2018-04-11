//::///////////////////////////////////////////////
//:: Electrical Trap
//:: NW_T1_ElecDeadC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 30d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"

#include "inc_traps"
void main()
{
    if (miTRPreHook()) return;
    TrapDoElectricalDamage(d6(25),28,6);
}


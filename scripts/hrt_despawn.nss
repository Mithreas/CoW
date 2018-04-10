//::///////////////////////////////////////////////
//:: Heartbeat: Despawn
//:: hrt_despawn
//:://////////////////////////////////////////////
/*
    Calls CheckDespawn on heartbeat and despawns
    this creature with VFX if its time, as set
    via SetDespawnTimer, has expired.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////

#include "inc_generic"

void main()
{
    CheckDespawn();
}

//::///////////////////////////////////////////////
//:: Heartbeat: Update Shadowdancer Aura
//:: hrt_updsdaura
//:://////////////////////////////////////////////
/*
    Updates the current state of the shadowdancer's
    bonus sneak attack properties. Ensure that
    lag-related issues will not cause the
    shadowdancer to lose these feats permanently.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2017
//:://////////////////////////////////////////////

#include "inc_shadowdancer"

void main()
{
    UpdateShadowdancerSneakAttackBonus();
}

//::///////////////////////////////////////////////
//:: Associate Removed: Remove SD Sneak Attack
//:: rem_remsdsneakatk
//:://////////////////////////////////////////////
/*
    Removes sneak attack bonuses from the master.
    Called when the shadow is being removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: March 7, 2017
//:://////////////////////////////////////////////

#include "inc_shadowdancer"

void main()
{
    object oMaster = GetLocalObject(OBJECT_SELF, "Master");

    RemoveShadowdancerSneakAttackBonus(oMaster);
}

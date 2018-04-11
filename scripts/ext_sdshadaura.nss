//::///////////////////////////////////////////////
//:: On Exit: Shadowdancer Shadow Aura
//:: ext_sdshadaura
//:://////////////////////////////////////////////
/*
    Removes temporary bonus sneak attack feats
    from the exiting shadowdancer's hide.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////

#include "inc_shadowdancer"

void main()
{
    RemoveShadowdancerSneakAttackBonus(GetExitingObject());
}

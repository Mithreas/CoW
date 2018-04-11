//::///////////////////////////////////////////////
//:: On Enter: Shadowdancer Shadow Aura
//:: ent_sdshadaura
//:://////////////////////////////////////////////
/*
    Grants the shadowdancer + 1d6 sneak attack
    / 3 shadowlord levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////

#include "inc_shadowdancer"

void main()
{
    GrantShadowdancerSneakAttackBonus(GetEnteringObject());
}

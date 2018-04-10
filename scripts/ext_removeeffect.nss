//::///////////////////////////////////////////////
//:: On Exit: Remove Effects
//:: ext_removeeffect
//:://////////////////////////////////////////////
/*
    Removes all effects from the exiting object
    that were applied by this aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 5, 2016
//:://////////////////////////////////////////////

#include "inc_effect"

void main()
{
    RemoveTaggedEffects(GetExitingObject(), EFFECT_TAG_AURA, GetAreaOfEffectCreator());
}

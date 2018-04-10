//::///////////////////////////////////////////////
//:: Executed Script: Resurrect
//:: exe_resurrect
//:://////////////////////////////////////////////
/*
    Resurrects the calling object and reapplies
    character bonuses.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////

#include "inc_bonuses"

void main()
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyCharacterBonuses(OBJECT_SELF, FALSE);
}

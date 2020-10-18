//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "inc_zombie"
#include "inc_divination"
#include "inc_state"
#include "inc_totem"

void main()
{
    if (fbZGetIsZombie(OBJECT_SELF))
    {
        FloatingTextStringOnCreature("... that's the first time your animal companion has ignored you. You feel saddened and alone.", OBJECT_SELF, FALSE);
        return;
    }

    if(GetIsTimelocked(OBJECT_SELF, "Animal Companion"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Animal Companion");
        return;
    }

    miDVGivePoints(OBJECT_SELF, ELEMENT_LIFE, 25.0);
    SummonAnimalCompanion(OBJECT_SELF);	
	gsSTDoCasterDamage(OBJECT_SELF, 5);
	IncrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);  	
}

//::///////////////////////////////////////////////
//:: Aura of Stunning
//:: NW_S1_AuraStun.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

#include "inc_spell"

void main()
{
    //::  No stacking auras
    gsSPRemoveEffect(OBJECT_SELF, 202, OBJECT_SELF);

    //Set and apply the AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_STUN);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}

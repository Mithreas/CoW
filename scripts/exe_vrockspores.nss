//::///////////////////////////////////////////////
//:: Executed Script: Vrock Spores
//:: exe_vrockspores
//:://////////////////////////////////////////////
/*
    Every three rounds, a vrock may release
    a cloud of spores to afflict enemy
    targets. Affected creatures suffer -1
    fortitude and 1d4 acid damage on impact,
    as well as an additional 1d4 acid damage
    every round for a period of 10 rounds. The
    effects of this afflication may be removed
    via the neutralize poison spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////

#include "inc_dot"
#include "inc_time"
#include "x0_i0_spells"

void main()
{
    float fDistanceEnemy = GetDistanceToObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY));
    float fDistanceFriend = GetDistanceToObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND));
    float fDistanceNeutral = GetDistanceToObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL));

    if(!GetIsInCombat()
        || (fDistanceEnemy < 0.0 || fDistanceEnemy > RADIUS_SIZE_LARGE)
        || (fDistanceFriend >= 0.0 && fDistanceFriend <= RADIUS_SIZE_LARGE)
        || (fDistanceNeutral >= 0.0 && fDistanceNeutral <= RADIUS_SIZE_LARGE)) return;

    int nTime = GetModuleTime();
    int nLastTime = GetLocalInt(OBJECT_SELF, "VrockSporeTimestamp");

    if(nTime - nLastTime < 18) return;

    float fDelay;
    location lTarget = GetLocation(OBJECT_SELF);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_NATURE), OBJECT_SELF);

    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && !GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
        {
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) / 20.0;
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, -1, TRUE));
            DelayCommand(fDelay, ApplyDoTToCreature(EffectSavingThrowDecrease(SAVING_THROW_FORT, 1), VFX_DUR_CESSATE_NEGATIVE, "d4acid",
                oTarget, 60.0, 6.0, OBJECT_SELF, EFFECT_TAG_POISON, -1));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    }
    SetLocalInt(OBJECT_SELF, "VrockSporeTimestamp", nTime);
}

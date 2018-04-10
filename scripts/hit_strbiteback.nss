//::///////////////////////////////////////////////
//:: On Hit: Strength Biteback
//:: hit_strbiteback
//:://////////////////////////////////////////////
/*
    Enemies that hit the target must make a
    fortitude saving throw (DC = 14 + HD / 2)
    or suffer 1d6 strength damage for
    1 round / level.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 19, 2017
//:://////////////////////////////////////////////

#include "inc_generic"
#include "x0_i0_spells"

// Applies d6 strength penalty to the target.
void ApplyStrengthDamage(object oTarget, float fDuration);

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetHitDice(oCaster) + GetBonusHitDice(oCaster);
    int nDC = 17 + (nHitDice) / 2;

    if(GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE) || GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))) return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
    {
        // l33t engine hax to allow strength penalty to stack.
        AssignCommand(oTarget, ApplyStrengthDamage(oTarget, RoundsToSeconds(nHitDice)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
    }
}

//::///////////////////////////////////////////////
//:: ApplyStrengthDamage
//:://////////////////////////////////////////////
/*
    Applies d6 strength penalty to the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 20, 2017
//:://////////////////////////////////////////////
void ApplyStrengthDamage(object oTarget, float fDuration)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH, d6()), oTarget, fDuration);
}

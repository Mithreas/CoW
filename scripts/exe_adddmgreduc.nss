//::///////////////////////////////////////////////
//:: Executed Script: Add Damage Reduction
//:: exe_adddmgreduc
//:://////////////////////////////////////////////
/*
    Applies a damage reduction effect to the
    caller.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 13, 2016
//:://////////////////////////////////////////////

void main()
{
    int nAmount = GetLocalInt(OBJECT_SELF, "DAMAGE_REDUCTION_AMOUNT");
    int nDamagePower = GetLocalInt(OBJECT_SELF, "DAMAGE_REDUCTION_POWER");
    int nLimit = GetLocalInt(OBJECT_SELF, "DAMAGE_REDUCTION_LIMIT");

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(nAmount, nDamagePower, nLimit)), OBJECT_SELF);
}

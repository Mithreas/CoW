//::///////////////////////////////////////////////
//:: Executed Script: Modify Attacks
//:: exe_modattacks
//:://////////////////////////////////////////////
/*
    Modifiers the caller's number of attacks
    by a given number.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 25, 2016
//:://////////////////////////////////////////////

void main()
{
    int nAttackModifier = GetLocalInt(OBJECT_SELF, "ATTACKS_MODIFIER");

    if(nAttackModifier > 5) nAttackModifier = 5;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectModifyAttacks(nAttackModifier)), OBJECT_SELF);
}

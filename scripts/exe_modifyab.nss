//::///////////////////////////////////////////////
//:: Executed Script: Modify AB
//:: exe_modifyab
//:://////////////////////////////////////////////
/*
    Modifiers the caller's attack bonus by
    a given amount.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 20, 2016
//:://////////////////////////////////////////////

void main()
{
    int nABModifier = GetLocalInt(OBJECT_SELF, "AB_MODIFIER");

    if(nABModifier > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nABModifier)), OBJECT_SELF);
    }
    else if(nABModifier < 0)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(nABModifier * -1)), OBJECT_SELF);
    }
}

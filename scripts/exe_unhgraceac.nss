//::///////////////////////////////////////////////
//:: Executed Script: Unholy Grace AC
//:: exe_unhgraceac
//:://////////////////////////////////////////////
/*
    Updates the caller's AC, granting it a dodge
    bonus based on its current charisma score.
    Never call this from a PC; it will conflict
    with PC bonuses.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

void UpdateUnholyGraceAC();

void main()
{
    DelayCommand(0.0, UpdateUnholyGraceAC());
}

//::///////////////////////////////////////////////
//:: Update Unholy Grace AC
//:://////////////////////////////////////////////
/*
    Main logic for AC update. Put on a delay
    to ensure calculations occur after effects
    from spells have been applied.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////
void UpdateUnholyGraceAC()
{
    effect eEffect;

    eEffect = GetFirstEffect(OBJECT_SELF);

    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE && GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT && GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
            RemoveEffect(OBJECT_SELF, eEffect);
        eEffect = GetNextEffect(OBJECT_SELF);
    }

    if(GetAbilityModifier(ABILITY_CHARISMA) <= 0) return;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(GetAbilityModifier(ABILITY_CHARISMA))), OBJECT_SELF);
}

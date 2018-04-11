//::///////////////////////////////////////////////
//:: Executed Script: Death
//:: exe_death
//:://////////////////////////////////////////////
/*
    The creature dies after a delay specified
    by local float DEATH_DELAY.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 24, 2017
//:://////////////////////////////////////////////

void main()
{
    DelayCommand(GetLocalFloat(OBJECT_SELF, "DEATH_DELAY"), ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF));
}

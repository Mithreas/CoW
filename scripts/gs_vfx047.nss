#include "inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                                              OBJECT_SELF, 1,
                                              CREATURE_TYPE_IS_ALIVE, TRUE);

        if (GetIsObjectValid(oCreature) &&
            GetDistanceToObject(oCreature) < 7.5)
        {
            ActionCastSpellAtObject(
                SPELL_CHAIN_LIGHTNING,
                oCreature,
                METAMAGIC_ANY,
                TRUE,
                0,
                PROJECTILE_PATH_TYPE_DEFAULT,
                TRUE);
        }

        DelayCommand(6.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}

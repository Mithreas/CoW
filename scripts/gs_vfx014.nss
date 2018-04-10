#include "gs_inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oObject  = GetFirstObjectInArea(oArea);
        int nRacialType = RACIAL_TYPE_INVALID;

        while (GetIsObjectValid(oObject))
        {
            if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
                ! (GetPlotFlag(oObject) || GetIsDM(oObject)))
            {
                switch (GetRacialType(oObject))
                {
                case RACIAL_TYPE_CONSTRUCT:
                    break;

                case RACIAL_TYPE_UNDEAD:
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                        EffectHeal(d6()),
                                        oObject);
                    break;

                default:
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                        EffectDamage(d6(),
                                                     DAMAGE_TYPE_NEGATIVE,
                                                     DAMAGE_POWER_ENERGY),
                                        oObject);
                    break;
                }
            }

            oObject = GetNextObjectInArea(oArea);
        }

        DelayCommand(6.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}

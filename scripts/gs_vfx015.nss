#include "inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        object oObject = GetFirstObjectInArea(oArea);

        while (GetIsObjectValid(oObject))
        {
            if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
                ! (GetPlotFlag(oObject) || GetIsDM(oObject)))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectDamage(d6(), DAMAGE_TYPE_FIRE),
                                    oObject);
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

#include "gs_inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (! gsARGetIsAreaActive(oArea))
    {
        DeleteLocalInt(OBJECT_SELF, "GS_ENABLED");
        return;
    }

    object oObject = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        if (GetIsPC(oObject) && ! (GetPlotFlag(oObject) || GetIsDM(oObject)) &&
            WillSave(oObject, 20, SAVING_THROW_TYPE_MIND_SPELLS) == 0)
        {
            if (WillSave(oObject, 20, SAVING_THROW_TYPE_EVIL) == 0)
            {
                AdjustAlignment(oObject, ALIGNMENT_EVIL, 1);
            }

            if (WillSave(oObject, 20, SAVING_THROW_TYPE_LAW) == 0)
            {
                AdjustAlignment(oObject, ALIGNMENT_LAWFUL, 1);
            }
        }

        oObject = GetNextObjectInArea(oArea);
    }

    DelayCommand(HoursToSeconds(1), gsRun());
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    //gsRun();
}

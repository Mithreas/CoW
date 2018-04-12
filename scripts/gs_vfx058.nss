#include "inc_effect"

const string GS_TEMPLATE_SKULL = "gs_placeable374";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    float fValue  = 0.0;
    float fRadius = 0.9;
    float fZ      = 2.5;

    fValue        = IntToFloat(Random(3600)) / 10.0;
    gsFXCreateCircle(fValue, fValue + 360.0, 24.0, 2.5, 0.0, 0.0, 80, GS_TEMPLATE_SKULL); //15
    fValue        = IntToFloat(Random(3600)) / 10.0;
    gsFXCreateCircle(fValue, fValue + 360.0, 30.0, 1.9, 0.5, 0.0, 70, GS_TEMPLATE_SKULL); //12
    fValue        = IntToFloat(Random(3600)) / 10.0;
    gsFXCreateCircle(fValue, fValue + 360.0, 40.0, 1.5, 1.0, 0.0, 60, GS_TEMPLATE_SKULL); //9
    fValue        = IntToFloat(Random(3600)) / 10.0;
    gsFXCreateCircle(fValue, fValue + 360.0, 45.0, 1.2, 1.5, 0.0, 50, GS_TEMPLATE_SKULL); //8
    fValue        = IntToFloat(Random(3600)) / 10.0;
    gsFXCreateCircle(fValue, fValue + 360.0, 60.0, 1.0, 2.0, 0.0, 40, GS_TEMPLATE_SKULL); //6

    while (fZ <= 4.0)
    {
        fValue  = IntToFloat(Random(3600)) / 10.0;
        gsFXCreateCircle(fValue, fValue + 360.0, 60.0, fRadius, fZ, 0.0, 30, GS_TEMPLATE_SKULL); //6
        fZ      += 0.5;
        fRadius -= 0.05;
    }

    while (fZ <= 6.0)
    {
        fValue  = IntToFloat(Random(3600)) / 10.0;
        gsFXCreateCircle(fValue, fValue + 360.0, 72.0, fRadius, fZ, 0.0, 30, GS_TEMPLATE_SKULL); //5
        fZ      += 0.5;
        fRadius -= 0.05;
    }

    DestroyObject(OBJECT_SELF);
}

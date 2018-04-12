#include "inc_area"

void gsRun(float fAngle = 0.0)
{
    object oArea      = GetArea(OBJECT_SELF);

    if (! gsARGetIsAreaActive(oArea))
    {
        DeleteLocalInt(OBJECT_SELF, "GS_ENABLED");
        return;
    }

    effect eEffect    = EffectVisualEffect(134);
    vector vPosition1 = GetPosition(OBJECT_SELF);
    vector vPosition2 = vPosition1;
    float fDelay      = 0.0;
    float fAngle1     = fAngle;
    float fRadius     = 0.0;
    int nNth1         = 0;
    int nNth2         = 0;

    for (; nNth1 < 3; nNth1++)
    {
        fRadius     = 2.0;

        for (nNth2 = 0; nNth2 < 12; nNth2++)
        {
            DelayCommand(
                fDelay,
                ApplyEffectAtLocation(
                    DURATION_TYPE_INSTANT,
                    eEffect,
                    Location(
                        oArea,
                        vPosition2 + AngleToVector(fAngle1) * fRadius,
                        0.0)));

            fDelay       +=  0.4;
            vPosition2.z +=  0.75;
            fAngle1      += 30.0;
            fRadius      -=  0.2;

            if (fAngle1 > 360.0) fAngle1 -= 360.0;
            if (fRadius <   0.0) fRadius  =   0.0;
        }

        vPosition2  = vPosition1;
        fAngle     += 120.0;

        if (fAngle > 360.0) fAngle -= 360.0;

        fAngle1     = fAngle;
    }

    DelayCommand(fDelay, gsRun(fAngle));
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    gsRun();
}

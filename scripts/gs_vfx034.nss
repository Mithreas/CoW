#include "inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        if (Random(100) >= 50)
        {
            effect eEffect   = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
            vector vPosition = GetPosition(OBJECT_SELF);
            float fDelay     = IntToFloat(Random(70)) / 10.0;
            int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
            int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
            vPosition.x      = IntToFloat(Random(nSizeX) + 1);
            vPosition.y      = IntToFloat(Random(nSizeY) + 1);

            DelayCommand(
                fDelay,
                ApplyEffectAtLocation(
                    DURATION_TYPE_INSTANT,
                    eEffect,
                    Location(oArea, vPosition, 0.0)));
        }

        DelayCommand(6.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}

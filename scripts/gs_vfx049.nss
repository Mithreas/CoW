#include "inc_area"

void main()
{
    object oArea     = GetArea(OBJECT_SELF);
    effect eEffect   = EffectVisualEffect(VFX_DUR_FLIES);
    vector vPosition = GetPosition(OBJECT_SELF);
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
    int i            = 0;
    int c            = nSizeX * nSizeY / 1000;

    if (c > 10) c = 10;

    for (; i < c; i++)
    {
        vPosition.x = IntToFloat(Random(nSizeX) + 1);
        vPosition.y = IntToFloat(Random(nSizeY) + 1);

        ApplyEffectAtLocation(
            DURATION_TYPE_PERMANENT,
            eEffect,
            Location(oArea, vPosition, 0.0));
    }
}

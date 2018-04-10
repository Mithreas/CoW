#include "gs_inc_area"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea     = GetArea(OBJECT_SELF);
    effect eEffect   = EffectAreaOfEffect(AOE_PER_OVERMIND, "****", "****", "****");
    vector vPosition = GetPosition(OBJECT_SELF);
    float fDelay     = 0.0;
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
    int i            = 0;
    int c            = nSizeX * nSizeY / 1000;

    if (c > 10) c = 10;

    for (; i < c; i++)
    {
        fDelay      = IntToFloat(Random(70)) / 10.0;
        vPosition.x = IntToFloat(Random(nSizeX) + 1);
        vPosition.y = IntToFloat(Random(nSizeY) + 1);

        DelayCommand(
            fDelay,
            ApplyEffectAtLocation(
                DURATION_TYPE_PERMANENT,
                eEffect,
                Location(oArea, vPosition, 0.0)));
    }

    DestroyObject(OBJECT_SELF);
}

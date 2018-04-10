#include "gs_inc_area"

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (gsARGetIsAreaActive(oArea))
    {
        effect eEffect   = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        vector vPosition = GetPosition(OBJECT_SELF);
        float fDelay     = 1.0;
        int nNth         = 0;

        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD),
            GetLocation(OBJECT_SELF));

        for (; nNth < 20; nNth++)
        {
            DelayCommand(
                fDelay,
                ApplyEffectAtLocation(
                    DURATION_TYPE_INSTANT,
                    eEffect,
                    Location(
                        oArea,
                        vPosition,
                        IntToFloat(Random(360)))));

            fDelay      +=  0.1;
            vPosition.z +=  0.5;
        }

        DelayCommand(6.0, gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}

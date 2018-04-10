#include "gs_inc_area"

void gsImpact(location lLocation)
{
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_METEOR_SWARM),
        lLocation);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation);
    effect eEffect;
    effect eVisual = EffectVisualEffect(VFX_IMP_FLAME_M);
    float fDelay   = 0.0;
    int nDamage    = 0;

    while (GetIsObjectValid(oTarget))
    {
        fDelay  = IntToFloat(Random(11)) / 10.0;
        nDamage = GetReflexAdjustedDamage(d6(6), oTarget, 16, SAVING_THROW_TYPE_FIRE);
        eEffect = EffectLinkEffects(eVisual, EffectDamage(nDamage, DAMAGE_TYPE_FIRE));

        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                eEffect,
                oTarget));

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation);
    }
}
//----------------------------------------------------------------
void gsRun()
{
    object oArea       = GetArea(OBJECT_SELF);

    if (! gsARGetIsAreaActive(oArea))
    {
        DeleteLocalInt(OBJECT_SELF, "GS_ENABLED");
        return;
    }

    vector vPosition   = GetPosition(OBJECT_SELF);
    float fDelay       = IntToFloat(Random(30));
    int nSizeX         = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY         = FloatToInt(gsARGetSizeY(oArea)) - 1;
    vPosition.x        = IntToFloat(Random(nSizeX) + 1);
    vPosition.y        = IntToFloat(Random(nSizeY) + 1);
    location lLocation = Location(oArea, vPosition, 0.0);

    DelayCommand(fDelay, gsImpact(lLocation));
    DelayCommand(30.0, gsRun());
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    gsRun();
}

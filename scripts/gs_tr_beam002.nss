void gsBeam(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_BEAM_FIRE),
                        oTarget,
                        2.0);

    DelayCommand(
        IntToFloat(Random(10)) / 10.0 + 0.5,
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M),
                                              EffectDamage(d6(2),
                                                           DAMAGE_TYPE_FIRE,
                                                           DAMAGE_POWER_ENERGY)),
                            oTarget));
}
//----------------------------------------------------------------
void main()
{
    object oEntering = GetEnteringObject();
    string sTag      = GetTag(OBJECT_SELF);
    int nNth         = 1;

    object oObject   = GetNearestObjectByTag(sTag);

    while (GetIsObjectValid(oObject))
    {
        AssignCommand(oObject, gsBeam(oEntering));
        oObject = GetNearestObjectByTag(sTag, OBJECT_SELF, ++nNth);
    }
}

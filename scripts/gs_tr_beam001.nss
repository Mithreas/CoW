void gsBeam(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_BEAM_EVIL),
                        oTarget,
                        2.0);

    switch (GetRacialType(oTarget))
    {
    case RACIAL_TYPE_CONSTRUCT:
        break;

    case RACIAL_TYPE_UNDEAD:
        DelayCommand(
            IntToFloat(Random(10)) / 10.0 + 0.5,
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectLinkEffects(EffectVisualEffect(VFX_IMP_HEALING_M),
                                                  EffectHeal(d6(4))),
                                oTarget));
        break;

    default:
        DelayCommand(
            IntToFloat(Random(10)) / 10.0 + 0.5,
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectLinkEffects(EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY),
                                                  EffectDamage(d6(4),
                                                               DAMAGE_TYPE_NEGATIVE,
                                                               DAMAGE_POWER_ENERGY)),
                                oTarget));
        break;
    }
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

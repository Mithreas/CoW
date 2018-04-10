void gsBeam(object oTarget)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_BEAM_HOLY),
                        oTarget,
                        2.0);
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

    DelayCommand(
        2.0,
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY),
                            oEntering));

    if (GetRacialType(oEntering) == RACIAL_TYPE_UNDEAD ||
        GetAlignmentGoodEvil(oEntering) == ALIGNMENT_EVIL)
    {
        DelayCommand(
            4.0,
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH),
                                                  EffectDeath()),
                                oEntering));
    }
}

void main()
{
    object oPC = GetEnteringObject();

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_DISPEL),
        oPC);

    effect eEffect = GetFirstEffect(oPC);

    while (GetIsEffectValid(eEffect))
    {
        RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }
}

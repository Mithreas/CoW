void main()
{
    DelayCommand(0.5,  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_SPARKS_PARRY), OBJECT_SELF));
    DelayCommand(0.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_SPARKS_PARRY), OBJECT_SELF));
}

void main()
{
    ApplyEffectAtLocation(
                    DURATION_TYPE_TEMPORARY,
                    EffectVisualEffect(VFX_DUR_WEB_MASS),
                    GetLocation(OBJECT_SELF),
                    3600.0 * 24); // 24 hours

    DestroyObject(OBJECT_SELF);
}

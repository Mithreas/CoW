void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_null", GetLocation(OBJECT_SELF));
    int nEffect    = GetLocalInt(OBJECT_SELF, "GS_EFFECT");

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(
            EffectVisualEffect(nEffect)),
        oObject);

    DestroyObject(OBJECT_SELF);
}

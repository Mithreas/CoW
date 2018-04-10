const string GS_TEMPLATE_TABLE = "gs_placeable401";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_TABLE,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject))
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR)),
                            oObject);

    DestroyObject(OBJECT_SELF);
}

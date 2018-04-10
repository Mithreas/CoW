const string GS_TEMPLATE_STATUE = "gs_placeable217";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_STATUE,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject))
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_STONESKIN)),
                            oObject);

    DestroyObject(OBJECT_SELF);
}

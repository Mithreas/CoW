const string GS_TEMPLATE_PANEL = "gs_placeable176";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
	
	string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
	if (sTemplate == "") sTemplate = GS_TEMPLATE_PANEL;

    object oObject = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  sTemplate,
                                  GetLocation(OBJECT_SELF));

    if (GetIsObjectValid(oObject))
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_BARKSKIN)),
                            oObject);

    DestroyObject(OBJECT_SELF);
}

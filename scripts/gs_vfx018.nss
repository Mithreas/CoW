void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(
                            EffectLinkEffects(
                                EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),
                                EffectCutsceneParalyze())),
                        OBJECT_SELF);
    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    SetPlotFlag(OBJECT_SELF, TRUE);
    SetLocalInt(OBJECT_SELF, "INANIMATE_OBJECT", 1);
}

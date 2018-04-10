void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectCutsceneParalyze()),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectCutsceneGhost()),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)),
                        OBJECT_SELF);

    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    SetLocalInt(OBJECT_SELF, "INANIMATE_OBJECT", 1);
}

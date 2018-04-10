void main()
{
    SetIsDestroyable(FALSE, FALSE, FALSE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), OBJECT_SELF);
    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    SetPlotFlag(OBJECT_SELF, TRUE);
}

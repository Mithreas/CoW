void _Petrify()
{
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT,
    //                    ExtraordinaryEffect(EffectPetrify()),
    //                    OBJECT_SELF);
    effect eStone = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_STONESKIN));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStone, OBJECT_SELF);

    AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE, 500.0, 99999999999.0));
    effect eParalyse = SupernaturalEffect(EffectCutsceneParalyze());
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalyse, OBJECT_SELF));

    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    SetPlotFlag(OBJECT_SELF, TRUE);
    SetLocalInt(OBJECT_SELF, "INANIMATE_OBJECT", 1);
}

void main()
{
    DelayCommand(2.0, _Petrify());
}

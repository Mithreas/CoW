void main()
{
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                          EffectAreaOfEffect(AOE_MOB_TYRANT_FOG,"nw_s1_stink_a"),
                          GetLocation(OBJECT_SELF),
                          RoundsToSeconds(2));

    ExecuteScript("gs_ai_death", OBJECT_SELF);
}

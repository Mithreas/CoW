void main()
{
 ExecuteScript("gs_ai_spawn", OBJECT_SELF);

 effect eSleep = EffectSleep();
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eSleep,OBJECT_SELF);
}

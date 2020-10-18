// Called as the heartbeat script on custom delayed attack AOEs. 
void main()
{
  object oCaster = GetAreaOfEffectCreator();

  if (!GetIsObjectValid(oCaster))
  {
      WriteTimestampedLogEntry("Creator not found for custom attack");
      return;
  }

  int nType = GetLocalInt(oCaster, "DAMAGE_TYPE");
  DeleteLocalInt(oCaster, "DAMAGE_TYPE");
  if (!nType) nType = DAMAGE_TYPE_NEGATIVE;

  int nVFX = GetLocalInt(oCaster, "VFX_IMP");
  DeleteLocalInt(oCaster, "VFX_IMP");
  if (!nVFX) nVFX = VFX_IMP_NEGATIVE_ENERGY;

  effect eDamage = EffectLinkEffects (EffectVisualEffect(nVFX), EffectDamage(d6(GetHitDice(oCaster)), nType));

  object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);

  while (GetIsObjectValid(oTarget))
  {
    if (GetIsReactionTypeHostile(oTarget, oCaster)) ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
  }
}
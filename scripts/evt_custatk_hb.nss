// Called as the heartbeat script on custom delayed attack AOEs. 
void main()
{
  object oCaster = GetAreaOfEffectCreator();

  if (!GetIsObjectValid(oCaster))
  {
      WriteTimestampedLogEntry("Creator not found for custom attack");
      return;
  }
  
  int bArea = (GetTag(oCaster) == "example_hostile_all"); // See a_enter
  
  int nType = GetLocalInt(oCaster, "DAMAGE_TYPE");
  DeleteLocalInt(oCaster, "DAMAGE_TYPE");
  if (!nType) nType = DAMAGE_TYPE_NEGATIVE;

  int nVFX = GetLocalInt(oCaster, "VFX_IMP");
  DeleteLocalInt(oCaster, "VFX_IMP");
  if (!nVFX) nVFX = VFX_IMP_NEGATIVE_ENERGY;
  
  // Clear the flag so they can attack again.
  DeleteLocalInt(oCaster, "TELEGRAPHED");
  effect eDamage;
  object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);

  while (GetIsObjectValid(oTarget))
  {
    if (bArea)
	{
	  eDamage = EffectLinkEffects (EffectVisualEffect(nVFX), EffectDamage(d6(GetHitDice(oTarget)), nType));
	  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	}  
	else if (!GetIsDead(oCaster) && GetIsReactionTypeHostile(oTarget, oCaster))
	{
	  eDamage = EffectLinkEffects (EffectVisualEffect(nVFX), EffectDamage(d6(GetHitDice(oCaster)), nType));
	  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	}
    oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
  }
}
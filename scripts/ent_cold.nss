// Entry script for a cold zone that damages you every turn you remain in it.
// Pair with ext_cold.
void DoColdDamage(object oEntering)
{
  if (!GetLocalInt(oEntering, "COLD")) return;
  
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(1), DAMAGE_TYPE_COLD), oEntering);

  DelayCommand(6.0f, DoColdDamage(oEntering));
}

void main()
{
  object oEntering = GetEnteringObject();
  
  SetLocalInt(oEntering, "COLD", TRUE);
  DoColdDamage(oEntering);
}
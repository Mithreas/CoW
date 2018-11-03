void _doHeartbeat(object oPC)
{
  if (GetLocalInt(oPC, "FEV_MOTHER_TREE") &&
      GetCurrentHitPoints(oPC) < GetMaxHitPoints(oPC))
  {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oPC);
    DelayCommand(1.0f, _doHeartbeat(oPC));
  }
}

void main()
{
    object oPC = GetEnteringObject();
    SetLocalInt(oPC, "FEV_MOTHER_TREE", TRUE);

    _doHeartbeat(oPC);
}

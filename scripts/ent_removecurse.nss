void main()
{
  object oEntering = GetEnteringObject();
  if (GetLocalInt(oEntering, "DOOMED"))
  {
    DeleteLocalInt(oEntering, "DOOMED");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oEntering);
	
	effect eEffect = GetFirstEffect(oEntering);
	while (GetIsEffectValid(eEffect))
	{
	  if (GetEffectCreator(eEffect) == GetLocalObject(oEntering, "DOOMER"))
	  {
	    RemoveEffect(oEntering, eEffect);
	  }
	  
	  eEffect = GetNextEffect(oEntering);
	}
  }

}

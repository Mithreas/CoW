 // Teleport oPC to the location lTarget
void teleportPC(object oPC, location lTarget);

 void main()
 {
	// Portal party and Use VFX?
	int bUseVFX    = GetLocalInt(OBJECT_SELF, "AR_USEVFX");
	int bVFXType   = GetLocalInt(OBJECT_SELF, "AR_VFX");
	int bDestroy   = GetLocalInt(OBJECT_SELF, "AR_DESTROY");
	string sTag    = GetLocalString(OBJECT_SELF, "AR_TP_LOCATION");
	object oPC     = GetPCSpeaker();

	if (!GetIsPC(oPC)) return;

	int nVFX = (bVFXType != FALSE) ? bVFXType : VFX_IMP_AC_BONUS;
	effect eVFX  = EffectVisualEffect(nVFX);

	object oWP = GetWaypointByTag(sTag);
	location lTarget = GetLocation(oWP);

	//::  Port the PC speaker as well
	if (bUseVFX) ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
	DelayCommand(1.0, teleportPC(oPC, lTarget));

	if (bDestroy)
	{
		DelayCommand(1.0, DestroyObject(OBJECT_SELF));
	}
}

void teleportPC(object oPC, location lTarget)
{
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToLocation(lTarget));
}

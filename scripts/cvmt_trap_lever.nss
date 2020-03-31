void replace (object oSparks)
{
   SetLocalInt(CreateObject(OBJECT_TYPE_PLACEABLE, d2() == 2 ? "magicred" : "magicblue", GetLocation(oSparks), FALSE, GetTag(oSparks)), "GS_STATIC", TRUE);
   DestroyObject(oSparks);
}

void main()
{
	// Play lever animation
	int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");

	if (!nActive)
	{
	  ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
	}
	else
	{
	  ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
	}
	
	// Store New State
	SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);
 
	// Find cvmt_trap_1_1 through 4_2 and randomly set their appearance to 164 (red) or 159 (blue)
    // Note - using NWNX_Object_SetAppearance won't show for a player until they re-enter so destroy and replace.
	replace(GetObjectByTag("cvmt_trap_1_1"));
	replace(GetObjectByTag("cvmt_trap_1_2"));
	replace(GetObjectByTag("cvmt_trap_2_1"));
	replace(GetObjectByTag("cvmt_trap_2_2"));
	replace(GetObjectByTag("cvmt_trap_3_1"));
	replace(GetObjectByTag("cvmt_trap_3_2"));
	replace(GetObjectByTag("cvmt_trap_4_1"));
	replace(GetObjectByTag("cvmt_trap_4_2"));
}
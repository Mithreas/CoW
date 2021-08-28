// Spell script for all shifter forms that aren't polymorph based.
// Covers race changes and gender swaps.
#include "inc_shapechanger"
#include "inc_state"
#include "nwnx_creature"
void main()
{
	int nSpellId = GetSpellId();
	object oPC   = OBJECT_SELF;
	
	// This feat conflicts with Hybrid Form for shapeshifters.  Don't let the PC use it if they 
	// are in hybrid form.
	if (GetLocalInt(gsPCGetCreatureHide(oPC), VAR_CURRENT_FORM) == 1)
	{
	  SendMessageToPC(oPC, "You cannot use this ability while in hybrid form.");
	  return;
	}
	
	if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC, TRUE))
	{
		SendMessageToPC(oPC, "You cannot use this ability while polymorphed.");
		return;
	}
	
  
    int nTimeout = GetLocalInt(OBJECT_SELF, "WATER_TIMEOUT");
	if (GetIsPC(OBJECT_SELF) && gsTIGetActualTimestamp() > nTimeout)
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 8.0);
	  SetLocalInt(OBJECT_SELF, "WATER_TIMEOUT", gsTIGetActualTimestamp() + 15*60);
	}  
  
	if (nSpellId == 856)
	{
		// Swap gender.
		NWNX_Creature_SetGender(oPC, !GetGender(oPC));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
		gsSTDoCasterDamage(oPC, 5);
	
		return;
	}
  
	// Race change.
	int nRacialType;
	int nAppearanceType;
  
	switch (nSpellId)
	{
		case 849: // Elf
			nRacialType = 1;
			nAppearanceType = 1;
			break;
		case 850: // Human
			nRacialType = 6;
			nAppearanceType = 6;
			break;
		case 851: // Halfling
			nRacialType = 3;
			nAppearanceType = 3;
			break;
		case 852: // Monstrous
			nRacialType = 13;
			nAppearanceType = 5;
			break;
	}

	if (nRacialType && nAppearanceType && GetRacialType(oPC) != nRacialType)
	{  
		SetCreatureAppearanceType(oPC, nAppearanceType);
		NWNX_Creature_SetRacialType(oPC, nRacialType);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
		gsSTDoCasterDamage(oPC, 5);
	}
}
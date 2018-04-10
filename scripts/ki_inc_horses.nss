//::///////////////////////////////////////////////
//:: ki_inc_horses
//:: Library: Additional Horse Functions
//:://////////////////////////////////////////////
/*
    Library with additional horse functions for Arelith
	
	MOUNTED_WEAPON Variable 1 = Mounted Only, 2 = Foot only
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: October 19, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_effecttags"
#include "inc_effect"
#include "x2_inc_itemprop"
#include "gs_inc_common"
#include "gs_inc_state"

//:: Public Function Declarations

//Get Ride rank
int kiGetRideRank(object oPC, int bInclBaseDex = FALSE, int bInclEquip = FALSE);
//Modify AC gained from tumble when mounted
void kiSetHorseTumbleAC(object oPC);
//Mounted Spell Failure
void kiSetHorseSpellFailure(object oPC, object oHorse);
//Mounted Combat AC bonus
void kiSetMountedCombatAC(object oPC);
//Mounted Combat AB bonus
void kiSetMountedAB(object oPC);
//Remove AC penalty from mounted
void kiRemoveHorseAC(object oPC);
//Mounted-Only Weapon Check
void ki_MountedWeapon(object oWeapon, object oPC);
//Dismounted-Only Weapon Check
void ki_DismountedWeapon(object oWeapon, object oPC);
//Arelith Mount Functions Wrapper
void ki_Wrapr_Mount(object oPC, object oHorse = OBJECT_INVALID);
//Arelith Dismount Functions Wrapper
void ki_Wrapr_Dismount(object oPC, object oHorse = OBJECT_INVALID);
//Duplicate Code for unequipping items... prevents circle dependancies
void kiUnequipItem(object oItem);
//get ride bonus from horse breed
int kiBreedRideBonus(object oPC, object oHorse);
//get ride penalty from sobriety
int kiDrunkRideBonus(object oPC);
//get ride bonus from combat
int kiCombatRideBonus(object oPC, object oHorse, int bCombat);
//get speed from breed
int kiBreedSpeed(object oPC, object oHorse);

//:: Function Declarations

//Get Ride rank & modify by horse gift
int kiGetRideRank(object oPC, int bInclBaseDex = FALSE, int bInclEquip = FALSE)
{
	int nRideRank = GetSkillRank(SKILL_RIDE, oPC, TRUE);
	
	if (GetLocalInt(gsPCGetCreatureHide(oPC), "MAY_RIDE_HORSE"))
	{
		      if (GetCharacterLevel(oPC) + 5 > nRideRank)
			         nRideRank = GetCharacterLevel(oPC) + 5;
	}
	
	   int nRide = nRideRank;

	if (bInclBaseDex)
	{
		int nDexBonus = (GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) - 10)/2;
		nRide += nDexBonus;
	}
	
	if (bInclEquip)
	{
		int nTotalRideRank = GetSkillRank(SKILL_RIDE, oPC, FALSE);
			  if (GetLocalInt(gsPCGetCreatureHide(oPC), "MAY_RIDE_HORSE"))
				  nTotalRideRank = nTotalRideRank + nRideRank - GetSkillRank(SKILL_RIDE, oPC, TRUE);

		int nTotalDexBonus = (GetAbilityScore(oPC,ABILITY_DEXTERITY,FALSE) - 10)/2;
		int nEquip = nTotalRideRank - nRideRank - nTotalDexBonus;
		nRide += nEquip;
	}
	
	return nRide;
}

//Modify AC gained from tumble when mounted
void kiSetHorseTumbleAC(object oPC)
{
	int nTumbleAC = GetSkillRank(SKILL_TUMBLE, oPC, TRUE) / 5;
	int nRideAC = kiGetRideRank(oPC) / 5;
	if (nTumbleAC > nRideAC)
	{
		int nAC = nTumbleAC - nRideAC;
		ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACDecrease(nAC)), oPC, 0.0, EFFECT_TAG_MOUNTED);
	}
}

//Mounted Spell Failure
void kiSetHorseSpellFailure(object oPC, object oHorse)
{
	//remove current effect
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		if ((GetIsTaggedEffect(eEffect, EFFECT_TAG_MOUNTED) && GetEffectType(eEffect) == EFFECT_TYPE_SPELL_FAILURE))
		{
			RemoveEffect(oPC, eEffect);
		}
		eEffect = GetNextEffect(oPC);
	}
	
	// Also add SF
	if (!(GetHasFeat(FEAT_MOUNTED_COMBAT, oPC) || GetLocalInt(oHorse, "BREED") == 3)
			&& GetLocalInt(gsPCGetCreatureHide(oPC), "Mounted") >= 1 )
	{
		ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellFailure(10)), oPC, 0.0, EFFECT_TAG_MOUNTED);
	}
}

//Mounted Combat AC bonus
void kiSetMountedCombatAC(object oPC)
{
	if (FALSE)
	{
		if  (GetHasFeat(FEAT_MOUNTED_COMBAT, oPC))
		{
			int nAC = kiGetRideRank(oPC) / 5;
			if (nAC > 6)
			{
				nAC = 6;
			}
			ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nAC)), oPC, 0.0, EFFECT_TAG_MOUNTED);
		}
	}
}

//Mounted Combat AB bonus
void kiSetMountedAB(object oPC)
{
	//remove current effect
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		if (GetIsTaggedEffect(eEffect, EFFECT_TAG_MOUNTED) && GetEffectType(eEffect) == EFFECT_TYPE_ATTACK_INCREASE)
		{
			RemoveEffect(oPC, eEffect);
		}
		eEffect = GetNextEffect(oPC);
	}
	
	//Apply effect if melee weapon
	if  (GetHasFeat(FEAT_MOUNTED_COMBAT, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "Mounted") >= 1 
											  && IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
	{
		      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(1)), oPC, 0.0, EFFECT_TAG_MOUNTED);
	}
	
	//Apply effect if ranged weapon
	else if  (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "Mounted") == 1 
													&& GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
	{
		      int nAB = 2; //Gives +0 ranged bonus overall - counters the -2 already given by feat.
		ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nAB)), oPC, 0.0, EFFECT_TAG_MOUNTED);
	}
}


//Remove AC changes from mounted
void kiRemoveHorseAC(object oPC)
{
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		if (GetIsTaggedEffect(eEffect, EFFECT_TAG_MOUNTED) && 
				(GetEffectType(eEffect) == EFFECT_TYPE_AC_DECREASE || GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE)
			)
		{
			RemoveEffect(oPC, eEffect);
		}
		eEffect = GetNextEffect(oPC);
	}
}

//Mounted-Only Weapon Check
void ki_MountedWeapon(object oWeapon, object oPC)
{
	if (GetLocalInt(gsPCGetCreatureHide(oPC), "Mounted") == 0 && GetLocalInt(oWeapon, "MOUNTED_WEAPON") == 1)
	{
		SendMessageToPC(oPC, "This weapon can only be used whilst mounted");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 0.75);
		DelayCommand(0.5, AssignCommand(oPC, kiUnequipItem(oWeapon)));
	}
}

//Dismounted-Only Weapon Check
void ki_DismountedWeapon(object oWeapon, object oPC)
{
	if (GetLocalInt(gsPCGetCreatureHide(oPC), "Mounted") >= 1 && GetLocalInt(oWeapon, "MOUNTED_WEAPON") == 2)
	{
		SendMessageToPC(oPC, "This weapon can only be used whilst mounted");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 0.75);
		DelayCommand(0.5, AssignCommand(oPC, kiUnequipItem(oWeapon)));
	}
}

//Arelith Mount Functions Wrapper
// need to do something for instant mount
void ki_Wrapr_Mount(object oPC, object oHorse = OBJECT_INVALID)
{
	kiSetHorseTumbleAC(oPC);
	kiSetMountedCombatAC(oPC);
	kiSetMountedAB(oPC);
	kiSetHorseSpellFailure(oPC, oHorse);
	ki_DismountedWeapon( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), oPC );
	ki_DismountedWeapon( GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), oPC );
}
//Arelith Dismount Functions Wrapper
void ki_Wrapr_Dismount(object oPC, object oHorse = OBJECT_INVALID)
{
	kiRemoveHorseAC(oPC);
	kiSetMountedAB(oPC);
	kiSetHorseSpellFailure(oPC, oHorse);
	ki_MountedWeapon( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), oPC );
	ki_MountedWeapon( GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), oPC );
}

//Duplicate Code for unequipping items... prevents circle dependancies
void kiUnequipItem(object oItem)
{
    if (GetHasSpellEffect(SPELL_CHARM_MONSTER) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL) ||
        GetHasSpellEffect(SPELL_MASS_CHARM))
    {
      // We get item duplication if we allow this.  Since charmed folks can't
      // do much, let them equip the item.
      return;
    }
    gsCMCopyItem(oItem, OBJECT_SELF, TRUE);
    DestroyObject(oItem);
}

//get ride bonus from horse breed
int kiBreedRideBonus(object oPC, object oHorse)
{
	int nHorseType = GetLocalInt(oHorse, "BREED");
	
	if (nHorseType < 0)
	{
		nHorseType = 0;
	}
	
	int nBonus = 0;
	
	switch(nHorseType)
	{
		case 0: //default horses
		{
			break;
		}
		case 1: //normal horses
		case 2: //pack horses
		{
			nBonus = 10;
			break;
		}
		case 3: //arcane horses
		{
			if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) >= 1 || GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 1)
			{
				nBonus = 5;
			}
			else
			{
				nBonus = -5;
			}
			break;
		}
		case 4: //elven horses
		{
			if (GetRacialType(oPC) == RACIAL_TYPE_ELF)
			{
				nBonus = 5;
			}
			else if (GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
			{
				nBonus = 0;
			}
			else if (GetRacialType(oPC) == RACIAL_TYPE_HALFORC)
			{
				nBonus = -15;
			}
			else
			{
				nBonus = -10;
			}
			break;
		}
		case 5: // wild horses
		{
			int nAnimalEmpathy = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC);
			nBonus = -15 + nAnimalEmpathy;
			break;
		}
		case 6: // destriers
		case 7: // war horses
		{
			nBonus = 5;
			break;
		}
		case 8: // nightmares
		case 9: // shadow steeds
		{
			nBonus = 0;
			break;
		}
	}
	return nBonus;
}

//get ride penalty from sobriety
int kiDrunkRideBonus(object oPC)
{
	int nBonus = 0;
	float fSober = gsSTGetState(GS_ST_SOBRIETY, oPC);
	if (fSober < 0.0)
	{
		nBonus = FloatToInt(fSober)/5;
	}
	return nBonus;
}

//get ride bonus from combat
int kiCombatRideBonus(object oPC, object oHorse, int bCombat)
{
	int nBonus = 0;
	
	if (!bCombat)
	{
		return nBonus;
	}
	
	int nHorseType = GetLocalInt(oHorse, "BREED");
	
	if (nHorseType < 0)
	{
		nHorseType = 0;
	}
	
	switch(nHorseType)
	{
		case 0: //default horses
		case 1: //normal horses
		case 2: //pack horses
		{
			nBonus = -15;
			break;
		}
		case 3: //arcane horses
		case 4: //elven horses
		case 5: // wild horses
		{
			nBonus = -5;
			break;
		}
		case 6: // destriers
		{
			nBonus = 10;
			break;
		}
		case 7: // war horses
		{
			nBonus = 5;
			break;
		}
		case 8: // nightmares
		case 9: // shadow steeds
		{
			nBonus = 0;
			break;
		}
	}
	return nBonus;
}

//get speed from breed
int kiBreedSpeed(object oPC, object oHorse)
{
	int nSpeed = 0;

	int nHorseType = GetLocalInt(oHorse, "BREED");
	
	if (nHorseType < 0)
	{
		nHorseType = 0;
	}
	
	switch(nHorseType)
	{
		case 0: //default horses
		case 1: //normal horses
		case 3: //arcane horses
		{
			nSpeed = 10;
			break;
		}
		case 2: //pack horses
		{
			nSpeed = 5;
			break;
		}
		case 6: // destriers
		case 7: // war horses
		case 8: // nightmares
		case 9: // shadow steeds
		{
			nSpeed = 15;
			break;
		}
		case 4: //elven horses
		{
			nSpeed = 20;
			break;
		}
		case 5: // wild horses
		{
			nSpeed = 30;
			break;
		}
	}
	return nSpeed;
}
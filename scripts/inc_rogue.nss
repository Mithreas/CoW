//::///////////////////////////////////////////////
//:: inc_rogue
//:: Library: Rogue
//:://////////////////////////////////////////////

#include "inc_effect"
#include "inc_generic"

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Internal: Return whether a weapon is a rogue weapon
int _IsRogueWeapon(object oWeapon);

// If a PC is wearing light armor, update the bonus AC rogues get for exceeding the max armor dex bonus.
void RogueUpdateLightArmorAC(object oPC);

// Add the move speed bonus for rogues in stealth.
void RogueEnterStealth(object oPC);

// Remove the move speed bonus for rogues in stealth.  Add AB bonus.
void RogueExitStealth(object oPC);

// Periodic heartbeat while rogue is in stealth.
void RogueStealthHB(object oPC);

// Remove rogue equipment bonuses
void RogueRemoveGearBonus(object oItem);

// Apply rogue equipment bonuses
void RogueGearBonus(object oItem);

// Apply rogue bonus feats
void RogueFeatBonus(object oPC);

// Apply rogue bonus skills
void RogueSkillBonus(object oPC);

// Apply rogue bonus HP
void RogueBonusHP(object oPC, int bLevelUp = TRUE);
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
int _IsRogueWeapon(object oWeapon)
{
    // We're purposefully excluding Quarterstaff
    int nBaseType = GetBaseItemType(oWeapon);
    if (nBaseType == BASE_ITEM_RAPIER ||
        nBaseType == BASE_ITEM_DAGGER ||
        nBaseType == BASE_ITEM_CLUB ||
        nBaseType == BASE_ITEM_HANDAXE ||
        nBaseType == BASE_ITEM_MORNINGSTAR ||
        nBaseType == BASE_ITEM_LIGHTCROSSBOW ||
        nBaseType == BASE_ITEM_HEAVYCROSSBOW ||
        nBaseType == BASE_ITEM_LIGHTMACE ||
        nBaseType == BASE_ITEM_SHORTBOW ||
        nBaseType == BASE_ITEM_SLING ||
		nBaseType == BASE_ITEM_SHORTSWORD ||
        nBaseType == BASE_ITEM_DART)
    	{
        return TRUE;
    	}

    return FALSE;
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// If a PC is wearing light armor, update the bonus AC rogues get for exceeding the max armor dex bonus.
void RogueUpdateLightArmorAC(object oPC)
{
    // Remove any effect tagged 'Rogue' that is also an AC increase.
    effect eEffect = GetFirstEffect(oPC);

    while (GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_ROGUE) && GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE) {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
	}

    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    if (!nRogueLevels) return;

    // Check to see if the rogue is wearing light armor
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    // Not Wearing Anything!
    if (!GetIsObjectValid(oItem))
        return;

    // Silly workaround to test armor type
    // Unidentify then check item base value

    int bID = GetIdentified(oItem);

    SetIdentified(oItem, FALSE);

    int nBaseAC = 0;

    switch (GetGoldPieceValue(oItem)) {
		case 1:    nBaseAC = 0; break;  // Cloth
        case 5:    nBaseAC = 1; break;  // Padded
        case 10:   nBaseAC = 2; break;  // Leather
        case 15:   nBaseAC = 3; break;  // Studded Leather / Hide
        case 100:  nBaseAC = 4; break;  // Chain Shirt / Scale Mail
        case 150:  nBaseAC = 5; break;  // Chainmail / Breastplate
        case 200:  nBaseAC = 6; break;  // Splint Mail / Banded Mail
        case 600:  nBaseAC = 7; break;  // Half Plate
        case 1500: nBaseAC = 8; break;  // Full Plate
    }

    SetIdentified(oItem, bID);

    if (nBaseAC > 3) return; // Not wearing light armor.
	if (nBaseAC < 1) return; // Cloth

    int nMax; // Calculate max dex bonus on armor
    if (nBaseAC == 3) nMax = 4;
    if (nBaseAC == 2) nMax = 6;
    if (nBaseAC == 1) nMax = 8;

    int nExceed = GetAbilityModifier(ABILITY_DEXTERITY, oPC) - nMax;
    if (nExceed > nRogueLevels / 3) nExceed = nRogueLevels / 3;
    if (nExceed < 1) return; // Not exceeding light armor limits, or insufficient rogue levels.

    effect eBuff = EffectACIncrease(nExceed);
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eBuff), oPC, 0.0, EFFECT_TAG_ROGUE);
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Add the move speed bonus for rogues in stealth.
void RogueEnterStealth(object oPC)
{

    // Remove any effect tagged 'Rogue' that is also a move speed increase
    effect eEffect = GetFirstEffect(oPC);

    while (GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_ROGUE) && GetEffectType(eEffect) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
	}

    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    if (!nRogueLevels || nRogueLevels < 16) return;

    int nIncrease = 10;
    if (nRogueLevels >= 24) nIncrease = 50;
    else if (nRogueLevels >= 22) nIncrease = 40;
    else if (nRogueLevels >= 20) nIncrease = 30;
    else if (nRogueLevels >= 18) nIncrease = 20;
    else if (nRogueLevels >= 16) nIncrease = 10;

    if (GetLevelByClass(CLASS_TYPE_ROGUE, oPC)) nIncrease -= 10;
    if (!nIncrease) return;

    effect eBuff = EffectMovementSpeedIncrease(nIncrease);
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eBuff), oPC, 0.0, EFFECT_TAG_ROGUE);

    // Timestamp to avoid multiple heartbeats.
    int nTime = GetModuleTime();
    if (nTime - GetLocalInt(oPC, "ROGUE_STEALTH_HB") < 5) return;
    SetLocalInt(oPC, "ROGUE_STEALTH_HB", nTime);
    DelayCommand(6.0, RogueStealthHB(oPC)); // Schedule heartbeat check.
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Remove the move speed bonus for rogues in stealth.  Add AB bonus.
void RogueExitStealth(object oPC)
{

    // Remove any effect tagged 'Rogue' that is also a move speed increase
    effect eEffect = GetFirstEffect(oPC);

    while (GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_ROGUE) && GetEffectType(eEffect) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    	}

    int nTime = GetModuleTime();

    if (nTime - GetLocalInt(oPC, "ROGUE_STEALTH_AB") < 30) {
        SetLocalInt(oPC, "ROGUE_STEALTH_AB", nTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(1)), oPC, RoundsToSeconds(1));
    	}
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Periodic heartbeat while rogue is in stealth.
void RogueStealthHB(object oPC)
{
    // PC no longer valid since last HB.
    if (!GetIsObjectValid(oPC)) return;

    int nTime = GetModuleTime();

    if (!GetActionMode(oPC, ACTION_MODE_STEALTH)) {  // We've exited stealth since the last check.

	       // Remove any effect tagged 'Rogue' that is also a move speed increase
        effect eEffect = GetFirstEffect(oPC);
        while (GetIsEffectValid(eEffect))
        		{
            if (GetIsTaggedEffect(eEffect, EFFECT_TAG_ROGUE) && GetEffectType(eEffect) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) {
                RemoveEffect(oPC, eEffect);
            			}
            eEffect = GetNextEffect(oPC);
        		}

        if (nTime - GetLocalInt(oPC, "ROGUE_STEALTH_AB") < 30) {
            SetLocalInt(oPC, "ROGUE_STEALTH_AB", nTime);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(1)), oPC, RoundsToSeconds(1));
        		}
    	} else {
		      // Timestamp to avoid multiple heartbeats.
		      if (nTime - GetLocalInt(oPC, "ROGUE_STEALTH_HB") < 5) return;
		      SetLocalInt(oPC, "ROGUE_STEALTH_HB", nTime);
		      DelayCommand(6.0, RogueStealthHB(oPC));  // Still in stealth, schedule another HB.
    	}
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Remove rogue equipment bonuses
void RogueRemoveGearBonus(object oItem)
{
    if(!GetIsObjectValid(oItem) || !GetIsPC(GetItemPossessor(oItem)) || GetIsDM(GetItemPossessor(oItem))) return;

    object oPC = GetItemPossessor(oItem);
    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);

    int nBonus;
    if (nRogueLevels >= 24) nBonus = 2;
    else if (nRogueLevels >= 19) nBonus = 1;
    else return;

    if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_WEAPON) {
        RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY, ITEM_PROPERTY_SUBTYPE_UNDEFINED,
									 GetItemPropertyStackedValue(oItem, ItemPropertyAttackBonus(nBonus)));
    	} else if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_AMMUNITION) {
		      RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, GetMatchingIPDamageType(oItem),
									 GetItemPropertyStackedValue(oItem, ItemPropertyDamageBonus(GetMatchingIPDamageType(oItem), nBonus)));
    	}
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Apply rogue equipment bonuses
void RogueGearBonus(object oItem)
{
	if(!GetIsObjectValid(oItem) || !GetIsPC(GetItemPossessor(oItem)) || GetIsDM(GetItemPossessor(oItem))) return;

    object oPC = GetItemPossessor(oItem);
    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);

    int nBonus;
    if (nRogueLevels >= 24) nBonus = 2;
    else if (nRogueLevels >= 19) nBonus = 1;
    else return;

    if (!_IsRogueWeapon(oItem)) return;

    // Clear out any old rogue bonuses first.
    if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_WEAPON) {
        RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY, ITEM_PROPERTY_SUBTYPE_UNDEFINED,
									 GetItemPropertyStackedValue(oItem, ItemPropertyAttackBonus(nBonus)));
    	} else if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_AMMUNITION) {
        RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, GetMatchingIPDamageType(oItem),
									 GetItemPropertyStackedValue(oItem, ItemPropertyDamageBonus(GetMatchingIPDamageType(oItem), nBonus)));
    	}

    if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_WEAPON) {
        AddStackingItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nBonus), oItem, 72000.0f);
    	} else if (GetEquipmentType(oItem) == EQUIPMENT_TYPE_AMMUNITION) {
        AddStackingItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(GetMatchingIPDamageType(oItem), nBonus), oItem, 72000.0f);
    	}
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Apply rogue bonus feats
void RogueFeatBonus(object oPC)
{
    int nRogueLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);

    if (nRogueLevel >= 2 && !GetKnowsFeat(FEAT_WEAPON_FINESSE, oPC))
        AddKnownFeat(oPC, FEAT_WEAPON_FINESSE, GetLevelByClassLevel(oPC, CLASS_TYPE_ROGUE, 2));

    if (nRogueLevel >= 10 && !GetKnowsFeat(FEAT_KEEN_SENSE, oPC))
        AddKnownFeat(oPC, FEAT_KEEN_SENSE, GetLevelByClassLevel(oPC, CLASS_TYPE_ROGUE, 10));


    // Sword & Dagger Feats
    int bSmall = FALSE;
    if (GetCreatureSize(oPC) < 3) bSmall = TRUE;

    if (nRogueLevel >= 10 && GetKnowsFeat(FEAT_AMBIDEXTERITY, oPC) && !bSmall) {
        // Rapier -> Dagger
        if (GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER, oPC) && !GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_SPECIALIZATION_DAGGER, GetKnownFeatLevel(oPC, FEAT_WEAPON_SPECIALIZATION_RAPIER));

        if (GetKnowsFeat(FEAT_WEAPON_FOCUS_RAPIER, oPC) && !GetKnowsFeat(FEAT_WEAPON_FOCUS_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_FOCUS_DAGGER, GetKnownFeatLevel(oPC, FEAT_WEAPON_FOCUS_RAPIER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_RAPIER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_DAGGER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_FOCUS_RAPIER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER));

        if (GetKnowsFeat(FEAT_IMPROVED_CRITICAL_RAPIER, oPC) && !GetKnowsFeat(FEAT_IMPROVED_CRITICAL_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_IMPROVED_CRITICAL_DAGGER, GetKnownFeatLevel(oPC, FEAT_IMPROVED_CRITICAL_RAPIER));


        // Dagger -> Rapier
        if (GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER, oPC) && !GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_SPECIALIZATION_RAPIER, GetKnownFeatLevel(oPC, FEAT_WEAPON_SPECIALIZATION_DAGGER));

        if (GetKnowsFeat(FEAT_WEAPON_FOCUS_DAGGER, oPC) && !GetKnowsFeat(FEAT_WEAPON_FOCUS_RAPIER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_FOCUS_RAPIER, GetKnownFeatLevel(oPC, FEAT_WEAPON_FOCUS_DAGGER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_RAPIER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_RAPIER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_FOCUS_DAGGER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER));

        if (GetKnowsFeat(FEAT_IMPROVED_CRITICAL_DAGGER, oPC) && !GetKnowsFeat(FEAT_IMPROVED_CRITICAL_RAPIER, oPC))
            AddKnownFeat(oPC, FEAT_IMPROVED_CRITICAL_RAPIER, GetKnownFeatLevel(oPC, FEAT_IMPROVED_CRITICAL_DAGGER));

    	} else if (nRogueLevel >= 10 && GetKnowsFeat(FEAT_AMBIDEXTERITY, oPC) && bSmall) {

        // Shortsword -> Dagger
        if (GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, oPC) && !GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_SPECIALIZATION_DAGGER, GetKnownFeatLevel(oPC, FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD));

        if (GetKnowsFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD, oPC) && !GetKnowsFeat(FEAT_WEAPON_FOCUS_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_FOCUS_DAGGER, GetKnownFeatLevel(oPC, FEAT_WEAPON_FOCUS_SHORT_SWORD));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_DAGGER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD));

        if (GetKnowsFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD, oPC) && !GetKnowsFeat(FEAT_IMPROVED_CRITICAL_DAGGER, oPC))
            AddKnownFeat(oPC, FEAT_IMPROVED_CRITICAL_DAGGER, GetKnownFeatLevel(oPC, FEAT_IMPROVED_CRITICAL_SHORT_SWORD));

        // Dagger -> Shortsword
        if (GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER, oPC) && !GetKnowsFeat(FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, GetKnownFeatLevel(oPC, FEAT_WEAPON_SPECIALIZATION_DAGGER));

        if (GetKnowsFeat(FEAT_WEAPON_FOCUS_DAGGER, oPC) && !GetKnowsFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD, oPC))
            AddKnownFeat(oPC, FEAT_WEAPON_FOCUS_SHORT_SWORD, GetKnownFeatLevel(oPC, FEAT_WEAPON_FOCUS_DAGGER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_FOCUS_DAGGER));

        if (GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER, oPC) && !GetKnowsFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD, oPC))
            AddKnownFeat(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD, GetKnownFeatLevel(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER));

        if (GetKnowsFeat(FEAT_IMPROVED_CRITICAL_DAGGER, oPC) && !GetKnowsFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD, oPC))
            AddKnownFeat(oPC, FEAT_IMPROVED_CRITICAL_SHORT_SWORD, GetKnownFeatLevel(oPC, FEAT_IMPROVED_CRITICAL_DAGGER));
    	}
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Apply rogue skill bonus
void RogueSkillBonus(object oPC)
{
    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);


    // Remove any effect tagged 'Rogue' that is also  permanent skill increase.
    effect eEffect = GetFirstEffect(oPC);

    while (GetIsEffectValid(eEffect))
    {
        if (GetIsTaggedEffect(eEffect, EFFECT_TAG_ROGUE) && GetEffectType(eEffect) == EFFECT_TYPE_SKILL_INCREASE && GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT) {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    	}

	   /* Rogue 10:  Keen Senses feat.  If the rogue already has this feat, the rogue instead gets a cumulative +2 Spot and Listen.
       	Rogue 14:  +5 to Spot and Listen
       	Rogue 24:  +10 to Spot and Listen (replaces Rogue 14 bonus) */

    if (nRogueLevels < 10) return;

    int nAmount;
    if (nRogueLevels >= 24) nAmount = 10;
    else if (nRogueLevels >= 14) nAmount = 5;
    if (GetRacialType(oPC) == RACIAL_TYPE_ELF) nAmount += 2;

    if (nAmount <= 0) return;

    effect eBuff = EffectSkillIncrease(SKILL_SPOT, nAmount);
    eBuff = EffectLinkEffects(eBuff, EffectSkillIncrease(SKILL_LISTEN, nAmount));
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eBuff), oPC, 0.0, EFFECT_TAG_ROGUE);
}
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Apply rogue bonus HP
void RogueBonusHP(object oPC, int bLevelUp = TRUE)
{
    // Arelith:  d6 -> d8 HP dice for rogues.
    int nHD   = GetHitDice(oPC);
    int nRogueLevels = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    if (!nRogueLevels) return;

    if (bLevelUp && NWNX_Creature_GetClassByLevel(oPC, nHD) != CLASS_TYPE_ROGUE) return;

    // if (bLevelUp) {
        NWNX_Creature_SetMaxHitPointsByLevel(oPC, nHD, 8);
    //}
    //else
    //{
        // Go through each rogue level and adjust its HP.
        int nCount;
        for (nCount == 1; nCount < nHD; nCount++)
        {
            if (NWNX_Creature_GetClassByLevel(oPC, nCount) == CLASS_TYPE_ROGUE)
            {
                NWNX_Creature_SetMaxHitPointsByLevel(oPC, nCount, 8);
            }
        }
    //}
}

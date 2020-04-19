#include "inc_effect"
#include "inc_bonuses"
#include "inc_class"
#include "inc_favsoul"
#include "inc_warlock"
#include "x2_inc_itemprop"
#include "inc_spellsword"
#include "inc_paladin"
#include "inc_horses"

// Handle weapon-switching attack penalty
void handlePenalty(object oOldLeft, object oOldRight, object oUnequipped, object oPC);

void main()
{
    object oUnequippedBy = GetPCItemLastUnequippedBy();
    object oUnequipped   = GetPCItemLastUnequipped();

    // Tail Concealment - Unequipping a cloak reveals a tail, if the creature has one
    if (GetBaseItemType(oUnequipped) == BASE_ITEM_CLOAK &&
        GetItemAppearance(oUnequipped, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) > 0) {
      // Check for a tail
      if (GetCreatureTailType(oUnequippedBy) == 14 ||
          GetCreatureTailType(oUnequippedBy) == 0) {
        object oHide = gsPCGetCreatureHide(oUnequippedBy);
        if (oHide == OBJECT_INVALID) {
          oHide = oUnequippedBy;
        }
        int nTailModel = GetLocalInt(oHide, "CloakConcealTailModel");
        if (nTailModel > 0 && nTailModel <= 13) {
          SetCreatureTailType(nTailModel, oUnequippedBy);
        }
      }
    }

    //::   Potential exploit using Tenser's as an Imp getting the sword, just destroy it!
    if ( GetStringUpperCase(GetTag(oUnequipped)) == "NW_WSWMLS013") {
        DestroyObject(oUnequipped, 0.25);
        return;
    }

    //::  If two-handed mode is active we have to remove bonus
    //::  Have to delay so slots get cleared
    DelayCommand(0.1, DoTwoHandedBonusCheck(oUnequippedBy, oUnequipped));
    
    if (GetLevelByClass(CLASS_TYPE_FIGHTER, oUnequippedBy))
    {
      miRemoveFighterBonuses(oUnequipped);
    }

	//::Kirito-Mounted Combat
	if (IPGetIsMeleeWeapon(oUnequipped) || GetWeaponRanged(oUnequipped))
	{
		kiSetMountedAB(oUnequippedBy);
	}
	
    //::Kirito-Spellsword path
    if (miSSGetIsSpellsword(oUnequippedBy))
    {
        //Re-Applies All Spellsword Bonuses
        miSSReApplyBonuses(oUnequippedBy, FALSE);

        //removes imbue properties
        int bPropertiesRemoved  = FALSE;
        itemproperty ipLoop = GetFirstItemProperty(oUnequipped);

        while (GetIsItemPropertyValid(ipLoop))
        {
            if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_TEMPORARY)
            {
            //    if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL ||
            //        GetItemPropertyType(ipLoop) == ITEM_PROPERTY_VISUALEFFECT ||
            //        GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS
            //      )
            //    {
            //        RemoveItemProperty(oUnequipped, ipLoop);
            //        bPropertiesRemoved = TRUE;
            //    }
                if(//GetBaseItemType(oUnequipped) == BASE_ITEM_ARMOR && 
					GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
                    {
                        RemoveItemProperty(oUnequipped, ipLoop);
                    }
            }
            else if (GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)
            {
                if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL && GetBaseItemType(oUnequipped) == BASE_ITEM_ARMOR )
                {
                    RemoveItemProperty(oUnequipped, ipLoop);
                    bPropertiesRemoved = TRUE;
                }
            }
            ipLoop=GetNextItemProperty(oUnequipped);
        }
        if (bPropertiesRemoved) SendMessageToPC(oUnequippedBy, "The imbued power fades from the item.");
    }

    //::Cortex-Divine Might Check
    if (GetLevelByClass(CLASS_TYPE_PALADIN, oUnequippedBy) || GetLevelByClass(CLASS_TYPE_BLACKGUARD, oUnequippedBy))
    {
        // Re-Applies Paladin Divine Might
        palDivineMightCheck(oUnequipped, oUnequippedBy);
    }

    if (GetResRef(oUnequipped) == "x2_it_emptyskin" || GetResRef(oUnequipped) == "hide_totemdrd" ||
       (FindSubString(GetResRef(oUnequipped), "ar_it") != -1 && FindSubString(GetResRef(oUnequipped), "mon_hide") != -1) )
    {
      SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oUnequippedBy);
    }

    //::  Unpolymorph, try and restore Spellbook Data
    if ( GetBaseItemType(oUnequipped) == BASE_ITEM_CREATUREITEM ) {
        //::  Remove active Auras from Monolith Elemental Shapes Abilities
        gsSPRemoveEffect(oUnequippedBy, 761, oUnequippedBy);    //::  Hellfire Aura
        gsSPRemoveEffect(oUnequippedBy, 196, oUnequippedBy);    //::  Aura of Cold
        gsSPRemoveEffect(oUnequippedBy, 202, oUnequippedBy);    //::  Aura of Stun

        DelayCommand(2.5, RestoreSpellsAfterPolymorph(oUnequippedBy));
    }

    // Dunshine: this is not used, but was done already so let's save it in case we ever want to use it:
    /*
    // keep track of artifacts equipped
    if (GetLocalInt(oUnequippedBy, "GVD_ARTIFACTS_COUNT") != 0) {
      if ((GetLocalInt(oUnequipped, "gvd_artifact_legacy") == 1) || (GetLocalInt(oUnequipped, "gvd_artifact_legacy_confirmed") == 1)) {
        SetLocalInt(oUnequippedBy, "GVD_ARTIFACTS_COUNT", GetLocalInt(oUnequippedBy, "GVD_ARTIFACTS_COUNT") - 1);
      }
    }
    */

    if (GetIsInCombat(oUnequippedBy) && GetIsPC(oUnequippedBy))
    {
        object oOldLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUnequippedBy);
        object oOldRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUnequippedBy);
        DelayCommand(0.1, handlePenalty(oOldLeft, oOldRight, oUnequipped, oUnequippedBy));
    }
    if(GetEquipmentType(oUnequipped) == EQUIPMENT_TYPE_WEAPON)
        DelayCommand(0.0, UpdateWeaponBonuses(oUnequippedBy));
    // Toggles spell availability based on whether the PC is polymorphed.
    DelayCommand(0.0, UpdateSpontaneousSpellReadyStates(oUnequippedBy));
}

void handlePenalty(object oOldLeft, object oOldRight, object oUnequipped, object oPC)
{
    if ((GetBaseItemType(oUnequipped) == BASE_ITEM_CBLUDGWEAPON) ||
        (GetBaseItemType(oUnequipped) == BASE_ITEM_CPIERCWEAPON) ||
        (GetBaseItemType(oUnequipped) == BASE_ITEM_CREATUREITEM) ||
        (GetBaseItemType(oUnequipped) == BASE_ITEM_CSLASHWEAPON) ||
        (GetBaseItemType(oUnequipped) == BASE_ITEM_CSLSHPRCWEAP) ||
        (GetBaseItemType(oUnequipped) == BASE_ITEM_INVALID) ||
        (oUnequipped == OBJECT_INVALID))
        {
            return;
        }
    object oCurrentLeft    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    object oCurrentRight   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int bCurrentLeftIsShield = (GetBaseItemType(oCurrentLeft) == BASE_ITEM_LARGESHIELD)||
                               (GetBaseItemType(oCurrentLeft) == BASE_ITEM_SMALLSHIELD)||
                               (GetBaseItemType(oCurrentLeft) == BASE_ITEM_TOWERSHIELD);
    int bOldLeftWasShield    = (GetBaseItemType(oOldLeft) == BASE_ITEM_LARGESHIELD)||
                               (GetBaseItemType(oOldLeft) == BASE_ITEM_SMALLSHIELD)||
                               (GetBaseItemType(oOldLeft) == BASE_ITEM_TOWERSHIELD);

    if (
       (oOldLeft != oCurrentLeft && GetIsObjectValid(oCurrentLeft) && !bCurrentLeftIsShield) || (oOldRight != oCurrentRight && GetIsObjectValid(oCurrentRight) && !GetWeaponRanged(oOldRight))
       )
    {
        // Don't apply penalty if we polymorphed!
        effect eNext = GetFirstEffect(oPC);
        while (GetIsEffectValid(eNext))
        {
            if (GetEffectType(eNext) == EFFECT_TYPE_POLYMORPH)
            {
                return;
            }
            eNext = GetNextEffect(oPC);

        }
        // Switched out an off-hand weapon this round
        effect eSwitchPenalty = EffectAttackDecrease(5, ATTACK_BONUS_MISC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSwitchPenalty, oPC, 6.0);
        FloatingTextStringOnCreature("You have some difficulty sheathing one weapon and drawing a new one with one hand.", oPC, FALSE);
    }
}

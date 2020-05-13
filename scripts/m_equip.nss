#include "inc_zombie"
#include "inc_common"
#include "inc_iprop"
#include "inc_text"
#include "inc_bonuses"
#include "inc_class"
#include "inc_favsoul"
#include "inc_warlock"
#include "inc_subdual"
#include "x2_i0_spells"
#include "inc_spellsword"
#include "inc_barbarian"
#include "inc_paladin"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "ki_check_bonds"
#include "inc_horses"

void gsUnequipItem(object oItem)
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
//----------------------------------------------------------------
void spearRestrictionNotSpear(object oOldLeftHand, object oOldRightHand, object oEquipped, object oEquippedBy)
{
    // remove the item being equipped.
    // Because we did a 0.4 second delay, oNewLeftHand will be AFTER the equip has finished.
    object oNewLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEquippedBy);
    // We just stuck our equipment in the left-hand slot, the pre-condition is that the main-hand is a spear and we're not equipping a shield.
    if (oNewLeftHand == oEquipped)
    {
        DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
        FloatingTextStringOnCreature("You can only use a shield in the off-hand weapon slot when using a spear.", oEquippedBy, FALSE);
    }
}
//----------------------------------------------------------------
void main()
{
    object oEquippedBy      = GetPCItemLastEquippedBy();
    object oEquipped        = GetPCItemLastEquipped();
    itemproperty ipProperty = GetFirstItemProperty(oEquipped);
    int nType               = 0;
    int nSubType            = 0;
    int nCost               = 0;
    int nParam              = 0;
    int nDurationType       = 0;
    int bStaticLevel        = GetLocalInt(GetModule(), "STATIC_LEVEL");
    string sSubRace         = GetSubRace(oEquippedBy);
    int nSubRace            = gsSUGetSubRaceByName(sSubRace);


    int bZombie = fbZGetIsZombie(oEquippedBy);
    if (bZombie)
    {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
      DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
    }

    // Tail concealment - Equipping a visible cloak conceals a tail.
    if (GetBaseItemType(oEquipped) == BASE_ITEM_CLOAK &&
      GetItemAppearance(oEquipped, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) > 0) {
      // Check for a tail
      int nTailModel = GetCreatureTailType(oEquippedBy);
      if (nTailModel > 0 && nTailModel <= 13) {
        object oHide = gsPCGetCreatureHide(oEquippedBy);
        if (oHide == OBJECT_INVALID) {
          oHide = oEquippedBy;
        }
        SetLocalInt(oHide, "CloakConcealTailModel", nTailModel);
        if (!GetLocalInt(oHide, "nX3_HorseRiderTail")) SetLocalInt(oHide, "nX3_HorseRiderTail", nTailModel);
        SetCreatureTailType(14, oEquippedBy);
      }
    }

    // totem appearance - needs to go here in case polymorph is reapplied
    // (e.g. -save, autosave).
    if (GetResRef(oEquipped) == "x2_it_emptyskin" || GetResRef(oEquipped) == "hide_totemdrd" ||
       (FindSubString(GetResRef(oEquipped), "ar_it") != -1 && FindSubString(GetResRef(oEquipped), "mon_hide") != -1) )
    {
      int nTail = GetLocalInt(oEquippedBy, "TAIL_APPEARANCE");
      if (nTail) SetCreatureTailType(nTail, oEquippedBy);
    }

    //::  Druid / Monk Dragonshape
    if ( GetLevelByClass(CLASS_TYPE_MONK, oEquippedBy) >= 1 &&
       ( GetResRef(oEquipped) == "co_dsbronzehide" ||
         GetResRef(oEquipped) == "co_dsredhide"  ||
         GetResRef(oEquipped) == "co_dsgreenhide")) {

        // We're finding WIS mod, and
        // reducing the hide's Armor AC by it.
        int nMonkWIS = GetAbilityModifier(ABILITY_WISDOM, oEquippedBy);
	       int nMonkACNerf;
		      if (nMonkWIS > 10) {
			         nMonkACNerf = nMonkWIS - 10;
			         if (nMonkACNerf > 5)
				            nMonkACNerf = 5;
			         nMonkWIS = 10;
			         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_DODGE, nMonkACNerf), oEquipped, 0.0);
        		}
		      if (nMonkWIS > 5) {
			         nMonkACNerf = nMonkWIS - 5;
			         nMonkWIS = 5;
			         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_DEFLECTION, nMonkACNerf), oEquipped, 0.0);
        		}
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_ARMOR, nMonkWIS), oEquipped, 0.0);
    }

    /*
    if ( GetLevelByClass(CLASS_TYPE_MONK, oEquippedBy) >= 1 &&
       ( GetResRef(oEquipped) == "nw_it_creitemdrc" ||
         GetResRef(oEquipped) == "nw_it_creitemdrm" ||
         GetResRef(oEquipped) == "nw_it_creitemdri")) {

        if ( GetHasFeat(FEAT_MONK_AC_BONUS, oEquippedBy) ) {
            NWNX_Creature_RemoveFeat(oEquippedBy, FEAT_MONK_AC_BONUS);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(GetLevelByClass(CLASS_TYPE_MONK, oEquippedBy)), oEquipped);
        }
    }
    */


    //creature item
    switch (GetBaseItemType(oEquipped))
    {
    case BASE_ITEM_CBLUDGWEAPON:
    case BASE_ITEM_CPIERCWEAPON:
    case BASE_ITEM_CREATUREITEM:
        // Check for latent vine mine HiPS feat.
        if(!GetHasSpellEffect(SPELL_VINE_MINE_CAMOUFLAGE, oEquippedBy))
        {
            IPRemoveMatchingItemProperties(oEquipped, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_PERMANENT, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT);
        }
    case BASE_ITEM_CSLASHWEAPON:
    case BASE_ITEM_CSLSHPRCWEAP:
        return;
    }

    if(GetBaseItemType(oEquipped) == BASE_ITEM_ARMOR)
    {
        ApplyAutoStillASFReduction(oEquippedBy);
    }

    //disallowed properties
    if (bStaticLevel) {
      while (GetIsItemPropertyValid(ipProperty))
      {
          if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
          {
              nType    = GetItemPropertyType(ipProperty);
              nSubType = GetItemPropertySubType(ipProperty);
              nCost    = GetItemPropertyCostTableValue(ipProperty);
              nParam   = GetItemPropertyParam1Value(ipProperty);

              switch (nType)
              {
              case ITEM_PROPERTY_DAMAGE_BONUS:
                  if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                      RemoveItemProperty(oEquipped, ipProperty);
                  break;

              case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                  if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                  {
                      RemoveItemProperty(oEquipped, ipProperty);
                  }
                  break;

              case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                  if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                      RemoveItemProperty(oEquipped, ipProperty);
                  break;

              case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                  if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                      RemoveItemProperty(oEquipped, ipProperty);
                  break;

              case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                  if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                      RemoveItemProperty(oEquipped, ipProperty);
                  break;

              case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                  if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                      RemoveItemProperty(oEquipped, ipProperty);
                  break;

              }
          }
          ipProperty = GetNextItemProperty(oEquipped);
      }
    } else if (GetIsPC(oEquippedBy)) {

      while (GetIsItemPropertyValid(ipProperty))
      {
        // Not-FL : Remove Freedom.
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) {
            RemoveItemProperty(oEquipped, ipProperty);
        }
        ipProperty = GetNextItemProperty(oEquipped);
      }
    }

    if (! GetIsDM(oEquippedBy))
    {
        //check for polymorph effect
        effect eEffect      = GetFirstEffect(oEquippedBy);
        int nNotPolymorphed = TRUE;

        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
            {
                nNotPolymorphed = FALSE;
                break;
            }

            eEffect = GetNextEffect(oEquippedBy);
        }

        // Dunshine: this is not used, but was done already so let's save it in case we ever want to use it:
        /*
        // Artifact restriction (1 allowed to be worn at the same time)
        if ((GetLocalInt(oEquipped, "gvd_artifact_legacy") == 1) || (GetLocalInt(oEquipped, "gvd_artifact_legacy_confirmed") == 1)) {
          // add 1 here, since unequip will lower it again with 1 soon
          SetLocalInt(oEquippedBy, "GVD_ARTIFACT_COUNT", GetLocalInt(oEquippedBy, "GVD_ARTIFACT_COUNT") + 1);

          if (GetLocalInt(oEquippedBy, "GVD_ARTIFACT_COUNT") > 1) {
            FloatingTextStringOnCreature("The power inside the artefacts is too much for you to equip more then one of them at the same time", oEquippedBy);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
            DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
          }
        }
        */

        // UMD restriction
        if (!gsIPDoUMDCheck(oEquipped, oEquippedBy))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
            DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
        }

        //item level restriction
        if (nNotPolymorphed && !bStaticLevel)
        {
            int nHitDice   = GetHitDice(oEquippedBy);
            int nItemValue = gsCMGetItemValue(oEquipped);
            int nItemLevel = GetLocalInt(oEquipped, "ILR");

            if (!GetPlotFlag(oEquipped) && nItemLevel > nHitDice)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
                DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));

                FloatingTextStringOnCreature(
                    gsCMReplaceString(
                        GS_T_16777535,
                        GetName(oEquipped),
                        IntToString(nItemLevel)),
                    oEquippedBy,
                    FALSE);

                return;
            }
        }

        //::  Imps can only use Tiny Weapons (Kukri, Dagger, Dart, Shuriken)
        //::  Polymorph is unaffected by this
        if (nSubRace == GS_SU_SPECIAL_IMP) {
            int bIsPolymorphed  = GetHasEffect(EFFECT_TYPE_POLYMORPH, oEquippedBy);
            int nItemType       = GetBaseItemType(oEquipped);
            int bTinyWeapon     = ( nItemType == BASE_ITEM_KUKRI ||
                                    nItemType == BASE_ITEM_DAGGER ||
                                    nItemType == BASE_ITEM_SHURIKEN ||
                                    nItemType == BASE_ITEM_DART);
            int bIsWeapon = (GetMeleeWeapon(oEquipped) || GetWeaponRanged(oEquipped));

            if (!bIsPolymorphed && bIsWeapon && !bTinyWeapon) {
                SendMessageToPC(oEquippedBy, "Imps are restricted to Tiny Weapons only (Kukri, Dagger, Dart, Shuriken).");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
                DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
            }
        }


        //Only check if right or left hand is equipped
        if(oEquipped == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEquippedBy) || oEquipped == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEquippedBy))
            DoTwoHandedBonusCheck(oEquippedBy);

        // Kensai restriction
        if (GetLocalInt(gsPCGetCreatureHide(oEquippedBy), "KENSAI"))
        {
           int nItemType = GetBaseItemType(oEquipped);

           switch (nItemType)
           {
             case BASE_ITEM_HEAVYCROSSBOW:
             case BASE_ITEM_LIGHTCROSSBOW:
             case BASE_ITEM_LONGBOW:
             case BASE_ITEM_SHORTBOW:
             case BASE_ITEM_SLING:
                SendMessageToPC(oEquippedBy, "Kensai are restricted to melee and thrown weapons.");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
                DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));
                break;
             default:
                break;
           }
        }

        //::Kirito-Spellsword path
        if (miSSGetIsSpellsword(oEquippedBy))
        {
		    //Re-Applies All Spellsword Bonuses
		    miSSReApplyBonuses(oEquippedBy, TRUE);
		    
			int bASFCheck = FALSE;
			itemproperty ipLoop = GetFirstItemProperty(oEquipped);

			while (GetIsItemPropertyValid(ipLoop))
			{
				if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_TEMPORARY)
				{
					if(//GetBaseItemType(oEquipped) == BASE_ITEM_ARMOR && 
					    GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
					{
						bASFCheck = TRUE;
					}
				}
				
				ipLoop=GetNextItemProperty(oEquipped);
			}
			
			if (!bASFCheck)
			{
				float fDuration = 24.0 * 60.0 * 60.0;
				AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT), oEquipped, fDuration);
    		}  
        }

        //::Cortex-Divine Might Check
        if (GetLevelByClass(CLASS_TYPE_PALADIN, oEquippedBy) || GetLevelByClass(CLASS_TYPE_BLACKGUARD, oEquippedBy))
        {
            // Re-Applies all Divine Might bonuses
            palDivineMightCheck(oEquipped, oEquippedBy);
        }

		//::Kirito-Bonded Weapon Check
        CheckBonds(oEquippedBy, oEquipped);
		
		//::Kirito-Mounted Combat
		if (GetMeleeWeapon(oEquipped) || GetWeaponRanged(oEquipped))
		{
			kiSetMountedAB(oEquippedBy);
		}
		
		//::Kirito - Mounted Restrictions
		if (GetLocalInt(oEquipped, "MOUNTED_WEAPON") == 1)
		{
			ki_MountedWeapon(oEquipped,oEquippedBy);
		}
		else if (GetLocalInt(oEquipped, "MOUNTED_WEAPON") == 2)
		{
			ki_DismountedWeapon(oEquipped,oEquippedBy);
		}

        // Spear Check
        if (GetBaseItemType(oEquipped) == BASE_ITEM_SHORTSPEAR)
        {
            object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEquippedBy);
            int bLeftHandIsShield = (GetBaseItemType(oLeftHand) == BASE_ITEM_LARGESHIELD)||
                                    (GetBaseItemType(oLeftHand) == BASE_ITEM_SMALLSHIELD)||
                                    (GetBaseItemType(oLeftHand) == BASE_ITEM_TOWERSHIELD);

            if (oLeftHand == oEquipped)
            {
                // No action necessary
                // This statement will never be reached as it stands right now. oLeftHand is the old item, and if the new item being
                // equipped is a spear. The existing left hand could never be a spear because spears can never be equipped in the left hand.
                // But if we change baseitems.2da, we should still make a check here to see if the spear was equipped in the off-hand slot
                // To do this, we need Delay(0.4, spearRestrictionIsSpear(oOldLeftHand, oOldRightHand, oEquipped, oEquippedBy) to see if the spear went
                // into the off-hand slot and if it did, unequip it.
            }
            else if ((!bLeftHandIsShield)&&(oLeftHand != OBJECT_INVALID))
            {
                DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oLeftHand)));
                FloatingTextStringOnCreature("You can only use a shield in the off-hand weapon slot when using a spear.", oEquippedBy, FALSE);
            }

        }
        else
        {
            // We are equipping some item which is not a spear.
            // We need to play with the timing a bit to get this right.
            // When this script fires, the script will see the old weapons in the left and right hand, this event fires IMMEDIATELY BEFORE
            // The item oEquipped is actually equipped in a slot. We see the EXISTING equipped items in those slots.
            object oOldRightHand    = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEquippedBy);
            object oOldLeftHand     = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEquippedBy);
            int bEquippingShield    =  ((GetBaseItemType(oEquipped) == BASE_ITEM_LARGESHIELD)||
                                        (GetBaseItemType(oEquipped) == BASE_ITEM_SMALLSHIELD)||
                                        (GetBaseItemType(oEquipped) == BASE_ITEM_TOWERSHIELD));

            // If we're not equipping a shield, and the right hand contains a spear
            if ((!bEquippingShield)&&(GetBaseItemType(oOldRightHand) == BASE_ITEM_SHORTSPEAR))
            {
                // This is the part with the timing. By delaying by 0.4 seconds, when we call GetItemInSlot() in the function, we will see the newly equipped item and which
                // slot it is in. This function fires AFTER the item has been equipped in the slot.
                DelayCommand(0.4, spearRestrictionNotSpear(oOldLeftHand, oOldRightHand, oEquipped, oEquippedBy));
            }
        }
    }
    if (GetEquipmentType(oEquipped) == EQUIPMENT_TYPE_WEAPON) {
        // dunshine: always disable subdual state when a weapon is equipped
        gvd_SetSubdualMode(oEquippedBy, 0);
        UpdateWeaponBonuses(oEquippedBy);
    }
    // Toggles spell availability based on whether the PC is polymorphed.
    UpdateSpontaneousSpellReadyStates(oEquippedBy);
}

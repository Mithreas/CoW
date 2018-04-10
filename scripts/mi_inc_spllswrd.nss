//::///////////////////////////////////////////////
//:: mi_inc_spllswrd
//:: Library: Spellsword
//:://////////////////////////////////////////////
/*
    Library with functions for spellsword wizards

    Spellsword wizards get the following changes:
    - +1 AB at Wizard Level 3,7,11,15,19,23,27
    - 1 APR at Level 1, 2 APR at L8, 3 APR at L15, 4 APR at L22 whilst wizard is the dominant class
    - INT bonus to Damage, limited by Wizard levels /2
    - BASE INT bonus to AC, limited by 1 + Wizard levels /6
    - 1 Discipline per 3 wizard levels
    - loss of one spell school
    - loss of conjuration school
    - loss of all epic spells except Epic: Mage Armour
    - D6 HP per wizard level
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: July 14, 2017
//:://////////////////////////////////////////////

// mi_inc_spllswrd
//
// Library with functionssforpellsword wizards.
//
//
//
//

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "gs_inc_pc"
#include "inc_generic"
#include "inc_item"
#include "inc_spells"
#include "inc_effecttags"
#include "ki_inc_calc_bab"
#include "ar_spellmatrix"
#include "x2_inc_itemprop"
#include "ki_inc_bonditem"
#include "ki_inc_bondtags"

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

//Check if spellsword
int miSSGetIsSpellsword(object oPC);
//Set SPELLSWORD flag on hide
void miSSSetIsSpellsword(object oPC);
//Set blocked school on hide
void miSSSetBlockedSchool(object oPC, int nSchool, int nNum = 1);
//Sets path variables
void miSSSetPathItem(object oPC);
// Applies Spellsword bonuses (e.g. AC for one-hand-wielding).
void miSSCharBonuses(object oPC, int bFeedback);
// Adjust AB and APR for Spellswords
void miSSSetABAPR(object oPC, int bFeedback = TRUE);
// Version 2 Adjust AB and APR for Spellswords
void miSSSetABAPR2(object oPC, int bFeedback = TRUE);
//Change Hitpoints to D6 for each wizard level
void miSSHitpoints(object oPC, int bLevelUp = TRUE, int bFeedback = TRUE);
//Removes All Spellsword Bonuses
void miSSRemoveCharBonuses(object oPC, int bFeedback);
//Removes All Spellsword Attack Bonuses
void miSSRemoveAB(object oPC, int bFeedback, int bLevelUp = TRUE);
//Applies All Spellsword Bonuses
void miSSApplyBonuses(object oPC, int bFeedback, int bLevelUp = TRUE);
//Re-Applies All Spellsword Bonuses
void miSSReApplyBonuses(object oPC, int bFeedback);
void miSSTest(object oPC);
//Give Martial Weapon Prof Feat
void miSSMWPFeat(object oPC);
//Imbue weapon - gives bonus to weapon if a spell is cast on it by a spellsword.
void miSSImbueWeapon(object oPC, int SpellID, object oWeapon, int bFeedback = TRUE);
//Imbue armour - gives bonus to weapon if a spell is cast on it by a spellsword.
void miSSImbueArmour(object oPC, int SpellID, object oArmour, int bFeedback = TRUE);


/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/


//------------------------------------------------------------------------------
//Check if spellsword
int miSSGetIsSpellsword(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "SPELLSWORD");
}

//------------------------------------------------------------------------------
//Set SPELLSWORD flag on hide
void miSSSetIsSpellsword(object oPC)
{
    SetLocalInt(gsPCGetCreatureHide(oPC), "SPELLSWORD", 1);
	SetLocalInt(gsPCGetCreatureHide(oPC), "SS_VER", 1);
}
//------------------------------------------------------------------------------
//Sets path variables
void miSSSetPathItem(object oPC)
{
    object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
    string sPath = "Spellsword";
    SetDescription(oAbility, GetDescription(oAbility) + "\nPath: " + sPath);
    SetIdentified(oAbility, TRUE);
}

//------------------------------------------------------------------------------
//Set blocked school on hide
void miSSSetBlockedSchool(object oPC, int nSchool, int nNum = 1)
{
   object oHide = gsPCGetCreatureHide(oPC);
   if (nNum == 1)
   {
     SetLocalInt(oHide, "MI_BLOCKEDSCHOOL1", nSchool);
   }
   else if (nNum == 2)
   {
     SetLocalInt(oHide, "MI_BLOCKEDSCHOOL2", nSchool);
   }
}

//------------------------------------------------------------------------------
// Sets Spellsword bonuses (e.g. INT bonus to AC/Damage etc).
void miSSCharBonuses(object oPC, int bFeedback)
{
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    if(!GetIsPC(oPC) || GetIsDM(oPC) || !nWizard) return;

    //check if spellsword
    if(miSSGetIsSpellsword(oPC))
    {
        int bRanged = FALSE;
        int bTwoHand = FALSE;

        int nBonus = 0;
        object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        object oLeftHand =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        object oHide = gsPCGetCreatureHide(oPC);
        int nAbilityMod;

        int nItemType = GetBaseItemType(oRightHand);

		int bIsMonk = ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 ) 
						&& (oRightHand == OBJECT_INVALID || nItemType == BASE_ITEM_KAMA)
						&& oLeftHand == OBJECT_INVALID);


        switch (nItemType)
        {
            case BASE_ITEM_HEAVYCROSSBOW:
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_LONGBOW:
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_SLING:
            {
                bRanged = TRUE;
            }
            case BASE_ITEM_DIREMACE:
            case BASE_ITEM_DOUBLEAXE:
            case BASE_ITEM_GREATAXE:
            case BASE_ITEM_GREATSWORD:
            case BASE_ITEM_HALBERD:
            case BASE_ITEM_HEAVYFLAIL:
            case BASE_ITEM_QUARTERSTAFF:
            case BASE_ITEM_SCYTHE:
            case BASE_ITEM_TRIDENT:
            case BASE_ITEM_TWOBLADEDSWORD:
            {
                bTwoHand = TRUE;
            }
            case BASE_ITEM_BASTARDSWORD:
            case BASE_ITEM_BATTLEAXE:
            case BASE_ITEM_CLUB:
            case BASE_ITEM_DWARVENWARAXE:
            case BASE_ITEM_LIGHTFLAIL:
            case BASE_ITEM_LONGSWORD:
            case BASE_ITEM_RAPIER:
            case BASE_ITEM_SCIMITAR:
            case BASE_ITEM_WARHAMMER:
            {
                if(GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)
                {
                    bTwoHand = TRUE;
                }
            }
        }
		
		

        // AC = 1 + 1/6 wizard levels, capped by Base INT mod
        if (bRanged || bTwoHand || oLeftHand != OBJECT_INVALID || bIsMonk)
        {
            if(bFeedback) SendMessageToPC(oPC, "You cannot manipulate the weave to protect you whilst you hold something in your offhand");
        }
        else
        {
            nAbilityMod = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, FALSE) - 10) / 2;

            if (1 + (nWizard / 6) < nAbilityMod)
            {
                nBonus = 1 + (nWizard / 6);
            }
            else
            {
                nBonus = nAbilityMod;
            }
            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nBonus, AC_SHIELD_ENCHANTMENT_BONUS)), oPC, 0.0, EFFECT_TAG_SPELLSWORD);
            if(bFeedback) SendMessageToPC(oPC, "Spellsword AC Bonus Granted: +" + IntToString(nBonus) + " Armor Class");
        }

        // DAM = 1/2 levels, capped by modified INT BONUS
        if (!bRanged)
        {
            nAbilityMod = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, FALSE) - 10) / 2;

            if ((nWizard / 2) < nAbilityMod)
            {
                nBonus = nWizard/2;
            }
            else
            {
                nBonus = nAbilityMod;
            }

            int nDamage;
            if (nBonus <= 5)
            { nDamage = nBonus; }
            else if (nBonus <= 20)
            { nDamage = nBonus + 10;}
            else if (nBonus > 20)
            { nDamage = 30; }
            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING)), oPC, 0.0, EFFECT_TAG_SPELLSWORD);
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Damage Bonus Granted: +" + IntToString(nBonus) + " Damage");
        }

        // Discipline - +1 / 3 levels
        if(nWizard >= 3)
        {
            effect eIncreaseDISC = EffectSkillIncrease(SKILL_DISCIPLINE, nWizard / 3);
            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eIncreaseDISC), oPC, 0.0, EFFECT_TAG_SPELLSWORD);
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Skill Bonus Granted: +" + IntToString(nWizard / 3) + " Discipline");
        }

    }
}

//------------------------------------------------------------------------------
// Adjust AB and APR for Spellswords
void miSSSetABAPR(object oPC, int bFeedback = TRUE)
{
    if (miSSGetIsSpellsword(oPC))
    {
		SendMessageToPC(oPC, ":ABAPR:");
        //Find level split for the wizard and non-wizard classes
        int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        int nCharacterLevel = GetCharacterLevel(oPC);
        int nOtherLevel = nCharacterLevel - nWizardLevel;


        //if more wizard levels add AB bonus and set APR
        if (nWizardLevel > nOtherLevel)
        {
            int nBonus = (nWizardLevel + 1) / 4;
            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nBonus)), oPC, 0.0, EFFECT_TAG_SPELLSWORD);
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Attack Bonus Granted: +" + IntToString(nBonus) + " Attack Bonus");

            object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
            object oLeftHand =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

            if (oRightHand == OBJECT_INVALID && oLeftHand == OBJECT_INVALID)
            {
                RestoreBaseAttackBonus(oPC);
                if(bFeedback) SendMessageToPC(oPC, "Spellsword Number of Attacks Reverted to BAB APR");
            }
            else
            {
                if (nCharacterLevel < 8)
                {
                    nBonus = 1;
                }
                else if (nCharacterLevel < 15)
                {
                    nBonus = 2;
                }
                else if (nCharacterLevel < 22)
                {
                    nBonus = 3;
                }
                else //if (nCharacterLevel < 31)
                {
                    nBonus = 4;
                }

                SetBaseAttackBonus(nBonus, oPC); //correctly sets APR however does not show true APR in character sheet.
                if(bFeedback) SendMessageToPC(oPC, "Spellsword Number of Attacks: " + IntToString(nBonus) + " Attacks");
            }
        }
        else
        {
            if(bFeedback) SendMessageToPC(oPC, "Wizard class less than other classes");
        }
    }
}

//------------------------------------------------------------------------------
// Adjust AB and APR for Spellswords
void miSSSetABAPR2(object oPC, int bFeedback = TRUE)
{
    if (miSSGetIsSpellsword(oPC))
    {
		SendMessageToPC(oPC, ":ABAPR2:");
        //Find level split for the wizard and non-wizard classes
        int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        int nCharacterLevel = GetCharacterLevel(oPC);
        int nOtherLevel = nCharacterLevel - nWizardLevel;
        int nAttackIncrease = 0;
        int nAttacks = 0;

        //if more wizard levels add AB bonus and set APR
        //if (nWizardLevel > nOtherLevel)
        {
            int nBAB = GetBaseAttackBonus(oPC);
            int nTargetBAB = _Calculate_pre_epic_BAB(oPC, miSSGetIsSpellsword(oPC));
            int nEpicPortionOfBAB = ( nCharacterLevel - 19 ) / 2;

            if ( nCharacterLevel <= 20 )
            {
                nEpicPortionOfBAB = 0;
            }

            if ( nCharacterLevel > 20 )
            {
                nAttackIncrease = nTargetBAB + nEpicPortionOfBAB;
                if (nCharacterLevel >= 23){ nAttackIncrease++; }
                if (nCharacterLevel >= 27){ nAttackIncrease++; }
            }
            else
            {
                nAttackIncrease = nTargetBAB;
            }
            nAttackIncrease -= nBAB;

            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nAttackIncrease)), oPC, 0.0, EFFECT_TAG_SPELLSWORD);
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Attack Bonus Granted: +" + IntToString(nAttackIncrease) + " Attack Bonus");
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Base Attack Bonus: +" + IntToString(nTargetBAB) + " Attack Bonus");

            object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
            object oLeftHand =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

            int bIsMonk = (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 );

            if ( bIsMonk &&
                    (oRightHand == OBJECT_INVALID || GetBaseItemType(oRightHand) == BASE_ITEM_QUARTERSTAFF || GetBaseItemType(oRightHand) == BASE_ITEM_KAMA
                        || GetBaseItemType(oRightHand) == BASE_ITEM_SHURIKEN)
                    && (oLeftHand == OBJECT_INVALID || GetBaseItemType(oLeftHand) == BASE_ITEM_KAMA)
               )
            {
                nAttacks =  1 + (( nTargetBAB - 1 ) / 3);
            }
            else
            {
                nAttacks =  1 + (( nTargetBAB - 1 ) / 5);
            }
			int nVersion = GetLocalInt(gsPCGetCreatureHide(oPC), "SS_VER");
            if (nCharacterLevel >= 22 && nVersion == 0 && nAttacks < 4)
            {
                //effect eAttackMod = EffectModifyAttacks(1);
                nAttacks ++;
            }
			SetBaseAttackBonus( nAttacks, oPC); //correctly sets APR however does not show true APR in character sheet.
            if(bFeedback) SendMessageToPC(oPC, "Spellsword Number of Attacks: " + IntToString(nAttacks) + " Attacks");
        }
        //else
        //{
        //    if(bFeedback) SendMessageToPC(oPC, "Wizard class less than other classes");
        //}
    }
}

//------------------------------------------------------------------------------
//Change Hitpoints to D6 for each wizard level
void miSSHitpoints(object oPC, int bLevelUp = TRUE, int bFeedback = TRUE)
{
  // Not a wizard level?
  int nHD   = GetHitDice(oPC);

  if (!miSSGetIsSpellsword(oPC)) return;

  int nLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  object oHide = gsPCGetCreatureHide(oPC);


  if (bLevelUp && NWNX_Creature_GetClassByLevel(oPC, nHD) != CLASS_TYPE_WIZARD) return;

  if(FALSE) SendMessageToPC(oPC, "Levelup=" + IntToString(bLevelUp));
  // Set hit dice to d6 - Hope this works, uses NWNX and I can't test that
  if (bLevelUp)
  {
    NWNX_Creature_SetMaxHitPointsByLevel(oPC, nHD, 6);
    if(bFeedback) SendMessageToPC(oPC, "Wizard HP Changed to D6");
  }
  else
  {
    // Go through each wizard level and adjust its HP.
    int nCount;
    for (nCount == 1; nCount < nHD; nCount++)
    {
      if (NWNX_Creature_GetClassByLevel(oPC, nCount) == CLASS_TYPE_WIZARD)
      {
        NWNX_Creature_SetMaxHitPointsByLevel(oPC, nCount, 6);
      }
    }
    if(bFeedback) SendMessageToPC(oPC, "All wizard HP Changed to D6");
  }
}

//------------------------------------------------------------------------------
//Applies All Spellsword Bonuses
void miSSRemoveCharBonuses(object oPC, int bFeedback)
{
    if(miSSGetIsSpellsword(oPC))
    {
        effect eEffect = GetFirstEffect(oPC);
        while (GetIsEffectValid(eEffect))
        {
            if (GetIsTaggedEffect(eEffect, EFFECT_TAG_SPELLSWORD) && (GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE
            //if ((GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE // use if NWNX not installed
                   || GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_INCREASE
                   || GetEffectType(eEffect) == EFFECT_TYPE_SKILL_INCREASE))
            {
                RemoveEffect(oPC, eEffect);
                if(bFeedback) SendMessageToPC(oPC, "Removed effect Type: " + IntToString(GetEffectType(eEffect)));
            }

            eEffect = GetNextEffect(oPC);
        }
    }
}

//------------------------------------------------------------------------------
//Applies All Spellsword Bonuses
void miSSRemoveAB(object oPC, int bFeedback, int bLevelUp = TRUE)
{
    if(miSSGetIsSpellsword(oPC) && bLevelUp)
    {
        effect eEffect = GetFirstEffect(oPC);
        while (GetIsEffectValid(eEffect))
        {
			SendMessageToPC(oPC,"effect" + IntToString(GetEffectType(eEffect)) + "tag" + IntToString(GetIsTaggedEffect(eEffect, EFFECT_TAG_SPELLSWORD)));
            if (GetIsTaggedEffect(eEffect, EFFECT_TAG_SPELLSWORD) && (GetEffectType(eEffect) == EFFECT_TYPE_ATTACK_INCREASE))
            // if (GetEffectType(eEffect) == EFFECT_TYPE_ATTACK_INCREASE) // use if NWNX not installed
            {
                RemoveEffect(oPC, eEffect);
                if(bFeedback) SendMessageToPC(oPC, "Removed effect Type: " + IntToString(GetEffectType(eEffect)));
            }

            eEffect = GetNextEffect(oPC);
        }
    }
}

//------------------------------------------------------------------------------
//Applies All Spellsword Bonuses
void miSSApplyBonuses(object oPC, int bFeedback, int bLevelUp = TRUE)
{
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    if(!GetIsPC(oPC) || GetIsDM(oPC) || !nWizard) return;

    //check if spellsword
    if(miSSGetIsSpellsword(oPC))
    {
        //remove previous effects
        miSSRemoveCharBonuses(oPC, FALSE);
        miSSRemoveAB(oPC, FALSE, TRUE);

        //add new effects
		SendMessageToPC(oPC, ":AB:");
        miSSHitpoints(oPC, bLevelUp, bFeedback);
        miSSSetABAPR2(oPC, bFeedback);
        miSSCharBonuses(oPC, bFeedback);
    }
}

//------------------------------------------------------------------------------
//Re-Applies All Spellsword Bonuses
void miSSReApplyBonuses(object oPC, int bFeedback)
{
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    if(!GetIsPC(oPC) || GetIsDM(oPC) || !nWizard) return;

    //check if spellsword
    if(miSSGetIsSpellsword(oPC))
    {
        //remove previous effects
        miSSRemoveCharBonuses(oPC, FALSE);
        miSSRemoveAB(oPC, FALSE, TRUE);

        //add new effects
		SendMessageToPC(oPC, ":RAB:");
        miSSCharBonuses(oPC, bFeedback);
        miSSSetABAPR2(oPC, bFeedback);
    }
}

//------------------------------------------------------------------------------
//Give Feat -- for local test char --
//blocked from all SS on Arelith since blocked school is 2 (conjuration)
void miSSTest(object oPC)
{
    if (GetLocalInt(gsPCGetCreatureHide(oPC), "MI_BLOCKEDSCHOOL2") == 7)
    {
        object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (oRHand != OBJECT_INVALID)
        {
            SendMessageToPC(oPC, "Bond Weapon");
			SetLocalInt(oRHand, "Elfblade", 1);
            bond_item(oRHand, oPC, BOND_TAG_BLADESINGER, INVENTORY_SLOT_RIGHTHAND);
        }

        //if (GetKnowsFeat(001 ,oPC)) return;
        //AddKnownFeat(oPC, 001);
    }
}

//------------------------------------------------------------------------------
//Give Martial Weapon Prof Feat
void miSSMWPFeat(object oPC)
{
    if (!GetKnowsFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL ,oPC))
    {
        AddKnownFeat(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL, GetLevelByClassLevel(oPC, CLASS_TYPE_WIZARD, 1));
    }
    if (!GetKnowsFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE ,oPC))
    {
        AddKnownFeat(oPC, FEAT_WEAPON_PROFICIENCY_SIMPLE, GetLevelByClassLevel(oPC, CLASS_TYPE_WIZARD, 1));
    }
    if (!GetKnowsFeat(FEAT_UNCANNY_DODGE_1 ,oPC))
    {
        AddKnownFeat(oPC, FEAT_UNCANNY_DODGE_1, GetLevelByClassLevel(oPC, CLASS_TYPE_WIZARD, 1));
    }
    if (!GetKnowsFeat(FEAT_ARMOR_PROFICIENCY_LIGHT ,oPC))
    {
        AddKnownFeat(oPC, FEAT_ARMOR_PROFICIENCY_LIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_WIZARD, 1));
    }
    if (!GetKnowsFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM ,oPC))
    {
        AddKnownFeat(oPC, FEAT_ARMOR_PROFICIENCY_MEDIUM, GetLevelByClassLevel(oPC, CLASS_TYPE_WIZARD, 1));
    }
}

//------------------------------------------------------------------------------
//Imbue weapon - gives bonus to weapon if a spell is cast on it by a spellsword.
void miSSImbueWeapon(object oPC, int SpellID, object oWeapon, int bFeedback = TRUE)
{
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    object oHide = gsPCGetCreatureHide(oPC);
    object oItem = IPGetTargetedOrEquippedMeleeWeapon();
    if (oItem == OBJECT_INVALID)
    {
        if(bFeedback) SendMessageToPC(oPC, "Weapon Invalid");
        return;
    }

    //::  Get Spell Level
    string sColumn  = "Wiz_Sorc";
    int nSpell      = _arGetCorrectSpellId(GetSpellId());   //::  Get Correct Spell Id from Grouped spells
    int nSpellLevel = StringToInt(Get2DAString("spells", sColumn, nSpell));

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND || nMetaMagic == METAMAGIC_SILENT ||  nMetaMagic == METAMAGIC_STILL)
    {
        nSpellLevel += 1;
    }
    else if ( nMetaMagic == METAMAGIC_EMPOWER )
    {
        nSpellLevel +=2;
    }
    else if ( nMetaMagic == METAMAGIC_MAXIMIZE )
    {
        nSpellLevel +=3;
    }
    else if ( nMetaMagic == METAMAGIC_QUICKEN )
    {
        nSpellLevel +=4;
    }
	
	if (nSpellLevel > (nWizard + 1)  / 2)
	{
		nSpellLevel = (nWizard + 1)  / 2;
	}

    int nSaveDC = 10 + nWizard;
    int nDamage;
    string nDamageText;
    if (nSpellLevel <= 3)
    {
        nDamage = DAMAGE_BONUS_1d4;
        nDamageText = "1D4";
        nSaveDC += 0;
    }
    else if (nSpellLevel <= 6)
    {
        nDamage = DAMAGE_BONUS_1d8;
        nDamageText = "1D8";
        nSaveDC += 2;
    }
    else if (nSpellLevel > 6)
    {
        nDamage = DAMAGE_BONUS_1d12;
        nDamageText = "1D12";
        nSaveDC += 4;
    }
    int nVFX;
    int nDamageType;
    string sScript = "SS_IM_";
	string sSaveDC = "SS_IMBUE_WEAPON_DC_";
    int nOnHit;
    int nSpecial = 0;

    //SetLocalInt(oHide, "SS_IMBUE_WEAPON_DC", nSaveDC);

    //if(bFeedback) SendMessageToPC(oPC, "SpellID: " + IntToString(SpellID));
    //if(bFeedback) SendMessageToPC(oPC, "SpellID: " + IntToString(nSpell));

    //Allow 2 imbue spells for epic spellsword
    itemproperty ipProperty = GetFirstItemProperty(oItem);
    int nCount = 0;

    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_TEMPORARY && 
				( //GetItemPropertyType(ipProperty) == ITEM_PROPERTY_DAMAGE_BONUS || //removed to stop temp essence messing things up
				GetItemPropertyType(ipProperty) == ITEM_PROPERTY_ONHITCASTSPELL))
		{
            nCount += 1;
        }
        ipProperty = GetNextItemProperty(oItem);
    }

    //remove previous imbue
    //if ((nWizard < 20 && nCount > 1) || nCount > 3)
	if ((nWizard < 20 && nCount == 1) || nCount == 2)
    {
        nCount = 0;
        itemproperty ipLoop = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipLoop))
        {
            if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_TEMPORARY)
            {
                if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL ||
                    GetItemPropertyType(ipLoop) == ITEM_PROPERTY_VISUALEFFECT ||
                    GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS
                  )
                {
                    RemoveItemProperty(oItem, ipLoop);
                }
            }
            ipLoop=GetNextItemProperty(oItem);
        }
    }



    switch(SpellID)
    {
        case SPELL_ACID_FOG:
        case SPELL_ACID_SPLASH:
        case SPELL_MELFS_ACID_ARROW:
        case SPELL_MESTILS_ACID_BREATH:
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:
        //acid
        {
            nDamageType = IP_CONST_DAMAGETYPE_ACID;
            sScript = "SS_IM_W_ACID";
			sSaveDC = "SS_IM_W_DC_ACID";
            nVFX = ITEM_VISUAL_ACID;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Acid");
            break;
        }
        case SPELL_BALL_LIGHTNING:
        case SPELL_CHAIN_LIGHTNING:
        case SPELL_GEDLEES_ELECTRIC_LOOP:
        case SPELL_SCINTILLATING_SPHERE:
        case SPELL_LIGHTNING_BOLT:
        case SPELL_ELECTRIC_JOLT:
        //electric
        {
            nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
            sScript = "SS_IM_W_ELEC";
			sSaveDC = "SS_IM_W_DC_ELEC";
            nVFX = ITEM_VISUAL_ELECTRICAL;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Electric");
            break;
        }
        case SPELL_BURNING_HANDS:
        case SPELL_COMBUST:
        case SPELL_FIREBALL:
        case SPELL_FIREBRAND:
        case SPELL_FLAME_ARROW:
        case SPELL_FLARE:
        case SPELL_DELAYED_BLAST_FIREBALL:
        case SPELL_WALL_OF_FIRE:
        case SPELL_INCENDIARY_CLOUD:
        case SPELL_METEOR_SWARM:
        case SPELL_SHADES_FIREBALL:
        case SPELL_SHADES_WALL_OF_FIRE:
        //fire
        {
            nDamageType = IP_CONST_DAMAGETYPE_FIRE;
            sScript = "SS_IM_W_FIRE";
			sSaveDC = "SS_IM_W_DC_FIRE";
            nVFX = ITEM_VISUAL_FIRE;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Fire");
            break;
        }
        case SPELL_CONE_OF_COLD:
        case SPELL_ICE_DAGGER:
        case SPELL_ICE_STORM:
        case SPELL_RAY_OF_FROST:
        case SPELL_SHADES_CONE_OF_COLD:
        //ice
        {
            nDamageType = IP_CONST_DAMAGETYPE_COLD;
            sScript = "SS_IM_W_COLD";
			sSaveDC = "SS_IM_W_DC_COLD";
            nVFX = ITEM_VISUAL_COLD;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Cold");
            break;
        }
        case SPELL_ISAACS_GREATER_MISSILE_STORM:
        case SPELL_ISAACS_LESSER_MISSILE_STORM:
        case SPELL_MAGIC_MISSILE:
        case SPELL_PHANTASMAL_KILLER:
        case SPELL_WEIRD:
        case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:
        //magic
        {
            if (nSpellLevel <= 3)
            {
                nDamage = DAMAGE_BONUS_1;
                nDamageText = "1";
            }
            else if (nSpellLevel <= 6)
            {
                nDamage = DAMAGE_BONUS_1d4;
                nDamageText = "1D4";
            }
            else if (nSpellLevel > 6)
            {
                nDamage = DAMAGE_BONUS_1d8;
                nDamageText = "1D8";
            }

            nDamageType = IP_CONST_DAMAGETYPE_MAGICAL;
            sScript = "SS_IM_W_MAGIC";
			sSaveDC = "SS_IM_W_DC_MAGIC";
            nVFX = ITEM_VISUAL_SONIC;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Magic");
            break;
        }
        case SPELL_CREATE_GREATER_UNDEAD:
        case SPELL_CREATE_UNDEAD:
        case SPELL_NEGATIVE_ENERGY_BURST:
        case SPELL_NEGATIVE_ENERGY_RAY:
        case SPELL_FINGER_OF_DEATH:
        case SPELL_ENERVATION:
        case SPELL_ENERGY_DRAIN:
        case SPELL_HORRID_WILTING:
        case SPELL_WAIL_OF_THE_BANSHEE:
		case SPELL_VAMPIRIC_TOUCH:
        //negative
        {
            nDamageType = IP_CONST_DAMAGETYPE_NEGATIVE;
            sScript = "SS_IM_W_NGTV";
			sSaveDC = "SS_IM_W_DC_NGTV";
            nVFX = ITEM_VISUAL_EVIL;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Negative");
            break;
        }
        case SPELL_HORIZIKAULS_BOOM:
        case SPELL_SILENCE:
        case SPELL_SOUND_BURST:
        case SPELL_WOUNDING_WHISPERS:
        case SPELL_GREAT_THUNDERCLAP:
        //sonic
        {
            nDamageType = IP_CONST_DAMAGETYPE_SONIC;
            sScript = "SS_IM_W_SONIC";
			sSaveDC = "SS_IM_W_DC_SONIC";
            nVFX = ITEM_VISUAL_SONIC;
            if(bFeedback) SendMessageToPC(oPC, "DamageType: " + "Sonic");
            break;
        }
        default:
        {
            if(bFeedback) SendMessageToPC(oPC, "You are not able to imbue this spell to your weapon");
            return;
        }
    }



    //24 hours
    float nDuration = 24.0*60.0*60.0;

    if (nWizard > 20 && nCount == 1)
    {
        SetLocalString(oItem, "RUN_ON_HIT_2", GetStringLowerCase(sScript));

        nCount = 2;
        itemproperty ipLoop = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipLoop))
        {
            if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_TEMPORARY)
            {
                if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_VISUALEFFECT)
                {
                    RemoveItemProperty(oItem, ipLoop);
                }
            }
            ipLoop=GetNextItemProperty(oItem);
        }

        nVFX = ITEM_VISUAL_HOLY;
    }
    else
    {
        SetLocalString(oItem, "RUN_ON_HIT_1", GetStringLowerCase(sScript));
		nCount = 1;
    }

	SetLocalInt(oHide, sSaveDC, nSaveDC);
    //if(bFeedback) SendMessageToPC(oPC, "DamageType: " + IntToString(nDamageType));
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(nDamageType, nDamage), oItem, nDuration);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyVisualEffect(nVFX), oItem, nDuration);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nWizard), oItem, nDuration);
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDamageIncrease(nDamage, nDamageType)), oPC, RoundsToSeconds(nWizard));
    if(bFeedback) SendMessageToPC(oPC, "Spellsword Imbue Damage Bonus Granted: +" + nDamageText + " Damage");
}

//------------------------------------------------------------------------------
//Imbue armour - gives bonus to weapon if a spell is cast on it by a spellsword.
void miSSImbueArmour(object oPC, int SpellID, object oArmour, int bFeedback = TRUE)
{
    oArmour = IPGetTargetedOrEquippedArmor();
    object oHide = gsPCGetCreatureHide(oPC);

    if (oArmour == OBJECT_INVALID)
    {
        if(bFeedback) SendMessageToPC(oPC, "Armour Invalid");
        return;
    }

    //put on hit property on armour
    int bIPExists = FALSE;
    itemproperty ipLoop = GetFirstItemProperty(oArmour);

    while (GetIsItemPropertyValid(ipLoop))
    {
        if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL)
        {
            bIPExists = TRUE;
        }
        ipLoop=GetNextItemProperty(oArmour);
    }

    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);

    if (!bIPExists)
    {
        DelayCommand(4.0, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nWizard), oArmour));
    }

    string sScript = "SS_IM_A";

    SetLocalString(oArmour, "RUN_ON_HIT_1", GetStringLowerCase(sScript));
    SetLocalInt(oHide, "SS_IMBUE_ARMOUR_CH", SpellID);

    if (GetLocalInt(gsPCGetCreatureHide(oPC), "MI_BLOCKEDSCHOOL2") == 7)
    {
        if(bFeedback) SendMessageToPC(oPC, "Imbued Armour: " + IntToString(GetLocalInt(oHide, "SS_IMBUE_ARMOUR_CH")));
        miSSTest(oPC);
    }

    string sSpell = "";
    switch(SpellID)
    {
        case SPELL_SHIELD:
        {
            sSpell = "Shield";
            break;
        }
        case SPELL_SHADOW_SHIELD:
        {
            sSpell = "Shadow Shield";
            break;
        }
        case SPELL_MAGE_ARMOR:
        {
            sSpell = "Mage Armour";
            break;
        }
        case SPELL_MESTILS_ACID_SHEATH:
        {
            sSpell = "Acid Sheath";
            break;
        }
        case SPELL_ELEMENTAL_SHIELD:
        {
            sSpell = "Elemental Shield";
            break;
        }
        case SPELL_STONESKIN:
        {
            sSpell = "Stoneskin";
            break;
        }
        case SPELL_GREATER_STONESKIN:
        {
            sSpell = "Greater Stoneskin";
            break;
        }
        case SPELL_PREMONITION:
        {
            sSpell = "Premonition";
            break;
        }
        case SPELL_GHOSTLY_VISAGE:
        {
            sSpell = "Ghostly Visage";
            break;
        }
        case SPELL_ETHEREAL_VISAGE:
        {
            sSpell = "Ethereal Visage";
            break;
        }
        case SPELL_LESSER_SPELL_MANTLE:
        {
            sSpell = "Lesser Spell Mantle";
            break;
        }
        case SPELL_SPELL_MANTLE:
        {
            sSpell = "Spell Mantle";
            break;
        }
        case SPELL_GREATER_SPELL_MANTLE:
        {
            sSpell = "Greater Spell Mantle";
            break;
        }
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY:
        {
            sSpell = "Minor Globe of Invulnerability";
            break;
        }
        case SPELL_GLOBE_OF_INVULNERABILITY:
        {
            sSpell = "Globe of Invulnerability";
            break;
        }
        default:
        {
            if(bFeedback) SendMessageToPC(oPC, "You are not able to embue this spell to your armour");
            return;
        }
    }
    if(bFeedback) SendMessageToPC(oPC, "Spell added to armour: " + sSpell);

}

//------------------------------------------------------------------------------
//Imbue armour - gives bonus to weapon if a spell is cast on it by a spellsword.
void miSSImbueArmourOLD(object oPC, int SpellID, object oArmour, int bFeedback = TRUE)
{
    oArmour = IPGetTargetedOrEquippedArmor();
    if (oArmour == OBJECT_INVALID)
    {
        if(bFeedback) SendMessageToPC(oPC, "Armour Invalid");
        return;
    }

    //remove old casting
//    itemproperty ipLoop = GetFirstItemProperty(oArmour);

//    while (GetIsItemPropertyValid(ipLoop))
//    {
//        if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL)
//        {
//            RemoveItemProperty(oArmour, ipLoop);
//        }
//        ipLoop=GetNextItemProperty(oArmour);
//    }

    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    //int nSpell      = _arGetCorrectSpellId(GetSpellId());   //::  Get Correct Spell Id from Grouped spells

//    if(bFeedback) SendMessageToPC(oPC, "SpellID: " + IntToString(SpellID));
//    if(bFeedback) SendMessageToPC(oPC, "SpellID: " + IntToString(nSpell));

    string sScript = "SS_IM_A";
    IPSafeAddItemProperty(oArmour, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nWizard), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    string sSpell = "";
    switch(SpellID)
    {
        case SPELL_SHIELD:
        {
            sSpell = "Shield";
            break;
        }
        case SPELL_SHADOW_SHIELD:
        {
            sSpell = "Shadow Shield";
            break;
        }
        case SPELL_MAGE_ARMOR:
        {
            sSpell = "Mage Armour";
            break;
        }
        case SPELL_MESTILS_ACID_SHEATH:
        {
            sSpell = "Acid Sheath";
            break;
        }
        case SPELL_ELEMENTAL_SHIELD:
        {
            sSpell = "Elemental Shield";
            break;
        }
        case SPELL_STONESKIN:
        {
            sSpell = "Stoneskin";
            break;
        }
        case SPELL_GREATER_STONESKIN:
        {
            sSpell = "Greater Stoneskin";
            break;
        }
        case SPELL_PREMONITION:
        {
            sSpell = "Premonition";
            break;
        }
        default:
        {
            if(bFeedback) SendMessageToPC(oPC, "You are not able to embue this spell to your armour");
            return;
        }
    }
    SetLocalString(oArmour, "RUN_ON_HIT_2", GetStringLowerCase(sScript));
    SetLocalInt(oArmour, "SS_IMBUE_ARMOUR_CH", SpellID);
    //24 hours
    float nDuration = 24.0*60.0*60.0;
    if(bFeedback) SendMessageToPC(oPC, "Spell added to armour: " + sSpell);
    //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nWizard), oArmour, nDuration);
    //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nWizard), oArmour);
}

//------------------------------------------------------------------------------
//Get Imbue armour spell
int miSSGetIASpell(object oArmour)
{
     return GetLocalInt(oArmour, "SS_IMBUE_ARMOUR_CH");
}
